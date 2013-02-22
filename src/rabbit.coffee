# the white rabbit
# brings wonderland to the world

TOP_COUNT = 4

projects_list = '.projects'
results_pane = '.results'

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
    @report.dimension('project').filter project.name
    results = $ results_pane
    results.empty()

    top_files = $ '<ul>'
    for file in @report.group('file').top TOP_COUNT
      top_files.append $ "<li>#{file.key} - #{file.value}</li>"
    top_files.appendTo results

    top_types = $ '<ul>'
    for file in @report.group('id').top TOP_COUNT
      top_types.append $ "<li>#{checks[file.key]} - #{file.value}</li>"
    top_types.appendTo results

  getProjects: ->
    $.get '/'

  getProjectInfo: (name) ->
    $.get "/#{name}"

window.whiteRabbit = new Rabbit()
