--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    -- self.ball = params.ball
    self.level = params.level
    self.balls = { params.ball }
    self.powerUps = {}

    self.recoverPoints = 5000
    self.expandPoints = 8000

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    if love.keyboard.wasPressed('h') then
        for k, brick in pairs(self.bricks) do
            if brick.inPlay then
                brick:hit()
                break
            end
        end
    end

    -- print(#self.balls)

    -- if love.keyboard.wasPressed('p') then
    --     self:addBalls()
    -- end

    -- update positions based on velocity
    self.paddle:update(dt)

    for i, powerUp in ipairs(self.powerUps) do
        powerUp:update(dt)

        local powerUpWasHit = powerUp:collides(self.paddle)

        if powerUpWasHit then powerUp.action(self) end
        if powerUpWasHit or powerUp.y >= VIRTUAL_HEIGHT then
            self.powerUps = table.filter(self.powerUps, function (p) return p ~= powerUp end)
        end
    end

    for i, ball in ipairs(self.balls) do
        ball:update(dt)

        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball:hitPaddle(self.paddle)
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then
                -- trigger the brick's hit function, which removes it from play
                brick:hit()
                ball:hitBrick(brick)
                if not brick.inPlay and brick.powerUp then
                    -- 8 is half of the powerUp sprite width, and I am too lazy to put it as a variable somewhere
                    table.insert(self.powerUps, PowerUp(brick.x + brick.width / 2 - 8, brick.y, brick.powerUp))
                end
                -- add to score
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                    self.paddle:expand()

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                if self.score > self.expandPoints then
                    -- multiply expand points by 2.5
                    self.expandPoints = math.min(100000, self.expandPoints * 2.5)
                    print(self.expandPoints)

                    self.paddle:expand()
                end

                break
            end
        end

        -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            self.balls = table.filter(self.balls, function (b) return b ~= ball end)
        end
    end

    if #self.balls == 0 then
        self.health = self.health - 1
        self.paddle:shrink()
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end

    -- go to our victory screen if there are no more bricks left
    if self:checkVictory() then
        gSounds['victory']:play()

        gStateMachine:change('victory', {
            level = self.level,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.balls[1],
            recoverPoints = self.recoverPoints
        })
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    -- local allBalls = table.concat(self.balls, { self.ball })
    -- self.ball:render()
    for _, ball in ipairs(self.balls) do
        ball:render()
    end

    for _, powerUp in ipairs(self.powerUps) do
        powerUp:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    return #table.filter(self.bricks, function(b) return b.inPlay end) == 0
    -- for k, brick in pairs(self.bricks) do
    --     if brick.inPlay then
    --         return false
    --     end
    -- end
    -- return true
end