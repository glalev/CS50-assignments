--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height, isComputer)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.isComputer = isComputer
end

function Paddle:update(dt, ball)
    local velocity = self:getVelocity(ball);
    local position = self.y + velocity * dt
    self.y = math.max(0, math.min(VIRTUAL_HEIGHT - self.height, position))
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:getVelocity(ball)
  return self.isComputer and self:getVelocityFromBall(ball) or self:getVelocityFromControls()
end

function Paddle:getVelocityFromControls()
  if love.keyboard.isDown('up') then
    return -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    return PADDLE_SPEED
  end

  return 0
end

function Paddle:getVelocityFromBall(ball)
  if ball.x >= VIRTUAL_WIDTH / 2 then return 0 end

  local direction = self.y + self.height / 2 < ball.y and 1 or -1
  local ballDistance = math.abs(self.y + self.height / 2 - ball.y)
  local adjustedSpeed = (PADDLE_SPEED - math.abs(ball.dy)) * ballDistance / (self.height / 2)
  local speed = ballDistance < self.height / 2
    and math.min(PADDLE_SPEED, ball.dy) or PADDLE_SPEED
  -- local speed = math.min(1,(math.abs(self.y + self.height - ball.y)) / PADDLE_SPEED / 2) * PADDLE_SPEED
  return direction * speed

end

