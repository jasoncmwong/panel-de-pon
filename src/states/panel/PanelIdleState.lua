PanelIdleState = Class{__includes = BaseState}

function PanelIdleState:init(panel)
    self.panel = panel
end

function PanelIdleState:render()
    love.graphics.draw(g_textures['panels'],
                       g_quads['panels'][self.panel.type],
                       self.panel.x,
                       self.panel.y)

    -- ### DEBUG ###
    -- love.graphics.setFont(g_fonts['small'])
    -- love.graphics.printf(self.panel.board_x, self.panel.x+1, self.panel.y+1, PANEL_DIM, 'left')
end
