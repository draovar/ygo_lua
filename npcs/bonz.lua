local Talkies = require('../libs/talkies')
require "../animation"

-- NPC data
bonz = {}
bonz.name = "Bonz"
bonz.x = 0
bonz.y = 0
bonz.w = 48
bonz.h = 64
bonz.dir = 1
bonz.interaction = false

bonz.dialogs = {
    "Hello...",
    "My name is Kiko and i am testing something..",
    "Do you want to help me? \n",
}
bonz.options = {
    { "Yes", function() Talkies.say("Player", "Sure, I'm glad I can help.") game_state = RUNING end },
    { "No",  function() Talkies.say("Player", "No, I can't right now.") game_state = RUNING end },
}

bonz.animation = newAnimation(love.graphics.newImage("sprites/bonz.png"), 48, 64, 1/2)

local function load()
    return
end

local function update(dt)
    Talkies.update(dt)
end

local function draw()
    love.graphics.draw(bonz.animation.spriteSheet, bonz.animation.quads[1 + 3*bonz.dir], bonz.x, bonz.y, 0, 1, 1, 24, 32)
end

local function interactions()
    Talkies.draw()
end

local function init_dialog()
  if not Talkies:isOpen() then
    Talkies.say(bonz.name, bonz.dialogs, {options = bonz.options})
    game_state = INTERACT
  end
end

local function keypressed(key)
    if key == "space" then Talkies.onAction()
    elseif key == "up" then Talkies.prevOption()
    elseif key == "down" then Talkies.nextOption()
    end
end


-- NPC APIs
bonz.load         = load
bonz.update       = update
bonz.draw         = draw
bonz.init_dialog  = init_dialog
bonz.interactions = interactions
bonz.keypressed   = keypressed


return bonz