cheerio   = require 'cheerio'
JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | projects.page', ->

  jsDom = null
  page  = '/view/bsimm/team-A/table'
  
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
      # 3 levels exist
      @.$('#level-1').html().assert_Contains 'Level 1'
      @.$('#level-2').html().assert_Contains 'Level 2'
      @.$('#level-3').html().assert_Contains 'Level 3'

      # level 1 headers
      table_Headers = (@.$(th).html() for th in @.$('#level-1 table th'))

      table_Headers.assert_Is [ '#', 'Domain', 'Practice', 'Activity', 'Level', 'Question',
                                'Yes', 'No', 'NA', 'Maybe', 'Proof' ]


      # level 2 data
      all_Rows  = @.$('#level-1 table tr')
      all_Cells = @.$('#level-1 table td')

      all_Rows.length.assert_Is 1         # this should NOT be 1  (means the only row that exists is the title)
      all_Cells.length.assert_Is 0        # this should NOT be 0  (means there are no cells
