
Basics = require("basics")
Eyes = require("eyes")

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    Basics.entity_init()
end

function events.tick()
    Basics.tick()
    Eyes.tick()
end

function events.render(delta, context)
    Basics.render()
    Eyes.render(delta)
end