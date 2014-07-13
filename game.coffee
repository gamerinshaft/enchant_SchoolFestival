DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620
titleNameState = 'up'
title_op = 'up'
enchant()

core = {}
window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT

  play_img = []
  play_img.push './title_name.png'
  play_img.push './title_back1.jpg'
  core.preload play_img

  core.onload = ->
    titleScene = new Scene()
    core.pushScene titleScene
    titleName = new Sprite 657, 110
    titleBack = new Sprite DISPLAY_WIDTH, DISPLAY_HEIGHT
    titleBack.image = core.assets['./title_back1.jpg']
    titleName.image = core.assets['./title_name.png']
    titleName.x = 137
    titleName.y = 255
    titleLabel = new Label()
    titleLabel.text = 'クリックしてスタート！'
    titleLabel.width = core.width
    titleLabel.textAlign = 'center'
    titleLabel.font = '38px cursive'
    titleLabel.opacity = 0
    titleLabel.y = 450
    titleLabel.color = 'white'

    titleLabel.onenterframe = ->
      if title_op == 'up'
        titleLabel.opacity += (new Date()).getMilliseconds() / 25000
        if titleLabel.opacity > 1
          title_op = 'down'
      else if title_op == 'down'
        titleLabel.opacity -= (new Date()).getMilliseconds() / 25000
        if titleLabel.opacity < 0.1
          title_op = 'up'

    titleName.onenterframe = ->
      if titleNameState == 'up'
        this.y -= 1
        if this.y == 220
          titleNameState = 'down'
      else if titleNameState == 'down'
        this.y += 1
        if this.y == 290
          titleNameState = 'up'


    titleScene.addChild titleBack
    titleScene.addChild titleName
    titleScene.addChild titleLabel
  core.start()
