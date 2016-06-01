module.exports = function ( ) {
    return {
        files: [
            { pattern: 'src/**/*.coffee'}
        ],

        tests: [
            //'test/**/*.coffee'
            'test/browser/All-Pages.test.coffee'
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