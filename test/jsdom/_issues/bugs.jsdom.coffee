JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | bugs', ->

  jsDom = null
  page  = '/view/samm/team-F/edit'

  before (done)->
    jsDom = new JsDom_API()
    jsDom.open page, ->
      jsDom.wait_No_Http_Requests ->
        done()

  it 'Issue 120 - Save is broken ',->
    using jsDom, ->
      original_Value = 'SAMM - team F'
      new_Value      = 'team abc'
      
      team_Name = @.window.angular.element(@.$('#team-name'))     # get the angular element
      scope     = team_Name.scope()                               # get the scope

      scope.metadata.team.assert_Is original_Value                # check value in scope
      team_Name.val()    .assert_Is original_Value                # check value in element


      team_Name.val(new_Value)                                    # change value in element
               .triggerHandler('input')                           # will trigger a digest

      team_Name.val()    .assert_Is new_Value                     # confirm change in element
      scope.metadata.team.assert_Is new_Value                     # confirm change in scope

      console.log @.$('#save-data').html()
      #console.log @.$('tr[id="SM.1.A"] td').size()


