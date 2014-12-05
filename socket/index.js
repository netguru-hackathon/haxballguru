var io = require('socket.io').listen(4001);

var sockets = {};
var hosts   = {};

var MAX_PLAYERS = 4;

io.sockets.on('connection', function(socket) {
  sockets[socket.id] = socket;

  broadcast = function(channel, data) {
    for (var v in sockets) {
      // if (v == socket.id)
      //   continue;

      sockets[v].emit(channel, data);
    }
  }

  socket.on('disconnect', function() {
    delete sockets[socket.id];
    delete hosts[socket.id];
  });

  socket.on('lobby.request.new_game', function(game_name) {
    broadcast('lobby.response.new_game', game_name);
  });

  socket.on('lobby.request.host_disconnected', function(game_name) {
    broadcast('lobby.response.host_disconnected', game_name);
  });

  socket.on('lobby.request.discover_available_games', function() {
    broadcast('lobby.response.discover_available_games');
  });

  socket.on('game.register_host', function(name) {
    hosts[name] = { socket: socket, players: [name] };
    console.log(hosts);
  });

  socket.on('game.host_left', function(name) {
    delete hosts[name];
  });

  socket.on('game.request.join', function(name) {

    if (hosts[name] == undefined) {
      socket.emit('game.response.game_not_found');
    } else {
      if (hosts[name]['players'].length >= MAX_PLAYERS) {
        socket.emit('game.response.game_is_full');
      } else {
        socket.emit('game.response.join');
      }
    }
  });

  socket.on('game.request.joined', function(opts) {
    name = opts['name'];
    my_name = opts['my_name'];
    hosts[name]['players'].push(my_name);
    hosts[name]['socket'].emit('game.player_joined', my_name);
  });

  socket.on('game.player_left', function(opts) {
    console.log(opts);
    host = opts['host'];
    name = opts['name'];

    if (hosts[host]['players'].indexOf(name) > 0) {
      hosts[host]['players'].splice(hosts[host]['players'].indexOf(name), 1);
    }

    broadcast('game.response.player_left', name);
  });

});
