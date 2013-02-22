# bill the lizard
# errand-runner for the white rabbit

http = require 'http'
url = require 'url'
fs = require 'fs'
path = require 'path'

king = require './king'

class Bill
  constructor: (@project_dir) ->
    @repo = king @project_dir

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
    # list of projects
    if not req_path? or /^\/?$/.test req_path
      console.log "getting project list"
      return @repo.getProjects()

    # project info
    if (match = req_path.match /^\/([^\/]+)\/?$/)
      project_name = match[1]
      console.log "getting project #{project_name}"
      try
        return @repo.getProjectInfo project_name
      catch ex
        return ['project not found']

    # list of results
    if (match = req_path.match /^\/([^\/]+)\/results\/?$/)
      project_name = match[1]
      console.log "getting project #{project_name} results"
      try
        return @repo.getProjectResults project_name
      catch ex
        return ['project not found']

    # result info
    if (match = req_path.match /^\/([^\/]+)\/results\/([^\/]+)\/?$/)
      project_name = match[1]
      result_id = match[2]
      console.log "getting project #{project_name} result #{result_id}"
      try
        return @repo.getProjectResultInfo project_name, result_id
      catch ex
        return ['project not found'] if /project/i.test ex.message
        return ['result not found']

module.exports = (dir) -> new Bill dir
