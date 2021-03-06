Board = Class{}

function Board:init(params)
    self.x = params.x                   -- X position of top left corner of board
    self.y = params.y                   -- Y position of top left corner of board
    self.width = params.width           -- Width of board in panels
    self.height = params.height         -- Height of board in panels
    self.num_types = params.num_types   -- Number of panels to use in generation
    
    self.cursor = Cursor({board = self, board_x = 3, board_y = 6})  -- Initialize cursor in starting position
    self.panels = {}  -- Table of panels in the board to be filled
    self:gen_board()  -- Initialize board
end

function Board:update(dt)
    for row = #self.panels, 1, -1 do
        for col = 1, #self.panels[1] do
            self.panels[row][col]:update(dt)
        end
    end
    self:replace_panels(self:get_matches(), true)
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
            -- ### DEBUG ###
            -- if not self.panels[row][col].empty then
            --     love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
            --     love.graphics.setFont(g_fonts['small'])
            --     love.graphics.printf(self.panels[row][col].board_x .. ',' .. self.panels[row][col].board_y, self.panels[row][col].x+1, self.panels[row][col].y+1, PANEL_DIM, 'left')
            --         love.graphics.setColor(1, 1, 1, 1)
            -- end
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
                    board = self,
                    board_x = col,
                    board_y = row,
                    empty = true
                }))
            end
        end
    end

    -- Replace matched panels until no matches are found
    local matches = self:get_matches()
    while #matches ~= 0 do
        self:replace_panels(matches, false)
        matches = self:get_matches()
    end
end

--[[
    Translates the board X coordinate of a panel to the X pixel coordinate of the window
]]
function Board:boardx_to_pixel(board_x)
    return (board_x-1)*PANEL_DIM + self.x
end

--[[
    Translates the board Y coordinate of a panel to the X pixel coordinate of the window
]]
function Board:boardy_to_pixel(board_y)
    return (board_y-1)*PANEL_DIM + self.y
end

