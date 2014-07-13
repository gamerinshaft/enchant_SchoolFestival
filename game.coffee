DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620
enchant();
core = {}

class TitleLabel extends Label
  constructor: ->
    super()
    @title_op = 'up'
    @text = 'クリックしてスタート！'
    @width = core.width
    @textAlign = 'center'
    @font = '38px cursive'
    @opacity = 0
    @y = 450
    @color = 'white'

  onenterframe: ->
    if @title_op == 'up'
      @opacity += (new Date()).getMilliseconds() / 25000
      if @opacity > 1
        @title_op = 'down'
    else if @title_op == 'down'
      @opacity -= (new Date()).getMilliseconds() / 25000
      if @opacity < 0.1
        @title_op = 'up'

class TitleName extends Sprite
  constructor: ->
    super(657, 110)
    @titleNameState = 'up'
    @image = core.assets['./title_name.png']
    @x = 137
    @y = 255

  onenterframe: ->
    if @titleNameState == 'up'
      @y -= 1
      if @y == 220
        @titleNameState = 'down'
    else if @titleNameState == 'down'
      @y += 1
      if @y == 290
        @titleNameState = 'up'

class TitleScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./title_back1.jpg']
    @titlename = new TitleName()
    @titlelabel = new TitleLabel()

    @addChild @bg
    @addChild @titlename
    @addChild @titlelabel

window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT
  assets = []
  assets.push('./title_name.png')
  assets.push('./title_back1.jpg')
  core.preload assets

  core.onload = ->
    @titleScene = new TitleScene()
    @.pushScene @titleScene
  core.start()
