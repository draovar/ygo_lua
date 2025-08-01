TILE_SIZE = 48

-- game states 
RUNING = 0
INTERACT = 1
game_state = RUNING

fonts = {
    default = love.graphics.newFont(),
    dialog  = love.graphics.newFont("res/fonts/PixelPurl.ttf", 24)
}

function game_load(map)
    require "player"
    require "npc"
    camera = require "libs/camera";
    cam = camera()
    sti = require 'libs/sti'
    gameMap = sti(map)
    groundLayer     = gameMap.layers["ground"]
    decorsLayer     = gameMap.layers["decors"]
    decorsLayer2    = gameMap.layers["decors2"]
    objectsLayer    = gameMap.layers["objects1"]
    objectsLayer2   = gameMap.layers["objects2"]
    objectsTiles    = gameMap.layers["objects_tiles1"]
    objectsTiles2   = gameMap.layers["objects_tiles2"]
    collisionsLayer = gameMap.layers["collisions"]
    objects = {}
    objects2 = {}

    NPCs_load()
    
    for _, obj in ipairs(objectsLayer.objects) do
        table.insert(objects, obj)
    end
    
    for _, obj in ipairs(objectsLayer2.objects) do
        table.insert(objects2, obj)
    end
end

function game_draw()
    love.graphics.clear({0.5, 0.5, 1, 1})

    cam:attach()
        gameMap:drawLayer(groundLayer)
        gameMap:drawLayer(decorsLayer)
        draw_background_objs()
        draw_background_objs2()
        NPCs_draw_background()
        player_draw()
        draw_foreground_objs()
        draw_foreground_objs2()
        NPCs_draw_foreground()
        gameMap:drawLayer(decorsLayer2)
    cam:detach()
    
    -- npc
    NPCs_interaction()

    -- debug
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("P_XY: "..tostring(player.x)..", "..tostring(player.y), 10, 30)
    love.graphics.print("P_XY: "..tostring(math.floor((player.x)/TILE_SIZE))..", "..tostring(math.floor((player.y+player.h/4)/TILE_SIZE)), 10, 50)
end

function game_update(dt)
    player_update(dt)
    NPCs_update(dt)

    for _, obj in ipairs(collisionsLayer.objects) do
        player_collision(obj)
    end
    for i, npc in ipairs(npcTable) do
        player_collision(npc.collisions)
    end
    player_move()

    -- camera
    cam:lookAt(math.floor(player.x), math.floor(player.y))
    local w, h = love.graphics.getDimensions( )
    cam.x = math.max(cam.x, 0 + w/2)
    cam.x = math.min(cam.x, 40*TILE_SIZE - w/2)
    cam.y = math.max(cam.y, 0 + h/2)
    cam.y = math.min(cam.y, 40*TILE_SIZE - h/2)

    if player.x < 0 then
        player.x = 1920
        load_map('maps/map1.lua')
    elseif player.x > 1920 then
        player.x = 0
        load_map('maps/map2.lua')
    end
end