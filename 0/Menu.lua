
Menu = Class{}

function Menu:init(items)
  self.items = items
  self.selected = 0
end

function Menu:render()
  for i, item in ipairs(self.items) do
    if i == self.selected + 1 then
      love.graphics.setColor(COLORS.yellow())
    else
      love.graphics.setColor(COLORS.white())
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
