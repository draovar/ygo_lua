require "player";

function love.load()
end

function love.draw()
    love.graphics.clear({0.5, 0.5, 1, 1})
    player_draw()
end

function love.update(dt)
    player_update(dt)
end