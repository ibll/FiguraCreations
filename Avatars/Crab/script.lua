-- by TheGoodDude#6142

----------------------
-- Figura Functions --
----------------------

WALK_ANIMATION = animations.model.walkin
FALL_ANIMATION = animations.model.fall

function events.entity_init()
	LastHeldItem = "minecraft:air"
	HeldItemTimer = 5

	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)

	nameplate.ENTITY:setPos(0, -1, 0)
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

	Item = player:getItem(1).id

	if Item ~= LastHeldItem then
		HeldItemTimer = 5
		LastHeldItem = Item
		if Item == "minecraft:air" then
			models.model.RIGHT_ARM:setVisible(false)
		end
	end

	if HeldItemTimer == 0 then
		models.model.RIGHT_ARM:setVisible(true)
	end

	HeldItemTimer = HeldItemTimer - 1
end

function events.render(delta, context)
	--HeadRot = player:getRot()
	HeadRot = vec(player:getRot().x, -(player:getBodyYaw() - player:getRot().y))
	if HeadRot.x < 0 then
		models.model.HEAD.BASE.EYES:setRot(-HeadRot.x/3, -HeadRot.y * 0.75, 0)
	else
		models.model.HEAD.BASE.EYES:setRot(HeadRot.x/2, -HeadRot.y * 0.75, 0)
	end

	if HeadRot.x < 0 then
		--models.model.HEAD.BASE.EYES:setRot(-HeadRot.x/3, 0 - HeadRot.y * 0.75, 0)
	else
		--models.model.HEAD.BASE.EYES:setRot( HeadRot.x/2, 0 - HeadRot.y * 0.75, 0)
	end

	if HeadRot.x < 0 then
		models.model.HEAD.BASE:setRot(HeadRot.x, 0, 0)
	end
end