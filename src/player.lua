Player = Class{}
Bullet = Class{}

local player_img = love.graphics.newImage('Graphics/player.png')
local player_shoot_img = love.graphics.newImage('Graphics/player_shoot.png')

local bullet_speed = 5

function Player:init()
    self.width, self.height = player_img:getDimensions()
    self.x, self.y = WINDOW_WIDTH / 2 - self.width / 2, WINDOW_HEIGHT / 2 - self.height / 2
    self.speed = 3

    -- Player's bullet
    self.bullet = {}
    self.bullet.x, self.bullet.y = nil, nil
    self.bullet.width, self.bullet.height = player_shoot_img:getDimensions()
    self.bullet.cooldownTimer = 0
    self.bullet.cooldownSpeed = 0.5

    self.bullets = {}
end

function Player:render()
    love.graphics.draw(player_img, self.x, self.y)

    for k, shot in ipairs(self.bullets) do
        shot:render()
    end
end

function Player:update(dt)
    Player:move(self)
    Player:shoot(self, dt)

    for k, shot in ipairs(self.bullets) do
        shot:update()

        -- If bullet goes pass screen, delete it
        if (shot.y < -self.bullet.height) then
            table.remove(self.bullets, k)
            break
        end
    end

    -- Update cooldown timer
    if (self.bullet.cooldownTimer ~= 0) then
        self.bullet.cooldownTimer = math.floor(self.bullet.cooldownTimer - self.bullet.cooldownSpeed * dt)
    end
end

function Player:shoot(self, dt)
    if (love.keyboard.wasPressed('space')) and (self.bullet.cooldownTimer == 0) then
        table.insert(self.bullets, Bullet())

        -- Initilize the latest bullet according to current x, y of player
        self.bullets[#self.bullets]:init(self.bullet.x, self.bullet.y)

        -- Start default cooldown timer here
        self.bullet.cooldownTimer = 25
    end
end

function Player:move(self)
    if (love.keyboard.isDown('w')) then self.y = math.max(0, self.y - self.speed) end
    if (love.keyboard.isDown('s')) then self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.speed) end
    if (love.keyboard.isDown('a')) then self.x = math.max(0, self.x - self.speed) end
    if (love.keyboard.isDown('d')) then self.x = math.min(WINDOW_WIDTH - self.width, self.x + self.speed) end

    -- Update new position for new bullet
    self.bullet.x = self.x + self.width / 2 - self.bullet.width / 2
    self.bullet.y = self.y - self.bullet.height
end

-------------------------- Functions of a Bullet-----------------------------------
function Bullet:init(x, y)
    self.x, self.y = x, y
end

function Bullet:render()
    love.graphics.draw(player_shoot_img, self.x, self.y)
end

function Bullet:update()
    self.y = self.y - bullet_speed
end
