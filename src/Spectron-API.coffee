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
    
  setup: =>
    @.options.path = @.root_Path.path_Combine 'node_modules/.bin/electron'
    @.options.args = [ __dirname.path_Combine '../electron-apps/web-view' ]
    @.app          = new @.Application @.options
    @

  start: =>
    @.app.start()

  stop: =>
    @.app.stop()

module.exports =   Spectron_API