module.exports = function ( ) {
    return {
        files: [
            { pattern: 'electron-apps/**/*.*', instrument: false},
            { pattern: 'src/**/*.coffee'},
        ],

        tests: [
            'test/**/*.coffee'
        ],

        testFramework: 'mocha',

        env: {
            type: 'node'
        },
        debug:false
    };
};