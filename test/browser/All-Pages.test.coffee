Browser_API = require '../../src/_Test_APIs/Browser-API'

describe.only 'browser | All-Pages', ->

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
      browser.html (html)->
        cheerio = require 'cheerio'
        html.assert_Contains '<html><head>'
        $ = cheerio.load(html)
        $('a').length.assert_Is 37
        done()

    #view/routes/list