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
    core.kayogamehowtoscene = new KayoGameHowToScene()
    core.replaceScene(core.kayogamehowtoscene)


#---------------------かよゲーム説明シーン-----------------------
class KayoGameHowToScene extends Scene
  constructor: ->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./img/kayo_hawto.jpg']

    @addChild @bg

  ontouchend: ->
    core.popScene()
    core.kayogamescene = new KayoGameScene()
    core.replaceScene(core.kayogamescene)
#---------------------かよゲームシーン-----------------------

class KayoGameScene extends Scene
  constructor: ->
    core.keybind(16, "a")
    core.keybind(70, "b")
    core.keybind(32, "c")

    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.backgroundColor = 'wheat'

    @bgaction = new KayoGameSceneBackAction()
    @chara = new KayoGameSceneChara()

    @numberOfBomb = 3
    @bomblabel = new KayoGameSceneBomb(@numberOfBomb)
    @isOnceDoAmongPressKey = 0
    @staffs = []
    @kasuris = []
    @staffCycle = 40
    @pt = 0
    @gameTime = 0

    @time = new KayoGameSceneTime()
    @scoreLabel = new KayoGameSceneScore(@pt)

    @addChild @bg
    @addChild @bomblabel
    @addChild @bgaction
    @addChild @time
    @addChild @scoreLabel
    @addChild @chara


  onenterframe: ->
    @gameTime += 1/core.fps
    if core.frame % 20 == 0 && @staffCycle > 10
      @staffCycle -= 1
    if core.frame % @staffCycle == 0
      @rin = new KayoGameSceneRin()
      @addChild @rin
      @addChild @rin.kasuri
      @staffs.push @rin
      @kasuris.push @rin.kasuri
    i = @staffs.length
    j = @kasuris .length
    if core.input.b && @numberOfBomb > 0
      if @isOnceDoAmongPressKey == 0
        @isOnceDoAmongPressKey = 1
        while i
          @staffs.splice i, 1
          @removeChild @staffs[--i]
        while j
          @kasuris.splice j, 1
          @removeChild @kasuris[--j]
        @removeChild @bomblabel
        @bomblabel = new KayoGameSceneBomb(--@numberOfBomb)
        @addChild @bomblabel
    else
      @isOnceDoAmongPressKey = 0

    while i
      @staff = @staffs[--i]
      @kasuri = @kasuris[--j]
      if @kasuri.intersect(@chara)
        @removeChild @scoreLabel
        @scoreLabel = new KayoGameSceneScore(++@pt)
        @addChild @scoreLabel
      else if @kasuri.y > DISPLAY_HEIGHT
        @removeChild @kasuri

      if @staff.intersect(@chara)
        @staffs.splice i, 1
        @removeChild @staff
        core.popScene()
        core.gameover = new KayoGameOverScene(@gameTime.toFixed(2), @pt)
        core.pushScene core.gameover

      else if @staff.y > DISPLAY_HEIGHT
        @removeChild @staff

class KayoGameSceneChara extends Sprite
  constructor: ->
    super(58, 95)
    @image = core.assets['./img/kayo_chara.png']
    @moveTo(DISPLAY_WIDTH / 2 - @width / 2 , DISPLAY_HEIGHT - @height * 1)
    @scaleX = 1
    @scaleY = 1

  onenterframe: ->
    if core.input.left
      @scaleX = 1
      if core.input.a
        @x -= 5 if @x > 0
      else
        @x -= 15 if @x > 0

    if core.input.right
      @scaleX = -1
      if core.input.a
        @x += 5 if @x < DISPLAY_WIDTH - @width
      else
        @x += 15 if @x < DISPLAY_WIDTH - @width

class KayoGameSceneBomb extends Label
  constructor: (num)->
    super()
    @text = '残りボム数:' + num
    @color = 'darkred'
    @moveTo(10,10)
    @font = '28px serif'

class KayoGameSceneTime extends Label
  constructor: ->
    super()
    @time = 0
    @text = @time + ' 秒'
    @x = DISPLAY_WIDTH - 200
    @y = 10
    @color = 'darkred'
    @font = '28px italic'

  onenterframe: ->
    @time += 1 / core.fps
    @text = @time.toFixed(2).toString() + ' 秒'

class KayoGameSceneBackAction extends Sprite
  constructor: ->
    super(205,165)
    @image = core.assets['./img/gohan_bg.png']
    @x = DISPLAY_WIDTH/2 - @width/2
    @y = DISPLAY_HEIGHT/2 - @height/2

class KayoGameSceneRin extends Sprite
  constructor: ->
    super(83,144)
    @kasuri = new Kasuri()

    @image = core.assets['./img/kayo_rin.png']
    @x = Math.random() * (DISPLAY_WIDTH - @width * 1.1)
    @kasuri.x = @x - 10
    @scaleX = 1.1
    @scaleY = 1.1
    @y = - @height * 1.1

    @kasuri.scaleX = 1.1
    @kasuri.scaleY = 1.1
    @kasuri.y = - @kasuri.height * 1.1

  onenterframe: ->
    @y += 13
    @kasuri.y += 13

class Kasuri extends Sprite
  constructor: ->
    super(103, 144)

class KayoGameSceneScore extends Label
  constructor: (score) ->
    super()
    @text = score + ' Pt'
    @x = DISPLAY_WIDTH - 200
    @y = 50
    @color = 'darkred'
    @font = '28px meiryo'


#------------------かよゲームオーバーシーン--------------------
class KayoGameOverScene extends Scene
  constructor: (time, point)->
    super()
    @bg = new Sprite(DISPLAY_WIDTH, DISPLAY_HEIGHT)
    @bg.image = core.assets['./img/kayogameover.jpg']

    @datatime = new Label()
    @datatime.backgroundColor = 'white'
    @datatime.height = 50
    @datatime.textAlign = 'center'
    @datatime.text = '時間：' + time
    @datatime.color = 'midnightblue'
    @datatime.font = '48px serif'
    @datatime.x = DISPLAY_WIDTH - 420
    @datatime.y = DISPLAY_HEIGHT - 200

    @datascore = new Label()
    @datascore.backgroundColor = 'white'
    @datascore.height = 50
    @datascore.textAlign = 'center'
    @datascore.text = 'スコア：' + point
    @datascore.color = 'midnightblue'
    @datascore.font = '48px serif'
    @datascore.x = DISPLAY_WIDTH - 420
    @datascore.y = DISPLAY_HEIGHT - 100

    @addChild @bg
    @addChild @datatime
    @addChild @datascore

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
  assets.push('./img/kayo_hawto.jpg')
  core.preload assets


  core.onload = ->
    @titleScene = new TitleScene()
    @kayoGameScene = new KayoGameScene()
    @pushScene @titleScene
  core.start()

