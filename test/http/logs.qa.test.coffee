Http_API  = require '../../src/_Test_APIs/Http-API'

describe '_qa-tests | logs', ->
  http_API = null

  before ()->
    http_API = new Http_API()

  it '/aaaaa', (done)->                                     # make a request to a page that doesn't exist
    http_API.GET '/aaaaa', (data)->
      data.assert_Is 'Cannot GET /aaaaa\n'
      done()

  it '/v1/api/logs/file/0', (done)->                        # get the fist log file
    http_API.GET '/api/v1/logs/file/0', (logs_Data)->
      logs_Data.assert_Contains 'GET /aaaa'
      done()

  it '/v1/api/logs/file/aaabbb', (done)->                   # make a request to a log file that doesn't exist
    http_API.GET '/api/v1/logs/file/aaabbb', (logs_Data)->
      logs_Data.assert_Is 'not found'
      done()

  it '/v1/api/logs/path', (done)->      # make a request to a page that doesn't exist
    http_API.GET '/api/v1/logs/path', (logs_Path)->
      logs_Path.assert_Is_Not 'Cannot GET /api/v1/logs/path\n'
               .assert_Contains 'logs'
      done()

  it '/api/v1/logs/list', (done)->
    http_API.GET_Json '/api/v1/logs/list', (logs_File_Names)->
      logs_File_Names.assert_Size_Is_Greater_Than 0
      http_API.GET '/api/v1/logs/path', (logs_Path)->
        log_File = logs_Path.path_Combine logs_File_Names.first()
        #log_File.assert_File_Exists()                    # can't test this since we don't have access to the file system (when testing on DigitalOCean)
        #log_File.file_Contents().assert_Contains 'GET '
        done()