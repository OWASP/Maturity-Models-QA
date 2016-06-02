Browser_API = require '../../src/_Test_APIs/Browser-API'
Http_API    = require '../../src/_Test_APIs/Http-API'
async       = require 'async'

describe.only 'browser | All-Pages', ->

  browser = null
  http    = null

  before ()->
    browser = new Browser_API()
    http    = new Http_API()

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

  xit 'open all pages (http)', (done)->

    check_Link = (href, next)->
      #console.log "Loading #{href}"
      http.GET href, (html)->
        html.size().assert_Is_Bigger_Than 3
        next()

    http.$GET '/view/routes/list ', ($)->
      links = (link.attribs.href for link in $('a'))
      links.assert_Size_Is 37
      async.eachSeries links, check_Link, done

  it 'open all pages (browser and http)', (done)->
    @.timeout 60000
    check_Link = (href, next)->
      #console.log '> opening: ' + href
      browser.open(href).then ->                                          # opening href in a browser
        if href.contains 'team-random'                                    # special check for pages with random content
          href.size().assert_Is_Bigger_Than 20                            # we can;t   
          next()
        else
          browser.html (html_Browser)->
            http.GET href, (html_Http)->
              if html_Http.contains 'Found. Redirecting to '
                href = html_Http.remove ('Found. Redirecting to ')
                href = '/' + href if not href.starts_With ('/')
                http.GET href, (html_Http)->
                  html_Browser.assert_Is html_Http.remove('<!DOCTYPE html>')
                  next()
              else
                if html_Browser.contains '<html><head></head><body>'
                  html_Browser = html_Browser.remove '<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">'
                                             .remove '<html><head></head><body>'
                                             .remove '</pre></body></html>'
                                             .remove '</body></html>'
                  html_Http = html_Http.replace(/&/g,'&amp;')
                html_Http = html_Http.remove('<!DOCTYPE html>')

                html_Browser.assert_Is html_Http
                next()

    browser.open('/view/routes/list ').then ->
      #browser.show()
      browser.$html ($)->
        links = (link.attribs.href for link in $('a') )
        async.eachSeries links, check_Link, done