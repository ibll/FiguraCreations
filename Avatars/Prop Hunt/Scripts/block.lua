local dataAPI = require("Scripts.data")
local movementAPI = require("Scripts.movement")
local actionWheelAPI = require("Scripts.actionWheel")

local blockAPI = {}

function blockAPI.applyBlock(blockInfo, noResnap)
    -- when flipping between blocks that rotate/don't rotate, unsnap the player to force re-setting
    if noResnap ~= true then movementAPI.ticksInSameBlock = 0 end
    movementAPI.applyModelPos()

    for index, value in ipairs(models.model.root:getChildren()) do
        value:setVisible(false)
    end
    models.model.root[blockInfo.bone]:setVisible(true)

    if blockInfo.texture ~= nil then
        for index, value in ipairs(models.model.root[blockInfo.bone]:getChildren()) do
            value:setPrimaryTexture("RESOURCE", blockInfo.texture)
        end
    elseif blockInfo.textures ~= nil then
        for index, value in pairs(blockInfo.textures) do
            models.model.root[blockInfo.bone][index]:setPrimaryTexture("RESOURCE", value)
        end
    end

    actionWheelAPI.setSelectedBlock(blockInfo.name, blockInfo.id)

    dataAPI.selectedBlockInfo = blockInfo
end

return blockAPI