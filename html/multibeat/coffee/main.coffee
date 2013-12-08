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
    { id: "03", src: "src/03.wav"},

    { id: "loop00", src: "src/loops/looperman-l-0345547-0056297-cufool-im-alive-kick-and-percussion.wav"},
    { id: "loop01", src: "src/loops/looperman-l-0379853-0060060-alen9r-dance-time-drums.wav"},
    { id: "loop02", src: "src/loops/looperman-l-0563503-0044350-tonypowell-trance-loop-with-bass.wav"},
    { id: "loop03", src: "src/loops/looperman-l-0671112-0065844-danke-melodic.wav"}
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

    # TODO - Use a proxy, get rid of soundsLoaded
    createjs.Sound.addEventListener 'fileload', (event)=>
        if ++soundsLoaded >= soundMainfest.length
            console.log 'all sounds loaded'

    createjs.Sound.addEventListener 'loadComplete', (event)->
        console.log 'manifest loaded'
        console.log event
    createjs.Sound.registerManifest soundMainfest, './'

    preloadImage imgSources
    return

initApp = () ->
    connection = new Connection socketUrl

    $("#create").click ()->
        console.log 'click create'
        connection.create () ->
            $("#menuButtons").fadeOut()

    $("#join").click () ->
        groupId = $('#groupId').val()

        console.log groupId
        console.log (groupId isnt "")
        if groupId? and groupId isnt ""
            connection.join groupId, () ->
                console.log 'connection join complete'
                $("#menuButtons").fadeOut()
        else
            alert 'Please enter the group Id'

    client = new MultiBeatClient()

    ###socket = io.connect socketUrl
    socket.on 'connect', (message) ->
        console.log 'connected'

    socket.on 'greetings', (message) ->
        console.log "MESSAGE: #{message}"###

    $("#settingsButton").toggle (->
        $("#cointentOffset").animate
            left: "-360px"
        , 1000
    ), ->
        $("#cointentOffset").animate
            left: "0px"
        , 1000

    #DEBUG - Connect automatically
    ###connection.create () ->
        $("#menuButtons").fadeOut()###

    return

requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
        window.setTimeout callback, 1000 / 60
)()

require(requiredFiles, init)