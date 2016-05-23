assert      = require('assert')

Global_Setup = require('../../src/global-setup')


describe 'Global_Setup', ->

  it 'constructor', ->
    using new Global_Setup(), ->
      assert_Is_Null @.app

  it 'isRunning', ->
    using new Global_Setup(), ->
      @.isRunning().assert_Is_False()
      
  it 'getElectronPath', ->
    using new Global_Setup(), ->
      @.getElectronPath().assert_File_Exists()
      
  it 'appPath', ->
    using new Global_Setup(), ->
      @.app_Path.assert_Folder_Exists()


  it 'start, stop', ->
    @.timeout 5000
    using new Global_Setup(), ->
      @.startApplication().then =>
        @.isRunning().assert_Is_True()
        @.app.client.getTitle().then (title)=>
          title.assert_Is 'Electron App - with WebView'
          @.stopApplication().then =>
            @.isRunning().assert_Is_False()

  it 'stop', ->
    @.timeout 4000
    using new Global_Setup(), ->
      @.startApplication().then =>
        @.stopApplication().then =>
          @.stopApplication() 

describe 'test browserwindow and client', ->

  global_Setup   = null

  @.timeout 10000

  beforeEach () ->
    global_Setup = new Global_Setup()
    global_Setup.startApplication()

  afterEach ()->
    global_Setup.stopApplication()

  it 'gets window count', ()->
    global_Setup.isRunning().assert_Is_True()
    global_Setup.app.client.getWindowCount()
      .then (count) ->
        count.assert_Is 2

  it 'show an initial window', ()->
    using global_Setup.app.browserWindow, ->
      @.setBackgroundColor('#001122')
      @.setPosition(400,10)
      @.setSize(600,400)
      @.showInactive()

  it 'check title', ()->
    global_Setup.app.client.windowByIndex(1)
      .then -> global_Setup.app.client.getTitle()
      .then (title)->
        title.assert_Is 'Google'

  it 'check HTML', ()->
    global_Setup.app.client.windowByIndex(1)
      .then -> global_Setup.app.client.getHTML('*')
      .then (text)->
        text[0].assert_Contains 'Google'