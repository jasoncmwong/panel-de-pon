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
