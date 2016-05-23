Spectron_API = require '../../src/Spectron-API'

describe 'constructor',->
  it 'constructor', ->
    Spectron_API.assert_Is_Function()
    #console.log ''