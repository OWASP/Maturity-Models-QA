require 'fluentnode'

cheerio    = require 'cheerio'
Travis_API = require './Travis-API'

class Http_API

  constructor: ->
    @.travis_API = new Travis_API()
    
  GET: (path, callback)=>
    full_Url = @.travis_API.server_Url() + path
    full_Url.GET callback
    
  $GET: (path, callback)=>
    @.GET path, (data)=>
      callback cheerio.load data
      
  GET_Json: (path, callback)=>
    full_Url = @.travis_API.server_Url() + path
    full_Url.json_GET callback

  server_Url: ()=>
    @.travis_API.server_Url()

module.exports = Http_API