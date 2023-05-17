-- Original eye avatar template by Fran#3814

-- Make sure you edit constants at the top of blink.lua!
Blink = require("blink")

function events.entity_init()
  vanilla_model.INNER_LAYER:setVisible(false)
	vanilla_model.OUTER_LAYER:setVisible(false)
end

function events.tick()
  Blink.tick()
end

function events.render(delta, context)
  Blink.render(delta)
end