--[[
    Gets all matches in the current board state
]]
function Board:get_matches()
    local matches = {}
    local match_count = 0
    local curr_type = 0  -- Initialize with a non-existent type
    local matched = table.full(BOARD_HEIGHT, BOARD_WIDTH, false)  -- 2D table specifying whether a certain panel has been matched

    -- Check horizontal matches (and vertical extensions of them)
    for row = 1, #self.panels do
        for col = 1, #self.panels[1] do
            local curr_panel = self.panels[row][col]
            if curr_panel.empty or curr_panel.state_machine.state_name == 'fall' then  -- Empty or falling panel
                if match_count >= MATCH_THRESH then
                    matches, matched = self:finalize_match(table.slice(self.panels[row], col-match_count, col-1), matches, matched)
                end
                match_count = 0  -- Reset match counter
            else  -- Not empty panel
                if match_count == 0 then  -- Previous panel was empty
                    curr_type = curr_panel.type
                    match_count = 1
                elseif curr_panel.type == curr_type then  -- Panels adjacent to each other match
                    match_count = match_count + 1
                else  -- Panels adjacent to each other are different (but the current one is not empty)
                    if match_count >= MATCH_THRESH then
                        matches, matched = self:finalize_match(table.slice(self.panels[row], col-match_count, col-1), matches, matched)
                    end
                    curr_type = curr_panel.type
                    match_count = 1
                end
            end
        end
        -- Check for a match after the whole column is iterated over
        if match_count >= MATCH_THRESH then
            matches, matched = self:finalize_match(table.slice(self.panels[row], #self.panels[1]-match_count+1, #self.panels[1]), matches, matched)
        end

        match_count = 0
    end

    -- Re-initialize match variables
    match_count = 0
    curr_type = 0

    -- Check vertical matches among currently un-matched panels (with no need to check horizontal extensions)
    for col = 1, #self.panels[1] do
        for row = 1, #self.panels do
            local curr_panel = self.panels[row][col]
            if curr_panel.empty or matched[row][col]  then  -- Empty or matched panel
                if match_count >= MATCH_THRESH then
                    local match = {}
                    for i = 1, match_count do
                        match[i] = self.panels[row-i][col]
                    end
                    table.insert(matches, match)
                end
                match_count = 0
            else  -- Not empty or not matched panel
                if match_count == 0 then  -- Previous panel was empty or matched
                    curr_type = curr_panel.type
                    match_count = 1
                elseif curr_panel.type == curr_type then  -- Panels adjacent to each other match
                    match_count = match_count + 1
                else  -- Panels adjacent to each other are different (but the current one is not empty)
                    if match_count >= MATCH_THRESH then
                        local match = {}
                        for i = 1, match_count do
                            match[i] = self.panels[row-i][col]
                        end
                        table.insert(matches, match)
                    end
                    curr_type = curr_panel.type
                    match_count = 1
                end
            end
        end
        -- Check for a match after the whole column is iterated over
        if match_count >= MATCH_THRESH then
            local match = {}
            for i = 1, match_count do
                match[i] = self.panels[#self.panels-i+1][col]
            end
            table.insert(matches, match)
        end

        match_count = 0
    end
    return matches
end

--[[
    Takes a detected horizontal match, checks for vertical extensions of it, and inserts it into the table of existing matches
]]
function Board:finalize_match(match, matches, matched)
    local final_match = {}
    local type = match[1].type

    for k, panel in pairs(match) do
        table.insert(final_match, panel)
        matched[panel.board_y][panel.board_x] = true
        local matching_panels = {}
        local num_panels = 1

        -- Look for matching panels above
        local curr_y = panel.board_y - 1
        while curr_y > 0 do
            local curr_panel = self.panels[curr_y][panel.board_x]
            if not curr_panel.empty and curr_panel.type == type then  -- Matching panel
                matching_panels[num_panels] = curr_panel
                num_panels = num_panels + 1
            else  -- Different panel or empty
                break
            end
            curr_y = curr_y - 1
        end

        -- Look for matching panels below
        local curr_y = panel.board_y + 1
        while curr_y <= BOARD_HEIGHT do
            local curr_panel = self.panels[curr_y][panel.board_x]
            if not curr_panel.empty and curr_panel.type == type then -- Matching panel
                matching_panels[num_panels] = curr_panel
                num_panels = num_panels + 1
            else  -- Different panel or empty
                break
            end
            curr_y = curr_y + 1
        end

        -- Add matching panels to the final match if it met the match threshold
        if #matching_panels >= MATCH_THRESH-1 then  -- Enough panels vertically to count as a match
            table.extend(final_match, matching_panels)

            -- Update matched status
            for i, matched_panel in pairs(matching_panels) do
                matched[matched_panel.board_y][matched_panel.board_x] = true
            end
        end
    end

    table.insert(matches, final_match)
    return matches, matched
end

--[[
    Replaces matches found in the board with empty or randomly generated panels
]]
function Board:replace_panels(matches, empty)
    if not empty then  -- Replace with randomly generated
        for k, match in pairs(matches) do  -- Get the next match
            for i, panel in pairs(match) do  -- Get the next panel in the current match
                self.panels[panel.board_y][panel.board_x] = Panel {
                    board = self,
                    board_x = panel.board_x,
                    board_y = panel.board_y,
                    type = math.random(self.num_types)
                }
            end
        end
    else  -- Replace with empty
        for k, match in pairs(matches) do  -- Get the next match
            for i, panel in pairs(match) do  -- Get the next panel in the current match
                self.panels[panel.board_y][panel.board_x] = Panel {
                    board = self,
                    board_x = panel.board_x,
                    board_y = panel.board_y,
                    empty = true
                }
            end
        end
    end
end

--[[
    Swaps the two panels hovered over by the cursor
]]
function Board:swap()
    local x, y = self.cursor.board_x, self.cursor.board_y
    if self.panels[y][x].state_machine.state_name == 'idle' and self.panels[y][x+1].state_machine.state_name == 'idle' then  -- Only idle panels can be swapped
        self.panels[y][x].state_machine:change('swap', {direction = RIGHT})
        self.panels[y][x+1].state_machine:change('swap', {direction = LEFT})

        local temp = self.panels[y][x]

        self:switch_positions(x, y, x+1, y)
    end
end

--[[
    Switches two panels in the table, but does not update their board coordinates
]]
function Board:switch_positions(x1, y1, x2, y2)
    local temp = self.panels[y1][x1]
    self.panels[y1][x1] = self.panels[y2][x2]
    self.panels[y2][x2] = temp
end
