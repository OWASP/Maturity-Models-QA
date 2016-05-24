require 'fluentnode'

Http_API = require '../../src/_Test_APIs/Docker-API'

describe '_Test_APIs | Http_API', ->

  it 'constructor', ->
    using new Http_API(), ->
      @.constructor.name.assert_Is 'Docker_API'

  it 'server_Url', ->
    using new Http_API(), ->
      @.server_Url().assert_Is 'http://192.168.99.100:3000'

