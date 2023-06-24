ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

----------------------
-- Figura Functions --
----------------------

function events.ENTITY_INIT()
	-- disable vanilla model
	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	-- anims
	RISE_ANIMATION = animations.Horsey.rise
	FALL_ANIMATION = animations.Horsey.fall

	-- defaults
	LastEmote = "dab"
	Risen = false

	-- wheel, keybinds, and animations
	RepeatEmoteKey = keybinds:newKeybind("Repeat Last Emote", "key.keyboard.m")
		:setOnPress(RepeatLast)

	ActionWheelPg1 = action_wheel:newPage("Emotes")
	action_wheel:setPage(ActionWheelPg1)

	WaveAction = ActionWheelPg1:newAction()
		:item("minecraft:paper")
		:title("Wave")
		:onLeftClick(function() pings.emote("wave") end)

	DabAction = ActionWheelPg1:newAction()
		:item("minecraft:painting")
		:title("Wave")
		:onLeftClick(function() pings.emote("dab") end)

	RiseToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:scaffolding")
		:title("Rise")
		:color(DISABLED_COLOR)
		:onToggle(ToggleRise)
		:toggleTitle("Lower")
		:toggleColor(ENABLED_COLOR)
    RiseToggleAction:setToggled(HideEnabled)
end

function events.TICK()
	if player:isSneaking() then
		if Risen then
			models.Horsey.LowerHalf:setPos(0, 0, 6)
		else
			models.Horsey.LowerHalf:setPos(0, 0, 4)
		end
	else
		models.Horsey.LowerHalf:setPos(0, 0, 0)
	end
	-- tick functions
	-- Blink()
	Emotes()
end

function events.RENDER(delta)
	if RISE_ANIMATION:getPlayState() == "PLAYING" then
		Height = math.lerp(0, 1, RISE_ANIMATION:getTime()/RISE_ANIMATION:getLength())
	else
		FallTime = FALL_ANIMATION:getTime()
		if FallTime == 0 then Height = 0 return end
		Height = 1 - math.lerp(0, 1, FALL_ANIMATION:getTime()/FALL_ANIMATION:getLength())
	end
---@diagnostic disable-next-line: undefined-field
	renderer:setOffsetCameraPivot(0, Height, 0)
	-- eyes render
	-- eyesAnim(delta)
end

---------------
-- Functions --
---------------

function ToggleRise(state)
	print("§bRisen§f: §e" .. PrintState(state))
	Risen = state
	RiseToggleAction:setToggled(Risen)
	Sync()
end

function PrintState(state)
	if state then
		return "§aEnabled"
	else
		return "§cDisabled"
	end
end

function Sync()
	pings.sync(Risen)
end

function pings.sync(RisenState)
	Risen = RisenState
end

-- main emotes function
function Emotes()
	if Risen then
		if RISE_ANIMATION:getPlayState() == "STOPPED" then
			RISE_ANIMATION:setSpeed(1)
			RISE_ANIMATION:loop("HOLD")
			RISE_ANIMATION:play()
			FALL_ANIMATION:stop()
		end
	else
		if math.abs(RISE_ANIMATION:getTime()) >= RISE_ANIMATION:getLength() then
			RISE_ANIMATION:stop()
			FALL_ANIMATION:play()
		end
	end

	if player:isSprinting() then
		animations.Horsey[LastEmote]:stop()
	end

	if RISE_ANIMATION:getPlayState() == "STOPPED"  and FALL_ANIMATION:getTime() >= FALL_ANIMATION:getLength() then
		nameplate.ENTITY:setPos(0, 0.2, 0)
	else
		nameplate.ENTITY:setPos(0, 1, 0)
	end
end

function RepeatLast()
	pings.emote(LastEmote)
end

function pings.emote(name)
	if LastEmote == name and animations.Horsey[name]:getPlayState() == "PLAYING" and animations.Horsey[name]:getTime() < animations.Horsey[name]:getLength()then
		goto cancelemote
	end
	animations.Horsey[LastEmote]:stop()
	animations.Horsey[name]:play()
	LastEmote = name
	::cancelemote::
end

-- toggle rise
function pings.rise(state)
	Risen = state
end