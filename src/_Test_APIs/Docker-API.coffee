class Docker_API

  server_Url: ()=>
    "http://192.168.99.100:3000"

  is_Docker_Machine: ->
    docker_Files =  process.env.HOME.path_Combine('.docker/machine/machines/default')
    return docker_Files.folder_Exists()


module.exports = Docker_API