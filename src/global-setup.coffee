require 'fluentnode'

Application = require('spectron').Application
path        = require('path')

assert      = require('assert')
#chai   = require('chai')

class Global_Setup
  constructor: ->
    @.app = null

  getElectronPath: ->
    root_Path = wallaby?.localProjectDir || __dirname.path_Combine '../'
    return root_Path.path_Combine 'node_modules/.bin/electron'

  startApplication: (options) ->
    options.path = @.getElectronPath()

    #if process.env.CI
    #  options.startTimeout = 30000

    @.app = new Application(options)

    @.app.start()
         .then =>
            assert.equal @.app.isRunning(), true
            #chaiAsPromised.transferPromiseness = @.app.transferPromiseness
            return @.app

  stopApplication: (callback) =>
    if !@.app or !@.app.isRunning()
      return
    @.app.stop()

module.exports = new Global_Setup()