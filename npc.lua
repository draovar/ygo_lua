-- consts --
DIR_UP    = 0
DIR_DOWN  = 1
DIR_LEFT  = 2
DIR_RIGHT = 3

STATE_IDLE = 0
STATE_WALK = 1


npcTable = {}
function NPCs_load()
    npcLayer = gameMap.layers["npcs"]
    for _, obj in ipairs(npcLayer.objects) do
        npc = safeRequire("npcs/"..obj.name)
        if npc ~= nil then
            npc.x = obj.x
            npc.y = obj.y
            table.insert(npcTable, npc)
        end
    end
end

function NPCs_update(dt)
    for i, npc in ipairs(npcTable) do
        npc.update(dt)
    end
end

function NPCs_draw()
    player.focus = nil
    for i, npc in ipairs(npcTable) do
        npc.draw()
        if pointInRect(npc.x, npc.y, player.x - TILE_SIZE*2, player.y - TILE_SIZE*2, TILE_SIZE*4, TILE_SIZE*4) then
            love.graphics.print("Press X to talk...",npc.x - TILE_SIZE, npc.y - TILE_SIZE)
            player.focus = npc
            if love.keyboard.isDown("x") then
                npc.init_dialog()
            end
        end
    end
end

function NPCs_interaction()
    for i, npc in ipairs(npcTable) do
        npc.interactions()
    end
end