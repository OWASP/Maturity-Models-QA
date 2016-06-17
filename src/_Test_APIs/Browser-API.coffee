require 'fluentnode'
cheerio = require 'cheerio'

Travis_API   = require './Travis-API'
Spectron_API = require('electrium').Spectron_API

class Browser_API

  constructor: ->
    @.travis_Api      = new Travis_API()
    @.url_Target_Site = @.travis_Api.server_Url()
    @.spectron        = new Spectron_API().setup()
    @.spectron.options.path = @.spectron.options.path.remove('electrium/node_modules/').str() # handle bug in electrium

  html: (callback)=>
    @.spectron.app.client.getHTML('html')
      .then (html)->
        callback(html) if callback
        return html
      .catch (err)->
        console.log err

  $html: (callback)=>
    @.spectron.app.client.getHTML('html')
      .then (html)->
        $ = cheerio.load html
        callback($) if callback
        return $
      .catch (err)->                                        # to this for now, need a better solution to handle errors that happen inside
        console.log err                                     # .then() blocks


  open: (path, callback)=>
    if typeof(path) is 'function'                           # handle cases when callback is provided with no path
      callback = path
      url = @.url_Target_Site
    else
      url = @.url_Target_Site + (path || '/')
    #console.log 'opening ' + url
    @.spectron.open url
      .then ()->
        callback() if callback
      .catch (err)->
        console.log err

  show: ()=>
    @.spectron.show()

  url: (callback)=>
    @.html().then ()=>                                      # todo: find why calling the @.html first makes getUrl more robust
        @.spectron.app.client.getUrl()
          .then (url)->
            callback(url) if callback
            return url
          .catch (err)->
            console.log err

  #wait_No_Http_Requests: (next)=>                          # todo: implement this method for browser tests
module.exports = Browser_API