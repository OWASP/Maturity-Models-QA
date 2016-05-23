Spectron_API = require '../../src/Spectron-API'

wait = ()->
  new Promise (resolve)=>
    1000.wait ->
      resolve()

describe 'Spectron-API tests',->

  @.timeout 8000

  spectron = null;

  before ->
    spectron = new Spectron_API().setup()
    spectron.start()

  after ->
    wait().then ->
      spectron.stop()

  it 'open', ->
    using spectron, ->
      @.window().showInactive()
      #@.open 'https://www.google.com'
      @.window().loadURL('https://www.google.co.uk')
      @.client().waitUntilWindowLoaded()
        .then =>
            @.client().getTitle().then (title)=>
              title.assert_Is ''
              @.window().getURL().then (url)=>
                console.log url
                url.assert_Contains 'https://www.google.co.uk'



  xit 'start window manually', ->
    spectron.setup()
    using spectron, ->
      @.start()
        .then =>
          @.window().showInactive()
          @.window().loadURL('http://www.google.com')
          @.client().waitUntilWindowLoaded().then =>
            @.client().getTitle().then (title)=>
              title.assert_Is ''
              @.client().getHTML('*').then (html)=>
                html[0].assert_Contains 'Google'
