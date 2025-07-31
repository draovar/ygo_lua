require "../animation"

-- NPC data
local npc = {}
npc.name = "Bonz"
npc.x = 0
npc.y = 0
npc.dir = 1
npc.w = 48
npc.h = 64
npc.talkies = require('../libs/talkies')
npc.collisions = {}
npc.image = love.graphics.newImage("sprites/bonz_dialog.png")

npc.dialogs = {
    "Hello...",
    "My name is Kiko and i am testing something..",
    "Do you want to help me? \n",
}
npc.options = {
    { "Yes", function() player.talkies.say("Player", "Sure, I'm glad I can help.", {image = player.image}) end },
    { "No",  function() player.talkies.say("Player", "No, I can't right now.", {image = player.image}) end },
}

npc.animation = newAnimation(love.graphics.newImage("sprites/bonz.png"), 48, 64, 1/2)

local function load()
    npc.collisions.shape = "ellipse"
    npc.collisions.width = 48
    npc.collisions.height = 48
    npc.collisions.x = npc.x - npc.w/2
    npc.collisions.y = npc.y

    npc.quads = {}
    local imgWidth, imgHeight = npc.image:getWidth(), npc.image:getHeight()
    local spriteWidth = imgWidth / 5

    for i=0,4 do
		table.insert(npc.quads, love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, imgHeight, imgWidth, imgHeight))
	end
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
    npc.talkies.say(npc.name, npc.dialogs, {options = npc.options, image = npc.image, quads = npc.quads})
  end
end

-- NPC APIs
npc.load         = load
npc.update       = update
npc.draw         = draw
npc.init_dialog  = init_dialog
npc.interactions = interactions

return npc