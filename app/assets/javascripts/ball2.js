CollidingBoxes = function(ioLib){

  var keys = {
    left: false,
    right: false,
    up: false,
    down: false
  };

  createPlayer = function(xPos, xVel, fillStyle){
    return ioLib.addToGroup('boxes'
      ,new iio.Circle(xPos,ioLib.canvas.height/2,20)
      .setFillStyle(fillStyle)
      .enableKinematics()
      .setVel(xVel,xVel)
      .setBound('left', 0
        ,function(obj){
          obj.vel.x = 1;
          return true;
         })
      .setBound('right', ioLib.canvas.width
        ,function(obj){
          obj.vel.x = -1;
          return true;
        })
      .setBound('top', 0
        ,function(obj){
          obj.vel.y = 1;
          return true;
         })
      .setBound('bottom', ioLib.canvas.height
        ,function(obj){
          obj.vel.y = -1;
          return true;
        }));
  }

  createBall = function(xPos, xVel, fillStyle){
    return ioLib.addToGroup('boxes'
      ,new iio.Circle(xPos,ioLib.canvas.height/2,20)
      .setFillStyle(fillStyle)
      .enableKinematics()
      .setVel(xVel,xVel)
      .setBound('left', 0
        ,function(obj){
          obj.vel.x = 1;
          return true;
         })
      .setBound('right', ioLib.canvas.width
        ,function(obj){
          obj.vel.x = -1;
          return true;
        })
      .setBound('top', 0
        ,function(obj){
          obj.vel.y = 1;
          return true;
         })
      .setBound('bottom', ioLib.canvas.height
        ,function(obj){
          obj.vel.y = -1;
          return true;
        }));
  }

  // calculateNewVelocities = function(firstBall, secondBall) {
  //   var mass1, mass2, newVelX1, newVelX2, newVelY1, newVelY2, velX1, velX2, velY1, velY2;
  //   mass1 = firstBall.radius;
  //   mass2 = secondBall.radius;
  //   velX1 = firstBall.speed.x;
  //   velX2 = secondBall.speed.x;
  //   velY1 = firstBall.speed.y;
  //   velY2 = secondBall.speed.y;
  //   newVelX1 = (velX1 * (mass1 - mass2) + (2 * mass2 * velX2)) / (mass1 + mass2);
  //   newVelX2 = (velX2 * (mass2 - mass1) + (2 * mass1 * velX1)) / (mass1 + mass2);
  //   newVelY1 = (velY1 * (mass1 - mass2) + (2 * mass2 * velY2)) / (mass1 + mass2);
  //   newVelY2 = (velY2 * (mass2 - mass1) + (2 * mass1 * velY1)) / (mass1 + mass2);
  //   firstBall.speed = {
  //     x: newVelX1,
  //     y: newVelY1
  //   };
  //   secondBall.speed = {
  //     x: newVelX2,
  //     y: newVelY2
  //   };
  //   firstBall.position = {
  //     x: newVelX1,
  //     y: newVelY1
  //   };
  //   secondBall.position = {
  //     x: newVelX2,
  //     y: newVelY2
  //   };
  //   firstBall.x = firstBall.x + newVelX1;
  //   firstBall.y = firstBall.y + newVelY1;
  //   return secondBall.x = secondBall.x + newVelX2;
  // }


  movePlayer = function(player) {
    player.setVel((keys.right && 3) || (keys.left && -3) || 0, (keys.up && -3) || (keys.down && 3) || 0)
  };

  bindNavigation = function() {
    $(document).keydown(onKeyDown);
    $(document).keyup(onKeyUp);
    return true
  };

  onKeyDown = function(evt) {
    if (evt.keyCode === 37) keys.left = true;
    if (evt.keyCode === 38) keys.up = true;
    if (evt.keyCode === 39) keys.right = true;
    if (evt.keyCode === 40) keys.down = true;
    return true
  };

  onKeyUp = function(evt) {
    if (evt.keyCode === 37) keys.left = false;
    if (evt.keyCode === 38) keys.up = false;
    if (evt.keyCode === 39) keys.right = false;
    if (evt.keyCode === 40) keys.down = false;
    return true
  };

  var player = createPlayer(ioLib.canvas.width-600, 3, 'blue');
  var ball = createBall(ioLib.canvas.width-300, 0, 'red');

  ioLib.setCollisionCallback('boxes'
    ,function(box1, box2){
       var temp = box1.vel;

       if(box1.vel.x >= box2.vel.x) {
        temp.x = temp.x+1;
       }else{
        temp.x = temp.x-1;
       }

      if(box1.vel.y >= box2.vel.y) {
        temp.y = temp.y+1;
       }else{
        temp.y = temp.y-1;
       }
       box2.vel = temp;
     });


  bindNavigation();
  ioLib.setFramerate(100, function(){
    movePlayer(player)
  });

};

$(document).ready(function(){

  iio.start(CollidingBoxes);
});
