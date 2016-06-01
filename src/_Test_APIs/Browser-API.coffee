require 'fluentnode'

Spectron_API = require('electrium').Spectron_API

class Browser_API
  constructor: ->
    @.spectron = new Spectron_API().setup()
    @.spectron.options.path = @.spectron.options.path.remove('electrium/node_modules/').str()
    
module.exports = Browser_API