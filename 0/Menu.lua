
Menu = Class{}

local hugeFont = love.graphics.newFont('font.ttf', 84)
local items = {
  '1 Player',
  '2 Players',
}

function Menu:init()
    self.selected = 1 -- array indexing starts from 1 for some reason
end

function Menu:render()
  love.graphics.setFont(hugeFont)
  love.graphics.printf('Pong', 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(smallFont)
  love.graphics.printf('Press Up/Down to Select, Enter to begin!', 0, 10, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Copyright 2020 | Atari, please don\'t sue me', 0, 175, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(largeFont)
  for i, item in ipairs(items) do
    if i == self.selected then
      love.graphics.setColor(235, 203, 139, 255)
    else
        love.graphics.setColor(255, 255, 255, 255)
    end

    love.graphics.printf(item, VIRTUAL_WIDTH / 2 - 40, 110 + i * 20, VIRTUAL_WIDTH, 'left')
  end

end

function Menu:update()
  if love.keyboard.isDown('up') and self.selected == 2 then
    self.selected = 1
  elseif love.keyboard.isDown('down') and self.selected == 1 then
    self.selected = 2
  end
end
