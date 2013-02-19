# alice

class Alice
  constructor: (@name, @file) ->
    @lines = file.split '\n'
    @LINE_COUNT_LIMIT = 300
  analyze: ->
    @checkFileLineCount
    @checkLineLength
    @checkClassName
  alert: (msg) ->
    throw new Error msg
  checkFileLineCount: ->
    line_count = @lines.length
    if line_count > @LINE_COUNT_LIMIT
      alert "File #{@name} has too many lines: #{line_count} exceeds limit of #{@LINE_COUNT_LIMIT}"
  checkLineLength: ->
    for line in [0...@lines.length]
      line_length = @lines[line].length
      if line_length > @LINE_LENGTH_LIMIT
        alert "File #{@name}, line #{@_i} is too long: #{line_length} exceeds limit of #{@LINE_LENGTH_LIMIT}"
  checkClassName: ->
    class_name_match = @file.match /(.|\n)*class( |\t|\n)+([a-zA-Z][a-zA-Z0-9_]*)( |\t|\n)+/
    if not class_name_match
      alert "File #{@name} incorrectly formatted.  Unable to locate class name."
    if (class_name = class_name_match[3]) isnt @name
      alert "File #{@name} contains a class with a different name: #{class_name}"

module.exports = analyze = (name, file) ->
  (new Alice name, file).analyze()
