local blockTask

local function isValidBlockID(id)
    local function tryId(inputID) return world.newBlock(inputID) end
    return pcall(tryId, id)
end

local function applyBlock(blockInfo)

    if blockInfo.name == nil then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "; §rhas no 'name'!")
        return
    end

    if isValidBlockID(blockInfo.blockID) == false then
        if blockInfo.blockID then
            print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "; §b" .. blockInfo.blockID .. "§r is not a valid block ID!")
        else
            print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "; No 'blockID'!")
        end
        return
    end

    if (blockInfo.rotate) and (blockInfo.rotate ~= "Any" and blockInfo.rotate ~= "Limited" and blockInfo.rotate ~= "LimitedFlipWE") then
        print("§4Error!\n§cInvalid Block Info!§r\n", blockInfo, "; 'rotate' must be \"Any\", \"Limited\", \"LimitedFlipWE\" or nil.")
        return
    end

    if blockTask == nil then
        blockTask = models.model.root:newBlock(blockInfo.name)
            :setPos(-8, 0, -8)
    end

    blockTask:setBlock(blockInfo.blockID)

end

return applyBlock