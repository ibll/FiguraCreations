Swing = require("swing")
Eyes = require("eyes")

----------------------
-- Figura Functions --
----------------------

function events.entity_init()
	Tick = 0

	-- action wheel constants
	ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
	DISABLED_COLOR = vectors.hexToRGB("#f38ba8")
	-- feather vars
	FeatherTimer = 0
	-- jumping constants
	JumpKey = keybinds:fromVanilla("key.jump")
	-- jumping vars
	IsJumping = false
	-- anim constants
	SHRINK_ANIM = animations.player_model.shrink
	FEATHER_SHRINK_ANIM = animations.feather_model.shrink

	vanilla_model.INNER_LAYER:setVisible(false)
	vanilla_model.OUTER_LAYER:setVisible(false)
	vanilla_model.CAPE:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	-- config loading
	ArmorEnabled = false
	ParticlesEnabled = false 
	if config:load("ArmorEnabled") == true then ArmorEnabled = true end
	if config:load("ParticlesEnabled") == true then ParticlesEnabled = true end

	-- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

	ArmorToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:netherite_chestplate")
		:title("Enable Armour")
		:color(DISABLED_COLOR)
		:onToggle(pings.toggleArmor)
		:toggleTitle("Disable Armour")
		:toggleColor(ENABLED_COLOR)
	ArmorToggleAction:setToggled(ArmorEnabled)
	ParticleToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:nether_star")
		:title("Enable Particles")
		:color(DISABLED_COLOR)
		:onToggle(pings.toggleParticles)
		:toggleTitle("Disable Particles")
		:toggleColor(ENABLED_COLOR)
	ParticleToggleAction:setToggled(ParticlesEnabled)

	Swing.head(models.player_model.Head.ExtendedHair, 180, {-120, 65, -30, 30, -30, 30})
	Swing.head(models.player_model.Head.ExtendedHair.Hair1, 180, {-120, 65, -30, 30, -30, 30}, models.player_model.Head.ExtendedHair, 1)
	Swing.head(models.player_model.Head.ExtendedHair.Hair1.Hair2, 180, {-120, 65, -30, 30, -30, 30}, models.player_model.Head.ExtendedHair, 2)

	Swing.head(models.feather_model.GoldenFeather.Feather1, 180)
	Swing.head(models.feather_model.GoldenFeather.Feather1.Feather2, 180, nil, models.feather_model.GoldenFeather.Feather1, 1)
	Swing.head(models.feather_model.GoldenFeather.Feather1.Feather2.Feather3, 180, nil, models.feather_model.GoldenFeather.Feather1, 2)

	models.feather_model.GoldenFeather:setLight(vectors.vec2(15, 15))
end

function events.tick()
	Tick = Tick + 1
	if Tick > 200 then
		if host:isHost() then
			pings.sync(ArmorEnabled, ElytraEnabled)
		end
		Tick = 0
	end
	
	if JumpKey:isPressed() and IsJumping == false then
		pings.jumpPressed()
	end

	if IsJumping and player:getVelocity().y == 0 then
		IsJumping = false
	end

	Eyes.tick()
	VanillaParts()
end

function events.render(delta, context)
	if context == "RENDER" then Eyes.render(delta) end
	if ParticlesEnabled then Particles() end
	CustomParts()
end

---------------------
-- Model Functions --
---------------------

function VanillaParts()
	-- show or hide armor
	if ArmorEnabled and animations.player_model.shrink:getPlayState() == "STOPPED" then
		vanilla_model.ARMOR:setVisible(true)
	else
		vanilla_model.ARMOR:setVisible(false)
	end
end

