Class = require('src/class')

require('src/enemy')
require('src/player')
require('src/background')
require('src/util')

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

gFont = love.graphics.setNewFont('Fonts/Pixel-Miners.ttf', 14)
gBGM = love.audio.newSource("Sounds/background.mp3", "stream")

function love.load()
    player = Player()
    player:init()

    background = Background()
    background:init()
    
    for k = 1, 10 do
        table.insert(Enemies, Enemy())
        Enemies[#Enemies]:init()
    end

    gBGM:play()
    gBGM:setVolume(0.5)
    gBGM:setLooping(true)
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
    if (dt < 1) then
        background:update(dt)

        player:update(dt)
        for k, enemy in ipairs(Enemies) do
            enemy:update(dt, k)
        end

    end

    -- flush keys pressed table
    love.keyboard.keysPressed = {}
end