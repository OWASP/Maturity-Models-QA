cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | raw.page', ->

  jsDom = null
  page  = '/view/bsimm/team-A/raw'
  
  before (done)->
    jsDom = new JsDom_API()
    jsDom.open page, ->
      jsDom.wait_No_Http_Requests ->
        done()

  it 'check menu was loaded ok', ()->
    using jsDom, ->
      @.$('ng-view').length.assert_Is 1
      @.$('.top-bar a').eq(0).attr('href').assert_Is '/view'
      @.$('.top-bar a').eq(1).attr('href').assert_Is '/view/projects'
      @.$('.top-bar a').eq(2).attr('href').assert_Is '/view/routes'

  it 'check page contents', ()->
    using jsDom, ->
      @.$('#data').length.assert_Is 1
      @.$('#data').html().assert_Contains '"team": "Team A"\n'       