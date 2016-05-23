require 'fluentnode'

Application = require('spectron').Application

class Global_Setup
  constructor: (options)->
    @.options   = options || {}
    @.app       = null
    @.root_Path = wallaby?.localProjectDir || __dirname.path_Combine '../'
    @.app_Path  = __dirname.path_Combine '../electron-apps/web-view'
    @.options.path = @.getElectronPath()
    @.options.args = [@.app_Path]
    
  getElectronPath: =>
    @.root_Path.path_Combine 'node_modules/.bin/electron'

  isRunning: =>
    @.app?.isRunning() || false

  startApplication: () =>
    @.app = new Application(@.options)
    @.app.start()

  stopApplication: () =>
    if !@.app or !@.app.isRunning()
      return
    @.app.stop()

module.exports = Global_Setup