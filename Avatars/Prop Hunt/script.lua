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
    {
        name = "Wool",
        variants = {
            {
                name = "White Wool",
                id = "minecraft:white_wool",
                bone = "Block",
                texture = "minecraft:textures/block/white_wool.png"
            },
            {
                name = "Light Gray Wool",
                id = "minecraft:light_gray_wool",
                bone = "Block",
                texture = "minecraft:textures/block/light_gray_wool.png"
            },
            {
                name = "Gray Wool",
                id = "minecraft:gray_wool",
                bone = "Block",
                texture = "minecraft:textures/block/gray_wool.png"
            },
            {
                name = "Black Wool",
                id = "minecraft:black_wool",
                bone = "Block",
                texture = "minecraft:textures/block/black_wool.png"
            },
            {
                name = "Brown Wool",
                id = "minecraft:brown_wool",
                bone = "Block",
                texture = "minecraft:textures/block/brown_wool.png"
            },
            {
                name = "Red Wool",
                id = "minecraft:red_wool",
                bone = "Block",
                texture = "minecraft:textures/block/red_wool.png"
            },
            {
                name = "Orange Wool",
                id = "minecraft:orange_wool",
                bone = "Block",
                texture = "minecraft:textures/block/orange_wool.png"
            },
            {
                name = "Yellow Wool",
                id = "minecraft:yellow_wool",
                bone = "Block",
                texture = "minecraft:textures/block/yellow_wool.png"
            },
            {
                name = "Lime Wool",
                id = "minecraft:lime_wool",
                bone = "Block",
                texture = "minecraft:textures/block/lime_wool.png"
            },
            {
                name = "Green Wool",
                id = "minecraft:green_wool",
                bone = "Block",
                texture = "minecraft:textures/block/green_wool.png"
            },
            {
                name = "Cyan Wool",
                id = "minecraft:cyan_wool",
                bone = "Block",
                texture = "minecraft:textures/block/cyan_wool.png"
            },
            {
                name = "Light Blue Wool",
                id = "minecraft:light_blue_wool",
                bone = "Block",
                texture = "minecraft:textures/block/light_blue_wool.png"
            },
            {
                name = "Blue Wool",
                id = "minecraft:blue_wool",
                bone = "Block",
                texture = "minecraft:textures/block/blue_wool.png"
            },
            {
                name = "Purple Wool",
                id = "minecraft:purple_wool",
                bone = "Block",
                texture = "minecraft:textures/block/purple_wool.png"
            },
            {
                name = "Magenta Wool",
                id = "minecraft:magenta_wool",
                bone = "Block",
                texture = "minecraft:textures/block/magenta_wool.png"
            },
            {
                name = "Pink Wool",
                id = "minecraft:pink_wool",
                bone = "Block",
                texture = "minecraft:textures/block/pink_wool.png"
            }
        }
    }
}

----------
-- Vars --
----------

local syncTick = 0

local ticksInSameBlock = 0
local snapMode = "Rounded"
local savedPosition
local snapApplied = false
local selectedBlockInfo = blockInfos[1]

local mainPage
local blockPage
local variantPages = {}
local snapModeAction
local blockCycleAction

local seekerEnabled = false
local seekerApplied = false

local buildModeEnabled = false

---------------
-- Functions --
---------------

function pings.sync(snapState, seekerState, selectedBlockState, blockRotState)
    snapMode = snapState
    seekerEnabled = seekerState
    selectedBlockInfo = selectedBlockState

    models.model:setRot(blockRotState)
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
            if selectedBlockInfo.rotate then
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

local function applyBlock(blockInfo, noResnap)
    -- when flipping between blocks that rotate/don't rotate, unsnap the player to force re-setting
    if noResnap ~= true then ticksInSameBlock = 0 end
    applyModelPos()

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

    selectedBlockInfo = blockInfo
end

function pings.applyBlock(blockInfo)
    applyBlock(blockInfo)
end

local function blockActionExecute(blockInfo)
    if blockInfo.variants ~= nil then
        if variantPages[blockInfo.name] == nil then
            local variantPage = action_wheel:newPage(blockInfo.name)

            variantPage:newAction()
                :title("Back")
                :item('minecraft:barrier')
                :onLeftClick(function() action_wheel:setPage(mainPage) end)

            for variantKey, variantValue in ipairs(blockInfo.variants) do
                local action = variantPage:newAction()
                    :item(variantValue.id)
                    :title(variantValue.name)
                    :onLeftClick(function() blockActionExecute(variantValue) end)
            end

            variantPages[blockInfo.name] = variantPage
        end

        action_wheel:setPage(variantPages[blockInfo.name])
    else
        pings.applyBlock(blockInfo)
        action_wheel:setPage(mainPage)
    end
end

local function generateBlockPage()
    blockPage = action_wheel:newPage("Blocks")
    
    blockPage:newAction()
        :title("Back")
        :item('minecraft:barrier')
        :onLeftClick(function() action_wheel:setPage(mainPage) end)

    for key, value in ipairs(blockInfos) do
        local blockSelectAction = blockPage:newAction()
            :title(value.name)
            :onLeftClick(function() blockActionExecute(value) end)

        if value.variants == nil then
            blockSelectAction:item(value.id)
        else
            blockSelectAction:item(value.variants[1].id)
        end
    end
end

function pings.place(pos)
    local copy = models.model.root:copy("Block")
    models.model.World:addChild(copy)
    copy:setVisible(true)
    copy:setPos(pos)
end

local function quickSync()
    if not host:isHost() then return end

    local currentRot = models.model:getRot()

    pings.sync(snapMode, seekerEnabled, selectedBlockInfo, currentRot)
    applyBlock(selectedBlockInfo, true)
end

local function lazySync()
    syncTick = syncTick + 1
    if syncTick < 200 then return end
    if not host:isHost() then return end
    quickSync()
    syncTick = 0
end

------------
-- Figura --
------------

function events.entity_init()
    -- setup
    setVisibleAsProp(true)

    -- action wheel
	mainPage = action_wheel:newPage("Functions")
	action_wheel:setPage(mainPage)

    local seekerToggleAction = mainPage:newAction()
		:item("minecraft:grass_block")
		:title("Current Mode: Prop")
		:color(DISABLED_COLOR)
		:onToggle(toggleSeeker)
        :toggleItem("minecraft:netherite_sword")
		:toggleTitle("Current Mode: Seeker")
		:toggleColor(ENABLED_COLOR)
    seekerToggleAction:setToggled(seekerEnabled)

    snapModeAction = mainPage:newAction()
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :onLeftClick(cycleSnapMode)

    local buildModeToggleAction = mainPage:newAction()
		:item("minecraft:diamond_shovel")
		:title("Building Mode: Disabled")
		:color(DISABLED_COLOR)
		:onToggle(toggleBuildMode)
        :toggleItem("minecraft:dispenser")
		:toggleTitle("Building Mode: Enabled")
		:toggleColor(ENABLED_COLOR)
    buildModeToggleAction:setToggled(buildModeEnabled)

    blockCycleAction = mainPage:newAction()
        :item("minecraft:dirt")
        :title("Dirt")
        :onLeftClick(function() action_wheel:setPage(blockPage) end)

    generateBlockPage()
    applyBlock(selectedBlockInfo)
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