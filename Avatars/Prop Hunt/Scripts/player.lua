local dataAPI = require("Scripts.data")
local applyBlock = require("Scripts.applyBlock")
local actionWheelAPI = require("Scripts.actionWheel")

local savedPosition
local snapApplied
local seekerApplied = false

local playerAPI = {}

playerAPI.ticksInSameBlock = 0

---------
-- API --
---------

function playerAPI.applyModelPos()
    local pos = player:getPos()
    local currentPosition

    if dataAPI.snapMode == "Floored" then
        currentPosition = pos:floor()
    else
        currentPosition = vec(math.floor(pos.x), math.round(pos.y), math.floor(pos.z))
    end

    if savedPosition == currentPosition then
        playerAPI.ticksInSameBlock = playerAPI.ticksInSameBlock + 1
    else
        playerAPI.ticksInSameBlock = 0
    end

    if playerAPI.ticksInSameBlock >= 20 and dataAPI.snapMode ~= "Disabled" then
        models.model:setParentType("WORLD")

        local offsetRot = 0
        if dataAPI.selectedBlockInfo.offsetRot then
            offsetRot = dataAPI.selectedBlockInfo.offsetRot
        end

        if snapApplied == false then
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.25, 2, false)

            local blockPos
            if dataAPI.snapMode == "Floored" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            elseif dataAPI.snapMode == "Rounded" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            end
            models.model:setPos(blockPos)

            local blockRot = 0

            if dataAPI.selectedBlockInfo.rotate == "Any" then
                blockRot = math.round(player:getRot().y/90) * 90
                if blockRot % 180 == 0 then blockRot = blockRot + 180 end

            elseif dataAPI.selectedBlockInfo.rotate == "Limited" then
                blockRot = math.abs(math.round(player:getRot().y/90) * 90)
                if (blockRot + 180) % 360 == 0 then
                    blockRot = blockRot + 180
                elseif (blockRot + 270) % 360 == 0 then
                    blockRot = blockRot + 180
                end

            elseif dataAPI.selectedBlockInfo.rotate == "LimitedFlipWE" then
                blockRot = math.abs(math.round(player:getRot().y/90) * 90)
                if (blockRot + 180) % 360 == 0 then
                    blockRot = blockRot + 180
                elseif (blockRot + 90) % 360 == 0 then
                    blockRot = blockRot + 180
                end
            end

            models.model.root:setRot(0, blockRot + offsetRot, 0)

            dataAPI.blockRot = blockRot

            snapApplied = true
        else
            models.model.root:setRot(0, dataAPI.blockRot + offsetRot, 0)
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        models.model.root:setRot(0, 0, 0)
        snapApplied = false
    end

    savedPosition = currentPosition
end

function playerAPI.setBlock(blockInfo, unsnap)
    applyBlock(blockInfo)

    -- when flipping between blocks that rotate/don't rotate, unsnap the player to force re-setting
    if unsnap ~= false then
        playerAPI.ticksInSameBlock = 0
        playerAPI.applyModelPos()
    end

    actionWheelAPI.setSelectedBlock(blockInfo.name, blockInfo.blockID)

    dataAPI.selectedBlockInfo = blockInfo
end

function pings.setBlock(blockInfo, unsnap)
    playerAPI.setBlock(blockInfo, unsnap)
end

function playerAPI.setVisibleAsProp(state)
    seekerApplied = not state

    vanilla_model.ALL:setVisible(not state)
    nameplate.ENTITY:setVisible(not state)
    models.model.root:setVisible(state)

    local shadowSize = 0.5
    if state == true then shadowSize = 0 end
    renderer:setShadowRadius(shadowSize)
end

function playerAPI.tick()
    if dataAPI.seekerEnabled then
        if not seekerApplied then playerAPI.setVisibleAsProp(false) end
    else
        if seekerApplied then playerAPI.setVisibleAsProp(true) end
        playerAPI.applyModelPos()
    end
end

return playerAPI