local ibllVA = require("IbllVA")
local eyes = require("eyes")

local conditionalModelParts = {
    body = {
        notOnBack = {
            models.Steampunk.Body.Bust
        },
        onBackOnly = {
            models.Steampunk.Body.Backpack
        }
    },
    feet = {
        models.Steampunk.RightLeg.RightShoe,
        models.Steampunk.LeftLeg.LeftShoe
    }
}

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    ibllVA.init(conditionalModelParts, true)
end

function events.tick()
    ibllVA.lazySync()
    ibllVA.conditionalModelParts()
    eyes.tick()
end

function events.render(delta, context)
    eyes.render(delta)
end