aurora-websocket
================

WebSocket streaming plugin for [aurora.js](https://github.com/audiocogs/aurora.js)


This will expose the following method on the aurora.js AV.Player class:

```javascript
AV.Player.fromWebSocket(serverUrl, fileName)
```

Use your WebSocket server URI and track file name, eg:

```javascript
var player = AV.Player.fromWebSocket('ws://localhost:8080', '01 Conundrum.flac');
player.play();
```

Look to the server-examples folder for the server implementation required.
So far I have only provided an implementation in Node, feel free to pull request with others.


MIT Licensed.