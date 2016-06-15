Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | api | files', ->
  
  http_API = null

  before ()->
    http_API = new Http_API()    


  it '/api/v1/files/list', (done)->
    http_API.GET_Json '/api/v1/file/list', (data)->
      data.assert_Contains [ 'coffee-data', 'json-data' ]
      done()

  it '/api/v1/file/get/AAAA', (done)->
    http_API.GET_Json '/api/v1/file/get/AAA', (data)->
      data.error.assert_Is 'not found'
      done()       
      
  it '/api/v1/file/get/json-data', (done)->
    using http_API, ->
      file_1 = 'json-data'
      file_2 = 'coffee-data'

      @.GET_Json "/api/v1/file/get/#{file_1}", (data)=>
        data.user.name.assert_Is 'Joe'

        @.GET_Json "/api/v1/file/get/#{file_2}", (data)->
          data.user.assert_Is 'in coffee'
          done()
           
  it '/api/v1/file/get/json-data?pretty', (done)->
    using http_API, ->
      @.GET '/api/v1/file/get/json-data', (data_json)=>
        @.GET  '/api/v1/file/get/json-data?pretty', (data_pretty)->
          data_json.str()       .assert_Is_Not data_pretty
          data_json.json_Parse().assert_Is data_pretty.json_Parse()
          done()