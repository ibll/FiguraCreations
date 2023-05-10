vanilla_model.PLAYER:setVisible(false)

Blink = require("blink")
Basics = require("basics")

function events.entity_init()
    Basics.entity_init()
end

function events.tick()
    Blink.tick()
    Basics.tick()
end

function events.render(delta, context)
    Blink.render(delta)
    Basics.render()
end