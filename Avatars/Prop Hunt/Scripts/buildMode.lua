local dataAPI = require("Scripts.data")

local buildModeAPI = {}

-------------------
-- API Functions --
-------------------

function pings.place(pos)
    models.model.World:newPart("PlaceForBlock"):newBlock("PlacedBlock")
        :setBlock(dataAPI.selectedBlockInfo.blockID)
        :setVisible(true)
        :setPos(pos)
end

function buildModeAPI.place(pos)
    pings.place(pos)
end


function buildModeAPI.click()
    if dataAPI.buildModeEnabled ~= true then return end

    local targetedBlock, hitPos, side = host:getPickBlock()

    if targetedBlock:getID() == "minecraft:air" then return end

    local pos = targetedBlock:getPos()*16
    pos = vec(pos.x, pos.y + 0.01, pos.z)

    local positionOffsetVectors = {
        up = vec(0, 16, 0),
        down = vec(0, -16, 0),
        north = vec(0, 0, -16),
        south = vec(0, 0, 16),
        east = vec(16, 0, 0),
        west = vec(-16, 0, 0),
    }
    
    pos = pos:add(positionOffsetVectors[side])

    buildModeAPI.place(pos)
end

return buildModeAPI