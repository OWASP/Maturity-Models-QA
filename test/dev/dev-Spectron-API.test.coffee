Spectron_API = require '../../src/Spectron-API'

describe 'Spectron-API tests',->
  spectron = null;

  before ->
    spectron = new Spectron_API()

  @.timeout 5000
  it.only 'start window manually', ->
    about_Blank = spectron.root_Path.path_Combine './electron-apps/about-blank'
    about_Blank.files()
               .file_Names().assert_Is 	[ 'index.js', 'package.json' ]


    wait = ()->
      new Promise (resolve)=>
        console.log 'here 123';
        1000.wait ->
          resolve()


    spectron.setup()
    using spectron, ->
      @.options.args = [about_Blank]
      
      @.start().then => 
                  @.app.browserWindow.showInactive()
                  @.is_Running().assert_Is_True()  
                  wait()
               .then =>
                  console.log 'here 456'
                  @.is_Running().assert_Is_True()
                  @.stop()
               .then =>
                  console.log 'here 789'
                  @.is_Running().assert_Is_False()


#
#      #@.options.args = [about_Blank]
#
#      #      wait = ()->
#      #
#      #        new Promise (resolve)->
#      #          console.log 'here';
#      #          #2000.wait =>
#      #          #  console.log 'here 2';
#      #          resolve()
#
#      @.start().then =>
#        console.log 'here 1'
#        @.stop().then =>
#          console.log 'here 2'
#
#      return "ok"
#
#      @.start().then =>
#                  console.log('here 0');
#                  #wait()
#
#               .then ()=>
#                  console.log('here 3..');
#                  @.stop();
#
##@.options.args = [ __dirname ]
#    #console.log spectron.app.client
#    #console.log ''