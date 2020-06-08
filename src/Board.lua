Board = Class{}

function Board:init(params)
    self.x = params.x                   -- X position of top left corner of board
    self.y = params.y                   -- Y position of top left corner of board
    self.width = params.width           -- Width of board in tiles
    self.height = params.height         -- Height of board in tiles
    self.num_types = params.num_types   -- Number of panels to use in generation
    
    self.cursor = Cursor({board = self, board_x = 3, board_y = 6})  -- Initialize cursor in starting position
    self.panels = {}  -- Table of panels in the board to be filled
    self:gen_board()  -- Initialize board
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

    -- Render cursor
    self.cursor:render()
end

--[[
    Generates panels in a board for playing
]]
function Board:gen_board()
    for row = 1, BOARD_HEIGHT do
        table.insert(self.panels, {})
        for col = 1, BOARD_WIDTH do
            if row > 6 then
                table.insert(self.panels[row], Panel({
                    board = self,
                    board_x = col,
                    board_y = row,
                    type = math.random(self.num_types)}))
            else
                table.insert(self.panels[row], Panel({
                    empty = true
                }))
            end

        end
    end
    
    -- Determine matches until no matches are found
end

--[[
    Translates the board coordinates of a panel to the pixel coordinates of the window
]]
function Board:board_to_pixel(board_x, board_y)
    return {x = (board_x-1)*PANEL_DIM+self.x, y = (board_y-1)*PANEL_DIM+self.y}
end
