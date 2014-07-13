DISPLAY_WIDTH = 930
DISPLAY_HEIGHT = 620

enchant()

core = {}
window.onload = ->
  core = new Core DISPLAY_WIDTH, DISPLAY_HEIGHT
  core.onload = ->
  core.start
