-- consts --
DIR_UP    = 0
DIR_DOWN  = 1
DIR_LEFT  = 2
DIR_RIGHT = 3

STATE_IDLE = 0
STATE_WALK = 1


function NPCs_load()
    npcTable = {}
    npcLayer = gameMap.layers["npcs"]
    for _, obj in ipairs(npcLayer.objects) do
        npc = safeRequire("npcs/"..obj.name)
        if npc ~= nil then
            npc.x = obj.x + TILE_SIZE / 2
            npc.y = obj.y --+ TILE_SIZE / 2
            npc.load()
            table.insert(npcTable, npc)
        end
    end
end

function NPCs_update(dt)
    for i, npc in ipairs(npcTable) do
        npc.update(dt)
    end
end

function NPCs_draw_foreground()
    player.focus = nil
    for i, npc in ipairs(npcTable) do
        if npc.y > player.y then
            npc.draw()
        end
    end
end

function NPCs_draw_background()
    player.focus = nil
    for i, npc in ipairs(npcTable) do
        if npc.y <= player.y then
            npc.draw()
        end
    end
end

function NPCs_interaction()
    for i, npc in ipairs(npcTable) do
        if pointInRect(npc.x, npc.y, player.x - TILE_SIZE*2, player.y - TILE_SIZE*2, TILE_SIZE*4, TILE_SIZE*4) then
            cam:attach()
                love.graphics.setColor(0,0,0,0.6)
                love.graphics.rectangle("fill", npc.x - TILE_SIZE - 4, npc.y - TILE_SIZE, 104, 16)
                love.graphics.setColor(1,1,1,1)
                love.graphics.print("Press X to talk...",npc.x - TILE_SIZE, npc.y - TILE_SIZE)
            cam:detach()
            player.focus = npc
            if love.keyboard.isDown("x") then
                npc.init_dialog()
            end
        end
        npc.interactions()
    end
end

function NPCs_keypressed(npc, key)
    if npc.talkies ~= nil then
        if key == "space" then npc.talkies.onAction()
        elseif key == "up" then npc.talkies.prevOption()
        elseif key == "down" then npc.talkies.nextOption()
        end
    end
end