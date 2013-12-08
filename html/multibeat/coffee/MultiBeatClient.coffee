###
User: mmarinucci
Copyright © mename 2013 All rights reserved
MultiBeatClient
###

class MultiBeatClient

    constructor: () ->

        @instance = null

        # Show the buttons when the user is connected
        EventManager.subscribe 'connected', @onConnected
        EventManager.subscribe 'beat', @playBeat
        EventManager.subscribe 'socketData', @onSocketData
        EventManager.subscribe 'isHost', @initSettings

        $(".soundButton").click (event) =>
            ###console.log 'sound button clicked ' + $(event.target).text()###
            beatId = $(event.target).text()

            # Message targeted toward the connection
            EventManager.publish 'connection',
                message: 'beat'
                payload: beatId

            #@playBeat beatId

        $(".loopButton").click (event) =>
            loopId = "loop#{$(event.target).text()}"

            # Stop the previous beat
            if @instance?
                @instance.stop()

            #play (src, interrupt, delay, offset, loop, volume, pan)
            #src  [interrupt="none"|options]  [delay=0]  [offset=0]  [loop=0]  [volume=1]  [pan=0]
            @instance = createjs.Sound.play loopId, createjs.Sound.INTERRUPT_NONE, 0, 0, -1
            if @instance is null or @instance.playState is createjs.Sound.PLAY_FAILED then return


    initSettings: (isHost) ->
        if isHost
            $("#hostLabel").text 'IS HOST'
        else
            $("#hostLabel").text 'NOT HOST'
            $("#musicButtons").css 'height', '100%'
            $('#loops').css 'display', 'none'

    onSocketData: (socketData) ->
        console.log 'on socket data received'
        console.log socketData
        if socketData? and socketData.id isnt null
            console.log "Socket Group: #{socketData.id}"
            $("#groupLabel").text "#{socketData.id}"


        #EventManager.unsubscribe 'socketData', @onSocketData



    playBeat: (beatId) ->
        console.log 'play beat ' + beatId
        #play (src, interrupt, delay, offset, loop, volume, pan)
        instance = createjs.Sound.play beatId, createjs.Sound.INTERRUPT_NONE, 0, 0, false, 1
        if instance is null or instance.playState is createjs.Sound.PLAY_FAILED then return

    onConnected: (data) ->
        EventManager.unsubscribe 'connected', @onConnected

        console.log 'client connected'

        $("#menuButtons").fadeOut 'slow', 'linear', ->
            $("#connected").fadeIn()

root = exports ? window
root.MultiBeatClient = MultiBeatClient