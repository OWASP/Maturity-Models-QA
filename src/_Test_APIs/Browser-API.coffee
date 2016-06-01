require 'fluentnode'
cheerio = require 'cheerio'

Spectron_API = require('electrium').Spectron_API

class Browser_API

  constructor: ->
    @.url_Target_Site = "http://46.101.86.6"
    @.spectron        = new Spectron_API().setup()
    @.spectron.options.path = @.spectron.options.path.remove('electrium/node_modules/').str()

  html: (callback)=>
    @.spectron.app.client.getHTML('html').then (html)->
      callback(html) if callback
      return html

  open: (path)=>
    url = @.url_Target_Site + (path || '/')
    console.log 'opening ' + url
    @.spectron.window().loadURL(url)

  url: (callback)=>
    @.spectron.app.browserWindow.getURL().then (url)->    # seems to be more robust than @.spectron.app.client.getUrl()
      callback(url) if callback
      return url
      
module.exports = Browser_API