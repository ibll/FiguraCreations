local blockInfos = require("blockInfos")

local dataAPI = {}

--synced
dataAPI.snapMode = "Rounded"
dataAPI.seekerEnabled = false
dataAPI.selectedBlockInfo = blockInfos[1]
dataAPI.blockRot = nil
-- unsynced
dataAPI.buildModeEnabled = false

function pings.sync(snapState, seekerState, selectedBlockState, blockRotState)
    dataAPI.snapMode = snapState
    dataAPI.seekerEnabled = seekerState
    dataAPI.selectedBlockInfo = selectedBlockState
end

function dataAPI.quickSync()
    if not host:isHost() then return end
    pings.sync(dataAPI.snapMode, dataAPI.seekerEnabled, dataAPI.selectedBlockInfo, currentRot)
end

local syncTick = 0
function dataAPI.lazySync()
    syncTick = syncTick + 1
    if syncTick < 200 then return end
    dataAPI.quickSync()
    syncTick = 0
end

return dataAPI