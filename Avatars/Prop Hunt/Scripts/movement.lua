local dataAPI = require("Scripts.data")

local movementAPI = {}

movementAPI.ticksInSameBlock = 0

local savedPosition
local snapApplied

local seekerApplied = false

---------
-- API --
---------

function movementAPI.applyModelPos() 
    local pos = player:getPos()
    local currentPosition

    if dataAPI.snapMode == "Floored" then
        currentPosition = pos:floor()
    else
        currentPosition = vec(math.floor(pos.x), math.round(pos.y), math.floor(pos.z))
    end

    if savedPosition == currentPosition then
        movementAPI.ticksInSameBlock = movementAPI.ticksInSameBlock + 1
    else
        movementAPI.ticksInSameBlock = 0
    end

    if movementAPI.ticksInSameBlock >= 20 and dataAPI.snapMode ~= "Disabled" then
        models.model:setParentType("WORLD")

        if snapApplied == false then
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.25, 2, false)
            
            local blockPos
            if dataAPI.snapMode == "Floored" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            elseif dataAPI.snapMode == "Rounded" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            end
            models.model:setPos(blockPos)

            local blockRot
            if dataAPI.selectedBlockInfo.rotate then
                blockRot = math.round(player:getRot().y/90) * 90
            end
            models.model:setRot(0, blockRot, 0)
            
            snapApplied = true
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        models.model:setRot(0, 0, 0)
        snapApplied = false
    end

    savedPosition = currentPosition
end

function movementAPI.setVisibleAsProp(state)
    seekerApplied = not state

    vanilla_model.ALL:setVisible(not state)
    nameplate.ENTITY:setVisible(not state)
    models.model.root:setVisible(state)

    if state == true then ShadowSize = 0 else ShadowSize = 0.5 end
    renderer:setShadowRadius(ShadowSize)
end

function movementAPI.tick()
    if dataAPI.seekerEnabled then
        if not seekerApplied then movementAPI.setVisibleAsProp(false) end
    else
        if seekerApplied then movementAPI.setVisibleAsProp(true) end
        movementAPI.applyModelPos()
    end
end

return movementAPI