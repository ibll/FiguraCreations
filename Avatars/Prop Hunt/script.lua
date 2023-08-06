-- scripts
local dataAPI = require("Scripts.data")
local actionWheelAPI = require("Scripts.actionWheel")
local playerAPI = require("Scripts.player")
local applyBlock = require("Scripts.applyBlock")
local buildModeAPI = require("Scripts.buildMode")

------------
-- Figura --
------------

function events.entity_init()
    actionWheelAPI.generateMainPage()
    actionWheelAPI.generateBlockPage()
    action_wheel:setPage(actionWheelAPI.mainPage)
    actionWheelAPI.setSelectedBlock(dataAPI.selectedBlockInfo.name, dataAPI.selectedBlockInfo.blockID)

    playerAPI.setVisibleAsProp(true)
    applyBlock(dataAPI.selectedBlockInfo, true)
end

function events.tick()
    dataAPI.lazySync()
    playerAPI.tick()
end

local placeKeybind = keybinds:fromVanilla("key.use")
placeKeybind:setOnPress(function() buildModeAPI.click() end)