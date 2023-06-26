-- Ibll Vanilla Accessories v1.0
-- For wrangling vanilla armour/elytra/capes

--- Format:
---
--- {
---
---     head = {
---         netheriteOnly = {}
---     },
---     body = {
---         notOnBack = {},
---         onBackOnly = {}
---     },
---     legs = {},
---     feet = {}
--- }
---
--- Place model parts in all but the parent table!
---
--- For example, ear parts placed in the `head` table
--- will automatically hide when any helmet is equiped!
---
--- Another: parts on the chest/stomach placed in
--- `body.notOnBack` will disappear when a chestplate
--- is equipped, but not with elytra!
---@alias IbllVA.PartLocationTable table

----------
-- VARS --
----------

local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local savedConditionalModelParts

local armorEnabled
local elytraEnabled

local armorToggleAction
local elytraToggleAction

local tick = 0

-----------
-- PINGS --
-----------

function pings.sync(armourState, elytraState)
    armorEnabled = armourState
    elytraEnabled = elytraState
    vanilla_model.ARMOR:setVisible(armorEnabled)
    vanilla_model.ELYTRA:setVisible(elytraEnabled)
end

local function quickSync()
    pings.sync(armorEnabled, elytraEnabled)
end

---------------
-- FUNCTIONS --
---------------

local function printState(string, state)
    local function fancyState(value)
        if value == true or value == false then
            if value then return "§aEnabled" else return "§cDisabled" end
        else
            return "§b" .. value
        end
    end
    print(string .. ": " .. (fancyState(state)))
end

local function toggleArmor()
    armorEnabled = not armorEnabled
    config:save("ArmorEnabled", armorEnabled)
    armorToggleAction:setToggled(armorEnabled)
    quickSync()
    printState("Armour Visibility", armorEnabled)
end

local function toggleElytra()
    elytraEnabled = not elytraEnabled
    config:save("ElytraEnabled", elytraEnabled)
    elytraToggleAction:setToggled(elytraEnabled)
    quickSync()
    printState("Elytra Visibility", elytraEnabled)
end

---------
-- API --
---------

local IbllVA_API = {}

---@param conditionalModelParts? IbllVA.PartLocationTable
---@param defaultPage? boolean
---@param returnPage? Page
---@return Page
function IbllVA_API.init(conditionalModelParts, defaultPage, returnPage)
    savedConditionalModelParts = conditionalModelParts

    -- config loading
    armorEnabled = false
    if config:load("ArmorEnabled") == true then armorEnabled = true end
    elytraEnabled = false
    if config:load("ElytraEnabled") == true then elytraEnabled = true end
    quickSync()

    -- action wheel
    local functionsPage = action_wheel:newPage("Functions")
    if defaultPage == true then action_wheel:setPage(functionsPage) end

    armorToggleAction = functionsPage:newAction()
        :item("minecraft:netherite_chestplate")
        :title("Enable Armour")
        :color(DISABLED_COLOR)
        :onToggle(toggleArmor)
        :toggleTitle("Disable Armour")
        :toggleColor(ENABLED_COLOR)
    armorToggleAction:setToggled(armorEnabled)

    elytraToggleAction = functionsPage:newAction()
        :item("minecraft:elytra")
        :title("Enable Elytra")
        :color(DISABLED_COLOR)
        :onToggle(toggleElytra)
        :toggleTitle("Disable Elytra")
        :toggleColor(ENABLED_COLOR)
    elytraToggleAction:setToggled(elytraEnabled)

    if returnPage then
        functionsPage:newAction(8)
            :title("Back")
            :item('minecraft:barrier')
            :onLeftClick(function() action_wheel:setPage(returnPage) end)
    end

    return functionsPage
end

function IbllVA_API.lazySync()
    tick = tick + 1
    if tick < 200 then return end
    if not host:isHost() then return end

    quickSync()
    tick = 0
end

function IbllVA_API.conditionalModelParts()
    if savedConditionalModelParts == nil then return end

    local function helmetClipping()
        if savedConditionalModelParts.head == nil then return end

        local function modelVisibility(bool)
            for index, value in ipairs(savedConditionalModelParts.head) do
                value:setVisible(bool)
            end
        end

        local function netheriteBlockedModelVisibility(bool)
            if savedConditionalModelParts.head.netheriteOnly == nil then return end
            for index, value in ipairs(savedConditionalModelParts.head.netheriteOnly) do
                value:setVisible(bool)
            end
        end

        local slotId = player:getItem(6).id

        if vanilla_model.HELMET:getVisible() == false or slotId == "minecraft:air" then
            modelVisibility(true)
            netheriteBlockedModelVisibility(true)
        else
            modelVisibility(false)
            netheriteBlockedModelVisibility(slotId ~= "minecraft:netherite_helmet")
        end
    end
    helmetClipping()

    local function bodyClipping()
        if savedConditionalModelParts.body == nil then return end

        local function frontSidesModelVisibiilty(bool)
            if savedConditionalModelParts.body.notOnBack == nil then return end
            for index, value in ipairs(savedConditionalModelParts.body.notOnBack) do
                value:setVisible(bool)
            end
        end

        local function backpackModelVisibility(bool)
            if savedConditionalModelParts.body.onBackOnly == nil then return end
            for index, value in ipairs(savedConditionalModelParts.body.onBackOnly) do
                value:setVisible(bool)
            end
        end

        local function wraparoundModelVisibility(bool)
            for index, value in ipairs(savedConditionalModelParts.body) do
                value:setVisible(bool)
            end
        end

        local slotId = player:getItem(5).id

        if slotId == "minecraft:air" then
            frontSidesModelVisibiilty(true)
            backpackModelVisibility(true)
            wraparoundModelVisibility(true)
            return
        end

        local backClear
        local frontSidesClear

        if vanilla_model.ELYTRA:getVisible() == true and slotId == "minecraft:elytra" then backClear = false else backClear = true end
        if vanilla_model.CHESTPLATE:getVisible() == true and slotId ~= "minecraft:elytra" then frontSidesClear = false else frontSidesClear = true end

        wraparoundModelVisibility(backClear and frontSidesClear)
        backpackModelVisibility(backClear)
        frontSidesModelVisibiilty(frontSidesClear)
    end
    bodyClipping()

    local function leggingClipping()
        if savedConditionalModelParts.legs == nil then return end
        local function modelVisibility(bool)
            for index, value in ipairs(savedConditionalModelParts.legs) do
                value:setVisible(bool)
            end
        end
    
        local slotId = player:getItem(4).id
        if vanilla_model.LEGGINGS:getVisible() == false or slotId == "minecraft:air" then return modelVisibility(true) end
        modelVisibility(false)
    end
    leggingClipping()

    local function bootClipping()
        if savedConditionalModelParts.feet == nil then return end
        local function modelVisibility(bool)
            for index, value in ipairs(savedConditionalModelParts.feet) do
                value:setVisible(bool)
            end
            models.Steampunk.LeftLeg.LeftShoe:setVisible(bool)
            models.Steampunk.RightLeg.RightShoe:setVisible(bool)
        end
    
        local slotId = player:getItem(3).id
        if vanilla_model.BOOTS:getVisible() == false or slotId == "minecraft:air" then return modelVisibility(true) end
        modelVisibility(false)
    end
    bootClipping()
    
    -- Add other functions below!
end

return IbllVA_API