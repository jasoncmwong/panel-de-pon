PanelSwapState = Class{__includes = BaseState}

function PanelSwapState:init(panel)
    self.panel = panel
    self.direction = nil  -- Direction the panel will travel
end

function PanelSwapState:enter(params)
    self.direction = params.direction

    -- Determine horizontal panel speeds and update board X positions
    if self.direction == LEFT then
        self.panel.dx = -BASE_SWAP_SPD
        self.panel.board_x = self.panel.board_x - 1
    elseif self.direction == RIGHT then
        self.panel.dx = BASE_SWAP_SPD
        self.panel.board_x = self.panel.board_x + 1
    end
end

function PanelSwapState:update(dt)
    self.panel.x = self.panel.x + self.panel.dx*dt

    if self.direction == LEFT and self.panel.x <= self.panel.board:boardx_to_pixel(self.panel.board_x-1) + PANEL_DIM then  -- Reached/passed left slot
        -- Limit movement to only the swapped spot and stop movement
        self.panel.x = self.panel.board:boardx_to_pixel(self.panel.board_x)

        -- Update state
        -- if self.panel.board_y < BOARD_HEIGHT and self.panel.board.panels[self.panel.board_y+1][self.panel.board_x].empty then  -- On top of an empty slot
        --     self.panel.state_machine:change('fall')
        -- else  -- On top of a panel or bottom of the board
        self.panel.state_machine:change('idle')
        -- end
    elseif self.direction == RIGHT and self.panel.x + PANEL_DIM >= self.panel.board:boardx_to_pixel(self.panel.board_x+1) then  -- Reached/passed right slot
        -- Limit movement to only the swapped spot and stop movement
        self.panel.x = self.panel.board:boardx_to_pixel(self.panel.board_x)

        --Update state
        -- if self.panel.board_y < BOARD_HEIGHT and self.panel.board.panels[self.panel.board_y+1][self.panel.board_x].empty then  -- On top of an empty slot
        --     self.panel.state_machine:change('fall')
        -- else  -- On top of a panel or bottom of the board
        self.panel.state_machine:change('idle')
        -- end
    end
end

function PanelSwapState:render()
    love.graphics.draw(g_textures['panels'],
                       g_quads['panels'][self.panel.type],
                       self.panel.x,
                       self.panel.y)
end
