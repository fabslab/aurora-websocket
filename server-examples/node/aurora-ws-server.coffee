fs = require 'fs'
path = require 'path'
Throttle = require 'throttle'
WebSocketServer = require('ws').Server
port = 8080

wss = new WebSocketServer { port }
audioFolder = './audio'

wss.on 'connection', (ws) ->
  audioStream = null
  audioPath = ''
  playing = false

  ws.on 'close', ->
    audioStream?.removeAllListeners()

  ws.on 'message', (msg) ->
    msg = JSON.parse msg

    if msg.fileName?
      audioPath = path.join audioFolder, msg.fileName
      fs.stat audioPath, (err, stats) ->
        if err
          ws.send JSON.stringify { error: 'Could not retrieve file.' }
        else
          ws.send JSON.stringify { fileSize: stats.size }
          createFileStream()

    else if msg.resume
      audioStream?.resume()
      playing = true

    else if msg.pause
      audioStream?.pause()
      playing = false

    else if msg.reset
      audioStream?.removeAllListeners()
      playing = false
      createFileStream()

    return

  createFileStream = ->
    # throttle to a rate that should be enough for FLAC playback
    # if we don't throttle the WebSocket client can't start playback
    # until the whole file has streamed since the events happen too fast
    audioStream = fs.createReadStream(audioPath).pipe(new Throttle(700 * 1024))

    unless playing
      audioStream.pause()

    audioStream.on 'data', (data) ->
      ws.send data, { binary: true }

    audioStream.on 'end', ->
      console.log 'end'
      ws.send JSON.stringify { end: true }

console.log "Serving WebSocket for Aurora.js on port #{port}"
