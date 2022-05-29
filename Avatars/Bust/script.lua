-- by TheGoodDude#6142

----------------------
-- Figura Functions --
----------------------

function player_init()
	-- defaults
	armourEnabled = true
	elytraEnabled = true
	bustEnabled = true
	tick = 0

	if data.load("armourEnabled") == "false" then
		armourEnabled = false
	end

	if data.load("elytraEnabled") == "false" then
		elytraEnabled = false
	end

	if data.load("bustEnabled") == "false" then
		bustEnabled = false
	end

	action_wheel.setLeftSize(2)
	action_wheel.setRightSize(1)

	action_wheel.SLOT_1.setTitle("Toggle Bust")
	action_wheel.SLOT_1.setItem("minecraft:melon")
	action_wheel.SLOT_1.setFunction(function() ping.bust( not bustEnabled) end)

	action_wheel.SLOT_2.setTitle("Toggle Armour")
	action_wheel.SLOT_2.setItem("minecraft:netherite_chestplate")
	action_wheel.SLOT_2.setFunction(function() ping.armour( not armourEnabled) end)

	action_wheel.SLOT_3.setTitle("Toggle Elytra")
	action_wheel.SLOT_3.setItem("minecraft:elytra")
	action_wheel.SLOT_3.setFunction(function() ping.elytra( not elytraEnabled) end)
end

function tick()
	tick = tick + 1
	if tick > 200 then
		if client.isHost() then
			ping.sync(armourEnabled, elytraEnabled, bustEnabled)
		end
		tick = 0
	end

	-- show or hide armour
	if armourEnabled then
		for key, value in pairs(armor_model) do
			value.setEnabled(true)
		end
	else
		for key, value in pairs(armor_model) do
			value.setEnabled(false)
		end
	end
	
	-- show or hide elytra
	if elytraEnabled then
		for key, value in pairs(elytra_model) do
			value.setEnabled(true)
		end
	else
		for key, value in pairs(elytra_model) do
			value.setEnabled(false)
		end
	end

	-- show or hide bust
	if (player.getEquipmentItem(5).getType() == "minecraft:air" or player.getEquipmentItem(5).getType() == "minecraft:elytra" or not armor_model.CHESTPLATE.getEnabled()) and bustEnabled then
		model.Body.setEnabled(true)
	else
		model.Body.setEnabled(false)
	end
end

---------------
-- Functions --
---------------

function ping.sync(armourState, elytraState, bustState)
		armourEnabled = armourState
		elytraEnabled = elytraState
		bustEnabled = bustState
end

-- toggle armour
function ping.armour(state)
	data.save("armourEnabled", state)
	log("§bArmour Visibility§f: §e" .. printState(state))
	armourEnabled = state
end

-- togle elytra
function ping.elytra(state)
	data.save("elytraEnabled", state)
	log("§bElytra Visibility§f: §e" .. printState(state))
	elytraEnabled = state
end

function ping.bust(state)
	data.save("bustEnabled", state)
	log("§bBust Visibility§f: §e" .. printState(state))
	bustEnabled = state
end

function printState(state)
	if state then
		return "§aEnabled"
	else
		return "§cDisabled"
	end
end