StartState = Class{__includes = BaseState}


function StartState:render()
    local rectWidth = 200
    local rectHeight = 50
    love.graphics.setColor(111/255, 203/255, 159/255, 255/255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH-rectWidth)/2, (VIRTUAL_HEIGHT-rectHeight)/2, rectWidth, rectHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("PANEL DE PON", (VIRTUAL_WIDTH-rectWidth)/2, (VIRTUAL_HEIGHT-gFonts['large']:getHeight())/2, rectWidth, 'center')
end