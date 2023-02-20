-- Swinging Physics by Manuel_#2867
-- Ported to Rewrite by Celeste_Dalloway and RonelPower306

local swing={}

local gravity = 0.05
local friction = 0.1
local centrifugalForce = 0.2

local sinr = math.sin
local cosr = math.cos
local rad = math.rad
local deg = math.deg
local lerp = math.lerp
local atan = math.atan

local function sin(x)
    return sinr(rad(x))
end
local function cos(x)
    return cosr(rad(x))
end

-- Returns movement angle relative to look direction (2D top down view, ignores Y)
-- Requires velocity vector variable containing player velocity
-- 0   : forward
-- 45  : left forward
-- 90  : left
-- 135 : left backwards
-- 180 : backwards
-- -135: right backwards
-- -90 : right
-- -45 : right forward
local function playerMoveAngle()
    local lookdir = player:getLookDir()
    lookdir.y = 0
    local m = 90+deg(atan(playerVelocity.z/playerVelocity.x))
    if playerVelocity.x < 0 then
        m = m + 180
    end
    local l = 90+deg(atan(lookdir.z/lookdir.x))
    if lookdir.x < 0 then
        l = l + 180
    end
    local ret = l - m
    if ret ~= ret then
        return 0
    else
        return ret
    end 
end

local moveAngle = 0
local playerSpeed = 0
local _yRotHead = 0
local yRotHead = 0
local forceHead = 0
local downHead = vectors.vec3(0,0,0)
local _yRotBody = 0
local yRotBody = 0
local forceBody = 0
local downBody = vectors.vec3(0,0,0)

events.ENTITY_INIT:register(function()
    _yRotHead = player:getRot().y
    yRotHead = _yRotHead
    _yRotBody = player:getBodyYaw()
    yRotBody = _yRotBody
    playerVelocity = player:getVelocity()
    playerVelocity.y = 0
end)

events.TICK:register(function ()
    moveAngle = playerMoveAngle()

    playerVelocity = player:getVelocity()
    playerVelocity.y = 0
    playerSpeed = playerVelocity:length()*6

    local playerRot = player:getRot()

    _yRotHead = yRotHead
    yRotHead = playerRot.y
    forceHead = (_yRotHead - yRotHead)/8
    downHead.x = playerRot.x
    _yRotBody = yRotBody
    yRotBody = player:getBodyYaw()
    forceBody = (_yRotBody - yRotBody)/8
    
    if player:getPose() == "CROUCHING" then
        downBody.x = deg(0.5)
    else
        downBody.x = 0
    end
end)

function swing.head(part, dir, limits, root, depth)
    local depths = depth
    local _rot = vectors.vec3(0,0,0)
    local rot = vectors.vec3(0,0,0)
    local velocity = vectors.vec3(0,0,0)
    if depths == nil then depths = 0 end
    local fric = friction*math.pow(1.5, depths)
    
    local rotLimits = limits
    
    events.TICK:register(function ()
        _rot = rot
        
        local roots = root

        local grav
        if roots ~= nil then
            grav = ((downHead - roots:getRot()) - rot) * gravity
        else
            grav = (downHead - rot) * gravity
        end
        
        velocity = velocity + grav + vectors.vec3(
            sin(dir)*forceHead - cos(moveAngle)*playerSpeed + cos(dir)*math.abs(forceHead)*centrifugalForce,
            0,
            cos(dir)*forceHead + sin(moveAngle)*playerSpeed - sin(dir)*math.abs(forceHead)*centrifugalForce
            )
        velocity = velocity * (1-fric)

        rot = rot + velocity
    end)

    if limits ~= nil then events.TICK:register(function()
        if rot.x < limits[1] then rot.x = limits[1] velocity.x = 0 end
        if rot.x > limits[2] then rot.x = limits[2] velocity.x = 0 end
        if rot.y < limits[3] then rot.y = limits[3] velocity.y = 0 end
        if rot.y > limits[4] then rot.y = limits[4] velocity.y = 0 end
        if rot.z < limits[5] then rot.z = limits[5] velocity.z = 0 end
        if rot.z > limits[6] then rot.z = limits[6] velocity.z = 0 end
    end) end 


    local modelpart = part

    events.RENDER:register(function(delta)
        modelpart:setRot(lerp(_rot, rot, delta))
    end)

end

function swing.body(part, dir, limits, root, depth)
    local depths = depth
    local _rot = vectors.vec3(0,0,0)
    local rot = vectors.vec3(0,0,0)
    local velocity = vectors.vec3(0,0,0)
    if depths == nil then depths = 0 end
    local fric = friction*math.pow(1.5, depths)
    events.TICK:register(function ()
        _rot = rot

        local grav
        if root ~= nil then
            grav = ((downBody - root:getRot()) - rot) * gravity
        else
            grav = (downBody - rot) * gravity
        end
        
        velocity = velocity + grav + vectors.vec3(
        sin(dir)*forceBody - cos(moveAngle)*playerSpeed + cos(dir)*math.abs(forceBody)*centrifugalForce,
        0,
        cos(dir)*forceBody + sin(moveAngle)*playerSpeed - sin(dir)*math.abs(forceBody)*centrifugalForce
        )
        velocity = velocity * (1-fric)

        rot = rot + velocity
    end)

    if limits ~= nil then events.TICK:register(function()
        if rot.x < limits[1] then rot.x = limits[1] velocity.x = 0 end
        if rot.x > limits[2] then rot.x = limits[2] velocity.x = 0 end
        if rot.y < limits[3] then rot.y = limits[3] velocity.y = 0 end
        if rot.y > limits[4] then rot.y = limits[4] velocity.y = 0 end
        if rot.z < limits[5] then rot.z = limits[5] velocity.z = 0 end
        if rot.z > limits[6] then rot.z = limits[6] velocity.z = 0 end
    end) end

    local modelpart = part

    events.RENDER:register(function(delta)
        modelpart:setRot(lerp(_rot, rot, delta))
    end)
end

return swing