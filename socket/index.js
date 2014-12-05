var io = require('socket.io').listen(4001);

var sockets = {};
var hosts   = {};

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

  socket.on('game.register_host', function() {
    hosts[socket.id] = socket;
  });

  socket.on('game.host_left', function() {
    delete hosts[socket.id];
  });

});
