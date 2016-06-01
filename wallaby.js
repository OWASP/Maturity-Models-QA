module.exports = function ( ) {
    return {
        files: [
            { pattern: 'src/**/*.coffee'}
        ],

        tests: [
            //'test/**/*.coffee'
            'test/_Test_APIs/Browser-API.test.coffee'
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