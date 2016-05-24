#!/usr/bin/env coffee
require 'fluentnode'

Spectron_API = require '../src/Spectron-API'
nesh         = require 'nesh'
global.spectron     = null


setup_Spectron = ->
  using  new Spectron_API(), ->
    global.spectron = @
    @.setup()
    @.start().then =>
      @.show()
      @.window().setAlwaysOnTop(true)
      @.open 'http://news.bbc.co.uk'



start_Nesh = ->
  nesh.loadLanguage 'coffee'
  nesh.start (err, repl) ->
    nesh.log.error err if err

setup_Spectron()
start_Nesh()