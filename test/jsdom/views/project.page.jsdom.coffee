cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | project.page', ->

  jsDom = null
  page  = '/view/project/bsimm'
  
  before (done)->
    jsDom = new JsDom_API()
    jsDom.open page, ->
      jsDom.wait_No_Http_Requests ->
        done()

  it 'check ng-view contents', (done)->
    using jsDom, ->
      @.$('ng-view li').length.assert_Is_Bigger_Than 1
      @.$('a').eq(0).attr('href').assert_Is '/view'
      @.$('a').eq(1).attr('href').assert_Is '/view/projects'
      @.$('a').eq(2).attr('href').assert_Is '/view/routes'
      @.$('a').eq(3).attr('href').assert_Is "view/project/bsimm/schema"
      @.$('a').eq(4).attr('href').assert_Is "view/project/bsimm/scores"

      teams =  (@.$(a).html() for a in @.$('#project li a'))
      teams.assert_Contains [ 'level-1', 'level-2', 'save-test',
                              'team-A', 'team-B', 'team-C', 'team-random' ]
      done()
