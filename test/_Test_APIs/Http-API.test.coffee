require 'fluentnode'

Http_API = require '../../src/_Test_APIs/Http-API'

describe '_Test_APIs | Http_API', ->

  it 'constructor', ->
    using new Http_API(), ->
      @.constructor.name.assert_Is 'Http_API'
      @.docker_API.constructor.name.assert_Is 'Docker_API'

 it 'GET', (done)->
   using new Http_API(), ->
    @.GET '/', (html)->
      console.log html
      html.assert_Is 'Found. Redirecting to d3-radar'
      done()       