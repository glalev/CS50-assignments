--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a type, with the varietes adding extra points to the matches.
]]
local POINTS = { 50, 55, 65, 80, 100, 120 }
Tile = Class{}

function Tile:init(x, y, color, type)

    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.isSpecial = math.random() > 0.9
    self.color = color
    self.type = self.isSpecial and type or 6
    self.points = POINTS[type]
end

function Tile:render(x, y)

    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.type],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.type],
        self.x + x, self.y + y)
end