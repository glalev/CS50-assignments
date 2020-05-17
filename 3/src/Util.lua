--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), generate all of the
    quads for the different tiles therein, divided into tables for each set
    of tiles, since each color has 6 varieties.
]]

-- TODO maybe add the tile width and height as a global constant
function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0
    local varieties = 6
    local w = 32
    local h = 32
    local atlasWidth, atlasHeight = atlas:getDimensions()
    local rows = atlasHeight / h
    local sets = atlasWidth / w / varieties
    local counter = 1

    -- 9 rows of tiles
    for row = 1, rows do

        -- two sets of 6 cols, different tile varietes
        for i = 1, sets do
            tiles[counter] = {}

            for col = 1, varieties do
                table.insert(tiles[counter], love.graphics.newQuad(x, y, w, h, atlasWidth, atlasHeight))
                x = x + w
            end

            counter = counter + 1
        end
        y = y + h
        x = 0
    end

    return tiles
end

function GetTilesColorsCount(atlas)
    local atlasWidth, atlasHeight = atlas:getDimensions()

    return atlasHeight / 32 * atlasWidth / 32 / 6
end
