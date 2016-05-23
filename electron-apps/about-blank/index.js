var app = require('electron').app
var BrowserWindow = require('electron').BrowserWindow

var mainWindow = null

app.on('ready', function () {
    mainWindow = new BrowserWindow({
        show      : false,
        //center    : true,
        x         : 100,
        y         : -1500,
        width     : 800,
        height    : 400
    })
    mainWindow.loadURL('file://' + __dirname + '/..web-view/index.html')
    mainWindow.on('closed', function () { mainWindow = null })
})
