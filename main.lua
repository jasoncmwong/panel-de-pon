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

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')
end

function love.update(dt)
    gStateMachine:update(dt)
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end