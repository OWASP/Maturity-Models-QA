require 'fluentnode'

Docker_API = require '../../src/_Test_APIs/Docker-API'

describe '_Test_APIs | Docker_API', ->

  it 'constructor', ->
    using new Docker_API(), ->
      @.constructor.name.assert_Is 'Docker_API'
      @.options.assert_Is {}
      @.port.assert_Is    3000

  xit 'server_Url', ->      # unstable until a better way is found to switch between local and cloud server
    using new Docker_API(), ->
      @.using_Docker_Machine = -> true
      @.server_Url().assert_Is 'http://46.101.86.6'  # using digital ocean image
      #@.server_Url().assert_Is  'http://192.168.99.100:3000'
      #@.server_Url().assert_Is  'http://localhost:3000'
      @.using_Docker_Machine = -> false
      #@.server_Url().assert_Is 'http://188.166.175.74'
      #@.server_Url().assert_Is 'http://localhost:3000'
      @.server_Url().assert_Is 'http://46.101.86.6'

  it 'using_Docker_Machine', ->
    using new Docker_API(), ->
      console.log 'using docker machine: ' + @.using_Docker_Machine()
      if process.env.HOME.path_Combine('.docker/machine').folder_Exists()
        @.using_Docker_Machine().assert_Is_True()
      else
        @.using_Docker_Machine().assert_Is_False()


