local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local rootBone
local headBone
local tiltBone
local headBoneAnchor

local tick

local function rayRender(delta, context)
    if context == "FIRST_PERSON" then return end

    local tiltRot = (-player:getRot(delta).x - headBone:getRot().x)
    local headBodyOffset = (player:getRot().y - player:getBodyYaw() + 180) % 360 - 180
    local eyeRot = -headBodyOffset/2
    local playerVel = vectors.rotateAroundAxis(player:getBodyYaw(delta),player:getVelocity(),vec(0, 1, 0))*75

    local idleOffset = vectors.vec3(
        math.cos(world.getTime(delta)/20),
        math.sin(world.getTime(delta)/25),
        math.sin(world.getTime(delta)/30)
    )

    local function leftUp()
        local leftUpAnim = animations.Ray.LeftUp
        local leftArm = rootBone.LeftArm

        if player:getItem(2).id == "minecraft:air" then
            leftArm.LeftUpperArm:setOffsetRot((idleOffset*5)+(vec(playerVel.z/2, 0, math.abs(playerVel.z))))
            leftArm.LeftUpperArm.LeftLowerArm:setOffsetRot(idleOffset*5)
            leftArm.LeftUpperArm.LeftLowerArm.LeftHand.LeftFingers:setOffsetRot(0, idleOffset.y*-20, 0)
            leftArm.LeftUpperArm.LeftLowerArm.LeftHand.LeftThumb:setOffsetRot(0, 0, idleOffset.z*-20)

            if (leftUpAnim:getPlayState() == "PLAYING") then return end
            leftUpAnim:play()
        else
            if not leftUpAnim:getPlayState() == "PLAYING" then return end
            leftUpAnim:stop()
        end
    end
    leftUp()

    local function rightUp()
        local rightUpAnim = animations.Ray.RightUp
        local rightArm = rootBone.RightArm
        if player:getItem(1).id == "minecraft:air" then
            rightArm.RightUpperArm:setOffsetRot((idleOffset*5)+(vec(playerVel.z/2, 0, -math.abs(playerVel.z))))
            rightArm.RightUpperArm.RightLowerArm:setOffsetRot(idleOffset*-5)
            rightArm.RightUpperArm.RightLowerArm.RightHand.RightFingers:setOffsetRot(0, idleOffset.y*20, 0)
            rightArm.RightUpperArm.RightLowerArm.RightHand.RightThumb:setOffsetRot(0, 0, idleOffset.z*20)

            if (rightUpAnim:getPlayState() == "PLAYING") then return end
            rightUpAnim:play()
        else
            if not (rightUpAnim:getPlayState() == "PLAYING") then return end
            rightUpAnim:stop()
        end
    end
    rightUp()

    -- When swimming/flying, player model does not face where the camera is looking by default.
    local headXRotExtraDegrees
    if player:getBoundingBox().y <= 1 then headXRotExtraDegrees = 90 else headXRotExtraDegrees = 0 end
    headBone:setRot(math.lerp(headBone:getRot(),vec(math.clamp(-playerVel.z, -25, 100) + headXRotExtraDegrees, 0, playerVel.x),delta))

    rootBone:setPos(idleOffset)
    nameplate.ENTITY:setPos(idleOffset/32)

    tiltBone:setRot(math.lerp(tiltBone:getRot(),vec(math.clamp(tiltRot,-25,25),0,0),delta))
    tiltBone.Eye:setRot(math.lerp(tiltBone.Eye:getRot(),vec(0,math.clamp(eyeRot,-50,50),0),delta))
end

----------------------
-- Figura Functions --
----------------------

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    vanilla_model.ARMOR:setVisible(false)
    vanilla_model.ELYTRA:setVisible(false)

    rootBone = models.Ray.root
    headBone = rootBone.Main
    tiltBone = headBone.Inner.Moving
    headBoneAnchor = rootBone.MainAnchor

    tick = 0
end

function events.tick()
    -- Tick Functions
end

function events.render(delta, context)
    rayRender(delta, context)
end
