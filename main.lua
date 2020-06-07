require 'src/Dependencies'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    love.window.setTitle('Panel de Pon')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false,
    })

    g_state_machine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    g_state_machine:change('start')

    love.keyboard.keys_pressed = {}
end

function love.update(dt)
    g_state_machine:update(dt)
end

function love.draw()
    push:start()
    g_state_machine:render()
    push:finish()
end

function love.keypressed(key)
    love.keyboard.keys_pressed[key] = true
end

function love.keyboard.was_pressed(key)
    if love.keyboard.keys_pressed[key] then
        return true
    else
        return false
    end
end
