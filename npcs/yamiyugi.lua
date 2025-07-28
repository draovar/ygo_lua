require "../animation"

-- NPC data
local npc = {}
npc.name = "Yami Yugi"
npc.x = 0
npc.y = 0
npc.dir = 1
npc.w = 48
npc.h = 64
npc.talkies = require('../libs/talkies')
npc.image = love.graphics.newImage("sprites/yugi_img.png")
npc.collisions = {}

npc.dialogs = {
    "You are not ready yet..",
    "Come to me later!\n",
}
npc.options = {
    { "Bye", function() game_state = RUNING end },
}

npc.animation = newAnimation(love.graphics.newImage("sprites/yamiyugi.png"), 48, 64, 1/2)

local function load()
    npc.collisions.shape = "ellipse"
    npc.collisions.width = 48
    npc.collisions.height = 48
    npc.collisions.x = npc.x - npc.w/2
    npc.collisions.y = npc.y
end

local function update(dt)
    npc.collisions.x = npc.x - npc.w/2
    npc.collisions.y = npc.y
    npc.talkies.update(dt)
end

local function draw()
    love.graphics.draw(npc.animation.spriteSheet, npc.animation.quads[1 + 3*npc.dir], npc.x, npc.y, 0, 1, 1, 24, 32)
end

local function interactions()
    npc.talkies.draw()
end

local function init_dialog()
  if not npc.talkies:isOpen() then
    npc.talkies.say(npc.name, npc.dialogs, {options = npc.options, image = npc.image})
    game_state = INTERACT
  end
end

-- NPC APIs
npc.load         = load
npc.update       = update
npc.draw         = draw
npc.init_dialog  = init_dialog
npc.interactions = interactions

return npc