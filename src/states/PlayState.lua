PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.board = Board({
        x = (VIRTUAL_WIDTH-BOARD_WIDTH*16)/2,
        y = 10,
        width = BOARD_WIDTH, 
        height = BOARD_HEIGHT,
        num_types = 5
    })
end

function PlayState:update()
    if love.keyboard.was_pressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.board:render()
end
