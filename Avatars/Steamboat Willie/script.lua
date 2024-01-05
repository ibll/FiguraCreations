local ibllVA = require("IbllVA")

local conditionalModelParts = {
    legs = {
        models.Willie.RightLeg.RightPantsLeg,
        models.Willie.LeftLeg.LeftPantsLeg,
        models.Willie.Body.Pants
    },
    feet = {
        models.Willie.RightLeg.RightShoe,
        models.Willie.LeftLeg.LeftShoe,
    }
}

local tailFrame = 0

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    ibllVA.init(conditionalModelParts, true)
end

function events.tick()

    if player:isCrouching() then
        models.Willie.Tail:setPos(0, -2, 4)
    else
        models.Willie.Tail:setPos(0, 0, 0)
    end

    models.Willie.Tail.Tail:setUV(0, tailFrame*0.0625)
    if world:getTime() % 4 == 0 then
        tailFrame = tailFrame + 1
    end

    ibllVA.tick()
end