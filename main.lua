require "game"

function love.load()
    background = love.graphics.newImage("res/loading2.png")
    game_ready = 0
end

function love.update(dt)
    if game_ready == 2 then 
        game_update(dt)
    elseif game_ready == 1 then
        game_load()
        game_ready = 2
    else
        game_ready = 1
    end
end

function love.draw()
    if game_ready == 2 then 
        game_draw()
    else
        love.graphics.draw(background, 0, 0)
    end
end