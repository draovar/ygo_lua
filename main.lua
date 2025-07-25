require "player";
require "npc";

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
    objects = {}
    for _, obj in ipairs(objectsLayer.objects) do
        table.insert(objects, obj)
    end

    npcs_init()

    -- debug
    print("id", "x", "y", "width", "height")
    for i, obj in ipairs(objects) do
        print(objects[i].id, objects[i].x, objects[i].y, objects[i].width, objects[i].height)
    end
    print("Number objs:", #objects)

    print(NPCs[bonz.x][bonz.y].dialogs[1])
end

function love.draw()
    love.graphics.clear({0.5, 0.5, 1, 1})
    cam:attach()
        gameMap:drawLayer(groundLayer)
        draw_background_objs()
        npcs_draw()
        player_draw()
        draw_foreground_objs()
        
        -- debug
        -- love.graphics.setColor(1, 0, 0)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.setColor(1, 1, 1)

        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, TILE_SIZE, TILE_SIZE)

        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, TILE_SIZE, TILE_SIZE)
        -- love.graphics.rectangle("line", math.floor((player.x)/TILE_SIZE) * TILE_SIZE + TILE_SIZE, math.floor((player.y+player.h/4)/TILE_SIZE) * TILE_SIZE - TILE_SIZE, TILE_SIZE, TILE_SIZE)
    cam:detach()

    -- debug
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("P_XY: "..tostring(player.x)..", "..tostring(player.y), 10, 30)
    love.graphics.print("P_XY: "..tostring(math.floor((player.x)/TILE_SIZE))..", "..tostring(math.floor((player.y+player.h/4)/TILE_SIZE)), 10, 50)
end

function love.update(dt)
    player_update(dt)

    for _, obj in ipairs(collisionsLayer.objects) do
        player_collision(obj)
    end

    player_move()

    cam:lookAt(math.floor(player.x), math.floor(player.y))
end