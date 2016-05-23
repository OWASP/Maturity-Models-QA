require 'fluentnode'

spectron = require 'spectron'

class Spectron_API
  
  constructor: (options)->
    @.options     = options || {}
    @.Application = spectron.Application
    @.app         = null
    @.root_Path   = wallaby?.localProjectDir || __dirname.path_Combine '../'        
    
  is_Running: =>
    @.app?.isRunning() || false

  open: (url)=>
    @.window().loadURL(url)
    @.client().waitUntilWindowLoaded()      

  setup: =>
    @.options.path  = @.root_Path.path_Combine 'node_modules/.bin/electron'
    @.options.args ?= [ __dirname.path_Combine '../electron-apps/about-blank' ]
    @.app           = new @.Application @.options
    @

  show: =>
    @.window().showInactive()
    @
    
  start: =>
    @.app.start()

  stop: =>
    @.app.stop()

  client: => @.app?.client
  window: => @.app?.browserWindow

module.exports =   Spectron_API