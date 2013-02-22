# the white rabbit
# brings wonderland to the world

class Card
  constructor: (info) ->
    @name = info.name
    @last_run = info.lastRun
    @last_score = info.lastScore
    @results = {}

  addRun: (run) ->
    that = @
    @getResultInfo(run).then (results) ->
      for result in results
        result.run = run
        result.project = that.name
      that.results[run] = results

  getResults: ->
    $.get "/#{@name}/results"

  getResultInfo: (run) ->
    $.get "/#{@name}/results/#{run}"

class Rabbit
  constructor: ->
    @createReport()
    that = @
    @projects = {}
    @getProjects().then (names) ->
      loadInfo = (info) ->
        proj = that.projects[info.name] = new Card info
        proj.loadRun(info.lastRun).then (results) ->
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

window.whiteRabbit = new Rabbit()
