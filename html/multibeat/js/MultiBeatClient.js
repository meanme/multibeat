// Generated by CoffeeScript 1.3.3

/*
User: mmarinucci
Copyright © mename 2013 All rights reserved
MultiBeatClient
*/


(function() {
  var MultiBeatClient, root;

  MultiBeatClient = (function() {

    function MultiBeatClient() {
      var _this = this;
      this.instance = null;
      EventManager.subscribe('connected', this.onConnected);
      EventManager.subscribe('beat', this.playBeat);
      EventManager.subscribe('socketData', this.onSocketData);
      EventManager.subscribe('isHost', this.initSettings);
      $(".soundButton").click(function(event) {
        /*console.log 'sound button clicked ' + $(event.target).text()
        */

        var beatId;
        beatId = $(event.target).text();
        return EventManager.publish('connection', {
          message: 'beat',
          payload: beatId
        });
      });
      $(".loopButton").click(function(event) {
        var loopId;
        loopId = "loop" + ($(event.target).text());
        if (_this.instance != null) {
          _this.instance.stop();
        }
        _this.instance = createjs.Sound.play(loopId, createjs.Sound.INTERRUPT_NONE, 0, 0, -1);
        if (_this.instance === null || _this.instance.playState === createjs.Sound.PLAY_FAILED) {

        }
      });
    }

    MultiBeatClient.prototype.initSettings = function(isHost) {
      if (isHost) {
        return $("#hostLabel").text('IS HOST');
      } else {
        $("#hostLabel").text('NOT HOST');
        $("#musicButtons").css('height', '100%');
        return $('#loops').css('display', 'none');
      }
    };

    MultiBeatClient.prototype.onSocketData = function(socketData) {
      console.log('on socket data received');
      console.log(socketData);
      if ((socketData != null) && socketData.id !== null) {
        console.log("Socket Group: " + socketData.id);
        return $("#groupLabel").text("" + socketData.id);
      }
    };

    MultiBeatClient.prototype.playBeat = function(beatId) {
      var instance;
      console.log('play beat ' + beatId);
      instance = createjs.Sound.play(beatId, createjs.Sound.INTERRUPT_NONE, 0, 0, false, 1);
      if (instance === null || instance.playState === createjs.Sound.PLAY_FAILED) {

      }
    };

    MultiBeatClient.prototype.onConnected = function(data) {
      EventManager.unsubscribe('connected', this.onConnected);
      console.log('client connected');
      return $("#menuButtons").fadeOut('slow', 'linear', function() {
        return $("#connected").fadeIn();
      });
    };

    return MultiBeatClient;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.MultiBeatClient = MultiBeatClient;

}).call(this);
