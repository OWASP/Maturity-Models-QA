JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | directives | projects.page', ->

  project = 'bsimm'
  team    = 'team-A'
  jsDom   = null
  page    = "/view/#{project}/#{team}"
  
  beforeEach (done)->
    jsDom = new JsDom_API()                                   # create JsDom API object
    jsDom.open page, ->                                       # open defined page (above)
      jsDom.wait_No_Http_Requests ->                          # wait until all http requests have been invoked
        done()

  it 'check ng-view contents', ()->
    using jsDom, ->
      links = @.$('.sub-nav a')                               # get all navigation links

      test_Link = (text, url)=>                               # function to test links
        link = links[index++]                                 # get link to test
        link.text.assert_Is text                              # confirm link text is expected value
        link.click()                                          # click on link
        @.$location().url().assert_Is url                     # confirm location matches expected value



      index = 1                                               # this is a really weird timing bug since this check doesn't work here
      #test_Link 'bsimm', "/view/project/#{project}"
      test_Link 'view' , "/view/#{project}/#{team}"
      test_Link 'table', "/view/#{project}/#{team}/table"
      test_Link 'radar', "/view/#{project}/#{team}/radar"
      test_Link 'edit' , "/view/#{project}/#{team}/edit"
      index = 0                                               # but it works here
      test_Link 'bsimm', "/view/project/#{project}"


  it 'check links active state', ()->
    using jsDom, -> 
      links = @.$('.sub-nav a')
      links.eq(1).parent().eq(0).attr('class').assert_Contains 'active'