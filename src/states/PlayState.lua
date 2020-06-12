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
    elseif love.keyboard.was_pressed('up') then
        self.board.cursor:move(UP)
    elseif love.keyboard.was_pressed('left') then
        self.board.cursor:move(LEFT)
    elseif love.keyboard.was_pressed('down') then
        self.board.cursor:move(DOWN)
    elseif love.keyboard.was_pressed('right') then
        self.board.cursor:move(RIGHT)
    elseif love.keyboard.was_pressed('f') then
        self.board:swap()
    end
end

function PlayState:render()
    self.board:render()
end
