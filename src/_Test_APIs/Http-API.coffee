require 'fluentnode'

cheerio    = require 'cheerio'
Docker_API = require './Docker-API'

class Http_API

  constructor: ->
    @.docker_API = new Docker_API()
    
  GET: (path, callback)=>
    full_Url = @.docker_API.server_Url() + path
    full_Url.GET callback
    
  $GET: (path, callback)=>
    @.GET path, (data)=>
      callback cheerio.load data
      
  GET_Json: (path, callback)=>
    full_Url = @.docker_API.server_Url() + path
    full_Url.json_GET callback

  server_Url: ()=>
    @.docker_API.server_Url()

module.exports = Http_API