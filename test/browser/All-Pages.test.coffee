Browser_API = require '../../src/_Test_APIs/Browser-API'
Http_API    = require '../../src/_Test_APIs/Http-API'
async       = require 'async'

describe 'browser | All-Pages', ->

  browser = null
  http    = null

  before ()->
    browser = new Browser_API()
    http    = new Http_API()

    using browser.spectron, ->
      @.start()

  after ()->
    using browser, ->
      @.spectron?.stop()

  it 'get routes list', (done)->
    browser.open('/routes').then ->
      browser.$html ($)->
        $.html().assert_Contains '<h2>Available routes</h2>'
        $('a').length.assert_Is_Bigger_Than 37
        $('h2').html().assert_Is('Available routes')
        done()

  it 'open all pages (http)', (done)->                                         # using site hosted at DigitalOcean this test runs in 1.4sec
    @.timeout 3000
    check_Link = (href, next)->                                                # using site hosted at localhost it runs in 680ms
      #console.log "Loading #{href}"
      http.GET href, (html)->
        html.size().assert_Is_Bigger_Than 3
        next()

    http.$GET '/view/routes/list ', ($)->
      links = (link.attribs.href for link in $('a'))
      links.assert_Is_Bigger_Than 37
      async.eachSeries links, check_Link, done


  it 'open all pages (browser and http)', (done)->                            # using site hosted at DigitalOcean this test runs in 16 sec
    @.timeout 40000                                                           #    when running on locahosst this test runs in 12.5 sec
    check_Link = (href, next)->
      #console.log '> opening: ' + href                                       # see page being opened (useful when debugging)
      browser.open(href).then ->                                              # opening href in a browser
        if href.contains 'team-random'                                        # special check for pages with random content
          href.size().assert_Is_Bigger_Than 20                                #    since we can't compare its content with the http version
          next()
        else
          browser.html (html_Browser)->                                       # get html content from browser
            http.GET href, (html_Http)->                                      # get html content via direct http request
              if html_Http.contains 'Found. Redirecting to '                  # if http request is a redirect
                href = html_Http.remove ('Found. Redirecting to ')            #   extract redirect url from html body
                href = '/' + href if not href.starts_With ('/')               #   fix case when redirect doesn't start with a /
                http.GET href, (html_Http)->                                  #   make request to redirect page
                  html_Http = html_Http.remove('<!DOCTYPE html>')             #   remove docktype from html (it is removed in the browser)
                  html_Browser.assert_Is html_Http                            #   compare html from http request with html rendered in browser
                  next()
              else                                                            # else (not an redirect)
                if html_Browser.contains '<html><head></head><body>'          #   check for case when json was sent to browser
                  html_Browser = html_Browser.remove '<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">'
                                             .remove '<html><head></head><body>'
                                             .remove '</pre></body></html>'   #   remove all of these
                                             .remove '</body></html>'         #   that were added by the browser
                  html_Http = html_Http.replace(/&/g,'&amp;')                 #   small encoding fix

                html_Http = html_Http.remove('<!DOCTYPE html>')               #   remove docktype from html (it is removed in the browser)

                html_Browser.assert_Is html_Http                              #   compare html from http request with html rendered in§ browser
                next()

    browser.open('/view/routes/list ').then ->                                # get all current routes from browser
      browser.show()                                                         # don't show the browser (only good when debugging an issue)
      browser.$html ($)->
        links = (link.attribs.href for link in $('a') )                       # extract all links from page
        async.eachSeries links, check_Link, done                              # for each link call check_Link