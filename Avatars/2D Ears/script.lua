---------------------
-- Modify these!!! --
---------------------
-- i'm really sorry these are a mess, it's super
-- hard to describe much of the behaviour in this.

-- anyway, you can get pretty much any behaviour
-- you want by changing these.

-- if you don't like how it's billboarded, the "offset"
-- value in the render function is the actual var that
-- everything else is calculating for you.

local BILLBOARDED_MODELPART = models.model

local FRONT_ANGLE = 0
-- the angle the ears should try to avoid.
-- ears will keep as close back as possible.
-- To stay back, set to 0
-- To stay right, set to 90
-- To stay front, set to 180
-- To stay left, set to 270

local FLIP_TOLERANCE = 10
-- in degrees, the deadzone space where the ears
-- won't flip. when set to 0, slightly moving the
-- camera from left to right will cause repeated
-- flipping

local LERP_TIME = 10
-- in ticks, the time it takes for the ears to
-- travel from one side to the other. there are
-- 20 ticks in a second.

local FLIP_DIR = "AWAY_FROM_FRONT"
-- local FLIP_DIR = "TOWARDS_FRONT"
-- local FLIP_DIR = "AWAY_FROM_CAMERA"
-- local FLIP_DIR = "TOWARDS_CAMERA"
-- local FLIP_DIR = "CLOCKWISE"
-- local FLIP_DIR = "COUNTERCLOCKWISE"

local BIAS_RELATIVE_TO_SCREEN = false
-- if you want the ears to prefer staying towards
-- one side of the *head*, set this false.
-- if you want the ears to prefer staying towards
-- one side of the *viewers screen*, set this true.

local LEFT_BIAS = 0
-- in degrees, range where ears will prefer one
-- side of the head/screen. can be -90 through 90.

local function getRotationOfParent()
    return -math.shortAngle(player:getRot().y, -90)
end
-- the angle to consider as the "base" of the
-- billboarded part. the default is when it's
-- placed on the head.
-- i've not tried modifying this, i've just
-- put it here for ease of access. good luck!

----------
-- Vars --
----------

local tick = 0
local targetTick = 0
local offset = 0
local targetOffset = 0
local earsLeftOfScreen = false

----------------------
-- Figura Functions --
----------------------

function events.tick()
    tick = tick + 1

    local camPos = client:getCameraPos()
    local plaPos = player:getPos()
    local relDir = math.atan(camPos.z - plaPos.z, camPos.x - plaPos.x)*180/math.pi
    local hostDir = getRotationOfParent()
    local relAngle = math.shortAngle(hostDir, relDir + FRONT_ANGLE)
    local leftAngle = math.shortAngle(relAngle, -90)
    local rightAngle = math.shortAngle(relAngle, 90)
    
    local camIsLeft
    local camIsRight
    local earsShouldBeLeftOfScreen

    if BIAS_RELATIVE_TO_SCREEN == false then
        camIsLeft = leftAngle > -90 - LEFT_BIAS + FLIP_TOLERANCE and leftAngle < 90 - LEFT_BIAS - FLIP_TOLERANCE
        camIsRight = rightAngle < 90 - LEFT_BIAS - FLIP_TOLERANCE and rightAngle > -90 - LEFT_BIAS + FLIP_TOLERANCE
        earsShouldBeLeftOfScreen = (leftAngle < -90 - LEFT_BIAS) or (leftAngle > 90 - LEFT_BIAS)
        
    else
        camIsLeft = leftAngle > -90 + LEFT_BIAS + FLIP_TOLERANCE and leftAngle < 90 - LEFT_BIAS - FLIP_TOLERANCE
        camIsRight = rightAngle < 90 + LEFT_BIAS - FLIP_TOLERANCE and rightAngle > -90 - LEFT_BIAS + FLIP_TOLERANCE
        earsShouldBeLeftOfScreen = (leftAngle < -90 + LEFT_BIAS) or (leftAngle > 90 - LEFT_BIAS)

    end

    local function startFlip()
        targetTick = tick + LERP_TIME

        local offsetDiff = 180
        if FLIP_DIR == "AWAY_FROM_FRONT" then
            if earsLeftOfScreen then offsetDiff = -offsetDiff end
            if math.abs(relAngle) > 90 then offsetDiff = -offsetDiff end
        elseif FLIP_DIR == "TOWARDS_FRONT" then
            if not earsLeftOfScreen then offsetDiff = -offsetDiff end
            if math.abs(relAngle) > 90 then offsetDiff = -offsetDiff end
        elseif FLIP_DIR == "AWAY_FROM_CAMERA" then
            if earsLeftOfScreen then offsetDiff = -offsetDiff end
        elseif FLIP_DIR == "TOWARDS_CAMERA" then
            if not earsLeftOfScreen then offsetDiff = -offsetDiff end
        elseif FLIP_DIR == "CLOCKWISE" then
            offsetDiff = -offsetDiff
        end

        targetOffset = targetOffset + offsetDiff
    end
    
    if camIsLeft or camIsRight then
        if  earsShouldBeLeftOfScreen ~= earsLeftOfScreen then
            startFlip()
            -- print("Flip!")
        end
        earsLeftOfScreen = targetOffset/180%2 == 0
    end
    
    -- print(camIsLeft, ", ", camIsRight, ", ", relAngle, ", ", world:getTime())
end

function events.render(delta)
    if tick < targetTick then
        local timeDiff = 1 - (targetTick - tick)/LERP_TIME
        offset = math.lerp(offset, targetOffset, timeDiff)
    end

    BILLBOARDED_MODELPART:setRot(0, player:getBodyYaw(delta)-client:getCameraRot().y+offset, 0)
end