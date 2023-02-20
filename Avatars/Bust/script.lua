models:setPrimaryTexture("SKIN")

function events.entity_init()
    Tick = 0

	-- action wheel constants
	ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
	DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

    -- config loading
    BustEnabled = false
    if config:load("BustEnabled") == true then BustEnabled = true end
    ArmorEnabled = false
    if config:load("ArmorEnabled") == true then ArmorEnabled = true end
	ElytraEnabled = false
    if config:load("ElytraEnabled") == true then ElytraEnabled = true end

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

	ArmorToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:netherite_chestplate")
		:title("Enable Armour")
		:color(DISABLED_COLOR)
		:onToggle(ToggleArmor)
		:toggleTitle("Disable Armour")
		:toggleColor(ENABLED_COLOR)
    ArmorToggleAction:setToggled(ArmorEnabled)

	ElytraToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:elytra")
		:title("Enable Elytra")
		:color(DISABLED_COLOR)
		:onToggle(ToggleElytra)
		:toggleTitle("Disable Elytra")
		:toggleColor(ENABLED_COLOR)
    ElytraToggleAction:setToggled(ElytraEnabled)

    BustToggleAction = ActionWheelPg1:newAction()
        :item("minecraft:melon")
        :title("Enable Bust")
        :color(DISABLED_COLOR)
        :onToggle(ToggleBust)
        :toggleTitle("Disable Bust")
        :toggleColor(ENABLED_COLOR)
    BustToggleAction:setToggled(BustEnabled)

    Sync()
end

function events.tick()
    function SyncTick()
        Tick = Tick + 1
        if Tick < 200 then return end
        if not host:isHost() then return end
        Sync()
        Tick = 0
    end
    SyncTick()
end

function events.render()
    function ShowBust()
		local BUST = models.Bust.Body
        if not BustEnabled then return BUST:setVisible(false) end
		if player:getItem(5).id == "minecraft:air" then return BUST:setVisible(true) end
		if player:getItem(5).id == "minecraft:elytra" then return BUST:setVisible(true) end
		if not vanilla_model.CHESTPLATE:getVisible() then return BUST:setVisible(true) end
		BUST:setVisible(false)
	end
	ShowBust()
end

---------------
-- Functions --
---------------

function ModifyVisibility()
    vanilla_model.ARMOR:setVisible(ArmorEnabled)
    vanilla_model.ELYTRA:setVisible(ElytraEnabled)
end

function PrintState(string, state)
    function State(bool)
        if bool then return "§aEnabled" else return "§cDisabled" end
    end
    print(string .. ": " .. (State(state)))
end

function Sync()
    pings.sync(ArmorEnabled, ElytraEnabled, BustEnabled)
end

function ToggleArmor()
    ArmorEnabled = not ArmorEnabled
    config:save("ArmorEnabled", ArmorEnabled)
    Sync()
    PrintState("Armour Visibility", ArmorEnabled)
end
function ToggleElytra()
    ElytraEnabled = not ElytraEnabled
    config:save("ElytraEnabled", ElytraEnabled)
    Sync()
    PrintState("Elytra Visibility", ElytraEnabled)
end
function ToggleBust()
    BustEnabled = not BustEnabled
    config:save("BustEnabled", BustEnabled)
    Sync()
    PrintState("Bust Visibility", BustEnabled)
end

--------------------
-- Ping Functions --
--------------------

function pings.sync(armourState, elytraState, bustState)
    ArmorEnabled = armourState
    ElytraEnabled = elytraState
    BustEnabled = bustState

    ModifyVisibility()
end