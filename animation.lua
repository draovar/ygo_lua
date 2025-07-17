function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function norm_speed(x, y, s)
    len = math.sqrt(x * x + y * y)
    if len ~= 0 and len ~= s then
        x = x / (len / s)
        y = y / (len / s)
    end
    return x,y
end

function love.keypressed(key, scancode, isrepeat)
   if key == "lshift" then
        player.s = 4
        player.animation.duration = 1/player.s
   end
end

function love.keyreleased(key)
   if key == "lshift" then
      player.s = 2
      player.animation.duration = 1/player.s
   end
end

function draw_background_objs()
    for _, obj in ipairs(objectsLayer.objects) do
        if obj.y + obj.height <= player.y + player.h/2 + 8 then
            local draw_x = 1 + obj.x/TILE_SIZE
            local draw_y = 1 + obj.y/TILE_SIZE
            for i=0, obj.width/TILE_SIZE, 1 do
                for j=0, obj.height/TILE_SIZE, 1 do
                    local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                    if tile then
                        local tileset = gameMap.tilesets[tile.tileset]
                        love.graphics.draw(tileset.image, tile.quad, obj.x + i*TILE_SIZE, obj.y + j*TILE_SIZE)
                    end
                end
            end
        end
    end
end

function draw_foreground_objs()
    for _, obj in ipairs(objectsLayer.objects) do
        if obj.y + obj.height > player.y + player.h/2 + 8 then
            local draw_x = 1 + obj.x/TILE_SIZE
            local draw_y = 1 + obj.y/TILE_SIZE
            for i=0, obj.width/TILE_SIZE, 1 do
                for j=0, obj.height/TILE_SIZE, 1 do
                    local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                    if tile then
                        local tileset = gameMap.tilesets[tile.tileset]
                        love.graphics.draw(tileset.image, tile.quad, obj.x + i*TILE_SIZE, obj.y + j*TILE_SIZE)
                    end
                end
            end
        end
    end
end