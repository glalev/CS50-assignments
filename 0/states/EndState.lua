EndState = Class{__includes = BaseState}
local colorTimer = 0.07

function EndState:enter(winningPlayer)
  self.winningPlayer = winningPlayer
  self.timer = colorTimer
  self.textColor = 'white'
end

function EndState:update(dt)
  if love.keyboard.wasPressed('ender') or love.keyboard.wasPressed('return') then
    gFeatures.score:reset()
    return gStateMachine:change('serve', self.winningPlayer == 1 and 2 or 1)
  end

  self.timer = self.timer - dt
  if self.timer < 0 then
    self.timer = colorTimer
    self.textColor =  self.textColor == 'white' and 'yellow' or 'white'
  end
end

function EndState:render()
  local color = COLORS[self.textColor]
  love.graphics.setColor(color())
  love.graphics.setFont(FONTS.huge)
  love.graphics.printf('Player '.. tostring(self.winningPlayer) ..', Win!', 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(COLORS.white())
  love.graphics.setFont(FONTS.small)
  love.graphics.printf('Press Enter to restart!', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
end