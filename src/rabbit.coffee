# the white rabbit
# brings wonderland to the world

class Rabbit
  constructor: ->
    @createReport()
    that = @
    @projects = {}
    @getProjects().then (names) ->
      loadInfo = (info) ->
        that.projects[info.name] =
          info: info
          results:{}
        that.getProjectResultInfo(info.name, info.lastRun).then (results) ->
          that.projects[info.name].results[info.lastRun] = results
          for result in results
            result.run = info.lastRun
            result.project = info.name
          that.report.add results
      for name in names
        that.projects[name] = {}
        that.getProjectInfo(name).then loadInfo

  createReport: ->
    @report = gryphon()
    @report.dimension 'project'
    @report.dimension 'run'
    @report.group 'file'
    @report.group 'id'
    @report.dimension 'excess', (d) ->
      100*(d.actual - d.limit)/d.limit if d.actual and d.limit
      0

  getProjects: ->
    $.get '/'

  getProjectInfo: (name) ->
    $.get "/#{name}"

  getProjectResults: (name) ->
    $.get "/#{name}/results"

  getProjectResultInfo: (name, run) ->
    $.get "/#{name}/results/#{run}"

window.whiteRabbit = new Rabbit()
