module.exports = function ( ) {
    return {
        files: [
            { pattern: 'src/**/*.coffee'}
        ],

        tests: [
            //'test/**/*.coffee'
            //'test/browser/All-Pages.test.coffee'
            //'test/**/JsDom*.coffee'
            'test/jsdom/**/*.coffee'
            //'test/http/**/*.coffee'
        ],

        testFramework: 'mocha',

        env: {
            type: 'node'
        },
        workers: {
            recycle: true
        }
    };
};