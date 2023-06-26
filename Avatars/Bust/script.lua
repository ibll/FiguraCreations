local ibllVA = require("IbllVA")

local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local tick = 0

local bustEnabled = false

local conditionalModelParts = {
    body = {
        notOnBack = { models.Bust.Body }
    }
}

--------------------
-- Ping Functions --
--------------------

function pings.sync(bustState)
    bustEnabled = bustState

    models.Bust.Body["Bust"]:setVisible(bustEnabled)
    models.Bust.Body["Bust Layer"]:setVisible(bustEnabled)
end

local function quickSync()
    pings.sync(bustEnabled)
end

local function syncTick()
    tick = tick + 1
    if tick < 200 then return end
    if not host:isHost() then return end
    quickSync()
    tick = 0
end

------------------
-- Action Wheel --
------------------

local function printState(string, state)
    function State(bool)
        if bool then return "§aEnabled" else return "§cDisabled" end
    end
    print(string .. ": " .. (State(state)))
end

local function toggleBust()
    bustEnabled = not bustEnabled
    config:save("BustEnabled", bustEnabled)
    quickSync()
    printState("Bust Visibility", bustEnabled)
end

----------------------
-- Figura Functions --
----------------------

function events.entity_init()
    models:setPrimaryTexture("SKIN")

    -- config loading
    if config:load("BustEnabled") == true then bustEnabled = true end

    -- action wheel
	local functionWheel = ibllVA.init(conditionalModelParts, true)

    local bustToggleAction = functionWheel:newAction()
        :item("minecraft:melon")
        :title("Enable Bust")
        :color(DISABLED_COLOR)
        :onToggle(toggleBust)
        :toggleTitle("Disable Bust")
        :toggleColor(ENABLED_COLOR)
    bustToggleAction:setToggled(bustEnabled)

    quickSync()
end

function events.tick()
    ibllVA.tick()
    syncTick()
end