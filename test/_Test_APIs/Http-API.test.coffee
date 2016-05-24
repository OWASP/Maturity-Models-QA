require 'fluentnode'

console.log require 'electrium'  

Http_API = require '../../src/_Test_APIs/Http-API'

describe '_Test_APIs | Http_API', ->

  it 'constructor', ->
    using new Http_API(), ->
      @.constructor.name.assert_Is 'Http_API'

