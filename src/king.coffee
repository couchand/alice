# the king of hearts
# pardons those condemned by the queen

fs = require 'fs'
path = require 'path'

suffixed = (dir, name) ->
  path.join dir, "#{name}.json"

mustHave = (description, file) ->
  throw new Error "unable to find #{description} #{file}" unless fs.existsSync(file)

class Card
  constructor: (@name, @results_dir) ->
    mustHave "results dir", @results_dir
    @settings_file = suffixed @results_dir, 'card'
    @load @settings_file
    @loadResults()

  load: (settings_file) ->
    mustHave "project settings", settings_file
    settings = JSON.parse fs.readFileSync(settings_file).toString()
    @last_run = settings.lastRun
    @last_score = settings.lastScore

  loadResults: ->
    runs = fs.readdirSync @results_dir
    @results = (run.replace /\.json$/, '' for run in runs when /\.json$/.test(run) and not /^card\.json$/.test run)

  getResultInfo: (run) ->
    throw new Error "unable to find results #{run}" if -1 is @results.indexOf run
    result_file = path.join @results_dir, "#{run}.json"
    mustHave "result file", result_file
    JSON.parse fs.readFileSync(result_file).toString()

class King
  constructor: (@project_dir, @results_dir) ->
    @results_dir ?= path.join @project_dir, 'results'
    mustHave "project directory", @project_dir
    mustHave "results directory", @results_dir
    @settings_file = suffixed @project_dir, 'queen'
    mustHave "settings file", @settings_file
    @projects = {}
    @load @settings_file

  load: (settings_file) ->
    settings = JSON.parse fs.readFileSync(settings_file).toString()
    for project, src_dir of settings.projects
      @addProject project

  addProject: (name) ->
    results_dir = path.join @results_dir, name
    @projects[name] = new Card name, results_dir

  getProjects: ->
    name for name, project of @projects

  _getProject: (name) ->
    throw new Error "unable to find project #{name}" unless project = @projects[name]
    project

  getProjectInfo: (name) ->
    project = @_getProject name
    return {
      name: project.name
      lastRun: project.last_run
      lastScore: project.last_score
    }

  getProjectResults: (name) ->
    project = @_getProject name
    project.results

  getProjectResultInfo: (name, run) ->
    project = @_getProject name
    project.getResultInfo run

module.exports = (dir) -> new King dir
