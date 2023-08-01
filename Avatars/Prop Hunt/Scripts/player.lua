local dataAPI = require("Scripts.data")
local actionWheelAPI = require("Scripts.actionWheel")

local savedPosition
local snapApplied

local seekerApplied = false

local playerAPI = {}

playerAPI.ticksInSameBlock = 0

local function isValidBlockID(id)
    local function tryId(inputID) return world.newItem(inputID) end
    return pcall(tryId, id)
end

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
            if dataAPI.selectedBlockInfo.rotate == "Any" then
                blockRot = math.round(player:getRot().y/90) * 90
                if blockRot % 180 == 0 then blockRot = blockRot + 180 end

            elseif dataAPI.selectedBlockInfo.rotate == "Limited" then
                blockRot = math.abs(math.round(player:getRot().y/90) * 90)
                if blockRot % 360 == 0 then
                    blockRot = blockRot + 180
                elseif (blockRot + 90) % 360 == 0 then
                    blockRot = blockRot + 180
                end

            end
            models.model.root:setRot(0, blockRot, 0)

            snapApplied = true
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        models.model.root:setRot(0, 0, 0)
        snapApplied = false
    end

    savedPosition = currentPosition
end

function pings.applyBlock(blockInfo, unsnap)

    if blockInfo.name == nil then
        print("§4Error!\n§cInvalid Block Info!§r\nSelected block has no 'name'.")
        return
    end

    if isValidBlockID(blockInfo.blockID) == false then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, blockInfo.blockID, "is not a valid block ID!")
        return
    end

    if (blockInfo.rotate) and (blockInfo.rotate ~= "Any" and blockInfo.rotate ~= "Limited") then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "'rotate' must be \"Any\", \"Limited\", or nil.")
        return
    end

    -- when flipping between blocks that rotate/don't rotate, unsnap the player to force re-setting
    if unsnap ~= false then
        playerAPI.ticksInSameBlock = 0
        playerAPI.applyModelPos()
    end

    for index, value in pairs(models.model.root:getTask()) do
        value:remove()
    end

    models.model.root:newBlock(blockInfo.name)
        :setBlock(blockInfo.blockID)
        :setPos(-8, 0, -8)

    actionWheelAPI.setSelectedBlock(blockInfo.name, blockInfo.blockID)

    dataAPI.selectedBlockInfo = blockInfo
end

function playerAPI.applyBlock(blockInfo, unsnap)
    pings.applyBlock(blockInfo, unsnap)
end

function playerAPI.setVisibleAsProp(state)
    seekerApplied = not state

    vanilla_model.ALL:setVisible(not state)
    nameplate.ENTITY:setVisible(not state)
    models.model.root:setVisible(state)

    if state == true then ShadowSize = 0 else ShadowSize = 0.5 end
    renderer:setShadowRadius(ShadowSize)
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