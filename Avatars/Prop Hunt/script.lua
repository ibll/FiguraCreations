local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

----------
-- Vars --
----------

local syncTick = 0

local ticksInSameBlock = 0
local snapMode = "Rounded"
local savedPosition
local soundEffectPlayed = false

local snapModeAction

local seekerEnabled = false
local seekerApplied = false

local buildModeEnabled = false

---------------
-- Functions --
---------------

-- syncing

function pings.sync(snapState, seekerState)
    snapMode = snapState
    seekerEnabled = seekerState
end

local function quickSync()
    pings.sync(snapMode, seekerEnabled)
end

local function lazySync()
    syncTick = syncTick + 1
    if syncTick < 200 then return end
    if not host:isHost() then return end
    quickSync()
    syncTick = 0
end

-- action wheel helpers

local function printState(string, state)
    function State(value)
        if value == true or value == false then
            if value then return "§aEnabled" else return "§cDisabled" end
        else
            return "§b" .. value
        end
    end
    print(string .. ": " .. (State(state)))
end

local function cycleSnapMode()
    if snapMode == "Rounded" then
        snapMode = "Floored"
        snapModeAction:title("Snap Mode: Floored")
        snapModeAction:item("minecraft:black_carpet")
    elseif snapMode == "Floored" then
        snapMode = "Disabled"
        snapModeAction:title("Snap Mode: Disabled")
        snapModeAction:item("minecraft:barrier")
    else 
        snapMode = "Rounded"
        snapModeAction:title("Snap Mode: Rounded")
        snapModeAction:item("minecraft:ender_pearl")
    end
    config:save("SnapMode", snapMode)
    quickSync()
    printState("Snapping",  snapMode)
end

local function toggleSeeker(state)
	seekerEnabled = state
	quickSync()
	printState("Seeker", state)
end

-- movement handling

local function setVisibleAsProp(state)
    seekerApplied = not state

    vanilla_model.ALL:setVisible(not state)
    nameplate.ENTITY:setVisible(not state)
    models.model.root:setVisible(state)

    if state == true then ShadowSize = 0 else ShadowSize = 0.5 end
    renderer:setShadowRadius(ShadowSize)
end

local function applyModelPos() 
    local pos = player:getPos()
    local currentPosition

    if snapMode == "Floored" then
        currentPosition = pos:floor()
    else
        currentPosition = vec(math.floor(pos.x), math.round(pos.y), math.floor(pos.z))
    end

    if savedPosition == currentPosition then
        ticksInSameBlock = ticksInSameBlock + 1
    else
        ticksInSameBlock = 0
    end

    if ticksInSameBlock >= 20 and snapMode ~= "Disabled" then
        models.model:setParentType("WORLD")
        
        local blockPos
        if snapMode == "Floored" then
            blockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16 + 0.01, math.floor(pos.z)*16 + 8)
        elseif snapMode == "Rounded" then
            blockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16 + 0.01, math.floor(pos.z)*16 + 8)
        end
        models.model:setPos(blockPos)

        if soundEffectPlayed == false then
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.25, 2, false)
            soundEffectPlayed = true
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        soundEffectPlayed = false
    end

    savedPosition = currentPosition
end

-- build mode
local function toggleBuildMode(state)
    printState("Build Mode", state)
    buildModeEnabled = state
end

function pings.place(pos)
    Copy = models.model.root:copy("Block")
    models.model.World:addChild(Copy)
    Copy:setVisible(true)
    Copy:setPos(pos)
end

------------
-- Figura --
------------

function events.entity_init()
    -- setup
    setVisibleAsProp(true)

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

    local seekerToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:grass_block")
		:title("Current Mode: Prop")
		:color(DISABLED_COLOR)
		:onToggle(toggleSeeker)
        :toggleItem("minecraft:netherite_sword")
		:toggleTitle("Current Mode: Seeker")
		:toggleColor(ENABLED_COLOR)
    seekerToggleAction:setToggled(seekerEnabled)

    snapModeAction = ActionWheelPg1:newAction()
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :onLeftClick(cycleSnapMode)

    local buildModeToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:diamond_shovel")
		:title("Building Mode: Disabled")
		:color(DISABLED_COLOR)
		:onToggle(toggleBuildMode)
        :toggleItem("minecraft:lantern")
		:toggleTitle("Building Mode: Enabled")
		:toggleColor(ENABLED_COLOR)
    buildModeToggleAction:setToggled(buildModeEnabled)


    local blockCycleAction = ActionWheelPg1:newAction()
        :item("minecraft:dirt")
        :title("Dirt")
        :onLeftClick(CycleBlock)

    function CycleBlock()
        local texture = textures:fromVanilla()
        local model = models.model.root.Blocks:setPrimaryTexture(texture)
    end
end

function events.tick()
    if seekerEnabled then
        if not seekerApplied then setVisibleAsProp(false) end
    else
        if seekerApplied then setVisibleAsProp(true) end
        applyModelPos()
    end
    lazySync()
end

function events.MOUSE_PRESS(button, state, modifiers)
    if buildModeEnabled ~= true then return end
    if state ~= 1 then return end

    local targetedBlock, hitPos, side = player:getTargetedBlock(true, 6)

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

    pings.place(pos)
end