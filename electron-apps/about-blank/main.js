var app = require('electron').app
var BrowserWindow = require('electron').BrowserWindow

var mainWindow = null

app.on('ready', function () {
    mainWindow = new BrowserWindow({
        show      : false,
        //center    : true,
        x         : 100,
        y         : -1000,
        width     : 800,
        height    : 500
    })
    mainWindow.loadURL('about:about')

    mainWindow.on('closed', function () { mainWindow = null })
})
