Score = Class{}

function Score:init(left, right, max)
  self.left = left or 0
  self.right = right or 0
  self.max = max or 10
end

function Score:winner()
  if self.left >= self.max then return 1 end
  if self.right >= self.max then return 2 end

  return nil
end

function Score:reset()
  self.left = 0
  self.right = 0
end

function Score:render()
  love.graphics.setFont(FONTS.large)
  love.graphics.print(tostring(self.left), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(self.right), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function Score:update(dLeft, dRight)
  self.left = self.left + dLeft
  self.right = self.right + dRight
end