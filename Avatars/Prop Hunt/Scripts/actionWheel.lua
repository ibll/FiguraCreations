local dataAPI = require("Scripts.data")
local blockInfos = require("blockInfos")

local ENABLED_COLOR = vectors.hexToRGB("#A6E3A1")
local ENABLED_COLOR_HOVER = vectors.hexToRGB("#4Af43A")
local DISABLED_COLOR = vectors.hexToRGB("#F38bA8")
local DISABLED_COLOR_HOVER = vectors.hexToRGB("#DD0845")

local seekerToggleAction
local snapModeAction
local blockChangeAction

local storedVariantPages = {}

local actionWheelAPI = {}

local populatePageBlocks

---------------
-- Functions --
---------------

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

local function isValidBlockID(id)
    local function tryId(inputID) return world.newItem(inputID) end
    return pcall(tryId, id)
end

local function toggleSeeker(state)
    dataAPI.seekerEnabled = not state
    dataAPI.quickSync()
    printState("Prop Mode", not state)

    if state then
        seekerToggleAction:hoverColor(ENABLED_COLOR_HOVER)
    else
        seekerToggleAction:hoverColor(DISABLED_COLOR_HOVER)
    end
end

local function applySnapModeActionStyle()
    if dataAPI.snapMode == "Floored" then
        snapModeAction
        :item("minecraft:black_carpet")
        :title("Snap Mode: Floored")
        :color(ENABLED_COLOR)
        :hoverColor(ENABLED_COLOR_HOVER)
    elseif dataAPI.snapMode == "Disabled" then
        snapModeAction
        :item("minecraft:barrier")
        :title("Snap Mode: Disabled")
        :color(DISABLED_COLOR)
        :hoverColor(DISABLED_COLOR_HOVER)
    else
        snapModeAction
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :color(ENABLED_COLOR)
        :hoverColor(ENABLED_COLOR_HOVER)
    end
end

local function cycleSnapMode()
    if dataAPI.snapMode == "Rounded" then
        dataAPI.snapMode = "Floored"
    elseif dataAPI.snapMode == "Floored" then
        dataAPI.snapMode = "Disabled"
    else 
        dataAPI.snapMode = "Rounded"
    end
    applySnapModeActionStyle()

    config:save("SnapMode", dataAPI.snapMode)
    dataAPI.quickSync()
    printState("Snapping",  dataAPI.snapMode)
end

local function toggleBuildMode(state)
    printState("Build Mode", state)
    dataAPI.buildModeEnabled = state
end

local function blockPageAction(blockInfo, returnPage)
    if blockInfo.variants ~= nil then
        if blockInfo.name == nil then
            print("§4Error!\n§cInvalid Block Info!§r\n",  blockInfo, "must have a 'name'!")
            return
        end

        if blockInfo.uniquePageID == nil then
            print("§4Error!\n§cInvalid Block Info!§r\n",  blockInfo, "must have a 'uniquePageID'!")
            return
        end

        if storedVariantPages[blockInfo.uniquePageID] == nil then
            local variantPage = action_wheel:newPage(blockInfo.uniquePageID)

            variantPage:newAction()
                :title("Back")
                :item('minecraft:barrier')
                :onLeftClick(function() action_wheel:setPage(returnPage) end)
                :onRightClick(function() action_wheel:setPage(actionWheelAPI.mainPage) end)

            populatePageBlocks(variantPage, blockInfo.variants)
            storedVariantPages[blockInfo.uniquePageID] = variantPage
        end

        action_wheel:setPage(storedVariantPages[blockInfo.uniquePageID])
    else
        pings.applyBlock(blockInfo)
        action_wheel:setPage(actionWheelAPI.mainPage)
        if blockInfo.name then
            host:setActionbar(blockInfo.name)
        end
    end
end

function populatePageBlocks(page, blockInfo)
    for key, value in ipairs(blockInfo) do
        local action = page:newAction()
            :title(value.name)
            :onLeftClick(function() blockPageAction(value, page) end)

        if value.blockID then
            if isValidBlockID(value.blockID) then
                action:item(value.blockID)
            else
                print("§4Error!\n§cInvalid Block Info!§r\n`§b" .. value.blockID .. "§r` is not a valid block id!")
            end

        elseif value.variants and value.variants[1] and value.variants[1].blockID ~= nil then
            if isValidBlockID(value.variants[1].blockID) then
                action:item(value.variants[1].blockID)
            else
                print("§4Error!\n§cInvalid Block Info!§r\n`§b" .. value.variaints[1].blockID .. "§r` is not a valid block id!")
            end

        end

        if value.rightClick then
            print(value.rightClick)
            local rightClickTexture = textures["Click"]
            action:texture(rightClickTexture)
            action:onRightClick(function() blockPageAction(value.rightClick, page) end)
        end
    end
end

-------------------
-- API Functions --
-------------------

function actionWheelAPI.generateMainPage()
    local mainPage = action_wheel:newPage("Functions")

    seekerToggleAction = mainPage:newAction()
        :item("minecraft:netherite_sword")
        :title("Current Mode: Seeker")
        :color(DISABLED_COLOR)
        :onToggle(toggleSeeker)
        :toggleItem("minecraft:grass_block")
        :toggleTitle("Current Mode: Prop")
        :toggleColor(ENABLED_COLOR)
    seekerToggleAction:setToggled(not dataAPI.seekerEnabled)

    if dataAPI.seekerEnabled then
        seekerToggleAction:hoverColor(DISABLED_COLOR_HOVER)
    else
        seekerToggleAction:hoverColor(ENABLED_COLOR_HOVER)
    end

    snapModeAction = mainPage:newAction()
        :onLeftClick(cycleSnapMode)
    applySnapModeActionStyle()

    -- local buildModeToggleAction = mainPage:newAction()
    --     :item("minecraft:diamond_shovel")
    --     :title("Building Mode: Disabled")
    --     :color(DISABLED_COLOR)
    --     :onToggle(toggleBuildMode)
    --     :toggleItem("minecraft:dispenser")
    --     :toggleTitle("Building Mode: Enabled")
    --     :toggleColor(ENABLED_COLOR)
    -- buildModeToggleAction:setToggled(dataAPI.buildModeEnabled)

    blockChangeAction = mainPage:newAction()
        :item("minecraft:dirt")
        :title("Dirt")
        :onLeftClick(function() action_wheel:setPage(actionWheelAPI.blockPage) end)

    actionWheelAPI.mainPage = mainPage
end

function actionWheelAPI.generateBlockPage()
    local blockPage = action_wheel:newPage("Blocks")

    blockPage:newAction()
        :title("Back")
        :item('minecraft:barrier')
        :onLeftClick(function() action_wheel:setPage(actionWheelAPI.mainPage) end)

    populatePageBlocks(blockPage, blockInfos)

    actionWheelAPI.blockPage = blockPage
end

function actionWheelAPI.setSelectedBlock(title, blockID)
    blockChangeAction:title(title)
    if isValidBlockID(blockID) then
        blockChangeAction:item(blockID)
    else
        blockChangeAction:item()
    end
end

return actionWheelAPI