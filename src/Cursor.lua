Cursor = Class{}

function Cursor:init(params)
    self.board = params.board
    self.board_x = params.board_x
    self.board_y = params.board_y
end

function Cursor:render()
    local pixel_coords = self.board:board_to_pixel(self.board_x, self.board_y)
    love.graphics.draw(g_textures['cursor'], g_quads['cursor'], pixel_coords.x-1, pixel_coords.y-1)
end

--[[
    Handles cursor movement, restricting it only within the board
]]
function Cursor:move(dir)
    if dir == UP then
        self.board_y = math.max(1, self.board_y-1)
    elseif dir == LEFT then
        self.board_x = math.max(1, self.board_x-1)
    elseif dir == DOWN then
        self.board_y = math.min(BOARD_HEIGHT, self.board_y+1)
    else  -- Right
        self.board_x = math.min(BOARD_WIDTH-1, self.board_x+1)  -- Subtract 1 from width since cursor is 2 panels wide
    end
end
