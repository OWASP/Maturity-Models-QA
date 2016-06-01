return
Browser_API = require '../../src/_Test_APIs/Browser-API'

Spectron_API = require('electrium').Spectron_API

describe '_Test_APIs | browser | Simple-Open_Site', ->

  spectron  = null

  beforeEach ()->
    using new Spectron_API(), ->
      spectron = @
      @.setup()
      #@.options.path = @.options.path.remove('electrium/node_modules/').str()  # temp fix for https://github.com/o2platform/electrium/issues/1
      spectron.options.path = spectron.options.path.remove('electrium/node_modules/').str()
      spectron.app = new spectron.Application(spectron.options)
      #@.app = new @.Application(@.options)
      console.log 'asd 123 aaa'

    console.log 'here'

    aaa = spectron.app.start()
      #.then ()->
      #  console.log 'spectron started'
      #.catch (err)->
      #  console.log 'error: ' + err
    console.log aaa
      #.then =>
      #  @.show()

  afterEach ()->
    spectron.app.stop()
      .then ()->
        console.log 'spectron stopped'
      .catch (err)->
        console.log 'error: ' + err


  it 'open Google',->
    console.log 'will open google'