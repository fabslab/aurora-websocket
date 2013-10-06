Tests
=====

The tests for Aurora are written using the [QUnit](http://qunitjs.com/) testing framework.  They 
run in both Node.js and the browser.

##Setup

Running the tests requires running an HTTP server to host both QUnit itself (for the browser),
as well as the test data files as used by both the browser and Node to test HTTP loading.

To start a simple static HTTP server in the tests directory, run the following command:

    python -m SimpleHTTPServer
    
If you already have the test directory on an HTTP server, all you need to do is set the base URL of 
the "tests" folder to the `HTTP_BASE` variable in `config.coffee`.

## To run in the browser:

1. Follow the setup steps above.

2. Start HTTP server to host the tests:

        importer test.coffee -p 3031
        
    You may need to install `importer` using `npm install importer -g` first.

3. Run the WebSocket server in the ws-server folder:

        cd ws-server
        npm install
        node aurora-ws-server.js

4. Open `test.html` in your browser, using the HTTP server that you set up above.