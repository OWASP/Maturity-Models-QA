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
      @.$('ng-view li').eq(0).html().assert_Is '<a href="view/project/appsec" class="ng-binding">appsec</a>'
      done()
