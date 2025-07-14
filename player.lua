-- includes --
require "animation";

-- player class --
player = 
{
    x = 0,
    y = 0,
    animation = newAnimation(love.graphics.newImage("yugi2.png"), 48, 64, 2)
}

function player_update(dt)
    player_input()
    player.animation.currentTime = player.animation.currentTime + dt
    if player.animation.currentTime >= player.animation.duration then
        player.animation.currentTime = player.animation.currentTime - player.animation.duration
    end
end

function player_draw()
    local spriteNum = math.floor(player.animation.currentTime / player.animation.duration * #player.animation.quads) + 1
    love.graphics.draw(player.animation.spriteSheet, player.animation.quads[spriteNum], player.x, player.y, 0, 1)
end

function player_input()
    if love.keyboard.isDown("a") then
        player.x = player.x - 1
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + 1
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - 1
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + 1
    end
end