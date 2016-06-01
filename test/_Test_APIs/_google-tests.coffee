Browser_API = require '../../src/_Test_APIs/Browser-API'

describe '_Test_APIs | Browser_API | _google-tests', ->

  browser_API = null
  target_Url  = 'https://www.google.co.uk/'

  #beforeEach (done)->
  before (done)->
    browser_API = new Browser_API()
    using browser_API.spectron, ->
      @.start()
        .then =>
          #@.show()
          #console.log "opening #{target_Url}"
          @.window().loadURL(target_Url).then ->     #@.open(target_Url).then ->
            done()
        .catch (err)->
          console.log 'Error in Before: ' + err

  #afterEach ()->
  after ()->
    using browser_API, ->
      @.spectron?.stop()

  it 'no action', ()->
    console.log 'should open and close window ok'

  it 'browserWindow.getURL', (done)->
    using browser_API.spectron, ->
      @.app.browserWindow.getURL().then (url)->
        console.log 'The url is: ' + url
        url.assert_Is target_Url
        done()

  it 'browserWindow.getTitle', (done)->
    using browser_API.spectron, ->
      @.app.browserWindow.getTitle().then (title)->
        console.log 'The title is: ' + title
        title.assert_Is 'Google'
        done()

  it 'client.getHTML', (done)->
    using browser_API.spectron, ->
      @.app.client.getHTML('*').then (html)->
        html.assert_Contains('<title>Google</title>')
        done()

  it 'client.getUrl', (done)->
    using browser_API.spectron, ->
      @.app.client.getUrl().then (url)->
        url.assert_Is target_Url
        done()

