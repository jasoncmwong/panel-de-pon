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

function gen_cursor_quad(atlas)
    return love.graphics.newQuad(0, 0, 18, 18, atlas:getDimensions())
end

--[[
    Slices tables like Python
]]
function table.slice(tbl, first, last, step)
    local slice = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      slice[#slice+1] = tbl[i]
    end
    return slice
end

--[[
    Concatenates or extends two tables
]]
function table.extend(tbl1, tbl2)
    if #tbl2 ~= 0 then
        for i = 1, #tbl2 do
            tbl1[#tbl1 + 1] = tbl2[i]
        end
    end
    return tbl1
end

--[[
    Creates a 2D table with each index initialized with the specified value
]]
function table.full(rows, cols, val)
    full = {}
    for i = 1, rows do
        table.insert(full, {})
        for j = 1, cols do
            table.insert(full, {val})
        end
    end
    return full
end
