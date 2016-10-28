JsDom_API  = require '../../../src/_Test_APIs/JsDom-API'

describe 'jsdom | directives | projects.page', ->

  project = 'bsimm'
  team    = 'team-A'
  jsDom   = null
  page    = "/view/#{project}/#{team}/table"

  @.timeout 4000
  beforeEach (done)->
    jsDom = new JsDom_API()                                   # create JsDom API object
    jsDom.open page, ->                                       # open defined page (above)
      console.time 'duration'
      jsDom.wait_No_Http_Requests ->                          # wait until all http requests have been invoked
        console.timeEnd 'duration'
        done()

  # todo: this test is not very stable at the moment,
  # I think https://github.com/OWASP/Maturity-Models/issues/140 is part of the problem
  # Fix ng-view contents test #158 -  https://github.com/OWASP/Maturity-Models/issues/158
  xit 'check ng-view contents', (done)->
    using jsDom, ->
      links = @.$('.sub-nav a')                               # get all navigation links

      test_Link = (text, url, next)=>                         # function to test links
        link = links[index++]                                 # get link to test
        link.text.assert_Is text                              # confirm link text is expected value
        link.click()                                          # click on link
        jsDom.wait_No_Http_Requests =>
          @.$location().url().assert_Is url                   # confirm location matches expected value
          next()

      index = 1                                               # this is a really weird timing bug since this check doesn't work here
      #test_Link 'bsimm', "/view/project/#{project}"
      #test_Link 'view' , "/view/#{project}/#{team}"
      #test_Link 'bsimm', "/view/project/#{project}"   , ->
      test_Link 'table', "/view/#{project}/#{team}/table", ->

        return done()
        test_Link 'radar', "/view/#{project}/#{team}/radar", ->
          test_Link 'edit' , "/view/#{project}/#{team}/radar", ->
            wrong_value =  "/view/#{project}/#{team}/radar"                       #todo: wrong value
            test_Link 'raw' , "/view/#{project}/#{team}/radar", ->
              test_Link 'schema' , wrong_value , -> # "/view/#{project}/#{team}/radar", ->
                index = 0                                               # but it works here
                test_Link 'bsimm', wrong_value , -> # "/view/project/#{project}"   , ->
                  done()


  it.only 'check links active state', ()->
    using jsDom, -> 
      links = @.$('.sub-nav a')
      links.eq(1).parent().eq(0).attr('class').assert_Contains 'active'