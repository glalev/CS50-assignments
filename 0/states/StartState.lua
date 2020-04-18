StartState = Class{__includes = BaseState}

function StartState:update()
  if not love.keyboard.wasPressed('ender') and not love.keyboard.wasPressed('return') then
    return gFeatures.menu:update()
  end

  local leftControls = gFeatures.menu.selected == 1 and {['up'] = 'w', ['down'] = 's'} or nil
  local rightControls = {['up'] = 'up', ['down'] = 'down'}

  gFeatures.leftPlayer:setControls(leftControls)
  gFeatures.rightPlayer:setControls(rightControls)
  gStateMachine:change('serve')
end

function StartState:render()
  love.graphics.setFont(FONTS.huge)
  love.graphics.printf('Pong', 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(FONTS.small)
  love.graphics.printf('Press Up/Down to Select, Enter to begin!', 0, 10, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Copyright 2020 | Atari, please don\'t sue me', 0, 175, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(FONTS.normal)
  gFeatures.menu:render()
end