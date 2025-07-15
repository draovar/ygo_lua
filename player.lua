-- includes --
require "animation";

-- consts --
DIR_UP    = 0
DIR_DOWN  = 1
DIR_LEFT  = 2
DIR_RIGHT = 3

STATE_IDLE = 0
STATE_WALK = 1

-- player class --
player = {}
player.x = 64
player.y = 64
player.s = 2
player.dx = 0
player.dy = 0
player.dir = DIR_UP
player.state = STATE_IDLE
player.animation = newAnimation(love.graphics.newImage("yamiyugi.png"), 48, 64, 1/player.s)

function player_update(dt)
    -- reset
    player.state = STATE_IDLE
    player.dx = 0
    player.dy = 0
    
    -- input
    player_input()
    player.dx, player.dy = norm_speed(player.dx, player.dy, player.s)
    if player.dx ~= 0 or player.dy ~= 0 then
        player.state = STATE_WALK
        player.x = player.x + player.dx
        player.y = player.y + player.dy
    end

    -- animation update
    player.animation.currentTime = player.animation.currentTime + dt
    if player.animation.currentTime >= player.animation.duration then
        player.animation.currentTime = player.animation.currentTime - player.animation.duration
    end
end

function player_draw()
    if player.state == STATE_WALK then
        local spriteNum = math.floor(player.animation.currentTime / player.animation.duration * 2 ) + 1
        love.graphics.draw(player.animation.spriteSheet, player.animation.quads[spriteNum + 3*player.dir + 1], math.floor(player.x), math.floor(player.y), 0, 1, 1, 24, 32)
    else
        love.graphics.draw(player.animation.spriteSheet, player.animation.quads[1 + 3*player.dir], math.floor(player.x), math.floor(player.y), 0, 1, 1, 24, 32)
    end
end

function player_input()
    if love.keyboard.isDown("a") then
        player.dx = - player.s
        player.dir = DIR_LEFT
    end
    if love.keyboard.isDown("d") then
        player.dx = player.s
        player.dir = DIR_RIGHT
    end
    if love.keyboard.isDown("w") then
        player.dy = - player.s
        player.dir = DIR_UP
    end
    if love.keyboard.isDown("s") then
        player.dy = player.s
        player.dir = DIR_DOWN
    end

    if love.keyboard.isDown("x") then
        player.animation = newAnimation(love.graphics.newImage("yamiyugi.png"), 48, 64, 1/player.s)
    end
    if love.keyboard.isDown("z") then
        player.animation = newAnimation(love.graphics.newImage("yugi.png"), 48, 64, 1/player.s)
    end
end