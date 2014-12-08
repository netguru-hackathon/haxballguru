class Pitch
  constructor: (selector)->
    @node = $(selector)
    @width = @node.width()
    @height = @node.height()
    @objects = []

  center: ->
    {
      x: @width/2
      y: @height/2
    }

  addChild: (child) ->
    @objects.push child
    @node.append child.node

class Ball
  constructor: (@pitch, @position)->
    @radius = 15
    @position = { x: @pitch.width / 2, y: @pitch.height / 2 }
    @speed = { x: 3, y: 3 }
    @type = 'ball'
    @render()
    setInterval( @stopBall, 500 )

  render: ->
    @node = $('<div/>', class: 'ball').css(width: @radius*2, height: @radius*2)
    @pitch.addChild(@)

  stopBall: =>
    if @speed.x >= 0.5
      @speed.x = @speed.x - 0.5
    else if @speed.x <= -0.5
      @speed.x = @speed.x + 0.5
    else
      @speed.x = 0

    if @speed.y >= 0.5
      @speed.y = @speed.y - 0.5
    else if @speed.y <= -0.5
      @speed.y = @speed.y + 0.5
    else
      @speed.y = 0

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
    @node.css top: @position.y, left: @position.x

  detectCollisions: ->
    for ball in @pitch.objects
      unless ball == this
        if @ballCollision(ball)
          @calculateNewVelocities(this, ball)
          ball.updatePosition()
        else
          this.updatePosition()
          ball.updatePosition()

   ballCollision: (ball) ->
      (@position.x + @radius + ball.radius > ball.position.x) &&
      (@position.x < ball.position.x + @radius + ball.radius) &&
      (@position.y + @radius + ball.radius > ball.position.y) &&
      (@position.y < ball.position.y + @radius + ball.radius) &&
      (@distanceTo(this.position, ball.position) < @radius + ball.radius)

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
      firstBall.position.x = firstBall.position.x + newVelX1
      firstBall.position.y = firstBall.position.y + newVelY1

      secondBall.speed = { x: newVelX2, y: newVelY2 }
      secondBall.position.x = secondBall.position.x + newVelX2
      secondBall.position.y = secondBall.position.y + newVelY2

class Player
  constructor: (@pitch, @position, @className) ->
    @type = 'player'
    @radius = 25
    @speed = { x: 3, y: 3 }
    @render()

  render: ->
    @node = $('<div/>', class: "player #{@className}").css(width: @radius*2, height: @radius*2)
    @pitch.addChild(@)

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
    @node.css top: @position.y, left: @position.x

class Game
  constructor: ->
    @bindNavigation()
    @pitch = new Pitch('.dynamic-pitch')
    @keys = { left: false, right: false, up: false, down: false }
    ballPosition = {
      x: (@pitch.center().x)-100
      y: (@pitch.center().y)-100
    }
    playerPosition = {
      x: @pitch.center().x
      y: @pitch.center().y
    }
    @player = new Player(@pitch, playerPosition, 'red' )
    @ball = new Ball(@pitch, ballPosition)
    @pitch.players = [@player]
    setInterval( @movePlayer, 40 )

  movePlayer: =>
    # if @player.speed.x < 5
    #   @player.speed.x = 5 if @keys.right
    #   @player.speed.x = -5 if @keys.left
    #   @player.speed.x = 0 if @keys.right && @keys.left
    # else
    #   @player.speed.y = 5 if @keys.up
    #   @player.speed.y = -5 if @keys.down
    #   @player.speed.y = 0 if @keys.down && @keys.up
    @ball.detectCollisions()

  bindNavigation: ->
    $(document).keydown @onKeyDown
    $(document).keyup @onKeyUp

  onKeyDown: (evt) =>
    @player.speed.x = -5 if (evt.keyCode == 37)
    @player.speed.y = -5 if (evt.keyCode == 38)
    @player.speed.x = 5 if (evt.keyCode == 39)
    @player.speed.y = 5 if (evt.keyCode == 40)

  onKeyUp: (evt) =>
    @player.speed.x = 0 if (evt.keyCode == 37)
    @player.speed.y = 0 if (evt.keyCode == 38)
    @player.speed.x = 0 if (evt.keyCode == 39)
    @player.speed.y = 0 if (evt.keyCode == 40)

$ ->
  game = new Game()
