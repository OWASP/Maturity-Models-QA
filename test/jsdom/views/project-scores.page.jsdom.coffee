cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | project-scores.page', ->

  jsDom = null
  page  = '/view/project/bsimm/scores'
  
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
      # check title
      @.$('h3').text().assert_Is 'All team scores for bsimm'

      # check table headers
      table_Headers = (@.$(th).html() for th in @.$('table th'))
      table_Headers.assert_Is [ 'team', 'Level 1', 'Level 2', 'Level 3' ]

      # check table content
      all_Rows  = @.$('table tr')
      all_Cells = @.$('table td')

      all_Rows .length.assert_Is_Bigger_Than 9
      all_Cells.length.assert_Is_Bigger_Than 40

      @.$('#level-1').text().assert_Is 'level-1level-1 74% 5% 0%'
      @.$('#team-A' ).text().assert_Is 'team-Ateam-A 48% 35% 15%'
      @.$('#team-B' ).text().assert_Is 'team-Bteam-B 26% 28% 13%'