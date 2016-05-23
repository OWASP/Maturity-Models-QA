assert      = require('assert')

helpers = require('../src/global-setup')
appPath = __dirname.path_Combine '../electron-apps/web-view'

describe 'check values', ->

  it 'getElectronPath', -> helpers.getElectronPath().assert_File_Exists()
  it 'appPath'        , -> appPath.assert_Folder_Exists()

describe 'application launch', ->

  app   = null

  beforeEach () -> 
    helpers.startApplication  args: [appPath]
           .then (_app)-> 
              app = _app              

  afterEach (done)->
    helpers.stopApplication ()->
      done()

  it 'shows an initial window', ()->
    #app.isRunning().assert_Is_True()
    app.client.getWindowCount()
              .then (count) ->
                assert.equal count, 2
