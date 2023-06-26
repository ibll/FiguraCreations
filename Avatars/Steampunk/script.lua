local basics = require("basics")
local eyes = require("eyes")

local conditionalModelParts = {
    torso = {
        notOnBack = {
            models.Steampunk.Body.Bust
        },
        onBackOnly = {
            models.Steampunk.Body.Backpack
        }
    },
    boots = {
        models.Steampunk.RightLeg.RightShoe,
        models.Steampunk.LeftLeg.LeftShoe
    }
}

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    basics.init(conditionalModelParts, true)
end

function events.tick()
    basics.tick()
    eyes.tick()
    basics.conditionalModelParts()
end

function events.render(delta, context)
    eyes.render(delta)
end