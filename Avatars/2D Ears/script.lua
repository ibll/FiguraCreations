local BILLBOARDED_MODELPART = models.model
local LERP_TIME = 10 -- in ticks
local FLIP_TOLERANCE = 10 -- in degrees

local tick = 0
local targetTick = 0
local offset = 0
local targetoffset = 0
local earsRight = false

----------------------
-- Figura Functions --
----------------------

function events.tick()
    tick = tick + 1

    local camPos = client:getCameraPos()
    local plaPos = player:getPos()
    local relDir = math.atan(camPos.z - plaPos.z, camPos.x - plaPos.x)*180/math.pi
    local hostDir = -math.shortAngle(player:getRot().y, -90)
    local relativeAngle = math.shortAngle(hostDir, relDir)

    local function startFlip()
        targetTick = tick + LERP_TIME

        local offsetDiff = 180
        if relativeAngle < 0 then offsetDiff = -offsetDiff end
        -- comment next line to always flip away from camera
        if math.abs(relativeAngle) > 90 then offsetDiff = -offsetDiff end
        targetoffset = targetoffset + offsetDiff
    end

    local relAngPos = math.abs(relativeAngle)

    if relAngPos > FLIP_TOLERANCE and relAngPos < 180 - FLIP_TOLERANCE then
        if relativeAngle < 0 ~= earsRight then
            startFlip()
        end
        earsRight = relativeAngle < 0
    end
end

function events.render(delta)
    if tick < targetTick then
        local timeDiff = 1 - (targetTick - tick)/LERP_TIME
        offset = math.lerp(offset, targetoffset, timeDiff)
    end

    BILLBOARDED_MODELPART:setRot(0, player:getBodyYaw(delta)-client:getCameraRot().y+offset, 0)
end