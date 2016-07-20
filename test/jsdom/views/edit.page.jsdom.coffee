JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | views | edit.page', ->

  jsDom = null
  page  = '/view/bsimm/team-A/edit'
  
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
      table_Headers = (@.$(th).html() for th in @.$('table th'))
      table_Headers.size().assert_Is 20
      table_Headers.assert_Contains ['ID', 'Yes', 'No', 'NA','Maybe']

      all_Rows  = @.$('table tr')
      all_Cells = @.$('table td')

      all_Rows.length.assert_Is  120
      all_Cells.length.assert_Is 560

      @.$('#save-data').html().assert_Is 'save'         # save button
      @.$('#team-name').val() .assert_Is 'Team A'       # team name input fie
      @.$('#message'  ).html().assert_Is 'data loaded'  # status message
      @.$('#domain'   ).text().assert_Is 'Governance'   # save button

      using @.$('tr[id="SM.1.1"] td'),->
        @.length.assert_Is 5
        @.eq(0).html().assert_Is 'SM.1.1'
        @.eq(1).html().assert_Is '<input type="radio" ng-name="activity" ng-model="data.activities[activity]" value="Yes" class="ng-pristine ng-untouched ng-valid ng-not-empty" name="26">'
        @.eq(1).find('input').val().assert_Is 'Yes'
        @.eq(2).find('input').val().assert_Is 'No'
        @.eq(3).find('input').val().assert_Is 'NA'
        @.eq(4).find('input').val().assert_Is 'Maybe'

  # there is an interesting race condition on this method if it runs after the 'check team name value' one
  xit 'Check save message', (done)->
    using jsDom, ->
      @.$('#message').html().assert_Is 'data loaded'                       # message before save
      @.window.angular.element(@.$('#save-data')).triggerHandler('click')  # this is what triggers the .click() event
      @.wait_No_Http_Requests =>                                           # wait for http requests
        @.$('#message'  ).html().assert_Is 'file saved ok'                 # message after save
        done()

  it 'check team name value',->
    using jsDom, ->
      original_Value = 'Team A'
      new_Value      = 'Team abc'

      team_Name = @.window.angular.element(@.$('#team-name'))     # get the angular element
      scope     = team_Name.scope()                               # get the scope

      scope.metadata.team.assert_Is original_Value                # check value in scope
      team_Name.val()    .assert_Is original_Value                # check value in element



      team_Name.val(new_Value)                                    # change value in element
               .triggerHandler('input')                           # will trigger a digest

      team_Name.val()    .assert_Is new_Value                     # confirm change in element
      scope.metadata.team.assert_Is new_Value                     # confirm change in scope


