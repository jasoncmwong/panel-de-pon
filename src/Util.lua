function gen_panel_quads(atlas)
    local panels = {}

    -- Top left corner of the desired sprite in the sheet
    local x = 0
    local y = 0

    for col = 1, 6 do
        table.insert(panels, love.graphics.newQuad(x, y, PANEL_DIM, PANEL_DIM, atlas:getDimensions()))
        x = x + PANEL_DIM
    end

    return panels
end
