# the queen
# manage project analysis with alice

fs = require 'fs'
path = require 'path'

alice = require '../src/alice.coffee'

class Card
  constructor: (@name, @source_dir, @results_dir) ->
    fs.mkdirSync(@source_dir) unless fs.existsSync(@source_dir)
    fs.mkdirSync(@results_dir) unless fs.existsSync(@results_dir)
  analyze: ->
    # go ask alice

class Queen
  constructor: (@project_dir) ->
    fs.mkdirSync(@project_dir) unless fs.existsSync(@project_dir)
    @projects = {}
    @SOURCE_DIR = path.join @project_dir, "source"
    fs.mkdirSync(@SOURCE_DIR) unless fs.existsSync(@SOURCE_DIR)
    @RESULTS_DIR = path.join @project_dir, "results"
    fs.mkdirSync(@RESULTS_DIR) unless fs.existsSync(@RESULTS_DIR)
  addProject: (name, src) ->
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
