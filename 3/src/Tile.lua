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
    self.type = self.isSpecial and 6 or type
    self.points = POINTS[type]
    self.shine = {value = 80, direction = 1, step = 1.5, max = 250, min = 80}
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

    if (self.isSpecial) then
        local step = (self.shine.max - self.shine.value) / 100 + 1
        self.shine.value = self.shine.value + self.shine.direction * step
        if self.shine.value >= self.shine.max or self.shine.value <= self.shine.min then
            self.shine.direction = -self.shine.direction
        end
        love.graphics.setBlendMode('add')

        love.graphics.setColor(255, 255, 255, self.shine.value)
        love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.type],
            self.x + x, self.y + y)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end
end