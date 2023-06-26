-- action wheel constants
local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local tick = 0

local armorEnabled
local elytraEnabled

local armorToggleAction
local elytraToggleAction

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

local function quickSync()
    pings.sync(armorEnabled, elytraEnabled)
end

local function modifyVisibility()
    vanilla_model.ARMOR:setVisible(armorEnabled)
    vanilla_model.ELYTRA:setVisible(elytraEnabled)
end

-----------
-- PINGS --
-----------

function pings.sync(armourState, elytraState)
    armorEnabled = armourState
    elytraEnabled = elytraState
    modifyVisibility()
end

---------
-- API --
---------

local basicsAPI = {}

function basicsAPI.entity_init()
    -- config loading
    armorEnabled = false
    if config:load("ArmorEnabled") == true then armorEnabled = true end
    elytraEnabled = false
    if config:load("ElytraEnabled") == true then elytraEnabled = true end

    -- action wheel
    local functionsWheel = action_wheel:newPage("Functions")
    action_wheel:setPage(functionsWheel)

    armorToggleAction = functionsWheel:newAction()
        :item("minecraft:netherite_chestplate")
        :title("Enable Armour")
        :color(DISABLED_COLOR)
        :onToggle(toggleArmor)
        :toggleTitle("Disable Armour")
        :toggleColor(ENABLED_COLOR)
    armorToggleAction:setToggled(armorEnabled)

    elytraToggleAction = functionsWheel:newAction()
        :item("minecraft:elytra")
        :title("Enable Elytra")
        :color(DISABLED_COLOR)
        :onToggle(toggleElytra)
        :toggleTitle("Disable Elytra")
        :toggleColor(ENABLED_COLOR)
    elytraToggleAction:setToggled(elytraEnabled)

    quickSync()
end

function basicsAPI.tick()
    tick = tick + 1
    if tick < 200 then return end
    if not host:isHost() then return end

    quickSync()
    tick = 0
end

function basicsAPI.render()
    local function bustClipping()
        local function modelVisibility(bool)
            models.Steampunk.Body.Bust:setVisible(bool)
        end

        if player:getItem(5).id == "minecraft:air" then return modelVisibility(true) end
        if player:getItem(5).id == "minecraft:elytra" then return modelVisibility(true) end
        if not vanilla_model.CHESTPLATE:getVisible() then return modelVisibility(true) end
        modelVisibility(false)
    end
    bustClipping()

    local function bootClipping()
        local function modelVisibility(bool)
            models.Steampunk.LeftLeg.LeftShoe:setVisible(bool)
            models.Steampunk.RightLeg.RightShoe:setVisible(bool)
        end
    
        if player:getItem(3).id == "minecraft:air" then return modelVisibility(true) end
        if not vanilla_model.BOOTS:getVisible() then return modelVisibility(true) end
        modelVisibility(false)
    end
    bootClipping()

    -- Add other functions below!
end

return basicsAPI