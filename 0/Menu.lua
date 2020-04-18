
Menu = Class{}

function Menu:init(items)
    self.items = items
    self.selected = 0
end

function Menu:render()
  for i, item in ipairs(self.items) do
    if i == self.selected + 1 then
      love.graphics.setColor(COLORS.yellow[1], COLORS.yellow[2], COLORS.yellow[3], 255)
    else
        love.graphics.setColor(COLORS.white[1], COLORS.white[2], COLORS.white[3], 255)
    end

    love.graphics.printf(item, VIRTUAL_WIDTH / 2 - 40, 110 + i * 20, VIRTUAL_WIDTH, 'left')
  end

end

function Menu:update()
  if love.keyboard.wasPressed('up') then
    self.selected = (self.selected + 1) % #self.items
  elseif love.keyboard.wasPressed('down') then
    self.selected = (self.selected - 1) >= 0 and (self.selected - 1) or #self.items - 1
  end
end
