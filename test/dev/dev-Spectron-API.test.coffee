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

  it 'start window manually', ->
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
