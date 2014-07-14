DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620
enchant();
core = {}

#---------------------タイトルシーン-----------------------
class TitleScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./img/title_back1.jpg']
    @titlename = new TitleName()
    @titlelabel = new TitleLabel()

    @addChild @bg
    @addChild @titlename
    @addChild @titlelabel


class TitleName extends Sprite
  constructor: ->
    super(657, 110)
    @titleNameState = 'up'
    @image = core.assets['./img/title_name.png']
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


  ontouchstart: ->
    core.menuScene = new MenuScene()
    core.pushScene(core.menuScene)

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

#---------------------メニューシーン-----------------------

class MenuScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./img/menu.png']
    @menuscenelabel = new MenuSceneLabel()
    @menuscenekayo = new MenuSceneKayo()

    @addChild @bg
    @addChild @menuscenelabel
    @addChild @menuscenekayo

class MenuSceneLabel extends Label
  constructor: ->
    super()
    @text = '遊ぶゲームを選んでね！'
    @width = core.width
    @font = '38px serif'
    @y = 50
    @x = 390
    @color = 'rgb(251, 0, 126)'


class MenuSceneKayo extends Sprite
  constructor: ->
    super(404, 178)
    @image = core.assets['./img/kayo_menu2.png']
    @moveTo(395,120)
  ontouchend: ->
    core.popScene()
    core.kayogamescene = new KayoGameScene()
    core.replaceScene(core.kayogamescene)


#---------------------かよゲームシーン-----------------------

class KayoGameScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.backgroundColor = 'wheat'

    @chara = new KayoGameSceneChara()
    @bgaction = new KayoGameSceneBackAction()

    @addChild @bg
    @addChild @bgaction
    @addChild @chara

class KayoGameSceneChara extends Sprite
  constructor: ->
    super(146, 191)
    @image = core.assets['./img/kayo_chara.png']
    @moveTo(10,DISPLAY_HEIGHT - @height)

  onenterframe: ->
    if core.input.left
      @scaleX = 1
      @x -= 8 if @x > 0
    if core.input.right
      @scaleX = -1
      @x += 8 if @x < DISPLAY_WIDTH - @width


class KayoGameSceneBackAction extends Sprite
  constructor: ->
    super(205,165)
    @image = core.assets['./img/gohan_bg.png']
    @x = DISPLAY_WIDTH/2 - @width/2
    @y = DISPLAY_HEIGHT/2 - @height/2

#-------------------------メイン---------------------------
window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT
  assets = []
  assets.push('./img/title_name.png')
  assets.push('./img/title_back1.jpg')
  assets.push('./img/menu.png')
  assets.push('./img/kayo_menu2.png')
  assets.push('./img/bento1.jpg')
  assets.push('./img/kayo_chara.png')
  assets.push('./img/gohan_bg.png')
  core.preload assets

  core.onload = ->
    @titleScene = new TitleScene()
    @kayoGameScene = new KayoGameScene()
    @pushScene @titleScene
  core.start()
