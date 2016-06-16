class Docker_API

  constructor: (options)->
    @.options = options || {}
    @.port    = @.options.port || 3000

  server_Url: ()=>
    if @.in_Travis()
      return 'http://46.101.86.5'       # using digital ocean image
    else
      return 'http://localhost:3000'    # using local server (manually started)


  in_Travis: ->
    "/home/travis".folder_Exists()

module.exports = Docker_API