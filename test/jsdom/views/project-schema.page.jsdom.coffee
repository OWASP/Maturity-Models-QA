cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | projects.page', ->

  jsDom = null
  page  = '/view/project/bsimm/schema'
  
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
      @.$('h4').text().assert_Is 'Schema for Project bsimm - 3 activities'

      # check table headers
      table_Headers = (@.$(th).html() for th in @.$('table th b'))
      table_Headers.assert_Is [ 'Key', 'Level', 'Activity' ]

      # check table content
      all_Rows  = @.$('table tr')
      all_Cells = @.$('table td')

      all_Rows.length.assert_Is 4                              # this should NOT be 4
      all_Cells.length.assert_Is 9                             # this should NOT be just 9

      cell_Values = (@.$(th).text() for th in @.$('table td')) # confirm current wrong values
      cell_Values.assert_Is [ 'domains', '', '', 'practices', '', '', 'activities', '', '' ]