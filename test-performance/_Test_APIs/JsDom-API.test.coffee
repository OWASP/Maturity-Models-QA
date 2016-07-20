JsDom_API  = require '../../src/_Test_APIs/JsDom-API'

describe '_Test_APIs | JsDom_API', ->

  jsDom_API = null

  beforeEach ()->
    jsDom_API = new JsDom_API()

  it 'constructor', ->
    using jsDom_API,->
      @.constructor.name.assert_Is 'JsDom_API'
      @.travis_API.constructor.name.assert_Is 'Travis_API'

  it '$app, $http, $scope, $location', (done)->
    using jsDom_API,->
      @.open ()=>
        @.$app(  ).                length.assert_Is 1
        @.$http( ).pendingRequests.size().assert_Is 1
        @.$scope().$$watchers     .size().assert_Is 2
        @.$location().url()   .assert_Is '/view'
        @.$location().$$absUrl.assert_Is 'http://localhost:3000/view'

        done()

  it 'open()', (done)->
    using jsDom_API,->
      @.open ($, window)->
        window.angular.version.full.assert_Is '1.5.7'
        window.$.fn.jquery.assert_Is '3.1.0'
        (window.$ is $).assert_Is_True()
        $('body').eq(0).parent().html().assert_Contains('<head><meta class="foundation-mq-small">');

        assert_Is_Undefined window.$('ng-view').eq(0).html()
        done()

  #todo: remove test and replace with one that uses   wait_No_Http_Requests
  it 'open() with 250 delay', (done)->     # was 10ms locally
    using jsDom_API,->
      @.open ($, window)->
        250.wait ->
          window.$('ng-view').eq(0).html().assert_Contains '<p>Welcome. Please chose one of the menu options (above)</p>'
          done()

  it 'server_Url', ->
    using jsDom_API,->
      @.server_Url().assert_Is @.travis_API.server_Url()
      
  it 'wait_No_Http_Requests', (done)->
    using jsDom_API,->
      @.open 'view/routes', ()=>
        #assert_Is_Undefined @.window.$('ng-view').eq(0).html()
        @.wait_No_Http_Requests =>
          @.window.$('ng-view').eq(0).html().size().assert_Is_Bigger_Than 6000
          @.window.$('ng-view a').length.assert_Is_Bigger_Than 20
          @.window.$('ng-view a').eq(1).html().assert_Is '/api/v1/data/:project/:team/radar'
          done()
        