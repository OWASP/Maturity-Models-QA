Browser_API = require '../../src/_Test_APIs/Browser-API'


describe.only '_Test_APIs | Browser_API', ->

  browser_API = null

  #@.timeout 4000

  beforeEach ()->
    browser_API = new Browser_API()
    using browser_API, ->
      @.spectron.start()

  afterEach ()->
    using browser_API, ->
      @.spectron?.stop()

  it 'constructor', (done)->
    using new Browser_API(), ->
      @.constructor.name.assert_Is 'Browser_API'
      #@.spectron.root_Path.assert_Contains 'BSIMM-Graphs-QA'
      done()

  it 'open google, check url', ()->
    browser_API.spectron.open('https://www.google.com').then =>
      browser_API.spectron.show()
      browser_API.spectron.app.browserWindow.getURL().then (url)->
        console.log 'THE ULR is: ' + url
        url.assert_Contains('www.google.co.uk')
  return

  it 'open google', (done)->
    @.timeout 200500
    browser_API.spectron.open('https://www.google.com')
        .then =>
            using browser_API.spectron,->
              @.show()

              #console.log @.app
              #console.log @.app.electron

              console.log @.app.browserWindow
              #@.electron.openDevTools()
              #console.log @.client()

              return @.app.browserWindow.getURL().then (url)->
                console.log url
                url.assert_Contains('www.google.com')
                done()

              return 2000.wait ->
                done()

              @.app.browserWindow.setPosition(10,-1000)
              @.app.browserWindow.setSize(1000,1000)
              @.app.browserWindow.openDevTools()
              #browser_API.spectron.client()
              #console.log  @.window().getHTML().then (html)->
                #console.log html
              #200000.wait ->
              #  done()
        .catch (err)->
          console.log err
          done()
  return
  it 'open', (done)->
    #browser_API.spectron.show()
    browser_API.spectron.open('http://www.google.com')
    1000.wait done
    #console.log browser_API.s.show()
    return
    #@.timeout 4500
 
    #Spectron_API = require('electrium').Spectron_API

    #spectron = new Spectron_API();
    #spectron.setup()
    #spectron.options.path = spectron.options.path.remove('electrium/node_modules/').str()
    #spectron.app = new spectron.Application(spectron.options)
    #console.log  spectron.options
    ok = ()->
      console.log 'ok,closed ';
      done()
    fail = (err)->
      console.log('fail')
      done()
    aaa = spectron.app.start()
    aaa.then ->  console.log 'then'
    aaa.catch (err)->  console.log err
    console.log aaa
    1000.wait ->
      console.log aaa
    return aaa


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