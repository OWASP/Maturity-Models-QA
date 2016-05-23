Spectron_API = require '../src/Spectron-API'

describe 'constructor',->
    it 'constructor', ->
      using new Spectron_API(), ->
        @.options    .assert_Is {}
        @.Application.assert_Is_Function()
        @.root_Path  .assert_Folder_Exists()
                     .path_Combine('node_modules').assert_Folder_Exists()
        assert_Is_Null @.app

    it 'isRunning', ->
      using new Spectron_API(), ->
        @.is_Running().assert_Is_False()

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
                .assert_Contains 'electron-apps/web-view'


    it 'start and stop', ()->
      @.timeout 4000
      using new Spectron_API().setup(), ->
        @.start().then =>
          @.is_Running().assert_Is_True()
          @.stop()

    # other tests

    it 'expected files inside electron-apps/web-view folder', ->
      using new Spectron_API().setup(), ->
        app_Folder = @.options.args.first()
        app_Folder.assert_Folder_Exists().assert_Contains '/electron-apps/web-view'
                  .files().file_Names()  .assert_Contains ['index.html', 'main.js', 'package.json', 'web-view.html']

    it 'check title', ->
      @.timeout 4000
      using new Spectron_API().setup(), ->
        @.start().then =>
          @.app.client.getTitle().then (title)=>
            title.assert_Is 'Electron App - with WebView'
            @.stop()

    it 'check Html', ->
      @.timeout 4000
      using new Spectron_API().setup(), ->
        @.start().then =>
          @.app.client.windowByIndex(1).then =>
            @.app.client.getHTML('*').then (html)=>
              html.first().assert_Contains('Google')
              @.stop()












        