# the queen
# manage project analysis with alice

fs = require 'fs'
path = require 'path'
strftime = require 'strftime'

alice = require '../src/alice.coffee'

MAX_SEARCH_DEPTH = 4
getAllClassFiles = (dir, depth=0) ->
  files = []
  return files if depth > MAX_SEARCH_DEPTH
  for file in fs.readdirSync dir
    file_path = path.join dir, file
    if fs.statSync(file_path).isDirectory()
      files.push child for child in getAllClassFiles file_path, depth+1
    else
      files.push file_path
  files

suffixed = (dir, name) ->
  path.join dir, "#{name}.json"
getResultsFile = (dir, name) ->
  return candidate unless fs.existsSync (candidate = suffixed dir, name)
  counter = 1
  counter++ while fs.existsSync( candidate = suffixed dir, "#{name}-#{counter}" )
  candidate

class Card
  constructor: (@name, @source_dir, @results_dir) ->
    fs.mkdirSync(@source_dir) unless fs.existsSync(@source_dir)
    fs.mkdirSync(@results_dir) unless fs.existsSync(@results_dir)
    @settings_file = suffixed @results_dir, 'card'
    if fs.existsSync @settings_file
      @load @settings_file
  load: (settings_file) ->
    settings = JSON.parse fs.readFileSync(settings_file).toString()
    @last_run = settings.lastRun
    @last_score = settings.lastScore
  analyze: ->
    all_warnings = []
    @last_run = strftime "%Y-%m-%d-%H-%M-%S"

    # go ask alice
    for file_path in getAllClassFiles @source_dir
      name = file_path.match(/\/([^\/]+)\.cls$/)?[1]
      continue unless name
      file = fs.readFileSync(file_path).toString()
      warnings = alice.analyze name, file
      all_warnings.push warning for warning in warnings

    warning.project = @name for warning in all_warnings
    results_file = getResultsFile @results_dir, @last_run
    fs.writeFileSync results_file, JSON.stringify all_warnings

    @last_score = all_warnings.length
    fs.writeFileSync @settings_file, JSON.stringify
      name: @name
      lastRun: @last_run
      lastScore: @last_score

class Queen
  constructor: (@project_dir) ->
    fs.mkdirSync(@project_dir) unless fs.existsSync(@project_dir)
    @projects = {}
    @SOURCE_DIR = path.join @project_dir, "source"
    fs.mkdirSync(@SOURCE_DIR) unless fs.existsSync(@SOURCE_DIR)
    @RESULTS_DIR = path.join @project_dir, "results"
    fs.mkdirSync(@RESULTS_DIR) unless fs.existsSync(@RESULTS_DIR)
    @settings_file = suffixed @project_dir, 'queen'
    if fs.existsSync @settings_file
      @load @settings_file
  load: (settings_file) ->
    settings = JSON.parse fs.readFileSync(settings_file).toString()
    for project, dir of settings.projects
      @_addProject project, dir
  addProject: (name, src) ->
    @_addProject name, src
    project_info = {}
    for name, card of @projects
      project_info[name] = card.source_dir
    fs.writeFileSync @settings_file, JSON.stringify
      projects: project_info
  _addProject: (name, src) ->
    if src
      source_dir = src
    else
      source_dir = path.join @SOURCE_DIR, name
    results_dir = path.join @RESULTS_DIR, name
    @projects[name] = new Card name, source_dir, results_dir
  analyzeAll: ->
    for name, project of @projects
      project.analyze()
  analyzeProject: (name) ->
    @projects[name].analyze() if @projects[name]

module.exports = (dir) -> new Queen dir
