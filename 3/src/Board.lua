--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

function hasSpecialTile (arr)
    return table.reduce(arr, function(hasSpecial, tile)
        if hasSpecial then return true end
        if type(tile.isSpecial) == 'boolean' then
            return tile.isSpecial
        else
            return hasSpecialTile(tile)
        end
    end, false)
end

function getMatchesFromRow(row, matches)
    local seq = {}
    local rowMatches = {}

    for i, tile in ipairs(row) do
        local hasToBreak = (#seq ~=0 and tile.color ~= seq[1].color) or i == #row
        local hasToInsert = #seq == 0 or tile.color == seq[1].color
        if hasToInsert then
            table.insert(seq, tile)
        end

        if hasToBreak then
            if (#seq > 2) then
                table.insert(rowMatches, seq)
            end
            seq = { tile }
        end
    end

    local finalMatches = hasSpecialTile(rowMatches) and { row } or rowMatches

    return table.concat(matches, finalMatches)
end

function getMatchesFromColumn(columnIndex, t, matches)
    local seq = {}
    local columnMatches = {}
    local column = {}

    for i = 1, #t do
        local tile = t[i][columnIndex]
        local hasToBreak = (#seq ~=0 and tile.color ~= seq[1].color) or i == #t
        local hasToInsert = #seq == 0 or tile.color == seq[1].color

        column[i] = tile
        if hasToInsert then
            table.insert(seq, tile)
        end

        if hasToBreak then
            if (#seq > 2) then
                table.insert(columnMatches, seq)
            end
            seq = { tile }
        end
    end

    local finalMatches = hasSpecialTile(columnMatches) and { column } or columnMatches

    return table.concat(matches, finalMatches)
end

Board = Class{}

function Board:init(x, y, level, colors)
    self.x = x
    self.y = y
    self.matches = {}
    self.maxLevel = math.min(5, math.ceil(level / 1.9))
    self.colors = colors
    self:initializeTiles(level)
end

function Board:initializeTiles()

    self.tiles = {}

    for tileY = 1, 8 do

        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do

            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(self.colors), math.random(1, self.maxLevel)))
        end
    end

    while self:calculateMatches() do

        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the
    last two haven't been a match.
]]
function Board:calculateMatches()
    local verticalMathces = table.reduce(self.tiles[1], function(acc, _, columnIndex)
        -- gets all the matches from every single column, and concatenate them in one table
        return getMatchesFromColumn(columnIndex, self.tiles, acc)
    end, {})
    -- store matches for later reference
    self.matches = table.reduce(self.tiles, function(acc, row)
        -- gets all the matches from every single row,
        -- and concatenate them with the already found vertical matches
        return getMatchesFromRow(row, acc)
    end, verticalMathces)

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do

            -- if our last tile was a space...
            local tile = self.tiles[y][x]

            if space then

                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then

                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(self.colors), math.random(1, self.maxLevel))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end