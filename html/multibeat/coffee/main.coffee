###
User: matteo
Copyright © mename 2013 All rights reserved
main - Entry point for multibeatt
###


requiredFiles = ['Connection', 'EventManager', 'MultiBeatClient']
imgSources = []
images = []
imagesLoaded = 0

# Sounds from platinumaudiolab.com
soundMainfest = [
    { id: "00", src: "src/00.wav"},
    { id: "01", src: "src/01.wav"},
    { id: "02", src: "src/02.wav"},
    { id: "03", src: "src/03.wav"}
]
soundsLoaded = 0

socketUrl = 'http://localhost:1337/'
socket = null
connection = null
client = null

preloadImage = (imgSrc) ->
    if imgSrc.length > 0
        for i in [0...imgSrc.length] by 1
            images[i] = new Image()
            images[i].onload = onImageLoaded
            images[i].src = imgSources[i]
    else initApp()

onImageLoaded = (event) ->
    imagesLoaded++
    if (imagesLoaded >= imgSources.length)
        initApp()

init = (element) ->
    #Set up carousel
    $(document.body).addClass 'ready'

    preloadImage imgSources
    return

initApp = () ->
    connection = new Connection socketUrl

    $("#create").click ()->
        console.log 'click create'
        connection.create () ->
            $("#menuButtons").fadeOut()

    $("#join").click () ->
        console.log 'join'
        connection.join 0, () ->
            console.log 'connection join complete'
            $("#menuButtons").fadeOut()

    client = new MultiBeatClient()


    ###socket = io.connect socketUrl
    socket.on 'connect', (message) ->
        console.log 'connected'

    socket.on 'greetings', (message) ->
        console.log "MESSAGE: #{message}"###

    assetPath = 'src/00.wav'
    ###createjs.Sound.addEventListener 'fileload', (event) ->
        console.log 'sound play'
        createjs.Sound.play event.src
    createjs.Sound.registerSound assetPath###


    # TODO - Use a proxy, get rid of soundsLoaded
    createjs.Sound.addEventListener 'fileload', (event)=>
        if ++soundsLoaded >= soundMainfest.length
            console.log 'all sounds loaded'

    createjs.Sound.addEventListener 'loadComplete', (event)->
        console.log 'manifest loaded'
        console.log event
    createjs.Sound.registerManifest soundMainfest, './'


    return

requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
        window.setTimeout callback, 1000 / 60
)()

require(requiredFiles, init)