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
    self.stateMachine = StateMachine {                  -- State machine for a panel
        ['idle'] = function() return PanelIdleState(self) end,
        ['swap'] = function() return PanelSwapState(self) end
    }

    self.stateMachine:change('idle')
end

function Panel:update(dt)
    self.stateMachine:update(dt)
end

function Panel:render(offset_x, offset_y)
    if not self.empty then  -- Non-empty panel
        self.stateMachine:render()
    end
end
