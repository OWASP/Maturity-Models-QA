require 'fluentnode'

Spectron_API = require 'electrium'

class Browser_API
  constructor: ->
    @.spectron_API = new Spectron_API().setup()
  
module.exports = Browser_API