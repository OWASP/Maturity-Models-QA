cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | projects.page', ->

  jsDom = null
  page  = '/view/projects'
  
  before (done)->
    jsDom = new JsDom_API()
    jsDom.open page, ->
      jsDom.wait_No_Http_Requests ->
        done()

  it 'check jsdom loaded ok',->
    using jsDom, ->
      @.$app().length.assert_Is 1
      @.$.fn.jquery.assert_Is '3.0.0'
      @.$http().pendingRequests.size().assert_Is 0

  it 'check ng-view contents', (done)->
    using jsDom, ->
      @.$('ng-view li').length.assert_Is_Bigger_Than 1
      @.$('ng-view li').eq(0).html().assert_Contains '<a href="view/project/bsimm" class="ng-binding">bsimm</a>'
      @.$('a').eq(0).attr('href').assert_Is '/view'
      @.$('a').eq(1).attr('href').assert_Is '/view/projects'
      @.$('a').eq(2).attr('href').assert_Is '/view/routes'
      @.$('a').eq(3).attr('href').assert_Is 'view/project/bsimm'
      @.$('a').eq(4).attr('href').assert_Is 'view/project/bsimm/schema'
      @.$('a').eq(5).attr('href').assert_Is 'view/project/bsimm/scores'
      @.$('a').eq(6).attr('href').assert_Is 'view/project/samm'
      @.$('a').eq(7).attr('href').assert_Is 'view/project/samm/schema'
      @.$('a').eq(8).attr('href').assert_Is 'view/project/samm/scores'
      done()
