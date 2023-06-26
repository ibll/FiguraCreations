local emotes = require("emotes")
local rise = require("rise")

local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local emotesList = {
    {
        name = "Dab",
        item = "minecraft:painting",
        model = "Horsey",
        anim = "dab"
    },
    {
        name = "Wave",
        item = "minecraft:paper",
        model = "Horsey",
        anim = "wave"
    }
}

----------------------
-- Figura Functions --
----------------------

function events.ENTITY_INIT()
	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	-- action wheel
	local mainPage = action_wheel:newPage("Main")
	action_wheel:setPage(mainPage)

	rise.addActionTo(mainPage)

	local emoteWheel = emotes.init(emotesList, false, mainPage)
	mainPage:newAction()
		:title("Emotes")
		:item("minecraft:painting")
		:onLeftClick(function() action_wheel:setPage(emoteWheel) end)
end

function events.TICK()
	rise.riseTick()
end

function events.RENDER(delta)
	rise.riseRender()
end