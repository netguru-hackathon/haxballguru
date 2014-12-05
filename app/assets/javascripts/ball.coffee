class Pitch
  constructor: (selector)->
    @node = $(selector)
    @width = @node.width()
    @height = @node.height()

  center: ->
    {
      x: @width/2
      y: @height/2
    }

class Ball
  constructor: (@pitch)->
    @radius = 50
    @position = { x: @pitch.width / 2, y: @pitch.height / 2 }
    @speed = { x: 0, y: 0 }

  updatePosition: ->
    @position.x += @speed.x
    @position.y += @speed.y
    if (@position.x >= @pitch.width - @radius && @speed.x > 0)
      @speed.x = -@speed.x
    if (@position.x <= @radis && @speed.x < 0)
      @speed.x = -@speed.x
    if (@position.y >= @pitch.height - @radius && @speed.y > 0)
      @speed.y = -@speed.y
    if (@position.y <= @radius && @speed.y < 0)
      @speed.y = -@speed.y

  detectCollisions: ->
    for ball in @pitch.balls
      next if ball == this
      if ballCollision(ball)
        drawCollision(this, ball)
        calculateNewVelocities(this, ball)

   ballCollision: (ball)->
     (@position.x + @radius + ball.radius > ball.positon.x) && (@position.x < ball.x + radius + ball.radius) && (@position.y + @radius + ball.radius > ball.position.y) && (y < ball.y + @radius + balls.radius) && (distanceTo(this, ball) < @radius + @ball.radius)

   distanceTo: (positionA, positionB)->
     distance = Math.sqrt(((positionA.x - positionB.x) * (positionA.x - positionB.x)) + ((positionA.y - positionB.y) * (positionA.y - positionB.y)))
     distance *= -1 if distance < 0
     distance

   calculateNewVelocities: (firstBall, secondBall)->
      mass1 = firstBall.radius
      mass2 = secondBall.radius
      velX1 = firstBall.speed.x
      velX2 = secondBall.speed.x
      velY1 = firstBall.speed.y
      velY2 = secondBall.speed.y

      newVelX1 = (velX1 * (mass1 - mass2) + (2 * mass2 * velX2)) / (mass1 + mass2)
      newVelX2 = (velX2 * (mass2 - mass1) + (2 * mass1 * velX1)) / (mass1 + mass2)
      newVelY1 = (velY1 * (mass1 - mass2) + (2 * mass2 * velY2)) / (mass1 + mass2)
      newVelY2 = (velY2 * (mass2 - mass1) + (2 * mass1 * velY1)) / (mass1 + mass2)

      firstBall.speed = { x: newVelX1, y: newVelY1 }
      secondBall.speed = { x: newVelX2, y: newVelY2 }

      firstBall.position = { x: newVelX1, y: newVelY1 }
      secondBall.position = { x: newVelX2, y: newVelY2 }

      firstBall.x = firstBall.x + newVelX1
      firstBall.y = firstBall.y + newVelY1
      secondBall.x = secondBall.x + newVelX2
      secondBall.y = secondBall.y + newVelY2

class Player
  constructor: (@pitch, @position, @name)->
    @radius = 25
    @maxSpeed = 5
    @speed = { x: 0, y: 0 }
    @render()

  render: ->
    @node = $('<div/>', class: 'player red')
    @pitch.node.append @node

  updatePosition: ->
    @node.css top: @position.y, left: @position.x

class Game
  constructor: ->
    @bindNavigation()
    @pitch = new Pitch('.dynamic-pitch')
    @keys = { left: false, right: false, up: false, down: false }
    position = {
      x: (@pitch.center().x)-50
      y: (@pitch.center().y)-50
    }
    @player = new Player(@pitch, position, 'red' )
    @pitch.players = [@player]
    setInterval( @movePlayer, 1 )

  movePlayer: =>
    @player.position.x += 1 if @keys.right
    @player.position.x -= 1 if @keys.left
    @player.position.y -= 1 if @keys.up
    @player.position.y += 1 if @keys.down
    @player.updatePosition()

  bindNavigation: ->
    $(document).keydown @onKeyDown
    $(document).keyup @onKeyUp

  onKeyDown: (evt) =>
    @keys.left = true   if (evt.keyCode == 37)
    @keys.up = true     if (evt.keyCode == 38)
    @keys.right = true  if (evt.keyCode == 39)
    @keys.down = true   if (evt.keyCode == 40)

  onKeyUp: (evt) =>
    @keys.left = false   if (evt.keyCode == 37)
    @keys.up = false     if (evt.keyCode == 38)
    @keys.right = false  if (evt.keyCode == 39)
    @keys.down = false   if (evt.keyCode == 40)

$ ->
  game = new Game()
