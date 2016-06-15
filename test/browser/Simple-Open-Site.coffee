Browser_API = require '../../src/_Test_APIs/Browser-API'

xdescribe 'browser | Simple-Open_Site', ->
  browser = null

  before ()->
    browser = new Browser_API()

    using browser.spectron, ->
      @.start()

  after ()->
    using browser, ->
      @.spectron?.stop()


  it 'open /',->
    browser.show()
    browser.open().then ->
      browser.$html ($)->
        $.html().assert_Contains("MM_Graph")
        return 'ok'

#  it 'get routes list', (done)->
#    browser.open('/routes').then ->
#      browser.$html ($)->
#        $.html().assert_Contains '<h2>Available routes</h2>'
#        $('a').length.assert_Is_Bigger_Than 37
#        $('h2').html().assert_Is('Available routes')
#        done()