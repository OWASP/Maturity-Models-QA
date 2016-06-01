Browser_API = require '../../src/_Test_APIs/Browser-API'

describe '_Test_APIs | Browser_API ...', ->

  browser_API = null

  #@.timeout 4000

  before ()->
    browser_API = new Browser_API()
    using browser_API.spectron, ->
      @.start()
        #.then =>@.show()

  after ()->
    using browser_API, ->
      @.spectron?.stop()

  it 'constructor', (done)->
    using browser_API, ->
      @.constructor.name.assert_Is 'Browser_API'
      @.spectron.root_Path.assert_Contains 'BSIMM-Graphs-QA'
      done()

  it 'html() with Promise', (done)->
    browser_API.open().then =>
      browser_API.html().then (html)->
        html.assert_Contains '<title></title>'
        done()

  it 'html() with Callback', (done)->
    browser_API.open().then =>
      browser_API.html (html)->
        html.assert_Contains '<title></title>'
        done()

  it '$html()', (done)->
    browser_API.open().then =>
      browser_API.$html ($)->                           # test using callback
        $.html().assert_Contains '<title></title>'
        browser_API.$html().then (_$)->                 # test using promise
          _$.html().assert_Contains '<title></title>'
          $.html().assert_Is _$.html()
          done()

  it 'open()', (done)->
    #@.timeout 10000
    browser_API.open().then =>
      using browser_API.spectron.app.browserWindow, ->
        @.getURL().then (url)->
          url.assert_Is browser_API.url_Target_Site + '/d3-radar'
          done()

  it "open('/routes')", (done)->
    #@.timeout 10000
    browser_API.open('/routes').then =>
      using browser_API.spectron.app.browserWindow, ->
        @.getURL().then (url)->
          console.log url
          url.assert_Is browser_API.url_Target_Site + '/view/routes/list'
          done()

  it 'url() ', (done)->
    browser_API.open().then =>
      browser_API.url().then (url)->              # Promise
        url.assert_Contains '/d3-radar'
        browser_API.url (url)->                   # callback
          url.assert_Contains '/d3-radar'
          done()



#  it 'open (with dev tools)', (done)->
#    @.timeout 10000
#    browser_API.open('https://www.google.co.uk').then =>
#      using browser_API.spectron.app.browserWindow, ->
#        @.setPosition(10,-1000)
#        @.setSize(1000,1000)
#        @.openDevTools()  # not working as expected
#        @.getURL().then (url)->
#          url.assert_Contains('www.google')
#          5500.wait ->
#            done()
