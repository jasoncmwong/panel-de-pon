Panel = Class{}

function Panel:init(params)
    self.board = params.board           -- Board the panel is assigned to
    self.board_x = params.board_x       -- X position in the board (not in pixels)
    self.board_y = params.board_y       -- Y position in the board (not in pixels)
    self.type = params.type             -- Type of block
    self.empty = params.empty or false  -- Whether a panel should render
end

function Panel:render(offset_x, offset_y)
    if not self.empty then
        local pixel_coords = self.board:board_to_pixel(self.board_x, self.board_y)
        love.graphics.draw(g_textures['panels'],
                           g_quads['panels'][self.type],
                           pixel_coords.x,
                           pixel_coords.y)
    end
end
