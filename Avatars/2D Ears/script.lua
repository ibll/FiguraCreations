local BILLBOARDED_MODELPART = models.model

local LEFT_SIDE_OF_HEAD_BIAS = 25 -- in degrees
local FLIP_TOLERANCE = 10 -- in degrees
local LERP_TIME = 10 -- in ticks

local tick = 0
local targetTick = 0
local offset = 0
local targetoffset = 0
local earsLeftOfScreen = true

----------------------
-- Figura Functions --
----------------------

function events.tick()
    tick = tick + 1

    local camPos = client:getCameraPos()
    local plaPos = player:getPos()
    local relDir = math.atan(camPos.z - plaPos.z, camPos.x - plaPos.x)*180/math.pi
    local hostDir = -math.shortAngle(player:getRot().y, -90)
    local relAngle = math.shortAngle(hostDir, relDir)
    local leftAngle = math.shortAngle(relAngle, -90)
    local rightAngle = math.shortAngle(relAngle, 90)
    
    local earsShouldBeLeftOfScreen = (leftAngle < -90 - LEFT_SIDE_OF_HEAD_BIAS) or (leftAngle > 90 - LEFT_SIDE_OF_HEAD_BIAS)

    local function startFlip()
        targetTick = tick + LERP_TIME

        local offsetDiff = 180
        if earsLeftOfScreen then offsetDiff = -offsetDiff end
        -- comment next line to always flip away from camera
        if math.abs(relAngle) > 90 then offsetDiff = -offsetDiff end
        targetoffset = targetoffset + offsetDiff
    end

    local camIsLeft = leftAngle > -90 - LEFT_SIDE_OF_HEAD_BIAS + FLIP_TOLERANCE and leftAngle < 90 - LEFT_SIDE_OF_HEAD_BIAS - FLIP_TOLERANCE
    local camIsRight = rightAngle < 90 - LEFT_SIDE_OF_HEAD_BIAS - FLIP_TOLERANCE and rightAngle > -90 - LEFT_SIDE_OF_HEAD_BIAS + FLIP_TOLERANCE
    print(camIsLeft, ", ", camIsRight, ", ", leftAngle, ", ", world:getTime())

    if camIsLeft or camIsRight then
        print(earsShouldBeLeftOfScreen)
        if  earsShouldBeLeftOfScreen ~= earsLeftOfScreen then
            startFlip()
            -- print("Flip!")
        end
        earsLeftOfScreen = earsShouldBeLeftOfScreen
    end

end

function events.render(delta)
    if tick < targetTick then
        local timeDiff = 1 - (targetTick - tick)/LERP_TIME
        offset = math.lerp(offset, targetoffset, timeDiff)
    end

    BILLBOARDED_MODELPART:setRot(0, player:getBodyYaw(delta)-client:getCameraRot().y+offset, 0)
end