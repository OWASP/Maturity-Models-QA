require 'fluentnode'

Docker_API  = require './Docker-API'
jsdom       = require('jsdom')

class JsDom_API

  constructor: ->
    @.docker_API = new Docker_API()
    @.$          = null
    @.document   = null
    @.window     = null
    @.http       = null
    @.on_Created = null
    @.on_Load    = null

  $app: ()=>
    element = @.window.document.querySelector('.ng-scope')
    @.window.angular.element(element)

  $http: ()=>
    @.$app().injector().get('$http')

  $scope: ()=>
    @.$app().scope()
    
  open: (path, callback)=>
    if typeof(path) is 'function'
      callback = path
      path     = ''
    if not path.starts_With('/')
      path = '/' + path
      
    url = @.server_Url() + path
    config =
      url: url
      features :
        FetchExternalResources  : ["script"]
        ProcessExternalResources: ["script"]
        SkipExternalResources   : true # was false
      created: ()=> @.on_Created?()
      onload : ()=> @.on_Load?()
      done   : (err, window)=>
        throw err if err
        @.window = window
        @.$      = window.$
        callback @.$, @.window

    jsdom.env config

  server_Url: ->
    @.docker_API.server_Url()

  wait_No_Http_Requests: (next)=>
    if @.$http().pendingRequests.length > 0
      #console.log @.$http().pendingRequests[0].url
      #console.log 'waiting 10ms'
      5.wait =>
        @.wait_No_Http_Requests(next)
    else
      next()

  #open: (path)=>


module.exports = JsDom_API