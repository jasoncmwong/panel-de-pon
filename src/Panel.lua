Panel = Class{}

function Panel:init(params)
    self.board = params.board               -- Board the panel is assigned to
    self.board_x = params.board_x           -- X position in the board (not in pixels)
    self.board_y = params.board_y           -- Y position in the board (not in pixels)
    self.type = params.type                 -- Type of block
    self.empty = params.empty or false      -- Whether a panel should render

    self.x = self.board:boardx_to_pixel(self.board_x)   -- X coordinate for rendering (in pixels)
    self.y = self.board:boardy_to_pixel(self.board_y)   -- Y coordinate for rendering (in pixels)
    self.dx = 0                                         -- X velocity
    self.dy = 0                                         -- Y velocity
    self.state_machine = StateMachine {                 -- State machine for a panel
        ['idle'] = function() return PanelIdleState(self) end,
        ['swap'] = function() return PanelSwapState(self) end,
        ['fall'] = function() return PanelFallState(self) end
    }

    self.state_machine:change('idle')
end

function Panel:update(dt)
    self.state_machine:update(dt)
    self:apply_gravity()
end

function Panel:render(offset_x, offset_y)
    if not self.empty then  -- Non-empty panel
        self.state_machine:render()
    end
end

--[[
    Checks if a panel is eligible to fall
]]
function Panel:apply_gravity()
    if not self.empty and self.board_y < BOARD_HEIGHT and self.state_machine.state_name == 'idle' then  -- Not already falling and has potential to fall
        local below = self.board.panels[self.board_y+1][self.board_x]
        if below.empty or below.state_machine.state_name == 'fall' then
            self.state_machine:change('fall')
        end
    end
end
