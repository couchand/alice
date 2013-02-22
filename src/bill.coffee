# bill the lizard
# errand-runner for the white rabbit

http = require 'http'
url = require 'url'
fs = require 'fs'
path = require 'path'

queen = require './queen'

class Bill
  constructor: (@project_dir) ->

  listen: ->
    unless @server
      @server = http.createServer @serve.bind @
      @server.listen 8080
      console.log 'listening on localhost:8080'
    @server

  close: ->
    @server.close()
    @server = off

  serve: (req, res) ->
    { pathname: req_path } = url.parse req.url
    resource = @getResource req_path

    console.log "serving request for #{req_path}"

    res.setHeader 'content-type', 'application/json'
    res.write JSON.stringify resource
    res.end()

  getResource: (req_path) ->
    repo = queen @project_dir

    # list of projects
    if not req_path? or /^\/?$/.test req_path
      return (name for name, dif of repo.projects)

    # project info
    if (match = req_path.match /^\/([^\/]+)\/?$/)
      project_name = match[1]
      return ['project not found'] unless project = repo.projects[project_name]
      return {
        name: project.name
        lastRun: project.last_run
        lastScore: project.last_score
      }

    # list of results
    if (match = req_path.match /^\/([^\/]+)\/results\/?$/)
      project_name = match[1]
      return ['project not found'] unless project = repo.projects[project_name]

      runs = fs.readdirSync(project.results_dir)
      return (run.replace /\.json$/, '' for run in runs)

    # result info
    if (match = req_path.match /^\/([^\/]+)\/results\/([^\/]+)\/?$/)
      project_name = match[1]
      result_id = match[2]
      return ['project not found'] unless project = repo.projects[project_name]

      result_file = path.join project.results_dir, "#{result_id}.json"
      return ['result not found'] unless fs.existsSync result_file
      return JSON.parse fs.readFileSync(result_file).toString()

module.exports = (dir) -> new Bill dir
