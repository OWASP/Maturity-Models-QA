Docker_API = require './Docker-API'

class Http_API

  constructor: ->
    @.docker_API = new Docker_API()
    
  GET: (path, callback)=>
    full_Url = @.docker_API.server_Url() + path
    console.log full_Url
    full_Url.GET callback

module.exports = Http_API