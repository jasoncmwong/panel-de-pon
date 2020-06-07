Panel = Class{}

function Panel:init(board_x, board_y, type)
    self.board_x = board_x      -- X position in the board (not in pixels)
    self.board_y = board_y      -- Y position in the board (not in pixels)
    self.type = type            -- Type of block
end

function Panel:render(offset_x, offset_y)
    love.graphics.draw(g_textures['panels'],
                       g_quads['panels'][self.type],
                       (self.board_x-1)*PANEL_DIM + offset_x,
                       (self.board_y-1)*PANEL_DIM + offset_y)
end
