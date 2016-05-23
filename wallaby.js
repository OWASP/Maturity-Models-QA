module.exports = function ( ) {
    return {
        files: [
            { pattern: 'electron-apps/**/*.*', instrument: false},
            { pattern: 'src/**/*.coffee'},
        ],

        tests: [
            'test/dev/**/*.coffee'
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