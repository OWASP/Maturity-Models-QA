Http_API = require '../../../src/_Test_APIs/Http-API'
cheerio = require 'cheerio'

describe 'view - d3-radar', ->

  server   = null
  html     = null
  $        = null
  page      = '/live-radar'

  before (done)->
    server = new Http_API().server_Url() + page
    console.log server
    server.GET (html)->
      console.log  html.size()
      $ = cheerio.load(html)
      done()

  it 'html components', ->
    $.assert_Is_Function() 
    $('script').length.assert_Is 5
    $('script').attr().assert_Is { src: '/lib/jquery/dist/jquery.min.js' } # this only checks the first file
    $('h3'    ).html().assert_Is 'BSIMM Radar Graphs (ajax data)'
    console.log $('h3'    ).html()
