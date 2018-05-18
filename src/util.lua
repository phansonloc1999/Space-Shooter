----- Keyboard input handler
love.keyboard.keysPressed = {}

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if (key == 'escape') then
        love.event.quit()
    end
end

----- Log Function
function LOG(...)
    love.graphics.print(...)
    love.graphics.setColor(255, 255, 255)
end

----- AABB collision
function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

----- Initialize random number generator
math.randomseed(os.time())