local blockInfos, defaultBlockInfo = require("blockInfos")
local applyBlock = require("Scripts.applyBlock")

local syncTick = 0

local dataAPI = {}

--synced
dataAPI.snapMode = "Rounded"
dataAPI.seekerEnabled = false
dataAPI.selectedBlockInfo = defaultBlockInfo
dataAPI.blockRot = 0
-- unsynced
dataAPI.buildModeEnabled = false

-- data loading
local storedSnapMode = config:load("SnapMode")
if storedSnapMode ~= nil then
    dataAPI.snapMode = storedSnapMode
end

local storedBlockInfo = config:load("BlockInfo")
if storedBlockInfo ~= nil then
    dataAPI.selectedBlockInfo = storedBlockInfo
end

function pings.sync(snapState, seekerState, selectedBlockState, blockRotState)
    dataAPI.snapMode = snapState
    dataAPI.seekerEnabled = seekerState
    dataAPI.selectedBlockInfo = selectedBlockState
    dataAPI.blockRot = blockRotState

    applyBlock(dataAPI.selectedBlockInfo)
end

-------------------
-- API Functions --
-------------------

function dataAPI.quickSync()
    if not host:isHost() then return end
    pings.sync(dataAPI.snapMode, dataAPI.seekerEnabled, dataAPI.selectedBlockInfo, dataAPI.blockRot)
end

function dataAPI.lazySync()
    syncTick = syncTick + 1
    if syncTick < 100 then return end
    dataAPI.quickSync()
    syncTick = 0
end

return dataAPI