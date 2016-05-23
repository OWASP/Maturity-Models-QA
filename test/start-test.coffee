assert      = require('assert')

helpers = require('../src/global-setup')
appPath = __dirname.path_Combine '../electron-apps/web-view'

describe 'check values', ->

  it 'getElectronPath', -> helpers.getElectronPath().assert_File_Exists()
  it 'appPath'        , -> appPath.assert_Folder_Exists()

describe 'application launch', ->

  app   = null

  @.timeout 10000

  beforeEach () -> 
    helpers.startApplication  args: [appPath]
           .then (_app)-> 
              app = _app              

  afterEach ()->
    helpers.stopApplication()

  xit 'gets window count', ()->
    app.isRunning().assert_Is_True()
    app.client.getWindowCount()
              .then (count) ->
                count.assert_Is 3

  it 'show an initial window', ()->
    using app.browserWindow, ->
      @.setBackgroundColor('#001122')

      @.setPosition(400,10)
      @.setSize(600,400)
      @.showInactive()

  it 'check title', ()->
    app.client.windowByIndex(1)
      .then -> app.client.getTitle()
      .then (title)->
        title.assert_Is 'aaa'

  it 'check HTML', ()->
    app.client.windowByIndex(1)
      .then -> app.client.getHTML('*')
      .then (text)->
        console.log text
        text.assert_Is 'aaa'
      
#              .getText('body').then (text)->
#                assert.equal text, 'aaa'
#                #console.log text
#                #text.assert_Is 'asd'
#                #console.log @._keys().sort()
#                done()
      #4000.wait -> done()