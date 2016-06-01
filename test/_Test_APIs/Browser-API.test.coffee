Browser_API = require '../../src/_Test_APIs/Browser-API'


describe '_Test_APIs | Browser_API', ->

  browser_API = null

  #@.timeout 4000

  beforeEach (done)->
    browser_API = new Browser_API()
    using browser_API, ->
      #@.spectron.start().then ->
        done()

  afterEach (done)->
    using browser_API, ->
      #@.spectron.stop().then ->
        done()

  it 'constructor', (done)->
    using new Browser_API(), ->
      @.constructor.name.assert_Is 'Browser_API'
      #@.spectron.assert_Is_Object()
      #console.log '-------------------'
      #console.log @.spectron.root_Path
      #console.log @.spectron.options
      #console.log '-------------------'
      done()


  it 'open', (done)->
    @.timeout 4500
 
    Spectron_API = require('electrium').Spectron_API

    spectron = new Spectron_API();
    spectron.setup()
    spectron.options.path = spectron.options.path.remove('electrium/node_modules/').str()
    spectron.app = new spectron.Application(spectron.options)
    #console.log  spectron.options
    ok = ()->
      console.log 'ok,closed ';
      done()
    fail = (err)->
      console.log('fail')
      done()
    #return spectron.start().then ok, fail
    spectron.start().then ()->
      console.log 'showing window'
      spectron.window().showInactive().then ->
        console.log 'loading url'
        spectron.window().loadURL("https://www.google.com")
        spectron.client().waitUntilWindowLoaded()
        ##'http://localhost:3000')
          .then ->
            #console.log 'getting title'
            #aaa = spectron.window().getUrl()
              #.then ->
                console.log 'stopping now'
                1000.wait ->
                  spectron.app.stop()
                      .then ->
                        console.log 'stopped'
                        done()
            #console.log  aaa
            #aaa.then ok, fail
      return
      #done()
      #spectron.show() ->
      spectron.window().loadURL('http://localhost:3000')

      #spectron.open('http://news.bbc.co.uk').then ()->
      1000.wait ->
        spectron
          .app.stop()
              .then ok, fail
      console.log('aaaaa')
    return

    using new Browser_API(), ->
      spectron = @.spectron
      spectron.setup()
      #console.log  @.spectron.options.path
      spectron.start().then ->

      #console.log @.spectron
      #@.spectron.show ->
      #@.open 'http://localhost:3000'
      #  1000.wait ->
      #done()