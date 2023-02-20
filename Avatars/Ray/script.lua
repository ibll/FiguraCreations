-- Blink = require("blink")

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

    function LeftUp()
        LeftUp = animations.Ray.LeftUp
        LeftArm = RootBone.LeftArm
        if player:getItem(2).id == "minecraft:air" then
            if (LeftUp:getPlayState() == "PLAYING") then return end
            --LeftArm:parentType("BODY")
            LeftUp:play()
        else
            if not LeftUp:getPlayState() == "PLAYING" then return end
            --LeftArm:parentType("LEFT_ARM")
            LeftUp:stop()
        end
    end
    LeftUp()

    function RightUp()
        if player:getItem(1).id == "minecraft:air" then
            if (animations.Ray.RightUp:getPlayState() == "PLAYING") then return end
            animations.Ray.RightUp:play()
        else
            if not (animations.Ray.RightUp:getPlayState() == "PLAYING") then return end
            animations.Ray.RightUp:stop()
        end
    end
    RightUp()

    TiltRot = (-player:getRot(delta).x - HeadBone:getRot().x)
    EyeRot = (player:getBodyYaw(delta) - player:getRot(delta).y)/2
    PlayerVel = vectors.rotateAroundAxis(player:getBodyYaw(),player:getVelocity(),vec(0, 1, 0))*75

    -- When swimming/flying, player model does not face where the camera is looking by default.
    if player:getBoundingBox().y <= 1 then HeadXRotExtraDegrees = 90 else HeadXRotExtraDegrees = 0 end
    HeadBone:setRot(math.lerp(HeadBone:getRot(),vec(math.clamp(-PlayerVel.z, -25, 100) + HeadXRotExtraDegrees, 0, PlayerVel.x),delta))

    
    TiltBone:setRot(math.lerp(TiltBone:getRot(),vec(math.clamp(TiltRot,-25,25),0,0),delta))
    TiltBone.Eye:setRot(math.lerp(TiltBone.Eye:getRot(),vec(0,math.clamp(EyeRot,-15,15),0),delta))
end