Class = require('src/class')

require('src/enemy')
require('src/player')
require('src/background')
require('src/util')

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

function love.load()
    player = Player()
    player:init()

    background = Background()
    background:init()

    for k = 1, 10 do
        table.insert(Enemies, Enemy())
        Enemies[#Enemies]:init()
    end
end

function love.draw()
    background:render()

    player:render()
    love.graphics.setColor(0, 255, 0)
    LOG("Your score: "..player.score)

    for k, enemy in ipairs(Enemies) do
        enemy:render()
    end
end

function love.update(dt)
    background:update(dt)

    player:update(dt)
    for k, enemy in ipairs(Enemies) do
        enemy:update(dt, k)
    end

    -- flush keys pressed table
    love.keyboard.keysPressed = {}
end