
PowerUp = Class{}

PowerUp.TYPES = {
    addBalls = {
        skin = 6,
        action = function (state)
            local skin = state.balls[1].skin
            for i = 1, 3 - #state.balls do
                local ball = Ball(skin)
                ball.x = state.paddle.x + (state.paddle.width / 2) - 4
                ball.y = state.paddle.y - 8
                ball.dx = math.random(-200, 200)
                ball.dy = math.random(-50, -60)

                table.insert(state.balls, ball)
            end
        end
    },
    unlock = {
        skin = 9,
        action = function (state)
            for _, brick in ipairs(state.bricks) do
                brick.isLocked = false;
                if brick.powerUp == 'unlock' then
                    brick.powerUp = nil
                end
            end
        end
    }
}

function PowerUp:init(x, y, type)
    self.x = x
    self.y = y
    self.skin = PowerUp.TYPES[type].skin
    self.action = PowerUp.TYPES[type].action
    self.dy = 70
    self.width = 16
    self.height = 16
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end


function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    -- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin], self.x, self.y)
end

