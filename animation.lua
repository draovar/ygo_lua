bg_index = 0;

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
    for index = 1, #objects do
        if objects[index].y + objects[index].height > player.y + player.h/2 + 8 then
            bg_index = index
            break
        end
        local draw_x = 1 + objects[index].x/TILE_SIZE
        local draw_y = 1 + objects[index].y/TILE_SIZE
        for i=0, objects[index].width/TILE_SIZE do
            for j=0, objects[index].height/TILE_SIZE do
                local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                if tile then
                    local tileset = gameMap.tilesets[tile.tileset]
                    love.graphics.draw(tileset.image, tile.quad, objects[index].x + i*TILE_SIZE, objects[index].y + j*TILE_SIZE)
                end
            end
        end
    end
end

function draw_foreground_objs()
    for index = bg_index, #objects do
        if objects[index].y + objects[index].height > player.y + player.h/2 + 8 then
            local draw_x = 1 + objects[index].x/TILE_SIZE
            local draw_y = 1 + objects[index].y/TILE_SIZE
            -- draw object
            for i=0, objects[index].width/TILE_SIZE do
                for j=0, objects[index].height/TILE_SIZE do
                    local tile = objectsTiles.data[draw_y + j][draw_x + i] -- Y, X
                    if tile then
                        local tileset = gameMap.tilesets[tile.tileset]
                        love.graphics.draw(tileset.image, tile.quad, objects[index].x + i*TILE_SIZE, objects[index].y + j*TILE_SIZE)
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