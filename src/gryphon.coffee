# the gryphon
# unemotional analysis

class Gryphon
  constructor: ->
    @_xf = crossfilter()
    @_dims = {}
    @_grps ={}

  add: (data) ->
    @_xf.add data

  # dimension( name )
  #   returns a dimension if it exists
  # dimension( field )
  #   create a field accessor dimension
  # dimension( name, formula )
  #   create a formula dimension
  dimension: (name, formula) ->
    return @_dims[name] if @_dims[name]
    formula ?= (d) -> d[name]
    @_dims[name] = @_xf.dimension formula

  # group( name )
  #   returns a group if it exists
  # group( field )
  #   create a field grouping
  # group( name, field )
  #   create a named grouping
  # group( name, field, formula )
  #   create a named grouping with a rounding formula
  group: (name, field, formula) ->
    return @_grps[name] if @_grps[name]
    field ?= name
    if formula
      @_grps[name] = @dimension(field).group formula
    else
      @_grps[name] = @dimension(field).group()

window.gryphon = -> new Gryphon()
