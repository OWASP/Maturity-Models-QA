Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | api | tables', ->
  http_API = null

  before ()->
    http_API = new Http_API()

  # don't exist anymore
  xit '/view/aaaaa/table', (done)->
    http_API.$GET '/api/vi/table/aaaa', ($)->
      $('h2').html().assert_Is 'BSIMM Table for undefined'  # BUG
      done()

  # don't exist anymore
  xit '/view/team-A/table', (done)->
    http_API.$GET  '/view/team-A/table', ($)->
      $('h2').html().assert_Is 'BSIMM Table for Team A'
      $('th').length.assert_Is 4
      $($('th')[0]).html().assert_Is 'Governance'
      $($('th')[1]).html().assert_Is 'Intelligence'
      $($('th')[2]).html().assert_Is 'SSDL'
      $($('th')[3]).html().assert_Is 'Deployment'
      $('tr').length.assert_Is 22
      done()