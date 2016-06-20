Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | data | team-A', ->

  http_API = null

  before ()->
    http_API = new Http_API()

  it 'check team-A.json data', (done)->
    http_API.GET_Json '/api/v1/team/demo/get/team-A', (json)->
      json.metadata.team.assert_Is 'Team A'
      json.activities.Governance['SM.1.1'].assert_Is 'Yes'
      json.activities._keys().assert_Size_Is 4
      json.activities.Governance._keys().assert_Size_Is 20
      done()
