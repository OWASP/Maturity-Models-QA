require 'fluentnode'

Browser_API = require '../../src/_Test_APIs/Browser-API'

describe '_Test_APIs | Http_API', ->

  it 'constructor', ->
    using new Browser_API(), ->
      @.constructor.name.assert_Is 'Browser_API'

