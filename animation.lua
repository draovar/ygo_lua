bg_index = 1;
bg_index2 = 1;

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

    if player.focus then
        player.focus.keypressed(key)
    end
end

function love.keyreleased(key)
   if key == "lshift" then
      player.s = 2
      player.animation.duration = 1/player.s
   end
end

function draw_background_objs()
    for index = 1, #objects do
        if objects[index].y + objects[index].height > player.y + player.h/2 + 8 then
            bg_index = index
            break
        end
        local draw_x = objects[index].x/TILE_SIZE
        local draw_y = objects[index].y/TILE_SIZE
        for i=1, objects[index].width/TILE_SIZE do
            for j=1, objects[index].height/TILE_SIZE do
                local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                if tile then
                    local tileset = gameMap.tilesets[tile.tileset]
                    love.graphics.draw(tileset.image, tile.quad, objects[index].x + (i-1)*TILE_SIZE, objects[index].y + (j-1)*TILE_SIZE)
                end
            end
        end
    end
end

function draw_background_objs2()
    for index = 1, #objects2 do
        if objects2[index].y + objects2[index].height > player.y + player.h/2 + 8 then
            bg_index2 = index
            break
        end
        local draw_x = objects2[index].x/TILE_SIZE
        local draw_y = objects2[index].y/TILE_SIZE
        for i=1, objects2[index].width/TILE_SIZE do
            for j=1, objects2[index].height/TILE_SIZE do
                local tile = objectsTiles2.data[draw_y + j][draw_x + i] -- Y, X
                if tile then
                    local tileset = gameMap.tilesets[tile.tileset]
                    love.graphics.draw(tileset.image, tile.quad, objects2[index].x + (i-1)*TILE_SIZE, objects2[index].y + (j-1)*TILE_SIZE)
                end
            end
        end
    end
end

function draw_foreground_objs()
    for index = bg_index, #objects do
        if objects[index].y + objects[index].height > player.y + player.h/2 + 8 then
            local draw_x = objects[index].x/TILE_SIZE
            local draw_y = objects[index].y/TILE_SIZE
            -- draw object
            for i=1, objects[index].width/TILE_SIZE do
                for j=1, objects[index].height/TILE_SIZE do
                    local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                    if tile then
                        local tileset = gameMap.tilesets[tile.tileset]
                        love.graphics.draw(tileset.image, tile.quad, objects[index].x + (i-1)*TILE_SIZE, objects[index].y + (j-1)*TILE_SIZE)
                    end
                end
            end
            -- draw outline if needed
            if objects[index].height>96 then
                if  pointInRect(player.x + 24, player.y + 32, objects[index].x, objects[index].y, objects[index].width, objects[index].height) or 
                    pointInRect(player.x + 24, player.y - 32, objects[index].x, objects[index].y, objects[index].width, objects[index].height) or
                    pointInRect(player.x - 24, player.y + 32, objects[index].x, objects[index].y, objects[index].width, objects[index].height) or
                    pointInRect(player.x - 24, player.y - 32, objects[index].x, objects[index].y, objects[index].width, objects[index].height) then
                        player_outline()
                end
            end
            
        end
    end
end


function draw_foreground_objs2()
    for index = bg_index2, #objects2 do
        if objects2[index].y + objects2[index].height > player.y + player.h/2 + 8 then
            local draw_x = objects2[index].x/TILE_SIZE
            local draw_y = objects2[index].y/TILE_SIZE
            -- draw object
            for i=1, objects2[index].width/TILE_SIZE do
                for j=1, objects2[index].height/TILE_SIZE do
                    local tile = objectsTiles2.data[draw_y + j][draw_x + i] -- Y, X
                    if tile then
                        local tileset = gameMap.tilesets[tile.tileset]
                        love.graphics.draw(tileset.image, tile.quad, objects2[index].x + (i-1)*TILE_SIZE, objects2[index].y + (j-1)*TILE_SIZE)
                    end
                end
            end
            -- draw outline if needed
            if objects2[index].height>96 then
                if  pointInRect(player.x + 24, player.y + 32, objects2[index].x, objects2[index].y, objects2[index].width, objects2[index].height) or 
                    pointInRect(player.x + 24, player.y - 32, objects2[index].x, objects2[index].y, objects2[index].width, objects2[index].height) or
                    pointInRect(player.x - 24, player.y + 32, objects2[index].x, objects2[index].y, objects2[index].width, objects2[index].height) or
                    pointInRect(player.x - 24, player.y - 32, objects2[index].x, objects2[index].y, objects2[index].width, objects2[index].height) then
                        player_outline()
                end
            end
            
        end
    end
end

function pointInEllipse(px, py, ex, ey, ew, eh)
  -- center of the ellipse
  local cx = ex + ew * 0.5
  local cy = ey + eh * 0.5
  -- radii
  local a = ew * 0.5
  local b = eh * 0.5
  -- vector from center to point
  local dx = px - cx
  local dy = py - cy
  -- standard ellipse equation: (x/a)^2 + (y/b)^2 <= 1
  return (dx*dx)/(a*a) + (dy*dy)/(b*b) <= 1
end

function pointInRect(px, py, rx, ry, rw, rh)
  return px >= rx
     and px <= rx + rw
     and py >= ry
     and py <= ry + rh
end

function checkCollision(t, px, py, ox, oy, ow, oh)
    res = 0
    if t == "ellipse" then
        res = pointInEllipse(px, py, ox, oy, ow, oh)
    elseif t == "rectangle" then
        res = pointInRect(px, py, ox, oy, ow, oh)
    end
    return res
end

function safeRequire(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    else
        print("Warning: Failed to load module '" .. module)
        return nil
    end
end