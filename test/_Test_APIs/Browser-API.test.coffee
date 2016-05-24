return
Browser_API = require '../../src/_Test_APIs/Browser-API'


describe '_Test_APIs | Browser_API', ->

  it 'constructor', ->
    using new Browser_API(), ->
      @.constructor.name.assert_Is 'Browser_API'
      @.spectron_API.assert_Is_Object()

