local emotes = require("emotes")
local eyes = require("eyes")

local emotesList = {
    {
        name = "Dab",
        item = "minecraft:painting",
        model = "Lovely",
        anim = "dab"
    },
    {
        name = "Wave",
        item = "minecraft:paper",
        model = "Lovely",
        anim = "wave"
    }
}

----------------------
-- Figura Functions --
----------------------

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    vanilla_model.ARMOR:setVisible(false)
    vanilla_model.CAPE:setVisible(false)
    vanilla_model.ELYTRA:setVisible(false)

    emotes.init(emotesList, true)
end

function events.tick()
    emotes.tick()
    eyes.tick()
end

function events.render(delta, context)
    if context == "RENDER" then eyes.render(delta) end

    local function customRot()
        VanillaHeadRot = vanilla_model.HEAD:getOriginRot()
        HeadBodyOffset = (player:getRot().y - player:getBodyYaw() + 180) % 360 - 180
        models.Lovely.Noggin:setRot(VanillaHeadRot.x*1/2, -HeadBodyOffset*1/2, 0)
        models.Lovely.Noggin:setPos(- vanilla_model.HEAD:getOriginPos())

        models.Lovely.Base:setRot(0, -HeadBodyOffset/2, 0)
        models.Lovely.Base.Body:setRot(0, HeadBodyOffset*1/3, 0)
        models.Lovely.Base.Arms:setRot(0, HeadBodyOffset*3/8, 0)
        models.Lovely.Base.Legs:setRot(0, HeadBodyOffset/2, 0)
    end
    customRot()
end