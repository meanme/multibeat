###User: mmarinucci
Copyright © mename 2013 All rights reserved
Connection
###

class Connection

    construction: (@socketUrl) ->
        console.log 'socket connection'
        @socket = null

    # Listen for connection events
    onConnectionEvent: (data) =>
        console.log 'connection event'
        if data? and data.message? and data.payload?
            @socket.emit data.message, data.payload

    init: (callback) ->
        @socket = io.connect @socketUrl
        console.log 'init connection'
        @socket.on 'connect', (message) =>
            console.log 'connected'
            if callback? then do callback

        @socket.on 'beat', (beatId) ->
            console.log 'connection beat: ' + beatId
            EventManager.publish 'beat', beatId

        @socket.on 'socketData', (socketData) =>
            console.log 'connection socket data'

            EventManager.publish 'isHost', (socketData? and socketData.host? and socketData.host is @socket.socket.sessionid)
            EventManager.publish 'socketData', socketData

        @socket.on 'data', (message) ->
            console.log "DATA: #{message}"

        EventManager.subscribe 'connection', @onConnectionEvent

    create: (callback) ->
        console.log 'create a new group'
        @init =>
            @socket.emit 'create'
            EventManager.publish 'connected', true

            if callback? then do callback

    join: (groupId, callback) ->
        @init =>
            console.log 'join a group ' + groupId
            @socket.emit 'join', groupId
            EventManager.publish 'connected', true

            if callback? then do callback




root = exports ? window
root.Connection = Connection