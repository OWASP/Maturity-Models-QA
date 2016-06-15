cheerio   = require 'cheerio'
Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | views | projects', ->
  $        = null
  page     = '/view/projects'

  before (done)->
    http = new Http_API()
    http.server_Url()
        .add(page).GET (html)->
          $ = cheerio.load(html)
          done()

  it '/projects', ->
    $.assert_Is_Function()
    $('html').attr().assert_Is 'ng-app' : 'MM_Graph'
    $('ng-view'  ).html().assert_Is ''