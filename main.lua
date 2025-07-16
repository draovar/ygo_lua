require "player";

function love.load()
    sti = require 'libs/sti'
    gameMap = sti('maps/testMap.lua')
    camera = require "libs/camera";
    cam = camera()
end

function love.draw()
    love.graphics.clear({0.5, 0.5, 1, 1})
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["objs"])
        player_draw()
    cam:detach()

    -- debug
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.update(dt)
    player_update(dt)
    cam:lookAt(math.floor(player.x), math.floor(player.y))
end