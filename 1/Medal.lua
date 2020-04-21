
Medal = Class{}

local TYPES_TRESHOLDS = {
  { bronze = 5 },
  { silver = 12 },
  { gold = 20 }
}
-- since we only want the image loaded once, not per instantation, define it externally
local MEDALS_IMAGES = {
  empty = love.graphics.newImage('medal-empty.png'),
  bronze = love.graphics.newImage('medal-bronze.png'),
  silver = love.graphics.newImage('medal-silver.png'),
  gold = love.graphics.newImage('medal-gold.png')
}

function Medal:init(score)
  local type = 'empty'
  for i, treshold in ipairs(TYPES_TRESHOLDS) do
    for name, value in pairs(treshold) do
      if score >= value then
        type = name
      end
    end
  end

  self.type = type
end

function Medal:update(dt)
end

function Medal:render()
  love.graphics.draw(MEDALS_IMAGES[self.type], VIRTUAL_WIDTH / 2 - 20, 120)
end