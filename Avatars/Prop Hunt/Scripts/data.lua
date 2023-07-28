local blockInfos, defaultBlockInfo = require("blockInfos")

local syncTick = 0

local dataAPI = {}

--synced
dataAPI.snapMode = "Rounded"
dataAPI.seekerEnabled = false
dataAPI.selectedBlockInfo = defaultBlockInfo
dataAPI.blockRot = nil
-- unsynced
dataAPI.buildModeEnabled = false

-- data loading
local storedSnapMode = config:load("SnapMode")
if storedSnapMode ~= nil then
    dataAPI.snapMode = storedSnapMode
end

function pings.sync(snapState, seekerState, selectedBlockState, blockRotState)
    dataAPI.snapMode = snapState
    dataAPI.seekerEnabled = seekerState
    dataAPI.selectedBlockInfo = selectedBlockState
end

-------------------
-- API Functions --
-------------------

function dataAPI.quickSync()
    if not host:isHost() then return end
    pings.sync(dataAPI.snapMode, dataAPI.seekerEnabled, dataAPI.selectedBlockInfo, currentRot)
end

function dataAPI.lazySync()
    syncTick = syncTick + 1
    if syncTick < 200 then return end
    dataAPI.quickSync()
    syncTick = 0
end

return dataAPI