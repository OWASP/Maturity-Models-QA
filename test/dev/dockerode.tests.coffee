require 'fluentnode'

Docker = require('dockerode')
MemoryStream = require 'memorystream'
fs     = require 'fs'

describe 'dockerode tests', ()->

  it 'constructor', ()->
    using new Docker(), ->
      if @.modem.socketPath is undefined
        console.log @
      else
        @.modem.socketPath.assert_Is '/var/run/docker.sock'
        @.modem.protocol  .assert_Is 'http'

      #@.listContainers (err, containers)->
      #  #console.log err
      #  #console.log containers
      #  done()

  xit 'Issue 244 - Cannot authenticate when docker env variables are not set', (done)->
    docker = new Docker()

    docker.listImages (err, data)->
      assert_Is_Null data
      err.assert_Is {
                      code: 'ENOENT',
                      errno: 'ENOENT',
                      syscall: 'connect',
                      address: '/var/run/docker.sock' }

      done()

  it 'Issue 244 - Authenticating using docker-machine', (done)->
    docker_Files =  process.env.HOME.path_Combine('.docker/machine/machines/default')
    if (docker_Files.folder_Not_Exists())
      console.log 'skiping since docker-machine does not exist';
      return done()
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

  xit 'check environment variables', ->
    console.log 'DOCKER_TLS_VERIFY ' + process.env.DOCKER_TLS_VERIFY
    console.log 'DOCKER_HOST ' + process.env.DOCKER_HOST
    console.log 'DOCKER_CERT_PATH ' + process.env.DOCKER_CERT_PATH
    console.log 'DOCKER_TLS_VERIFY ' + process.env.DOCKER_TLS_VERIFY

    using new Docker(), ->
      console.log '---------'
      console.log @
      console.log '---------'

  xit 'list images', (done)->
    using new Docker(), ->
      @.listImages (err, images)->
        assert_Is_Null err
        console.log  images.json_Str()
        done()

  create_Docker = ()=>
    docker_Files =  process.env.HOME.path_Combine('.docker/machine/machines/default')
    if (docker_Files.folder_Not_Exists())
      return new Docker()

    ca_File      = docker_Files.path_Combine('ca.pem'  ).assert_File_Exists()
    cert_File    = docker_Files.path_Combine('cert.pem').assert_File_Exists()
    key_File     = docker_Files.path_Combine('key.pem' ).assert_File_Exists()

    options =
      host    : '192.168.99.100'
      port    : 2376
      ca      : ca_File  .file_Contents()
      cert    : cert_File.file_Contents()
      key     : key_File  .file_Contents()

    return new Docker(options)


  it 'pull repo', (done)->
    @.timeout 60000
    repoTag = 'ubuntu:latest' #'ubuntu:14.04'

    docker = create_Docker()

    onFinished = (err, output) ->
      assert_Is_Null err
      console.log output.last()
      output.last().status.assert_Contains repoTag
      done()

    onProgress = (event) ->
      #console.log event

    docker.pull repoTag, (err, stream) ->
      if (err)
        return done(err)

      docker.modem.followProgress(stream, onFinished, onProgress)


  it 'pull diniscruz/bsimm-graphs ', (done)->
    @.timeout 60000
    repoTag = 'diniscruz/bsimm-graphs:latest'
    docker = create_Docker()

    onFinished = (err, output) ->
      assert_Is_Null err
      console.log output.last()
      output.last().status.assert_Contains repoTag
      done()

    onProgress = (event) ->
      if ['Already exists', 'Waiting', 'Extracting', 'Pull complete', 'Downloading', 'Download complete'].not_Contains event.status
        if event.id
          console.log "#{event.status} - #{event.id}"
        else
          console.log #{event.status}

    docker.pull repoTag, (err, stream) ->
      docker.modem.followProgress(stream, onFinished, onProgress)

  it 'run ubunto commands ', (done)->
    docker = create_Docker()

    memStream = new MemoryStream();
    output = '';
    memStream.on 'data', (data)->
      output += data.toString()

    docker.run 'ubuntu', ['bash', '-c', 'uname -a'], memStream,  (err, data, container)->

      console.log output

      data.StatusCode.assert_Is 0
      container.stop (err)->
        err.message.assert_Is 'HTTP code is 304 which indicates error: container already stopped - '
        container.remove (err)->
          assert_Is_Null err
          container.remove (err)->
            console.log  err.message.contains 'HTTP code is 404 which indicates error: no such container - No such container'
            done()

  describe.only 'test ubuntu bash executions', ->
    docker     = null
    container  = null
    output     = null
    memStream = null


    beforeEach ->
      docker    = create_Docker()
      memStream = new MemoryStream();
      output = '';
      memStream.on 'data', (data)->
        output += data.toString()

    afterEach (done)->
      container.remove (err)->
        assert_Is_Null err
        done()


    run_Command = (args, next)->
      docker.run 'ubuntu', args, memStream,  (err, data, _container)->
        container = _container
        next()

    it 'run nothing'          , (done)-> run_Command [     'asd'              ], done
    it 'run: ps'              , (done)-> run_Command ['ps'                    ], done
    it 'run: bash -c uname -a', (done)-> run_Command ['bash', '-c', 'uname -a'], done
    it 'run: bash -c bash'    , (done)-> run_Command ['bash', '-c', 'ps'      ], done

    return
    it 'run and remove (check timings)', (done)->
      docker = create_Docker()



      docker.run 'ubuntu', ['bash', '-c', 'uname -a'], memStream,  (err, data, container)->

        console.log output

        data.StatusCode.assert_Is 0
        container.stop (err)->
          err.message.assert_Is 'HTTP code is 304 which indicates error: container already stopped - '
          container.remove (err)->
            assert_Is_Null err
            container.remove (err)->
              console.log  err.message.contains 'HTTP code is 404 which indicates error: no such container - No such container'
              done()