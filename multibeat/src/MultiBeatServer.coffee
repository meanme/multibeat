###
User: mmarinucci
Copyright © mename 2013 All rights reserved
MultiBeatServer
###

io = require 'socket.io'

class exports.MultiBeatServer

    # Static connections dictionary
    @connections : {}
    #Unique group ID
    @groupId : 0

    constructor: (@app) ->
        console.log "multi beat server constructor: #{app}"

        io = require('socket.io').listen app, {transports:['flashsocket', 'websocket', 'htmlfile', 'xhr-polling', 'jsonp-polling']}

        io.set 'log level', 1

        io.sockets.on 'connection', (socket) ->
            console.log 'connection received in multi beat server'

            socket.on 'create', (data) ->
                groupId = MultiBeatServer.groupId
                console.log "create group #{groupId}"
                MultiBeatServer.groupId++

                # Add the group to the dictionary
                MultiBeatServer.connections[groupId] =
                    id: groupId
                    host: socket.id
                    clients: new Array()

                MultiBeatServer.connections[groupId]

                socket.join groupId
                socket.group = groupId

                socket.emit groupId

            socket.on 'join', (data) ->
                console.log 'join multi beat'
                console.log MultiBeatServer.connections

                if MultiBeatServer.connections[data]?
                    console.log 'joining ' + data
                    socket.join data
                    socket.group = data

                    socket.emit 'data', "Welcome to #{MultiBeatServer.connections[data].id}"

                    # Notify all the other clients in the same group
                    socket.broadcast.to(data).emit 'data', "#{socket.id} joined group #{MultiBeatServer.connections[data].id}"
                else
                    console.log 'group not found'
                    socket.emit 'group not found'

            socket.on 'beat', (beatData) ->
                # Decide whether sounds should be player on click or propagated by the server
                socket.emit 'beat', beatData
                socket.broadcast.to(socket.group).emit 'beat', beatData

            socket.on 'data', (data) ->
                console.log 'data received MBS'
                console.log data

            socket.on 'disconnect',  () ->
                console.log 'disconnected'

            ###message = 'hello'
            socket.emit 'greetings', message###

            # TODO - Optionally send a list of available groups


###module.exports.MultiBeatServer = MultiBeatServer###

