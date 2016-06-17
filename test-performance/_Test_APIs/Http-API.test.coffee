require 'fluentnode'

Http_API = require '../../src/_Test_APIs/Http-API'

describe '_Test_APIs | Http_API', ->

  it 'constructor', ->
    using new Http_API(), ->
      @.constructor.name.assert_Is 'Http_API'
      @.travis_API.constructor.name.assert_Is 'Travis_API'

  it 'GET ....', (done)->
    using new Http_API(), ->
      @.GET '/', (html)->
        console.log html
        assert_Is_Not_Null html 
        html.assert_Is 'Found. Redirecting to /view'
        done()

  it 'server_Url', (done)->
    using new Http_API(), ->
      console.log @.server_Url()
      @.server_Url().GET (html)->
        html.assert_Is 'Found. Redirecting to /view'
        done()