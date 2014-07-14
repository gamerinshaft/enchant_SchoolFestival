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

  ontouchend: ->
   core.menuScene = new MenuScene()
   core.pushScene(core.menuScene)


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

    @bgaction = new KayoGameSceneBackAction()
    @chara = new KayoGameSceneChara()

    @staffs = []
    @staffCycle = 40
    @addChild @bg
    @addChild @bgaction
    @addChild @chara

  onenterframe: ->
    if core.frame % 50 == 0 && @staffCycle > 10
      @staffCycle -= 1
    if core.frame % @staffCycle == 0
      @rin = new KayoGameSceneRin()
      @addChild @rin
      @staffs.push @rin

    i = @staffs.length
    while i
      @staff = @staffs[--i]
      if @staff.intersect(@chara)
        @removeChild @staff
        core.popScene()
        core.gameover = new KayoGameOverScene()
        core.pushScene core.gameover
      else if @staff.y > DISPLAY_HEIGHT
        @removeChild @staff

class KayoGameSceneChara extends Sprite
  constructor: ->
    super(73, 95)
    @image = core.assets['./img/kayo_chara.png']
    @moveTo(DISPLAY_WIDTH / 2 - @width / 2 , DISPLAY_HEIGHT - @height)


  onenterframe: ->
    if core.input.left
      @scaleX = 1
      @x -= 12 if @x > 0
    if core.input.right
      @scaleX = -1
      @x += 12 if @x < DISPLAY_WIDTH - @width


class KayoGameSceneBackAction extends Sprite
  constructor: ->
    super(205,165)
    @image = core.assets['./img/gohan_bg.png']
    @x = DISPLAY_WIDTH/2 - @width/2
    @y = DISPLAY_HEIGHT/2 - @height/2

class KayoGameSceneRin extends Sprite
  constructor: ->
    super(83,144)
    @image = core.assets['./img/kayo_rin.png']
    @x = Math.random() * (DISPLAY_WIDTH - @width)
    @y = - @height

  onenterframe: ->
    @y += 10

#------------------かよゲームオーバーシーン--------------------
class KayoGameOverScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./img/kayogameover.jpg']

    @addChild @bg

  ontouchend: ->
    core.popScene()
    @titleScene = new TitleScene()
    core.pushScene @titleScene

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
  assets.push('./img/kayo_rin.png')
  assets.push('./img/kayogameover.jpg')

  core.preload assets

  core.onload = ->
    @titleScene = new TitleScene()
    @kayoGameScene = new KayoGameScene()
    @pushScene @titleScene
  core.start()
