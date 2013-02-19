# alice

class Alice
  constructor: (@name, @file) ->
    @lines = file.split '\n'
    @LINE_COUNT_LIMIT = 300
    @LINE_LENGTH_LIMIT = 65
  analyze: ->
    @warnings = []
    @line = 0
    @checkFileLineCount()
    @checkLineLength()
    @checkClassName()
    @checkConsistentWhitespace()
    @checkTrailingWhitespace()
    return @warnings
  alert: (msg) ->
    @warnings.push msg
  checkLimit: (actual, limit, msg) ->
    if actual > limit
      @alert "File #{@name} line #{@line+1} #{msg}: #{actual} exceeds limit of #{limit}"
  check: (ok, msg) ->
    if not ok
      @alert "File #{@name} line #{@line+1} #{msg}"
  checkFileLineCount: ->
    @checkLimit @lines.length, @LINE_COUNT_LIMIT, "has too many lines"
  checkLineLength: ->
    for line in [0...@lines.length]
      @line = line
      @checkLimit @lines[line].length, @LINE_LENGTH_LIMIT, "is too long", line
  checkClassName: ->
    class_name_match = @file.match /^(.|\n)*?class( |\t|\n)+([a-zA-Z][a-zA-Z0-9_]*)( |\t|\n)+/
    @check class_name_match, "incorrectly formatted.  Unable to locate class name."
    @check (class_name = class_name_match[3]) is @name, "contains a class with a different name: #{class_name}"
  checkConsistentWhitespace: ->
    first_whitespace_char = @file.match /( |\t)/
    @check first_whitespace_char, "has no whitespace."
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

module.exports =
  analyze: (name, file) ->
    (new Alice name, file).analyze()
