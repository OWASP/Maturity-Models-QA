Spectron_API = require '../src/Spectron-API'

describe 'Spectron-API',->

  spectron = null;

  @.timeout 4000
  
  before ->
    spectron = new Spectron_API().setup()
    spectron.start()

  after ->
    spectron.stop()



  it 'constructor', ->
    using new Spectron_API(), ->
      @.options    .assert_Is {}
      @.Application.assert_Is_Function()
      @.root_Path  .assert_Folder_Exists()
                   .path_Combine('node_modules').assert_Folder_Exists()
      assert_Is_Null @.app

  it 'isRunning', ->
    using spectron, ->
      @.is_Running().assert_Is_True()

  it.only 'open (BBC news)', ->
    url = 'http://news.bbc.co.uk'
    using spectron.show(), ->
      @.open url
      .then =>
        @.window().getURL().then (url)=>
          url.assert_Is url

  it 'setup', ->
    using new Spectron_API(), ->
      @.setup().assert_Is @
      using @.app, ->
        @.host                .assert_Is '127.0.0.1'
        @.port                .assert_Is 9515
        @.quitTimeout         .assert_Is 1000
        @.startTimeout        .assert_Is 5000
        @.waitTimeout         .assert_Is 5000
        @.connectionRetryCount.assert_Is 10
        @.nodePath            .assert_Is process.execPath
        @.env                 .assert_Is {}
        @.workingDirectory    .assert_Is __dirname.path_Combine('..')
        @.api.app             .assert_Is @
        @.api.requireName     .assert_Is 'require'
        @.transferPromiseness .assert_Is_Function()

        @.path.assert_File_Exists()
              .assert_Contains '.bin/electron'
        @.args.assert_Size_Is(1).first()
              .assert_Folder_Exists()
              .assert_Contains 'electron-apps/about-blank'

  it 'show', ->
    using spectron,->
      @.window().isVisible().then (value)=>
        value.assert_Is_False()
        @.show()
        @.window().isVisible().then (value)=>
          value.assert_Is_True()

  it 'start, stop', ()->
    using new Spectron_API().setup(), ->
      @.start().then =>
        @.is_Running().assert_Is_True()
        @.stop()

  it 'client, window', ->
    using spectron, ->
      @.client().commandList.assert_Is_Object()
      @.window().getURL.assert_Is_Function()

  # other tests
  describe 'other tests', ->
    it 'expected files inside electron-apps/web-view folder', ->
      using new Spectron_API().setup(), ->
        app_Folder = @.options.args.first()
        app_Folder.assert_Folder_Exists().assert_Contains '/electron-apps/about-blank'
                  .files().file_Names()  .assert_Contains [ 'main.js', 'package.json']

    it 'check title and html', ->
      webview = [ __dirname.path_Combine '../electron-apps/web-view' ]
      using new Spectron_API(), ->
        @.options.args = webview
        @.setup().start().then =>                                     # create chrome and start with web-view electron app
          @.app.client.getTitle().then (title)=>                      # get title of host window
            title.assert_Is 'Electron App - with WebView'

            @.app.client.getHTML('*').then (html)=>
              html.first().assert_Contains('<webview id="google" ')   # confirm we are in the electron window

              @.app.client.windowByIndex(1).then =>
                @.app.client.getHTML('*').then (html)=>
                  html.first().assert_Contains('Google')              # get html of webv-iew
                  @.stop()





        