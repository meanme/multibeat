###
User: mmarinucci
Copyright © mename 2013 All rights reserved
MultiBeatClient
###

class MultiBeatClient

    constructor: () ->
        # Show the buttons when the user is connected
        EventManager.subscribe 'connected', @onConnected

        EventManager.subscribe 'beat', @playBeat

        $(".soundButton").click (event) =>
            ###console.log 'sound button clicked ' + $(event.target).text()###
            beatId = $(event.target).text()

            # Message targeted toward the connection
            EventManager.publish 'connection',
                message: 'beat'
                payload: beatId

            #@playBeat beatId

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