vanilla_model.PLAYER:setVisible(false)

Blink = require("blink")

function events.tick()
    Blink.tick()
end

function events.render(delta, context)
    Blink.render(delta)
end