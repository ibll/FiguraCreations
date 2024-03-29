local settings = require("settings")
local applyBlock = require("Scripts.applyBlock")

local dataAPI = {}

----------
-- Vars --
----------

local syncTick = 0

--------------
-- API Vars --
--------------

--synced
dataAPI.snapMode = "Rounded"
dataAPI.seekerEnabled = false
dataAPI.selectedBlockInfo = settings.DEFAULT_BLOCK
dataAPI.blockRot = 0
-- unsynced
dataAPI.buildModeEnabled = false
dataAPI.ticksInSameBlock = 0

-- data loading
local storedSnapMode = config:load("SnapMode")
if storedSnapMode ~= nil then
    dataAPI.snapMode = storedSnapMode
end

local storedBlockInfo = config:load("BlockInfo")
if storedBlockInfo ~= nil then
    dataAPI.selectedBlockInfo = storedBlockInfo
end

---------------
-- Functions --
---------------

function pings.sync(snapState, seekerState, selectedBlockState, blockRotState)
    dataAPI.snapMode = snapState
    dataAPI.seekerEnabled = seekerState
    dataAPI.selectedBlockInfo = selectedBlockState
    dataAPI.blockRot = blockRotState

    applyBlock(dataAPI.selectedBlockInfo, true)
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