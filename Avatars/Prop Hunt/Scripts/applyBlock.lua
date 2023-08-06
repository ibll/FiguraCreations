local handleErrorsAPI = require("Scripts.handleErrors")
local settings = require("settings")

local blockTask
local otherBlocks = {}

local function applyBlock(blockInfo, suppressWarnings)
    if handleErrorsAPI.applyBlock(blockInfo, suppressWarnings) == false then return false end

    if blockTask == nil then
        blockTask = models.model.root:newBlock("Block")
            :setPos(-8, 0, -8)
    end

    for index, value in pairs(otherBlocks) do
        value:setBlock(nil)
    end

    if type(blockInfo.otherBlocks) == "table" then
        for index, value in ipairs(blockInfo.otherBlocks) do
            local offset = value.offset
            local otherBlockName = offset.x .. " " .. offset.y .. " " .. offset.z

            if otherBlocks[otherBlockName] == nil then
                otherBlocks[otherBlockName] = models.model.root:newBlock(otherBlockName)
                    :setPos(-8 + offset.x * 16, offset.y * 16, -8 + offset.z * 16)
            end

            otherBlocks[otherBlockName]:setBlock(value.blockID)
        end
    end

    blockTask:setBlock(blockInfo.blockID)
    return true
end

return applyBlock