require "player";

TILE_SIZE = 48

function love.load()
    camera = require "libs/camera";
    cam = camera()

    sti = require 'libs/sti'
    gameMap = sti('maps/map1.lua')
    groundLayer     = gameMap.layers["ground"]
    objectsLayer    = gameMap.layers["objects"]
    objectsTiles    = gameMap.layers["objects_tiles"]
    collisionsLayer = gameMap.layers["collisions"]
end

function love.draw()
    love.graphics.clear({0.5, 0.5, 1, 1})
    cam:attach()
        gameMap:drawLayer(groundLayer)
        draw_background_objs()
        player_draw()
        draw_foreground_objs()
        player_outline()
    cam:detach()

    -- debug
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("P_XY: "..tostring(player.x)..", "..tostring(player.y), 10, 30)
end

function love.update(dt)
    player_update(dt)

    for _, obj in ipairs(collisionsLayer.objects) do
        player_collision(obj)
    end

    player_move()

    cam:lookAt(math.floor(player.x), math.floor(player.y))
end