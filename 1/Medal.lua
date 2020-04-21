
Medal = Class{}

local MEDALS_REQUIREMENTS = {
  bronze = 1,
  silver = 3,
  gold = 5
}
-- since we only want the image loaded once, not per instantation, define it externally
local MEDALS_IMAGES = {
  empty = love.graphics.newImage('medal-empty.png'),
  bronze = love.graphics.newImage('medal-bronze.png'),
  silver = love.graphics.newImage('medal-silver.png'),
  gold = love.graphics.newImage('medal-gold.png')
}

function Medal:init(score)

end

function Medal:update(dt)
end

function Medal:render()
  love.graphics.draw(MEDALS_IMAGES.gold, VIRTUAL_WIDTH / 2 - 20, 115)
end