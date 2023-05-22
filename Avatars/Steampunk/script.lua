vanilla_model.PLAYER:setVisible(false)

Eyes = require("eyes")
Basics = require("basics")

function events.entity_init()
    Basics.entity_init()
end

function events.tick()
    Eyes.tick()
    Basics.tick()
end

function events.render(delta, context)
    Eyes.render(delta)
    Basics.render()
end