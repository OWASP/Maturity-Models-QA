return 
async     = require 'async'
cheerio   = require 'cheerio'
Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | views | d3-radar', ->

  server   = null
  html     = null
  $        = null
  page     = '/d3-radar'

  before (done)->
    server = new Http_API().server_Url()    
    server.add(page).GET (html)->
      $ = cheerio.load(html)
      done()

  it 'html components', ->
    $.assert_Is_Function()
    $('script').length.assert_Is 6
    $('script').attr().assert_Is { src: '/lib/jquery/dist/jquery.min.js' } # this only checks the first file
    $('h3'    ).html().assert_Is 'BSIMM Radar Graphs (v0.7.4)'

  it 'check dependencies can be loaded', (done)->
    @.timeout 4000
    check_Script =  (target, next)->
      target = server.add(target.attribs.src)
      target.GET (html)->
        html.assert_Not_Contains 'Cannot GET'
        next()

    check_Style =  (style, next)->
      target = server.add(style.attribs.href)
      target.GET (html)->
        html.assert_Not_Contains 'Cannot GET'
        next()

    async.eachSeries $('script'), check_Script, ->
      async.eachSeries $('link'), check_Style, done
