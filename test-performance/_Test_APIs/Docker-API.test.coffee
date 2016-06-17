require 'fluentnode'

Travis_API = require '../../src/_Test_APIs/Travis-API'

describe '_Test_APIs | Travis_API', ->

  it 'constructor', ->
    using new Travis_API(), ->
      @.constructor.name.assert_Is 'Travis_API'
      @.options.assert_Is {}
      @.port.assert_Is    3000

  it 'server_Url', (done)->
    using new Travis_API(), ->
      @.server_Url().GET (html)->
        html.assert_Is 'Found. Redirecting to /view'
        done()

