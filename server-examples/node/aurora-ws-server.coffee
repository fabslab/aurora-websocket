fs = require 'fs'
path = require 'path'
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
    # you will most likely want to stream at the native playback rate of the
    # audio instead of doing this since it will stream too fast and the client will 
    # have to wait for all websocket events (and thus the whole file to be transferred) 
    # before it can begin playback
    # ffmpeg offers that style of streaming using the "-re" flag
    # https://trac.ffmpeg.org/wiki/StreamingGuide#The-reflag
    audioStream = fs.createReadStream audioPath

    unless playing
      audioStream.pause()

    audioStream.on 'data', (data) ->
      ws.send data, { binary: true }

    audioStream.on 'end', ->
      ws.send JSON.stringify { end: true }

console.log "Serving WebSocket for Aurora.js on port #{port}"
