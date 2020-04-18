ServeState = Class{__includes = BaseState}

function ServeState:enter(servingPlayer)
  if gFeatures.score:winner() then
    return gStateMachine:change('end', gFeatures.score:winner());
  end
  self.servingPlayer = servingPlayer or 1
end

function ServeState:update(dt)
  if love.keyboard.wasPressed('ender') or love.keyboard.wasPressed('return') then
    local direction = self.servingPlayer == 1 and 1 or -1
    local dx = math.random(140, 200) * direction
    local dy = math.random(-50, 50)

    gFeatures.ball:setVelocity(dx, dy)
    gStateMachine:change('play')
  end
end

function ServeState:render()
  local n = tostring(self.servingPlayer)
  love.graphics.setFont(FONTS.small)
  love.graphics.printf('Player ' ..n .. "'s serve!",  0, 10, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')

  gFeatures.leftPlayer:render()
  gFeatures.rightPlayer:render()
  gFeatures.score:render()
  gFeatures.ball:render()
end