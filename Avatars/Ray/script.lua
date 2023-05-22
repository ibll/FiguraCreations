function events.entity_init()
    RootBone = models.Ray.root
    HeadBone = RootBone.Main
    HeadBoneAnchor = RootBone.MainAnchor
    TiltBone = HeadBone.Inner.Moving

    vanilla_model.PLAYER:setVisible(false)
    vanilla_model.ARMOR:setVisible(false)
    vanilla_model.ELYTRA:setVisible(false)

    Tick = 0

	-- action wheel constants
	ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
	DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)
end

function events.tick()
    -- Blink.tick()
    RayTick()
end

function events.render(delta, context)
    -- Blink.render(delta)
    RayRender(delta, context)
end

function RayTick()
end

function RayRender(delta, context)
    if context == "FIRST_PERSON" then return end

    -- rot tracking
    local headYaw = player:getRot(delta).y
	local bodyYawRaw = player:getBodyYaw(delta)
    BodyYaw = (bodyYawRaw - 360 * math.floor( bodyYawRaw / (360))) + math.floor(headYaw/360) * 360
	if math.abs(BodyYaw - headYaw) >= 180 then
		if BodyYaw > headYaw then
			BodyYaw = BodyYaw - 360
		elseif BodyYaw < headYaw then
			BodyYaw = BodyYaw + 360
		end
	end

    TiltRot = (-player:getRot(delta).x - HeadBone:getRot().x)
    EyeRot = (BodyYaw - headYaw)/2
    PlayerVel = vectors.rotateAroundAxis(BodyYaw,player:getVelocity(),vec(0, 1, 0))*75

    IdleOffset = vectors.vec3(
        math.cos(world.getTime(delta)/20),
        math.sin(world.getTime(delta)/25),
        math.sin(world.getTime(delta)/30)
    )

    function LeftUp()
        LeftUp = animations.Ray.LeftUp
        LeftArm = RootBone.LeftArm
        if player:getItem(2).id == "minecraft:air" then
            LeftArm.LeftUpperArm:setOffsetRot((IdleOffset*5)+(vec(PlayerVel.z/2, 0, math.abs(PlayerVel.z))))
            LeftArm.LeftUpperArm.LeftLowerArm:setOffsetRot(IdleOffset*5)
            LeftArm.LeftUpperArm.LeftLowerArm.LeftHand.LeftFingers:setOffsetRot(0, IdleOffset.y*-20, 0)
            LeftArm.LeftUpperArm.LeftLowerArm.LeftHand.LeftThumb:setOffsetRot(0, 0, IdleOffset.z*-20)

            if (LeftUp:getPlayState() == "PLAYING") then return end
            LeftUp:play()
        else
            if not LeftUp:getPlayState() == "PLAYING" then return end
            LeftUp:stop()
        end
    end
    LeftUp()

    function RightUp()
        RightUp = animations.Ray.RightUp
        RightArm = RootBone.RightArm
        if player:getItem(1).id == "minecraft:air" then
            RightArm.RightUpperArm:setOffsetRot((IdleOffset*5)+(vec(PlayerVel.z/2, 0, -math.abs(PlayerVel.z))))
            RightArm.RightUpperArm.RightLowerArm:setOffsetRot(IdleOffset*-5)
            RightArm.RightUpperArm.RightLowerArm.RightHand.RightFingers:setOffsetRot(0, IdleOffset.y*20, 0)
            RightArm.RightUpperArm.RightLowerArm.RightHand.RightThumb:setOffsetRot(0, 0, IdleOffset.z*20)

            if (RightUp:getPlayState() == "PLAYING") then return end
            RightUp:play()
        else
            if not (RightUp:getPlayState() == "PLAYING") then return end
            RightUp:stop()
        end
    end
    RightUp()

    -- When swimming/flying, player model does not face where the camera is looking by default.
    if player:getBoundingBox().y <= 1 then HeadXRotExtraDegrees = 90 else HeadXRotExtraDegrees = 0 end
    HeadBone:setRot(math.lerp(HeadBone:getRot(),vec(math.clamp(-PlayerVel.z, -25, 100) + HeadXRotExtraDegrees, 0, PlayerVel.x),delta))

    RootBone:setPos(IdleOffset)
    nameplate.ENTITY:setPos(IdleOffset/32)

    TiltBone:setRot(math.lerp(TiltBone:getRot(),vec(math.clamp(TiltRot,-25,25),0,0),delta))
    TiltBone.Eye:setRot(math.lerp(TiltBone.Eye:getRot(),vec(0,math.clamp(EyeRot,-15,15),0),delta))
end