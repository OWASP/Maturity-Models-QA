Http_API    = require '../../src/_Test_APIs/Http-API'
async       = require 'async'

describe 'http | All-Pages', ->
  http    = null

  before ()->
    http    = new Http_API()

  it 'open all pages (http)', (done)->                                         # using site hosted at DigitalOcean this test runs in 1.4sec
    @.timeout 5000                                                             # for travis run
    check_Link = (href, next)->                                                # using site hosted at localhost it runs in 680ms
      #console.log "Loading #{href}"
      http.GET href, (html)->
        html.size().assert_Is_Bigger_Than 3
        next()

    http.GET_Json '/api/v1/routes/list ', (routes)->
      routes.assert_Is_Bigger_Than 15
      async.eachSeries routes, check_Link, done