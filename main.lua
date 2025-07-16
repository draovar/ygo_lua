require "player";

function love.load()
    sti = require 'sti'
    gameMap = sti('testMap.lua')

    camera = require "camera";
    cam = camera()

    kk_dt = 0
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
    love.graphics.print("dt: "..tostring(kk_dt), 10, 30)
    
end

function love.update(dt)
    player_update(dt)
    cam:lookAt(math.floor(player.x), math.floor(player.y))
    love.graphics.print("dt: ", 10, 10)
    kk_dt = dt
end