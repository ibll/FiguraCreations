local dataAPI = require("Scripts.data")
local actionWheelAPI = require("Scripts.actionWheel")
local playerAPI = require("Scripts.player")

local blockInfos = require("blockInfos")

---------------
-- Functions --
---------------

function pings.applyBlock(blockInfo)
    playerAPI.applyBlock(blockInfo)
end

function pings.place(pos)
    local copy = models.model.root:copy("Block")
    models.model.World:addChild(copy)
    copy:setVisible(true)
    copy:setPos(pos)
end

------------
-- Figura --
------------

function events.entity_init()
    actionWheelAPI.generateMainPage()
    actionWheelAPI.generateBlockPage()
    action_wheel:setPage(actionWheelAPI.mainPage)

    -- setup
    playerAPI.setVisibleAsProp(true)
    playerAPI.applyBlock(dataAPI.selectedBlockInfo)
end

function events.tick()
    dataAPI.lazySync()
    playerAPI.tick()
end

function events.MOUSE_PRESS(button, state, modifiers)
    if dataAPI.buildModeEnabled ~= true then return end
    if state ~= 1 then return end

    local targetedBlock, hitPos, side = player:getTargetedBlock(true, 6)

    local pos = targetedBlock:getPos()*16
    pos = vec(pos.x+8, pos.y + 0.01, pos.z+8)

    local positionOffsetVectors = {
        up = vec(0, 16, 0),
        down = vec(0, -16, 0),
        north = vec(0, 0, -16),
        south = vec(0, 0, 16),
        east = vec(16, 0, 0),
        west = vec(-16, 0, 0),
    }
    pos = pos:add(positionOffsetVectors[side])

    pings.place(pos)
end