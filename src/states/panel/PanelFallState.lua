PanelFallState = Class{__includes = BaseState}

function PanelFallState:init(panel)
    self.panel = panel
    self.dist_travelled = nil
    self.is_top = nil
end

function PanelFallState:enter()
    self.panel.dy = BASE_FALL_SPD
    self.dist_travelled = 0
    if self.panel.board_y > 1 and not self.panel.board.panels[self.panel.board_y-1][self.panel.board_x].empty then  -- Panel above
        self.is_top = false
    else  -- No panel above (this panel is at the top of the stack)
        self.is_top = true
    end
end

function PanelFallState:update(dt)
    self.panel.y = self.panel.y + self.panel.dy*dt
    self.dist_travelled = self.dist_travelled + self.panel.dy*dt
    if self.dist_travelled >= PANEL_DIM then  -- Travelled at least one panel slot's worth of distance
        self:fall()
        if self.panel.board_y < BOARD_HEIGHT then  -- Potential to fall
            local below = self.panel.board.panels[self.panel.board_y+1][self.panel.board_x]
            if not below.empty and below.state_machine.state_name ~= 'fall' then  -- Non-empty panel below
                self.panel.y = self.panel.board:boardy_to_pixel(self.panel.board_y)  -- Limit position in case of overshoot

                -- Change state back to idle
                self.panel.state_machine:change('idle')
            end
        else  -- Bottom below
            self.panel.y = self.panel.board:boardy_to_pixel(self.panel.board_y)  -- Limit position in case of overshoot

            -- Change state back to idle
            self.panel.state_machine:change('idle')
        end
    end
end

function PanelFallState:render()
    love.graphics.draw(g_textures['panels'],
                       g_quads['panels'][self.panel.type],
                       self.panel.x,
                       self.panel.y)
end

--[[
    Updates board position of the falling panel
]]
function PanelFallState:fall()
    -- Update board coordinates and shift position in the table
    self.panel.board_y = self.panel.board_y + 1
    self.panel.board.panels[self.panel.board_y][self.panel.board_x] = self.panel

    -- Reset distance tracker
    self.dist_travelled = self.dist_travelled % PANEL_DIM

    if self.is_top then  -- Panel is at the top of the falling stack
        -- Create empty panel in the previous position
        self.panel.board.panels[self.panel.board_y-1][self.panel.board_x] = Panel {
            board = self.panel.board,
            board_x = self.panel.board_x,
            board_y = self.panel.board_y-1,
            empty = true
        }
    end
end
