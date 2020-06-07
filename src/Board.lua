Board = Class{}

function Board:init(x, y, width, height, num_types)
    self.x = x                      -- X position of top left corner of board
    self.y = y                      -- Y position of top left corner of board
    self.width = width              -- Width of board in tiles
    self.height = height            -- Height of board in tiles
    self.num_types = num_types      -- Number of panels to use in generation
    self.panels = {}                -- Table of panels in the board

    self:gen_board()
end

function Board:render()
    -- Render outline of board
    love.graphics.setColor(111/255, 203/255, 159/255, 255/255)
    love.graphics.rectangle('fill', self.x-BORDER_PAD, self.y-BORDER_PAD, self.width*16 + BORDER_PAD*2, self.height*16 + BORDER_PAD*2, 3)
    
    -- Render the board bounding box
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width*16, self.height*16)


    -- Render all panels on the board
    for row = 1, #self.panels do
        for col = 1, #self.panels[1] do
            self.panels[row][col]:render(self.x, self.y)
        end
    end
end

--[[
    Generates panels in a board for playing
]]
function Board:gen_board()
    for row = 1, BOARD_HEIGHT do
        table.insert(self.panels, {})
        for col = 1, BOARD_WIDTH do
            table.insert(self.panels[row], Panel(col, row, math.random(self.num_types)))
        end
    end
    
    -- Determine matches until no matches are found
end
