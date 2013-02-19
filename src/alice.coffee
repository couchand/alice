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
    return @warnings
  alert: (msg) ->
    @warnings.push msg
  checkLimit: (actual, limit, msg) ->
    if actual > limit
      @alert "File #{@name} line #{@line} #{msg}: #{actual} exceeds limit of #{limit}"
  check: (ok, msg) ->
    if not ok
      @alert "File #{@name} #{msg}"
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

module.exports =
  analyze: (name, file) ->
    (new Alice name, file).analyze()
