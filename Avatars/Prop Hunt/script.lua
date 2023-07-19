local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

----------
-- Data --
----------

local blockInfos = {
    {
        name = "Dirt",
        id = "minecraft:dirt",
        bone = "Block",
        texture = "minecraft:textures/block/dirt.png",
    },
    {
        name = "Cobblestone",
        id = "minecraft:cobblestone",
        bone = "Block",
        texture = "minecraft:textures/block/cobblestone.png",
    },
    {
        name = "Bedrock",
        id = "minecraft:bedrock",
        bone = "Block",
        texture = "minecraft:textures/block/bedrock.png",
    },
    {
        name = "Lantern",
        id = "minecraft:lantern",
        bone = "Lantern",
        texture = "minecraft:textures/block/lantern.png",
    },
    {
        name = "Crafting Table",
        id = "minecraft:crafting_table",
        bone = "Block",
        textures = {
            Bottom = "minecraft:textures/block/oak_planks.png",
            Top = "minecraft:textures/block/crafting_table_top.png",
            North = "minecraft:textures/block/crafting_table_front.png",
            South = "minecraft:textures/block/crafting_table_side.png",
            East = "minecraft:textures/block/crafting_table_side.png",
            West = "minecraft:textures/block/crafting_table_front.png",
        },
    },
    {
        name = "Anvil",
        id = "minecraft:anvil",
        rotate = true,
        bone = "Anvil",
        textures = {
            TopTop = "minecraft:textures/block/anvil_top.png",
            TopBody = "minecraft:textures/block/anvil.png",
            Middle = "minecraft:textures/block/anvil.png",
            LowerMid = "minecraft:textures/block/anvil.png",
            Base = "minecraft:textures/block/anvil.png",
        },
    },
}

----------
-- Vars --
----------

local syncTick = 0

local ticksInSameBlock = 0
local snapMode = "Rounded"
local savedPosition
local snapApplied = false

local snapModeAction
local blockCycleAction

local blockIndex = 1

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

        if snapApplied == false then
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.25, 2, false)
            
            local blockPos
            if snapMode == "Floored" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            elseif snapMode == "Rounded" then
                blockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16 + 0.001, math.floor(pos.z)*16 + 8)
            end
            models.model:setPos(blockPos)
            
            local blockRot
            if blockInfos[blockIndex].rotate then
                blockRot = math.round(player:getRot().y/90) * 90
            end
            models.model:setRot(0, blockRot, 0)
            
            snapApplied = true
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        snapApplied = false
    end

    savedPosition = currentPosition
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

local function toggleSeeker(state)
    seekerEnabled = state
    quickSync()
    printState("Seeker", state)
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

local function toggleBuildMode(state)
    printState("Build Mode", state)
    buildModeEnabled = state
end

local function applyBlock(id)
    -- when flipping between blocks that rotate/don't rotate, unsnap the player to force re-setting
    ticksInSameBlock = 0
    applyModelPos()

    local blockInfo = blockInfos[id]

    for index, value in ipairs(models.model.root:getChildren()) do
        value:setVisible(false)
    end
    models.model.root[blockInfo.bone]:setVisible(true)

    if blockInfo.texture ~= nil then
        for index, value in ipairs(models.model.root[blockInfo.bone]:getChildren()) do
            value:setPrimaryTexture("RESOURCE", blockInfo.texture)
        end
    elseif blockInfo.textures ~= nil then
        for index, value in pairs(blockInfo.textures) do
            models.model.root[blockInfo.bone][index]:setPrimaryTexture("RESOURCE", value)
        end
    end
    
    blockCycleAction:title(blockInfo.name)
    blockCycleAction:item(blockInfo.id)
end

local function cycleBlock()
    blockIndex = blockIndex + 1
    if blockIndex > #blockInfos then blockIndex = 1 end
    applyBlock(blockIndex)
end

-- build mode

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
        :toggleItem("minecraft:dispenser")
		:toggleTitle("Building Mode: Enabled")
		:toggleColor(ENABLED_COLOR)
    buildModeToggleAction:setToggled(buildModeEnabled)

    blockCycleAction = ActionWheelPg1:newAction()
        :item("minecraft:dirt")
        :title("Dirt")
        :onLeftClick(cycleBlock)

    applyBlock(1)
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