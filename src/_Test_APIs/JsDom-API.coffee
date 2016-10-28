require 'fluentnode'

Travis_API  = require './Travis-API'
jsdom       = require('jsdom')

# Add feature to JsDom-API to capture requests made #157 - https://github.com/OWASP/Maturity-Models/issues/157
class JsDom_API

  constructor: ->
    @.travis_API = new Travis_API()
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

  $location: ()=>
    @.$app().injector().get('$location')

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
        SkipExternalResources   : true 
      created: ()=> @.on_Created?()
      onload : ()=> @.on_Load?()
      done   : (err, window)=>
        throw err if err
        @.window = window
        @.$      = window.$
        callback @.$, @.window

    jsdom.env config

  server_Url: ->
    @.travis_API.server_Url()

  count = 0
  wait_No_Http_Requests: (next)=>
    if @.$http().pendingRequests.length > 0
      console.log "***** pending: " + @.$http().pendingRequests.length + " : " + count++
      for item in @.$http().pendingRequests
        console.log "    - " + item.url
        #console.log @.$http().pendingRequests
      5.wait =>        
        @.wait_No_Http_Requests(next)
    else
      next()

module.exports = JsDom_API