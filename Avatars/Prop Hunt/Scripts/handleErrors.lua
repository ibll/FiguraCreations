local settings = require("settings")

---------------
-- Functions --
---------------

local function isValidBlockID(id)
    local function tryId(inputID) return world.newBlock(inputID) end
    return pcall(tryId, id)
end

-------------------
-- API Functions --
-------------------

local handleErrorsAPI = {}

function handleErrorsAPI.applyBlock(blockInfo, suppressWarnings)
    local outputWarnings = true
    if suppressWarnings == false then outputWarnings = false end
    if settings.suppressWarnings == false then outputWarnings = false end

    if blockInfo.name == nil
    and outputWarnings
    then
        print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; Should have a 'name'!")
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
        print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; 'rotate' should be \"Any\", \"Limited\", \"LimitedFlipWE\" or nil.")
        return false
    end

    if type(blockInfo.otherBlocks) == "table" then
        if #blockInfo.otherBlocks < 1
        and outputWarnings
        then
            print("§6Warning!\n§eImproper Block Info!§r\n", blockInfo, "; 'otherBlocks' should not be empty!")
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
end

function handleErrorsAPI.blockPageActionWithGroups(blockInfo, suppressWarnings)
    local outputWarnings = true
    if suppressWarnings == false then outputWarnings = false end
    if settings.suppressWarnings == false then outputWarnings = false end

    if blockInfo.name == nil
    and outputWarnings
    then
        print("§6Warning!\n§eImproper Block Info!§r\n",  blockInfo, "should have a 'name'!")
        return false
    end

    if blockInfo.uniquePageID == nil then
        print("§4Error!\n§cInvalid Block Info!§r\n",  blockInfo, "must have a 'uniquePageID'!")
        return false
    end
end

return handleErrorsAPI