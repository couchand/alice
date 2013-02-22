# the white rabbit
# brings the world to wonderland

class Rabbit
  constructor: ->
    that = @
    @projects = {}
    @getProjects().then (names) ->
      for name in names
        that.projects[name] = {}
        that.getProjectInfo(name).then (info) ->
          that.projects[info.name] =
            info: info
            results: that.getProjectResultInfo(info.name, info.lastRun)

  getProjects: ->
    $.get '/'

  getProjectInfo: (name) ->
    $.get "/#{name}"

  getProjectResultInfo: (name, run) ->
    $.get "/#{name}/results/#{run}"

window.whiteRabbit = new Rabbit()
