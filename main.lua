require "player";

function love.load()
    sti = require 'libs/sti'
    gameMap = sti('maps/map1.lua')
    camera = require "libs/camera";
    objectsLayer = gameMap.layers["objects"]
    cam = camera()
end

function love.draw()
    love.graphics.clear({0.5, 0.5, 1, 1})
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])

        for _, obj in ipairs(objectsLayer.objects) do
            if obj.y + obj.height < player.y + 32 then
                local draw_x = 1 + obj.x/48
                local draw_y = 1 + obj.y/48
                local layer = gameMap.layers["objects_tiles"]
                for i=0, obj.width/48, 1 do
                    for j=0, obj.height/48, 1 do
                        local tile = layer.data[draw_y + j][draw_x + i] -- Y, X
                        if tile then
                            local tileset = gameMap.tilesets[tile.tileset]
                            love.graphics.draw(tileset.image, tile.quad, obj.x + i*48, obj.y + j*48)
                        end
                    end
                end
            end
        end

        player_draw()

        for _, obj in ipairs(objectsLayer.objects) do
            if obj.y + obj.height > player.y + 32 then
                local draw_x = 1 + obj.x/48
                local draw_y = 1 + obj.y/48
                local layer = gameMap.layers["objects_tiles"]
                for i=0, obj.width/48, 1 do
                    for j=0, obj.height/48, 1 do
                        local tile = layer.data[draw_y + j][draw_x + i] -- Y, X
                        if tile then
                            local tileset = gameMap.tilesets[tile.tileset]
                            love.graphics.draw(tileset.image, tile.quad, obj.x + i*48, obj.y + j*48)
                        end
                    end
                end
            end
        end
    cam:detach()

    -- debug
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("P_XY: "..tostring(player.x)..", "..tostring(player.y), 10, 30)
end

function love.update(dt)
    player_update(dt)
    cam:lookAt(math.floor(player.x), math.floor(player.y))
end