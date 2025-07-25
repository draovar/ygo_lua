-- consts --
DIR_UP    = 0
DIR_DOWN  = 1
DIR_LEFT  = 2
DIR_RIGHT = 3

STATE_IDLE = 0
STATE_WALK = 1

NPC = {}
NPC.__index = NPC
NPC.name = "Just NPC"
NPC.x = 1
NPC.y = 1
NPC.w = 48
NPC.h = 64
NPC.s = 2
NPC.dialogs = {"Hi, my name is NPC", "Buy Buy!"}
NPC.dir = DIR_UP
NPC.state = STATE_IDLE
NPC.animation = newAnimation(love.graphics.newImage("sprites/yamiyugi.png"), 48, 64, 1/player.s)

NPCs = {}

-- Constructor
function NPC:new(name, x, y, w, h, dialogs)
    local obj = setmetatable({}, self)
    obj.name = name or "NPC"
    obj.x = x or 1
    obj.y = y or 1
    obj.w = w or 48
    obj.h = h or 64
    obj.dir = DIR_DOWN
    NPC.state = STATE_IDLE
    NPC.animation = newAnimation(love.graphics.newImage("sprites/yamiyugi.png"), 48, 64, 1/player.s)
    obj.dialogs = dialogs or {}
    return obj
end

bonz = NPC:new("Bonz", 13, 10, 48, 64, {"Hi, my name is Bonz", "Buy Buy!"})

function npcs_init()
    local cols = groundLayer.width
    local rows = groundLayer.height

    for i = 1, cols do
        NPCs[i] = {}  -- create a new row
        for j = 1, rows do
            NPCs[i][j] = nil
        end
    end

    NPCs[bonz.x][bonz.y] = bonz
end

function npcs_draw()
    local cols = groundLayer.width
    local rows = groundLayer.height
    for i = 1, cols do
        for j = 1, rows do
            if NPCs[i][j] ~= nil then
                local npc_x = math.floor(NPCs[i][j].x * TILE_SIZE + TILE_SIZE/2)
                local npc_y = math.floor(NPCs[i][j].y * TILE_SIZE + TILE_SIZE/2)
                love.graphics.draw(NPCs[i][j].animation.spriteSheet, NPCs[i][j].animation.quads[1 + 3*NPCs[i][j].dir], npc_x, npc_y, 0, 1, 1, 24, 32)
                if pointInRect(npc_x, npc_y, player.x - TILE_SIZE*2, player.y - TILE_SIZE*2, TILE_SIZE*4, TILE_SIZE*4) then
                    love.graphics.print("Press X to talk...",npc_x - TILE_SIZE, npc_y - TILE_SIZE)
                -- else
                --     love.graphics.print("NO", npc_x - TILE_SIZE/2, npc_y - TILE_SIZE)
                end
            end
        end
    end

end