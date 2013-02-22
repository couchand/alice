# the white rabbit
# brings the world to wonderland

class Rabbit
  constructor: ->
    that = @
    @projects = {}
    @getProjects().then (names) ->
      loadInfo = (info) ->
        that.projects[info.name] =
          info: info
          results:{}
        that.getProjectResultInfo(info.name, info.lastRun).then (result) ->
          that.projects[info.name].results[info.lastRun] = result
      for name in names
        that.projects[name] = {}
        that.getProjectInfo(name).then loadInfo

  getProjects: ->
    $.get '/'

  getProjectInfo: (name) ->
    $.get "/#{name}"

  getProjectResults: (name) ->
    $.get "/#{name}/results"

  getProjectResultInfo: (name, run) ->
    $.get "/#{name}/results/#{run}"

window.whiteRabbit = new Rabbit()
