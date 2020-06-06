---- LIBRARIES ----
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

---- UTILITY ---- 
require 'src/constants'
require 'src/StateMachine'

---- STATES ----
require 'src/states/BaseState'
require 'src/states/StartState'

---- FONTS ----
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 24)
}