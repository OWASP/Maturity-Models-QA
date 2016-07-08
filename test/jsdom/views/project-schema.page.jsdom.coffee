cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | project-schema.page', ->

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
      @.$('h4').text().assert_Is 'Schema for Project bsimm -  activities'

      # check table headers
      table_Headers = (@.$(th).html() for th in @.$('table th'))
      table_Headers.assert_Is [ 'Domain', 'Practice', 'Key', 'Level', 'Activity' ]

      # check table content
      all_Rows  = @.$('table tr')
      all_Cells = @.$('table td')

      all_Rows .length.assert_Is 113
      all_Cells.length.assert_Is 352

      cell_Values = (@.$(th) for th in @.$('table td')) # confirm current wrong values

      cell_Values[0].text().assert_Is "Governance"
      cell_Values[1].text().assert_Is "Strategy & Metrics"
      cell_Values[2].text().assert_Is "SM.1.1"
      cell_Values[3].text().assert_Is "1"
      cell_Values[4].text().assert_Is "Publish process (roles, responsibilities, plan), evolve as necessary"

      cell_Values[0].attr('rowspan').assert_Is '34'
      cell_Values[1].attr('rowspan').assert_Is '11'
      cell_Values[2].attr('rowspan').assert_Is ''

      cell_Values[0].attr('id').assert_Is "Governance"
      cell_Values[1].attr('id').assert_Is "SM"
      cell_Values[2].attr('id').assert_Is "SM.1.1"

      @.$('#Governance').parent().find('td').length.assert_Is 5