StartState = Class{__includes = BaseState}


function StartState:update()
    if love.keyboard.was_pressed('escape') then
        love.event.quit()
    end

    if love.keyboard.was_pressed('enter') or love.keyboard.was_pressed('return') then
        g_state_machine:change('play')
    end
end

function StartState:render()
    local rect_width = 200
    local rect_height = 50
    love.graphics.setColor(111/255, 203/255, 159/255, 255/255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH-rect_width)/2, (VIRTUAL_HEIGHT-rect_height)/2, rect_width, rect_height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(g_fonts['large'])
    love.graphics.printf("PANEL DE PON", (VIRTUAL_WIDTH-rect_width)/2, (VIRTUAL_HEIGHT-g_fonts['large']:getHeight())/2, rect_width, 'center')
end