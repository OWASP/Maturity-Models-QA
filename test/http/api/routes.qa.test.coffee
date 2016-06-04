Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | api | routes', ->
  http_API = null

  before ()->
    http_API = new Http_API()

  it '/', (done)->
    http_API.GET '/', (data)->
      data.assert_Is 'Found. Redirecting to d3-radar'
      done()

  it '/api/v1/ping', (done)->
    http_API.GET '/ping', (data)->
      data.assert_Is 'pong'
      done()

  it '/api/v1/routes/list', (done)->
    http_API.GET_Json '/api/v1/routes/list', (data)->
      using data , ->
        @.assert_Contains ['/ping', '/d3-radar']
        @.assert_Is_Greater_Than 4
      done()

  it '/view/route/list', (done)->
    http_API.$GET  '/view/routes/list', ($)->
      $('h2').html().assert_Is 'Available routes'
      $('a')[2].attribs.assert_Is { href : '/d3-radar'}
      $.html($('a')[2]).assert_Is '<a href="/d3-radar">/d3-radar</a>'
      links = (a.attribs.href for a in $('a'))                          # get all routes
      links.assert_Size_Is_Bigger_Than 34                               # the routes should have been substituted here
      links.assert_Contains ['/api/v1/file/get/team-random', '/view/team-random/table']
      done()

  it '/view/routes/list-raw', (done)->
    http_API.$GET '/view/routes/list-raw',($)->
      $('h2').html().assert_Is 'Available routes'
      $('a')[2].attribs.assert_Is { href : '/d3-radar'}
      $.html($('a')[2]).assert_Is '<a href="/d3-radar">/d3-radar</a>'
      links = (a.attribs.href for a in $('a'))                          # get all routes
      links.assert_Size_Is_Bigger_Than 13                               # real list of routes
      links.assert_Contains ['/api/v1/file/get/:filename', '/view/:filename/table']
      done()

  it 'redirects', (done)->
    check_Redirect = (source, target, next) ->
      http_API.GET source, (data)->
        data.assert_Is "Found. Redirecting to #{target}"
        next()
    check_Redirect '/routes', '/view/routes/list', ->
      done()

  it 'check link: back to all routes', (done)->
    http_API.$GET '/view/file/list', ($)->
      link = $('#link-to-routes')
      link.attr().assert_Is { id: 'link-to-routes', href: '/routes', class: 'label round success' }
      link.html().assert_Is 'back to all routes'
      done()