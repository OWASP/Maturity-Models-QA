Browser_API = require '../../src/_Test_APIs/Browser-API'

describe 'browser | All-Pages', ->

  browser = null

  before ()->
    browser = new Browser_API()
    using browser.spectron, ->
      @.start()
      #.then =>@.show()

  after ()->
    using browser, ->
      @.spectron?.stop()

  it 'get routes list', (done)->
    browser.open('/routes').then ->
      browser.$html ($)->
        $.html().assert_Contains '<h2>Available routes</h2>'
        $('a').length.assert_Is 37
        $('h2').html().assert_Is('Available routes')
        done()

    #view/routes/list