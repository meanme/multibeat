// Generated by CoffeeScript 1.3.3

/*User: mmarinucci
Copyright © mename 2013 All rights reserved
Connection
*/


(function() {
  var Connection, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Connection = (function() {

    function Connection() {
      this.onConnectionEvent = __bind(this.onConnectionEvent, this);

    }

    Connection.prototype.construction = function(socketUrl) {
      this.socketUrl = socketUrl;
      console.log('socket connection');
      return this.socket = null;
    };

    Connection.prototype.onConnectionEvent = function(data) {
      console.log('connection event');
      if ((data != null) && (data.message != null) && (data.payload != null)) {
        return this.socket.emit(data.message, data.payload);
      }
    };

    Connection.prototype.init = function(callback) {
      this.socket = io.connect(this.socketUrl);
      this.socket.on('connect', function(message) {
        console.log('connected');
        if (callback != null) {
          return callback();
        }
      });
      this.socket.on('beat', function(beatId) {
        console.log('connection beat: ' + beatId);
        return EventManager.publish('beat', beatId);
      });
      this.socket.on('data', function(message) {
        return console.log("DATA: " + message);
      });
      return EventManager.subscribe('connection', this.onConnectionEvent);
    };

    Connection.prototype.create = function(callback) {
      var _this = this;
      console.log('create a new group');
      return this.init(function() {
        _this.socket.emit('create');
        EventManager.publish('connected', true);
        if (callback != null) {
          return callback();
        }
      });
    };

    Connection.prototype.join = function(groupId, callback) {
      var _this = this;
      return this.init(function() {
        console.log('join a group');
        _this.socket.emit('join', groupId);
        EventManager.publish('connected', true);
        if (callback != null) {
          return callback();
        }
      });
    };

    return Connection;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.Connection = Connection;

}).call(this);