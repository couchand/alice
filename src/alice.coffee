# alice

class Alice
  constructor: ->
    @LINE_COUNT_LIMIT = 300
    @LINE_LENGTH_LIMIT = 65
    @BLOCK_LINE_LIMITS =
      '{': [
        300 # class
        100 # method / inner class
        40  # block
        5   # inner block
      ]
    @BLOCK_LENGTH_LIMITS =
      '(': [
        150 # if statements/ parameter lists
        50  # enclosed parens
        # don't bother checking any deeper
      ]
      '[': [
        500 # far less than the legal limit of 10,000 for SOQL
        3   # should just be the odd list index
      ]
    @BLOCK_OPEN = /[\[\(\{]/
    @BLOCK_CLOSE = /[\]\)\}]/
    @INVERSE =
      '[': ']'
      ']': '['
      '(': ')'
      ')': '('
      '{': '}'
      '}': '{'
    @CLASS_NAME_REGEX = /^(\/\/.*\n|.|\n)*?class( |\t|\n)+([a-zA-Z][a-zA-Z0-9_]*)( |\t|\n)+/
    @CLASS_NAME_VALIDATOR = /^[A-Z][a-zA-Z]+$/
    @FINAL_VAR_REGEX = /final/
    @FINAL_VAR_STATIC_VALIDATOR = /static/
    @FINAL_VAR_NAME_VALIDATOR = /\s[A-Z_]+[\s=\(]/
  analyze: (@name, @file) ->
    @lines = file.split '\n'
    @warnings = []
    @line = 0
    @checkClassName()
    @checkFinalVarNames()
    @checkFileLineCount()
    @checkLineLength()
    @checkConsistentWhitespace()
    @checkTrailingWhitespace()
    @checkBlockLengthCounts()
    return @warnings
  alert: (msg) ->
    @warnings.push msg
  checkLimit: (actual, limit, msg) ->
    if actual > limit
      @alert "File #{@name} line #{@line+1} #{msg}: #{actual} exceeds limit of #{limit}"
  check: (ok, msg) ->
    if not ok
      @alert "File #{@name} line #{@line+1} #{msg}"
    not not ok
  checkFileLineCount: ->
    @checkLimit @lines.length, @LINE_COUNT_LIMIT, "has too many lines"
  checkLineLength: ->
    for line in [0...@lines.length]
      @line = line
      @checkLimit @lines[line].length, @LINE_LENGTH_LIMIT, "is too long", line
  checkClassName: ->
    @line = 0
    class_name_match = @file.match @CLASS_NAME_REGEX
    return unless @check class_name_match, "incorrectly formatted.  Unable to locate class name."
    lines = class_name_match[0].match(/\n/g)
    @line = lines.length if lines
    @check (class_name = class_name_match[3]) is @name, "contains a class with a different name: #{class_name}"
    @check @CLASS_NAME_VALIDATOR.test(class_name), "class should be named with CamelCase"
  checkFinalVarNames: ->
    for line in [0...@lines.length]
      @line = line
      if @FINAL_VAR_REGEX.test @lines[line]
        @check @FINAL_VAR_STATIC_VALIDATOR.test(@lines[line]), "constants should be static"
        @check @FINAL_VAR_NAME_VALIDATOR.test(@lines[line]), "constants should be named with ALL_CAPS"
  checkConsistentWhitespace: ->
    first_whitespace_char = @file.match /( |\t)/
    return unless @check first_whitespace_char, "has no whitespace."
    illegal_whitespace = switch first_whitespace_char[0]
      when '\t'
        /[ ]/
      when ' '
        /\t/
    for line in [0...@lines.length]
      @line = line
      @check not illegal_whitespace.test(@lines[line]), "contains inconsistent whitespace"
  checkTrailingWhitespace: ->
    for line in [0...@lines.length]
      @line = line
      @check not /( |\t)+$/.test(@lines[line]), "contains trailing whitespace"
  checkBlockLengthCounts: ->
    @line = 0
    cursor = 0
    stack = []
    while cursor < @file.length
      this_char = @file[cursor]
      if this_char.match @BLOCK_OPEN
        stack.push { char: this_char, line: @line, loc: cursor }
      else if this_char.match @BLOCK_CLOSE
        block_to_close = stack.pop()
        return unless @check block_to_close?.char is @INVERSE[this_char], "unmatched #{block_to_close?.char}, found #{this_char}"
        block_lines = @line - block_to_close.line + 1 # both lines count: line 45-45 is one line
        block_chars = cursor - block_to_close.loc - 1 # neither brace should count
        depth = (token.char for token in stack when token.char is @INVERSE[this_char]).length
        line_limit = @BLOCK_LINE_LIMITS[block_to_close.char]?[depth]
        char_limit = @BLOCK_LENGTH_LIMITS[block_to_close.char]?[depth]
        @checkLimit block_lines, line_limit, "`#{@INVERSE[this_char]}` block has too many lines for depth #{depth}" if line_limit
        @checkLimit block_chars, char_limit, "`#{@INVERSE[this_char]}` block has too many chars for depth #{depth}" if char_limit
      else if this_char.match /\n/
        @line++
      cursor++

module.exports =
  analyze: (name, file) ->
    new Alice().analyze(name, file)
