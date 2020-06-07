Board = Class{}

function Board:init(x, y, width, height)
    self.x = x              -- X position of top left corner of board
    self.y = y              -- Y position of top left corner of board
    self.width = width      -- Width of board in tiles
    self.height = height    -- Height of board in tiles
    self.panels = {}        -- Table of panels in the board
end

function Board:render()
    -- Render the board bounding box
    love.graphics.rectangle('fill', self.x, self.y, self.width*16, self.height*16)

    -- Render an example block
    love.graphics.setColor(111/255, 203/255, 159/255, 255/255)
    love.graphics.rectangle('fill', self.x, self.y, 16, 16, 2)
end
