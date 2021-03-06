port = 1337

express = require 'express'

multibeat = require './multibeat'

app = express.createServer( )

app.register '.html', require 'jade'

app.configure( () ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.session(secret: 'blutkind')

    app.use app.router
    app.use express.static(__dirname + '/html')
    app.use express.errorHandler({dumpExceptions: true, showTrack: true})
)

app.listen port

msb = new multibeat.MultiBeatServer.MultiBeatServer app

console.log "Server listening at port #{port}"
