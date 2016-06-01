require 'fluentnode'

Spectron_API = require('electrium').Spectron_API

class Browser_API

  constructor: ->
    @.url_Target_Site = "http://46.101.86.6"
    @.spectron        = new Spectron_API().setup()
    @.spectron.options.path = @.spectron.options.path.remove('electrium/node_modules/').str()

  open: (path)=>
    url = @.url_Target_Site + (path || '/')
    console.log 'opening ' + url
    @.spectron.window().loadURL(url)

module.exports = Browser_API