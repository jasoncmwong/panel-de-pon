---- LIBRARIES ----
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

---- UTILITY ---- 
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

---- CLASSES ----
require 'src/Board'
require 'src/Panel'
require 'src/Cursor'

---- STATES ----
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

---- FONTS ----
g_fonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 24)
}

---- GRAPHICS ----
g_textures = {
    ['panels'] = love.graphics.newImage('graphics/panels.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png')
}

g_quads = {
    ['panels'] = gen_panel_quads(g_textures['panels']),
    ['cursor'] = love.graphics.newQuad(0, 0, 34, 18, g_textures['cursor']:getDimensions())
}