function CustomParts()
	-- show or hide model parts depending if animating, armor enabled, or if item equipped

	function ShowHairSwoosh()
		local HAIR_SWOOSH = models.player_model.Head.TopHair.Swoosh
		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then return HAIR_SWOOSH:setVisible(false) end
		if player:getItem(6).id == "minecraft:air" then return HAIR_SWOOSH:setVisible(true) end
		if not vanilla_model.HELMET:getVisible() then return HAIR_SWOOSH:setVisible(true) end
		HAIR_SWOOSH:setVisible(false)
	end
	ShowHairSwoosh()

	function ShowBust()
		local BUST = models.player_model.Body.Bust
		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then return BUST:setVisible(false) end
		if player:getItem(5).id == "minecraft:air" then return BUST:setVisible(true) end
		if player:getItem(5).id == "minecraft:elytra" then return BUST:setVisible(true) end
		if not vanilla_model.CHESTPLATE:getVisible() then return BUST:setVisible(true) end
		BUST:setVisible(false)
	end
	ShowBust()

	-- Hair Colour
	if IsJumping then
		models.player_model.Head.ExtendedHair:setUV(16/128, 0)
		models.player_model.Head.TopHair:setUV(0, 16/64)
	else
		models.player_model.Head.ExtendedHair:setUV(0, 0)
		models.player_model.Head.TopHair:setUV(0, 0)
	end

	-- Golden Feather
	if player:getPose() == "FALL_FLYING" then
		if SHRINK_ANIM:getPlayState() == "STOPPED" then
			SHRINK_ANIM:setSpeed(1)
			SHRINK_ANIM:loop("HOLD")
			SHRINK_ANIM:play()

			FEATHER_SHRINK_ANIM:setSpeed(1)
			FEATHER_SHRINK_ANIM:loop("HOLD")
			FEATHER_SHRINK_ANIM:play()
		end

		-- Flicker red when falling too far down
		if (player:getRot().x > 45) then
			FeatherTimer = FeatherTimer + 1
			if FeatherTimer % 2 ~= 0 then
				if models.feather_model.GoldenFeather:getColor()[1] ~= 1 then
					models.feather_model.GoldenFeather:setColor(1, 1, 1)
				else
					models.feather_model.GoldenFeather:setColor(2, 0.5, 0.5)
				end
			end
		else
			models.feather_model.GoldenFeather:setColor(1, 1, 1)
			FeatherTimer = 0
		end

		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then
			models.player_model:setVisible(false)
		end

	else

		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then
		--if animations.player_model.shrink:getPlayState() == "ENDED" then
			SHRINK_ANIM:stop()
		

			FEATHER_SHRINK_ANIM:stop()
		
		end
		if not models.player_model.Head:getVisible() then
			models.player_model:setVisible(true)
		end

	end

	if animations.player_model.shrink:getPlayState() == "STOPPED" then
		models.feather_model.GoldenFeather:setVisible(false)
	else
		models.feather_model.GoldenFeather:setVisible(true)
	end
end

function Particles()
	if renderer:isFirstPerson() then return end
	if math.abs(player:getVelocity():length()) <= 0.225 then return end

	if player:getPose() ~= "FALL_FLYING" then
		if IsJumping then
			HandParticleColor = {131/255, 221/255, 235/255}
			FootParticleColor = {39/255, 117/255, 211/255}
		else
			HandParticleColor = {225/255, 114/255, 78/255}
			FootParticleColor = {202/255, 53/255, 37/255}
		end

		SpawnParticle(models.player_model.RightArm:partToWorldMatrix():apply(0, -10, 0), HandParticleColor)
		SpawnParticle(models.player_model.LeftArm:partToWorldMatrix():apply(0, -10, 0), HandParticleColor)
		SpawnParticle(models.player_model.RightLeg:partToWorldMatrix():apply(0, -10, 0), FootParticleColor)
		SpawnParticle(models.player_model.LeftLeg:partToWorldMatrix():apply(0, -10, 0), FootParticleColor)
	else
		if models.feather_model.GoldenFeather:getColor()[1] ~= 1 then
			SpawnParticle(models.feather_model.GoldenFeather:partToWorldMatrix():apply(0, 0, 0), {255/255, 96/255, 95/255})
		else
			SpawnParticle(models.feather_model.GoldenFeather:partToWorldMatrix():apply(0, 0, 0), {255/255, 255/255, 95/255})
		end
	end

end

--------------------
-- Ping Functions --
--------------------

function pings.jumpPressed()
	IsJumping = true
end

function pings.toggleArmor(state)
	config:save("ArmorEnabled", state)
	print("§bArmour Visibility§f: §e" .. PrintState(state))
	ArmorEnabled = state
end

function pings.toggleParticles(state)
	config:save("ParticlesEnabled", state)
	print("§bParticle Visibility§f: §e" .. PrintState(state))
	ParticlesEnabled = state
end

function pings.sync(armourState, elytraState)
    ArmorEnabled = armourState
    ElytraEnabled = elytraState
end

----------------------
-- Helper Functions --
----------------------

function PrintState(state)
	if state then
		return "§aEnabled"
	else
		return "§cDisabled"
	end
end

function SpawnParticle(pos, color)
    particles:newParticle("minecraft:dust " .. color[1] .. " " .. color[2] .. " " .. color[3] .. " " .. "1.0", pos, player:getVelocity():length() * 2)
end