Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | api | routes', ->
  http_API = null

  before ()->
    http_API = new Http_API()

  it '/', (done)->
    http_API.GET '/', (data)->
      data.assert_Is 'Found. Redirecting to /view'
      done()

  it '/api/v1/ping', (done)->
    http_API.GET '/ping', (data)->
      data.assert_Is 'pong'
      done()

  it '/api/v1/routes/list', (done)->
    http_API.GET_Json '/api/v1/routes/list', (data)->
      using data , ->
        @.assert_Contains ['/ping', '/view*']
        @.assert_Is_Greater_Than 4
      done()


  it 'redirects', (done)->
    check_Redirect = (source, target, next) ->
      http_API.GET source, (data)->
        data.assert_Is "Found. Redirecting to #{target}"
        next()
    check_Redirect '/', '/view', ->
      done()