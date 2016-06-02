require 'fluentnode'
cheerio = require 'cheerio'

Docker_API   = require './Docker-API'
Spectron_API = require('electrium').Spectron_API

class Browser_API

  constructor: ->
    @.url_Target_Site = new Docker_API().server_Url()
    @.spectron        = new Spectron_API().setup()
    @.spectron.options.path = @.spectron.options.path.remove('electrium/node_modules/').str()

  html: (callback)=>
    @.spectron.app.client.getHTML('html').then (html)->
      callback(html) if callback
      return html

  $html: (callback)=>
    @.spectron.app.client.getHTML('html')
      .then (html)->
        $ = cheerio.load html
        callback($) if callback
        return $
      .catch (err)->                  # to this for now, need a better solution to handle errors that happen inside
        console.log err               # .then() blocks


  open: (path)=>
    url = @.url_Target_Site + (path || '/')
    #console.log 'opening ' + url
    @.spectron.window().loadURL(url)
      .catch (err)->
        console.log err

  show: ()=>
    @.spectron.show()

  url: (callback)=>
    @.spectron.app.browserWindow.getURL().then (url)->    # seems to be more robust than @.spectron.app.client.getUrl()
      callback(url) if callback
      return url
      
module.exports = Browser_API