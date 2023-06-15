-- Art, model, and animations by TheGoodDude#6142
-- Eyes blinking and movement by Fran#3814
	-- Grandpa Scout#8739 for blink lerp

----------------------
-- Figura Functions --
----------------------

function player_init()
	-- disable vanilla model
	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	-- defaults
	LastEmote = "dab"
	Risen = false

	-- tools
	AnimationList = animations:getAnimations()

	-- wheel, keybinds, and animations
	repeatEmoteKey = keybind.newKey("Repeat Last Emote", "1")

	action_wheel.SLOT_2.setTitle("Wave")
	action_wheel.SLOT_2.setItem("minecraft:paper")
	action_wheel.SLOT_2.setFunction(function() ping.emote("wave") end)

	action_wheel.SLOT_3.setTitle("Rise")
	action_wheel.SLOT_3.setItem("minecraft:scaffolding")
	action_wheel.SLOT_3.setFunction(function() ping.emote("rise") end)

	action_wheel.SLOT_4.setTitle("Dab")
	action_wheel.SLOT_4.setItem("minecraft:painting")
	action_wheel.SLOT_4.setFunction(function() ping.emote("dab") end)
	--animation.dab.setBlendTime(0)

	action_wheel.setLeftSize(1)

	action_wheel.SLOT_5.setTitle("Toggle Rise")
	action_wheel.SLOT_5.setItem("minecraft:netherite_chestplate")
	action_wheel.SLOT_5.setFunction(function() ping.rise( not risen) end)
end

function tick()
	-- tick functions
	blink()
	emotes()

	-- check if any animations are playing
	animationPlaying = false
	for key, value in ipairs(animationList) do
		if animation[value].getPlayState() ~= "STOPPED" then
			animationPlaying = true
		end
	end

	-- toggle rise
	if risen and animation["rise"].getPlayState() == "STOPPED" then
		animation["rise"].play()
		model.RightLeg.setParentType("Torso")
		model.LeftLeg.setParentType("Torso")
		model.RightLeg.setPos({-2, 12 ,0})
		model.LeftLeg.setPos({2, 12 ,0})
	end

	if not risen and animation["rise"].getPlayState() == "ENDED" then
		animation["fall"].play()
		animation["rise"].stop()
		model.RightLeg.setParentType("RightLeg")
		model.LeftLeg.setParentType("LeftLeg")
		model.RightLeg.setPos({0, 0 ,0})
		model.LeftLeg.setPos({0, 0 ,0})
	end
end

function render(delta)
	-- eyes render
	eyesAnim(delta)
end

---------------------
-- Blink Functions --
---------------------

-- blink tick
function blink()
	-- tick
	blinkTick = blinkTick + 1
  
	-- if is already blinking
	if isBlinking then
		-- increase blink frame
		if lblinkFrame < 4 then
			lblinkFrame = lblinkFrame + 1
		end
  
		if rblinkFrame < 4 then
			rblinkFrame = rblinkFrame + 1
		end
  
		-- restart blink if frame is greater than 4
		if lblinkFrame >= 4 and rblinkFrame >= 4 then
			isBlinking = false
			blinkTick  = 0
		end
	-- check blink
	elseif blinkTick >= BLINK_MIN_DELAY and math.random() < BLINK_CHANCE or blinkTick >= BLINK_MAX_DELAY then
		-- dummy blink
		if client.isHost() and math.random() < DUMMY_BLINK_CHANCE then
			ping.blink(math.random() < 0.5, risen)
		-- normal blink
		else
			isBlinking  = true
			lblinkFrame = 0
			rblinkFrame = 0
		end
	end
end
  
-- eyes animation
function eyesAnim(delta)
	local eyes = model.Head.Eyes
  
	-- eyeballs
  
	-- get rot
	local rotX = (player.getBodyYaw() - player.getRot().y) / 45
	local rotY = player.getRot().x / 135
  
	-- apply
	eyes.Eyes.setPos(math.lerp(eyes.Eyes.getPos(), vectors.of({0, math.clamp(rotY, -0.45, 0.45), 0}), delta))
	eyes.Left_Iris.setPos(math.lerp(eyes.Left_Iris.getPos(), vectors.of({math.clamp(rotX, -0.15, 1), rotY, 0}), delta))
	eyes.Right_Iris.setPos(math.lerp(eyes.Right_Iris.getPos(), vectors.of({math.clamp(rotX, -1, 0.15), rotY, 0}), delta))
  
	-- blink
  
	-- blink uv
	local x = math.clamp(lblinkFrame + delta, 0, 4)
	local lblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))
  
	local x = math.clamp(rblinkFrame + delta, 0, 4)
	local rblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))
  
	-- set blink uv
	eyes.Left_Eyelid.setUV({0, lblink / TEXTURE_HEIGHT})
	eyes.Right_Eyelid.setUV({0, rblink / TEXTURE_HEIGHT})
end

---------------
-- Functions --
---------------

-- main emotes function
function emotes()
	-- switch from leg_down to breathe
	if animation.leg_down.getPlayState() == "ENDED" then
		animation.breathe.play()
		animation.leg_down.stop()
	end

	-- stop emoting when sprinting
	if player.isSprinting() and animation["rise"].getPlayState == "STOPPED" then
		animation.stopAll()
	end

	if animation["rise"].getPlayState() == "STOPPED" then
		nameplate.ENTITY.setPos({0, 0.2, 0})
	else
		nameplate.ENTITY.setPos({0, 1, 0})
	end

	if repeatEmoteKey.wasPressed() then
		ping.emote(lastEmote)
		repeatEmoteKey.reset()
	end
end

function repeatLast()
	ping.emote(lastEmote)
end

function ping.emote(name)
	lastEmote = name
	animation.stopAll()
	if name == "blink" then
		ping.blink(math.random() < 0.5)
	else
		animation[name].play()
	end
end

function ping.blink(arg, riseState)
	-- enable blinking
	isBlinking = true

	-- dummy blink
	lblinkFrame = arg and -DUMMY_BLINK_DELAY or 0
	rblinkFrame = not arg and -DUMMY_BLINK_DELAY or 0

	-- periodic rise sync
	if riseState ~= nil then
		risen = riseState
	end
end

-- toggle rise
function ping.rise(state)
	risen = state
end