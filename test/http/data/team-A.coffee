Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | data | team-A', ->

  http_API = null
  project  = null
  team     = null

  before ()->
    http_API = new Http_API()
    project  = 'bsimm'
    team     = 'team-A'

  it 'check team-A.json data', (done)->
    http_API.GET_Json "/api/v1/team/#{project}/get/#{team}", (json)->
      json.metadata.team.assert_Is 'Team A'
      using json.activities, ->
        @.Governance['SM.1.1'].assert_Is 'Yes'
        @._keys().assert_Size_Is 4
        @.Governance._keys().assert_Size_Is 20
      done()
