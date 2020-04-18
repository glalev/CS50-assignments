PlayState = Class{__includes = BaseState}

function PlayState:update(dt)
  if gFeatures.ball:collides(gFeatures.leftPlayer) then
    gFeatures.ball.dx = -gFeatures.ball.dx * 1.03
    gFeatures.ball.dy = gFeatures.ball.dy / math.abs(gFeatures.ball.dy) * math.random(10, 150)
    gFeatures.ball.x = gFeatures.leftPlayer.x + 5

    SOUNDS['paddle_hit']:play()
  end

  if gFeatures.ball:collides(gFeatures.rightPlayer) then
    gFeatures.ball.dx = -gFeatures.ball.dx * 1.03
    gFeatures.ball.x = gFeatures.rightPlayer.x - 4
    gFeatures.ball.dy = gFeatures.ball.dy / math.abs(gFeatures.ball.dy) * math.random(10, 150)

    SOUNDS['paddle_hit']:play()
  end

  -- detect upper and lower screen boundary collision, playing a sound
  -- effect and reversing dy if true
  if gFeatures.ball.y <= 0 then
    gFeatures.ball.y = 0
    gFeatures.ball.dy = -gFeatures.ball.dy

    SOUNDS['wall_hit']:play()
  end

  -- -4 to account for the ball's size
  if gFeatures.ball.y >= VIRTUAL_HEIGHT - 4 then
    gFeatures.ball.y = VIRTUAL_HEIGHT - 4
    gFeatures.ball.dy = -gFeatures.ball.dy

    SOUNDS['wall_hit']:play()
  end

  -- if we reach the left edge of the screen, go back to serve
  -- and update the score and serving player
  if gFeatures.ball.x < 0 then
    gFeatures.score:update(0, 1)
    gFeatures.ball:reset()
    return gStateMachine:change('serve', 1)
  end

  -- if we reach the right edge of the screen, go back to serve
  -- and update the score and serving player
  if gFeatures.ball.x > VIRTUAL_WIDTH then
    gFeatures.score:update(1, 0)
    gFeatures.ball:reset()
    return gStateMachine:change('serve', 2)
  end

  gFeatures.ball:update(dt)
  gFeatures.leftPlayer:update(dt, gFeatures.ball)
  gFeatures.rightPlayer:update(dt, gFeatures.ball)

end

function PlayState:render()
  love.graphics.setFont(FONTS.small)
  love.graphics.setColor(COLORS.green())
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
  love.graphics.setColor(COLORS.white())

  gFeatures.leftPlayer:render()
  gFeatures.rightPlayer:render()
  gFeatures.ball:render()
  gFeatures.score:render()
end