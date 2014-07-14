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

  ontouchstart: ->
    core.menuScene = new MenuScene()
    core.pushScene(core.menuScene)

class MenuSceneLabel extends Label
  constructor: ->
    super()
    @text = '遊ぶゲームを選んでね！'
    @width = core.width
    @font = '38px serif'
    @y = 50
    @x = 390
    @color = 'rgb(251, 0, 126)'

class MenuScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./menu.png']
    @menuscenelabel = new MenuSceneLabel()
    @menuscenekayo = new MenuSceneKayo()

    @addChild @bg
    @addChild @menuscenelabel
    @addChild @menuscenekayo

class MenuSceneKayo extends Sprite
  constructor: ->
    super(404, 178)
    @image = core.assets['./kayo_menu2.png']
    @moveTo(395,120)
  ontouchstart: ->
    console.log('hoge')
    core.popScene()
    core.kayogamescene = new KayoGameScene()
    core.replaceScene(core.kayogamescene)


class KayoGameScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./bento1.jpg']

    @addChild @bg

window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT
  assets = []
  assets.push('./title_name.png')
  assets.push('./title_back1.jpg')
  assets.push('./menu.png')
  assets.push('./kayo_menu2.png')
  assets.push('./bento1.jpg')
  core.preload assets

  core.onload = ->
    @titleScene = new TitleScene()
    @pushScene @titleScene
  core.start()
