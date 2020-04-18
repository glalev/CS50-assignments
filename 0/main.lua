-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
local push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'


-- require 'Paddle'
-- require 'Ball'
-- require 'Menu'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'

--States
require 'states/BaseState'
require 'states/StartState'
require 'states/ServeState'
require 'states/PlayState'
require 'states/EndState'

require 'Menu'
require 'Paddle'
require 'Ball'
require 'Score'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
-- PADDLE_SPEED = 200

function love.load()
  -- set love's default filter to "nearest-neighbor", which essentially
  -- means there will be no filtering of pixels (blurriness), which is
  -- important for a nice crisp, 2D look
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- set the title of our application window
  love.window.setTitle('Pong')


  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
  -- seed the RNG so that calls to random are always random
  math.randomseed(os.time())

  FONTS = {
    ['small'] = love.graphics.newFont('font.ttf', 8),
    ['normal'] = love.graphics.newFont('font.ttf', 16),
    ['large'] = love.graphics.newFont('font.ttf', 32),
    ['huge'] = love.graphics.newFont('font.ttf', 84),
  }

  SOUNDS = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }

  COLORS = {
    background = function () return 46, 52, 64, 255 end,
    green = function () return 163, 190, 140, 255 end,
    yellow = function () return 235, 203, 139, 255 end,
    white = function () return 236, 239, 244, 255 end,
  }

  gFeatures = {
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4),
    leftPlayer = Paddle(10, 30, 5, 20),
    rightPlayer = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20),
    score = Score(),
    menu = Menu({'1 Player', '2 Players'})
  }

  gStateMachine = StateMachine {
    ['start'] = function () return StartState() end,
    ['serve'] = function () return ServeState() end,
    ['play'] = function () return PlayState() end,
    ['end'] = function () return EndState() end
  }

  gStateMachine:change('start', gFeatures)

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then love.event.quit() end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()
  love.graphics.clear(COLORS.background())
  gStateMachine:render()
  push:finish()
end