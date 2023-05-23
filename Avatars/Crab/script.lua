----------------------
-- Figura Functions --
----------------------

WALK_ANIMATION = animations.model.walkin
FALL_ANIMATION = animations.model.fall
HIDE_ANIMATION = animations.model.hide
UNHIDE_ANIMATION = animations.model.unhide

ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

function events.entity_init()
	LastHeldItem = "minecraft:air"
	HeldItemTimer = 5

	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	nameplate.ENTITY:setPivot(0, 1, 0)

    -- config loading
    HideEnabled = false

	-- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

	HideToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:nautilus_shell")
		:title("Hide")
		:color(DISABLED_COLOR)
		:onToggle(ToggleHide)
		:toggleTitle("Stop Hiding")
		:toggleColor(ENABLED_COLOR)
    HideToggleAction:setToggled(HideEnabled)

end

function events.tick()
	if player:getPose() == "STANDING" then
		if WALK_ANIMATION:getPlayState() ~= "PLAYING" then
			WALK_ANIMATION:play()
		end

		-- stop leg pedalling when jumping
		if player:getVelocity().y ~= 0 then
			WALK_ANIMATION:setSpeed(1)
		else
			WALK_ANIMATION:setSpeed(player:getVelocity():length() * 10)
		end	
	else
		if WALK_ANIMATION:getPlayState() ~= "STOPPED" then
			WALK_ANIMATION:stop()
		end
	end

	if player:getVelocity().y <= 0 then
		FALL_ANIMATION:stop()
	else
		FALL_ANIMATION:play()
	end

	if player:getVelocity():length() >= 0.1 and HideEnabled then
		ToggleHide(false)
	end
end

function events.render(delta, context)
	if context == "FIRST_PERSON" then
		models.model.RIGHT_ARM:setVisible(false)
	else
		models.model.RIGHT_ARM:setVisible(true)
	end

	local headBodyOffset = (player:getRot().y - player:getBodyYaw() + 180) % 360 - 180

	HeadRot = vec(player:getRot().x, headBodyOffset)

	if HeadRot.x < 0 then
		models.model.HEAD.BASE.EYES:setRot(-HeadRot.x/3, -HeadRot.y * 0.75, 0)
	else
		models.model.HEAD.BASE.EYES:setRot(HeadRot.x/2, -HeadRot.y * 0.75, 0)
	end

	if HeadRot.x < 0 then
		models.model.HEAD.BASE:setRot(HeadRot.x, 0, 0)
	end

	if HideEnabled then
		if HIDE_ANIMATION:getPlayState() == "STOPPED" then
			HIDE_ANIMATION:setSpeed(1)
			HIDE_ANIMATION:loop("HOLD")
			HIDE_ANIMATION:play()
			UNHIDE_ANIMATION:stop()
		end
	else
		if math.abs(HIDE_ANIMATION:getTime()) >= HIDE_ANIMATION:getLength() then
			HIDE_ANIMATION:stop()
			UNHIDE_ANIMATION:play()
		end
	end

	if math.abs(HIDE_ANIMATION:getTime()) >= HIDE_ANIMATION:getLength() and HideEnabled then
		SetBodyVisibility(false)
	else
		SetBodyVisibility(true)
	end

	if HIDE_ANIMATION:getPlayState() == "PLAYING" then
		vanilla_model.HELD_ITEMS:setVisible(false)
	else
		vanilla_model.HELD_ITEMS:setVisible(true)
	end

end

function SetBodyVisibility(state)
	models.model.MIMIC_TORSO.INNER:setVisible(state)
	models.model.HEAD:setVisible(state)
	models.model.RIGHT_ARM:setVisible(state)
	models.model.LEFT_ARM:setVisible(state)
	models.model.LEFT_CRAWLERS:setVisible(state)
	models.model.RIGHT_CRAWLERS:setVisible(state)
end

function ToggleHide(state)
	print("§bHidden§f: §e" .. PrintState(state))
	HideEnabled = state
	HideToggleAction:setToggled(HideEnabled)
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
	pings.sync(HideEnabled)
end

function pings.sync(hideState)
	HideEnabled = hideState
end