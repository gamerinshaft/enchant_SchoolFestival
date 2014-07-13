DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620

enchant()

core = {}
window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT

  play_img = []
  play_img.push './play.png'
  core.preload play_img

  core.onload = ->
    titleScene = new Scene()
    core.pushScene titleScene
    titleBack = new Sprite DISPLAY_WIDTH, DISPLAY_HEIGHT
    titleBack.image = core.assets['./play.png']
    titleScene.addChild titleBack
  core.start()
