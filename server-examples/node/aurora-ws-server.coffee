fs = require 'fs'
path = require 'path'
WebSocketServer = require('ws').Server

wss = new WebSocketServer { port: 8080 }
audioFolder = './'

wss.on 'connection', (ws) ->
  audioStream = null
  audioPath = ''

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

    else if msg.pause
      audioStream?.pause()

    else if msg.reset
      audioStream?.removeAllListeners()
      createFileStream()

    return

  createFileStream = ->
    audioStream = fs.createReadStream audioPath
    audioStream.pause()

    audioStream.on 'data', (data) ->
      ws.send data, { binary: true }

    audioStream.on 'end', ->
      ws.send JSON.stringify { end: true }

return