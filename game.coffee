DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620

enchant()

core = {}
window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT

  play_img = []
  play_img.push ''
  core.preload gazou

  core.onload = ->
  core.start
