local settings = require("settings")

local blockTask
local otherBlocks = {}

local function isValidBlockID(id)
    local function tryId(inputID) return world.newBlock(inputID) end
    return pcall(tryId, id)
end

local function applyBlock(blockInfo, hideWarnings)

    local outputWarnings = true
    if hideWarnings then outputWarnings = false end
    if settings.SUPPRESS_WARNINGS then outputWarnings = false end

    if blockInfo.name == nil
    and outputWarnings
    then
        print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; No 'name'!")
        return false
    end

    if blockInfo.blockID == nil then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "; No 'blockID'!")
        return false
    elseif isValidBlockID(blockInfo.blockID) == false then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, ";", blockInfo.blockID, "is not a valid block ID!")
        return false
    end

    if (blockInfo.rotate)
    and (blockInfo.rotate ~= "Any" and blockInfo.rotate ~= "Limited" and blockInfo.rotate ~= "LimitedFlipWE")
    and outputWarnings
    then
        print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; 'rotate' must be \"Any\", \"Limited\", \"LimitedFlipWE\" or nil.")
        return false
    end

    if type(blockInfo.otherBlocks) == "table" then
        if #blockInfo.otherBlocks < 1
        and outputWarnings
        then
            print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; 'otherBlocks' is empty!")
            return false
        end

        for index, value in ipairs(blockInfo.otherBlocks) do

            if value.offset == nil then
                print("§4Error!\n§cInvalid Block Info!§r\n", value, "; No 'offset'!")
                return false
            elseif type(value.offset) ~= "Vector3" then
                print("§4Error!\n§cInvalid Block Info!§r\n", value, ";", value.offset, "is not a valid Vector3!")
                return false
            end

            if value.blockID == nil then
                print("§4Error!\n§cInvalid Block Info!§r\n", value, "; No 'blockID'")
                return false
            elseif not isValidBlockID(value.blockID) then
                print("§4Error!\n§cInvalid Block Info!§r\n", value, ";", value.blockID, "is not a valid block ID!")
                return false
            end

        end
    end

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