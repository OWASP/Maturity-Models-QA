return
require 'fluentnode'

Spectron_API = require('electrium').Spectron_API

class Browser_API
  constructor: ->
    @.spectron_API = new Spectron_API().setup()
  
module.exports = Browser_API