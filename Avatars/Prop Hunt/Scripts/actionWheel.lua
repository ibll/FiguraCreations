local dataAPI = require("Scripts.data")
local blockInfos = require("blockInfos")

local actionWheelAPI = {}

local snapModeAction
local blockCycleAction

local variantPages = {}

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
    dataAPI.seekerEnabled = state
    dataAPI.quickSync()
    printState("Seeker", state)
end

local function cycleSnapMode()
    if dataAPI.snapMode == "Rounded" then
        dataAPI.snapMode = "Floored"
        snapModeAction:title("Snap Mode: Floored")
        snapModeAction:item("minecraft:black_carpet")
    elseif dataAPI.snapMode == "Floored" then
        dataAPI.snapMode = "Disabled"
        snapModeAction:title("Snap Mode: Disabled")
        snapModeAction:item("minecraft:barrier")
    else 
        dataAPI.snapMode = "Rounded"
        snapModeAction:title("Snap Mode: Rounded")
        snapModeAction:item("minecraft:ender_pearl")
    end
    config:save("SnapMode", dataAPI.snapMode)
    dataAPI.quickSync()
    printState("Snapping",  dataAPI.snapMode)
end

local function toggleBuildMode(state)
    printState("Build Mode", state)
    dataAPI.buildModeEnabled = state
end

local function blockPageAction(blockInfo)
    if blockInfo.variants ~= nil then
        if variantPages[blockInfo.name] == nil then
            local variantPage = action_wheel:newPage(blockInfo.name)

            variantPage:newAction()
                :title("Back")
                :item('minecraft:barrier')
                :onLeftClick(function() action_wheel:setPage(actionWheelAPI.mainPage) end)

            for variantKey, variantValue in ipairs(blockInfo.variants) do
                local action = variantPage:newAction()
                    :item(variantValue.id)
                    :title(variantValue.name)
                    :onLeftClick(function() blockPageAction(variantValue) end)
            end

            variantPages[blockInfo.name] = variantPage
        end

        action_wheel:setPage(variantPages[blockInfo.name])
    else
        pings.applyBlock(blockInfo)
        action_wheel:setPage(actionWheelAPI.mainPage)
    end
end

---------
-- API --
---------

function actionWheelAPI.generateMainPage()
    local mainPage = action_wheel:newPage("Functions")

    local seekerToggleAction = mainPage:newAction()
        :item("minecraft:grass_block")
        :title("Current Mode: Prop")
        :color(DISABLED_COLOR)
        :onToggle(toggleSeeker)
        :toggleItem("minecraft:netherite_sword")
        :toggleTitle("Current Mode: Seeker")
        :toggleColor(ENABLED_COLOR)
    seekerToggleAction:setToggled(dataAPI.seekerEnabled)

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
    buildModeToggleAction:setToggled(dataAPI.buildModeEnabled)

    blockCycleAction = mainPage:newAction()
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

    for key, value in ipairs(blockInfos) do
        local blockSelectAction = blockPage:newAction()
            :title(value.name)
            :onLeftClick(function() blockPageAction(value) end)

        if value.variants == nil then
            blockSelectAction:item(value.id)
        else
            blockSelectAction:item(value.variants[1].id)
        end
    end

    actionWheelAPI.blockPage = blockPage
end

function actionWheelAPI.setSelectedBlock(title, id)
    blockCycleAction:title(title)
    blockCycleAction:item(id)
end

return actionWheelAPI