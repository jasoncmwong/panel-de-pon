PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.board = Board((VIRTUAL_WIDTH-BOARD_WIDTH*16)/2, 10, BOARD_WIDTH, BOARD_HEIGHT)
end

function PlayState:update()
    if love.keyboard.was_pressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.board:render()
end
