require 'fluentnode'

Docker = require('dockerode')
fs     = require 'fs'

describe.only 'dockerode tests', ()->

  it 'constructor', (done)->
    using new Docker(), ->
      log @
      #@.modem.socketPath.assert_Is '/var/run/docker.sock'
      #@.modem.protocol  .assert_Is 'http'

      @.listContainers (err, containers)->
        console.log err
        console.log containers
        done()

  it 'Issue 244 - Cannot authenticate when docker env variables are not set', (done)->
    docker = new Docker()

    docker.listImages (err, data)->
      assert_Is_Null data
      err.assert_Is {
                      code: 'ENOENT',
                      errno: 'ENOENT',
                      syscall: 'connect',
                      address: '/var/run/docker.sock' }
      console.log err
      console.log data
      done()

  it 'Issue 244 - Authenticating using docker-machine', (done)->
    docker_Files =  process.env.HOME.path_Combine('.docker/machine/machines/default')
    ca_File      = docker_Files.path_Combine('ca.pem'  ).assert_File_Exists()
    cert_File    = docker_Files.path_Combine('cert.pem').assert_File_Exists()
    key_File     = docker_Files.path_Combine('key.pem' ).assert_File_Exists()

    options =
      host    : '192.168.99.100'
      port    : 2376
      ca      : ca_File  .file_Contents()
      cert    : cert_File.file_Contents()
      key     : key_File  .file_Contents()

    docker = new Docker(options)
    docker.listImages (err, images)->
      assert_Is_Null err
      images.assert_Size_Is_Bigger_Than 10
      done()


    #ca: fs.readFileSync('ca.pem'),
    #cert: fs.readFileSync('cert.pem'),
    #key: fs.readFileSync('key.pem')

    #.docker/machine/machines/default