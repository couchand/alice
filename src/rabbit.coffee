# the white rabbit
# brings wonderland to the world

projects_list = '.projects'

class Card
  constructor: (info) ->
    @name = info.name
    @last_run = info.lastRun
    @last_score = info.lastScore
    @results = {}
    @addMarkup()

  addRun: (run) ->
    that = @
    @getResultInfo(run).then (results) ->
      for result in results
        result.run = run
        result.project = that.name
      that.results[run] = results

  addMarkup: ->
    li = $ '<li>'

    li.text "#{@name} (#{@last_score})"
    li.data 'rabbit.project', @name

    li.appendTo projects_list

  getResults: ->
    $.get "/#{@name}/results"

  getResultInfo: (run) ->
    $.get "/#{@name}/results/#{run}"

class Rabbit
  constructor: ->
    @createReport()
    @handleEvents()
    that = @
    @projects = {}
    @getProjects().then (names) ->
      loadInfo = (info) ->
        proj = that.projects[info.name] = new Card info
        proj.addRun(info.lastRun).then (results) ->
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

  handleEvents: ->
    that = @
    $ ->
      $(projects_list).on 'click', 'li', ->
        project = that.projects[$(@).data 'rabbit.project']
        that.showProject project

  showProject: (project) ->
    console.log project.name

  getProjects: ->
    $.get '/'

  getProjectInfo: (name) ->
    $.get "/#{name}"

window.whiteRabbit = new Rabbit()
