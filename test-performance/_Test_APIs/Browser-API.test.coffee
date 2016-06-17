Browser_API = require '../../src/_Test_APIs/Browser-API'

describe '_Test_APIs | Browser_API ...', ->

  browser_API = null

  @.timeout 2000

  before ()->
    browser_API = new Browser_API()
    using browser_API.spectron, ->
      @.start()
        .then ()-> {}
          #console.log 'Browser started'
        .catch (err)->
          console.log err

  after ()->
    using browser_API, ->
      @.spectron?.stop()

  it 'constructor', (done)->
    using browser_API, ->
      @.constructor.name.assert_Is 'Browser_API'
      @.spectron.root_Path.assert_Contains 'Maturity-Models-QA'
      done()

  it 'html() with Promise', (done)->
    browser_API.show()
    browser_API.open('/view/routes').then =>
      browser_API.html().then (html)->
        html.assert_Contains '<html ng-app="MM_Graph" class="ng-scope">'
        browser_API.spectron.app.browserWindow.getURL()
          .then (url)->
            url.assert_Is browser_API.url_Target_Site + '/view/routes'
            done()
          .catch (err)->
            console.log err


  it 'html() with Callback', (done)->
    browser_API.open().then =>
      browser_API.html (html)->
        html.assert_Contains '<html ng-app="MM_Graph" class="ng-scope">'
        done()

  it '$html()', (done)->
    browser_API.open().then =>
      browser_API.$html ($)->                           # test using callback
        $.html().assert_Contains '<html '
        browser_API.$html().then (_$)->                 # test using promise
          _$.html().assert_Contains '<html '
          $.html().assert_Is _$.html()
          done()

  it 'open() with promise', ()->
    browser_API.open()                                  # will fail is something is wrong with the open() call

  it 'open() with callback', (done)->
    browser_API.open '/aaaa', ()->                      # when path is provided
      browser_API.open ()->                             # when path is not provided
        done()

  it "open('/routes')", (done)->
    browser_API.open('/view/routes').then =>
      browser_API.url (url)->
        url.assert_Is browser_API.url_Target_Site + '/view/routes'
        done()

  it 'open() and check angular values', (done)->
    browser_API.show()
    browser_API.open '/view/routes', ->                                 # will fail is something is wrong with the open() call
      browser_API.$html ($)->                                           # before angular digest
        100.wait ->                                                     # wait a bit
          browser_API.$html (_$)->                                      # after angular digest
            $('a').length.assert_Is_Not _$('a').length
            done()

  it 'url()', ()->
    browser_API.open().then  ->
      browser_API.url().then (url)->                    # Promise
        url.assert_Contains '/view'
        browser_API.url (url)->                         # callback
          url.assert_Contains '/view'
