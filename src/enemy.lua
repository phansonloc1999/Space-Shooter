Enemy = Class{}

Enemies = {}

local enemy_img = love.graphics.newImage('Graphics/enemy.png')

local enemy_hit = love.audio.newSource('Sounds/enemy_hit.wav', 'static')

enemy_width, enemy_height = enemy_img:getDimensions()

local speed = 60

function Enemy:init()
    self.x, self.y = math.random(0, WINDOW_WIDTH - enemy_width), math.random(0, WINDOW_HEIGHT / 2 - enemy_height)
    self.next = {}
    self.next.isReached = true
    self.next_x, self.next_y = nil, nil
    self.isChasing = false
end

function Enemy:render()
    love.graphics.draw(enemy_img, self.x, self.y)
end

function Enemy:update(dt, k)
    Enemy:move(self, dt)
    Enemy:hit(self, k)
    Enemy:chase(self, dt)
end

-- Update funtions
function Enemy:hit(self, key)
    for k, bullet in ipairs(player.bullets) do
        if (CheckCollision(self.x, self.y, enemy_width, enemy_height, bullet.x, bullet.y, player.bullet.width, player.bullet.height)) then
            table.remove(Enemies, key)
            table.remove(player.bullets, k)
            enemy_hit:play()
            player.score = player.score + 1
            break
        end
    end
end

function Enemy:move(self, dt)
    if (not self.isChasing) then
        if (self.next.isReached) then
            self.next_x, self.next_y = math.random(0, WINDOW_WIDTH - enemy_width), math.random(0, WINDOW_HEIGHT - enemy_height)
            self.next.isReached = false
        end
    
        if (not self.next.isReached) then
            if (self.x > self.next_x) then self.x = math.floor(self.x - speed * dt)
            elseif (self.x < self.next_x) then self.x = math.floor(self.x + speed * dt) end
            if (self.y > self.next_y) then self.y = math.floor(self.y - speed * dt)
            elseif (self.y < self.next_y) then self.y = math.floor(self.y + speed * dt) end
        end
    
        if (self.x == self.next_x) and (self.y == self.next_y) then
            self.next.isReached = true
        end
    end
end

function Enemy:chase(self, dt)
    if (CheckCollision(player.x, player.y, player.width, player.height, self.x, self.y - 40, 70 + enemy_width, 70 + enemy_height)) then
        self.isChasing = true
    end

    if (self.isChasing) then
        if (self.x > (player.x + player.width / 2 )) then self.x = self.x - speed * dt
        elseif (self.x < (player.x + player.width / 2)) then self.x = self.x + speed * dt end
        if (self.y > (player.y + player.height / 2)) then self.y = self.y - speed * dt
        elseif (self.y < (player.y + player.height / 2)) then self.y = self.y + speed * dt end
    end
end