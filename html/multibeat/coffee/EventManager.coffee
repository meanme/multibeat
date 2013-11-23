###User: mmarinucci
Copyright © mename 2013 All rights reserved
EventManager
###

class EventManager

    @publish : (name, data, node) ->
        node?= document
        event = document.createEvent 'Event'
        event.initEvent name, true, true
        event.customData = data
        node.dispatchEvent event

    @subscribe : (name, callback, node) ->
        node?= document
        node.addEventListener name, ((event) ->
            callback event.customData, event
        ), true

    @unsubscribe : (name, callback, node) ->
        node?= document
        node.removeEventListener name, ((event) ->
            callback event.customData, event
        ), true


root = exports ? window
root.EventManager = EventManager