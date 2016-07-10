Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | api | files', ->
  
  http_API = null
  project  = null
  team     = null

  before ()->
    http_API = new Http_API()
    project = 'bsimm'
    team    = 'team-A'


  it '/api/v1/files/list', (done)->
    http_API.GET_Json '/api/v1/team/bsimm/list', (data)->
      data.assert_Contains [ 'team-A', 'team-B' ]
      done()

  it '/api/v1/team/:project/get/AAAA', (done)->
    http_API.GET_Json "/api/v1/team/#{project}/get/AAA", (data)->
      data.error.assert_Is 'not found'
      done()       
      
  it '/api/v1/team/:project/get/:team', (done)->
    using http_API, ->
      file_1 = 'team-A'
      file_2 = 'team-random'

      @.GET_Json "/api/v1/team/#{project}/get/#{file_1}", (data)=>
        data.metadata.team.assert_Is 'Team A'
        @.GET_Json "/api/v1/team/#{project}/get/#{file_2}", (data)->
          data.metadata.team.assert_Is 'Team Random'
          done()
           
  it '/api/v1/team/:project/get/team-A?pretty', (done)->
    using http_API, ->
      @.GET "/api/v1/team/#{project}/get/team-A", (data_json)=>
        @.GET  "/api/v1/team/#{project}/get/team-A?pretty", (data_pretty)->
          data_json.str()       .assert_Is_Not data_pretty
          data_json.json_Parse().assert_Is data_pretty.json_Parse()
          done()