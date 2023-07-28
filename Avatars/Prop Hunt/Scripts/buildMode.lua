local dataAPI = require("Scripts.data")

local buildModeAPI = {}

-------------------
-- API Functions --
-------------------

function pings.place(pos)
    local copy = models.model.root:copy("PlacedBlock")
    models.model.World:addChild(copy)
    copy:setVisible(true)
    copy:setPos(pos)
end

function buildModeAPI.place(pos)
    pings.place(pos)
end


function buildModeAPI.click()
    if dataAPI.buildModeEnabled ~= true then return end

    local targetedBlock, hitPos, side = host:getPickBlock()

    if targetedBlock:getID() == "minecraft:air" then return end

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

    buildModeAPI.place(pos)
end

return buildModeAPI