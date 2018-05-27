Player = Class{}
Bullet = Class{}

-- Image Objects
local player_img = love.graphics.newImage('Graphics/player.png')
local player_shoot_img = love.graphics.newImage('Graphics/player_shoot.png')

-- Sound Objects
local fire = love.audio.newSource('Sounds/player_fire.wav', 'static')
local hit = love.audio.newSource('Sounds/player_hit.wav', 'static')

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

    -- Player score and HP
    self.score = 0
    self.health = 100
    self.invunerableTimer = 0
    self.flickeringTimer = 20
end

function Player:render()
    if (self.flickeringTimer == 0) and (self.invunerableTimer ~= 0) then
    else love.graphics.draw(player_img, self.x, self.y) end
    love.graphics.setColor(255, 0, 255)
    LOG("HP:"..self.health, 0, 20)

    for k, shot in ipairs(self.bullets) do
        shot:render()
    end
end

function Player:update(dt)
    Player:move(self)
    Player:shoot(self, dt)
    Player:hit(self)

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

function Player:move(self)
    if (love.keyboard.isDown('w')) then self.y = math.max(0, self.y - self.speed) end
    if (love.keyboard.isDown('s')) then self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.speed) end
    if (love.keyboard.isDown('a')) then self.x = math.max(0, self.x - self.speed) end
    if (love.keyboard.isDown('d')) then self.x = math.min(WINDOW_WIDTH - self.width, self.x + self.speed) end

    -- Update new position for new bullet
    self.bullet.x = self.x + self.width / 2 - self.bullet.width / 2
    self.bullet.y = self.y - self.bullet.height + 10
end

function Player:shoot(self, dt)

    if (love.keyboard.wasPressed('space')) and (self.bullet.cooldownTimer == 0) then
        table.insert(self.bullets, Bullet())
        fire:play()

        -- Initilize the latest bullet according to current x, y of player
        self.bullets[#self.bullets]:init(self.bullet.x, self.bullet.y)

        -- Start default cooldown timer here
        self.bullet.cooldownTimer = 35
    end
end

function Player:hit(self)
    if (self.invunerableTimer ~= 0) then
        self.invunerableTimer = self.invunerableTimer - 1
        if (self.flickeringTimer ~= 0) then self.flickeringTimer = self.flickeringTimer - 1
        else self.flickeringTimer = 20 end
    end

    if (self.invunerableTimer == 0) then -- if not hit yet, check and set invulnerable time
        for k, e in ipairs(Enemies) do
            if (CheckCollision(self.x + 10, self.y + 10, self.width - 20, self.height - 20, e.x, e.y, enemy_width, enemy_height))then
                self.health = self.health - 50
                self.invunerableTimer = 120
                hit:play()
                break
            end
        end
    end

    if (self.health < 1) then --[[love.event.quit("restart")]] end
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