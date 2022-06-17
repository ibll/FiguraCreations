-- Art, model, and animations by TheGoodDude#6142
-- Eyes blinking and movement by Fran#3814
-- Hair physics by Manuel_#2867

----------------------
-- Figura Functions --
----------------------

function player_init()
	-- defaults
	armorEnabled = false
	elytraEnabled = false
	if data.load("armorEnabled") == "true" then
		armorEnabled = true
	end

	if data.load("elytraEnabled") == "true" then
		elytraEnabled = true
	end

	-- disable vanilla model
	for key, value in pairs(vanilla_model) do
		value.setEnabled(false)
	end

	-- jump detection
	isJumping = false
	jumpKey = keybind.getRegisteredKeybind("key.jump")

	-- blink constants
	TEXTURE_WIDTH   = 128    -- texture size (width), in pixels
	TEXTURE_HEIGHT  = 64    -- texture size (height), in pixels

	BLINK_MIN_DELAY = 70    -- minimum delay for blink, in ticks
	BLINK_MAX_DELAY = 100   -- maximum delay for blink, in ticks  
	BLINK_CHANCE    = 0.03  -- chance for blinking after the minimum delay is reached
  
	DUMMY_BLINK_CHANCE = 0.01 -- chance to make a dummy blink (blink one eye then another)
	DUMMY_BLINK_DELAY  = 5    -- delay in ticks to blink the other eye

	-- blink vars
	isBlinking  = true
	lblinkFrame = 0
	rblinkFrame = 0
	blinkTick   = 0

	-- wheel, keybinds, and animations
	action_wheel.setLeftSize(1)
	action_wheel.setRightSize(1)

	action_wheel.SLOT_1.setTitle("Toggle Armour")
	action_wheel.SLOT_1.setItem("minecraft:netherite_chestplate")
	action_wheel.SLOT_1.setFunction(function() ping.armor( not armorEnabled) end)

	action_wheel.SLOT_2.setTitle("Toggle Elytra")
	action_wheel.SLOT_2.setItem("minecraft:elytra")
	action_wheel.SLOT_2.setFunction(function() ping.elytra( not elytraEnabled) end)

	swingOnHead(model.Head.ExtendedHair, 180, {-120, 65, -30, 30, -30, 30})
	swingOnHead(model.Head.ExtendedHair.Hair1, 180, {-120, 65, -30, 30, -30, 30}, model.Head.ExtendedHair, 1)
	swingOnHead(model.Head.ExtendedHair.Hair1.Hair2, 180, {-120, 65, -30, 30, -30, 30}, model.Head.ExtendedHair, 2)
end

function tick()
	if jumpKey.isPressed() and isJumping == false then
		ping.jumpPressed()
	end

	if isJumping and player.getVelocity().y == 0 then
		isJumping = false
	end

	-- tick functions
	blink()
	vanillaParts()
	customParts()
end

function render(delta)
	eyesAnim(delta)
	particles()
end

---------------------
-- Model Functions --
---------------------

function vanillaParts()
	-- show or hide armor
	if armorEnabled and not animationPlaying then
		for key, value in pairs(armor_model) do
			value.setEnabled(true)
		end
	else
		for key, value in pairs(armor_model) do
			value.setEnabled(false)
		end
	end

	-- show or hide elytra
	if elytraEnabled and not animationPlaying then
		for key, value in pairs(elytra_model) do
			value.setEnabled(true)
		end
	else
		for key, value in pairs(elytra_model) do
			value.setEnabled(false)
		end
	end
end

function customParts()
	-- show or hide model parts depdnding if animating, armor enabled, or if item equipped
	if player.getEquipmentItem(6).getType() == "minecraft:air" or not armor_model.HELMET.getEnabled() then
		--nameplate.ENTITY.setPos({0, 0.2, 0})
		model.Head.HairSwoosh.setEnabled(true)
	else 
		--nameplate.ENTITY.setPos({0, 0, 0})
		model.Head.HairSwoosh.setEnabled(false)
	end

	if player.getEquipmentItem(5).getType() == "minecraft:air" or player.getEquipmentItem(5).getType() == "minecraft:elytra" or not armor_model.CHESTPLATE.getEnabled() then
		model.Body.Bust.setEnabled(true)
	else
		model.Body.Bust.setEnabled(false)
	end

	if isJumping then
		model.Head.ExtendedHair.setUV({16/128, 0})
		model.Head.FlatHair.setUV({0, 16/64})
		model.Head.HairSwoosh.setUV({0, 16/64})
	else
		model.Head.ExtendedHair.setUV({0, 0})
		model.Head.FlatHair.setUV({0, 0})
		model.Head.HairSwoosh.setUV({0, 0})
	end

end

function particles()
	if renderer.isFirstPerson() then return end
	if math.abs(player.getVelocity().getLength()) <= 0.225 then return end

	if isJumping then
		handParticleColor = {131/255, 221/255, 235/255}
		footParticleColor = {39/255, 117/255, 211/255}
	else
		handParticleColor = {225/255, 114/255, 78/255}
		footParticleColor = {202/255, 53/255, 37/255}
	end

	spawnParticle(model.RightArm.partToWorldPos({0, -10, 0}), handParticleColor)
	spawnParticle(model.LeftArm.partToWorldPos({0, -10, 0}), handParticleColor)
	spawnParticle(model.RightLeg.partToWorldPos({0, -10, 0}), footParticleColor)
	spawnParticle(model.LeftLeg.partToWorldPos({0, -10, 0}), footParticleColor)
end

--------------------
-- Ping Functions --
--------------------

function ping.blink(arg, armorState, elytraState)
	-- enable blinking
	isBlinking = true

	-- dummy blink
	lblinkFrame = arg and -DUMMY_BLINK_DELAY or 0
	rblinkFrame = not arg and -DUMMY_BLINK_DELAY or 0

	-- periodic armor sync
	if armorState ~= nil then
		armorEnabled = armorState
	end

	-- periodic elytra sync
	if elytraState ~= nil then
		elytraEnabled = elytraState
	end
end

function ping.armor(state)
	data.save("armorEnabled", state)
	log("§bArmor Visibility§f: §e" .. printState(state))
	armorEnabled = state
end

function ping.elytra(state)
	data.save("elytraEnabled", state)
	log("§bElytra Visibility§f: §e" .. printState(state))
	elytraEnabled = state
end

function ping.jumpPressed()
	isJumping = true
end

----------------------
-- Helper Functions --
----------------------

function printState(state)
	if state then
		return "§aEnabled"
	else
		return "§cDisabled"
	end
end

function spawnParticle(pos, color)
    particle.addParticle("dust", pos, {color[1], color[2], color[3], player.getVelocity().getLength() * 2})
end

---------------------
-- Blink Functions --
--- by  Fran#3814 ---
---------------------

-- blink tick
function blink()
	-- tick
	blinkTick = blinkTick + 1
  
	-- if is already blinking
	if isBlinking then
		-- increase blink frame
		if lblinkFrame < 4 then
			lblinkFrame = lblinkFrame + 1
		end
  
		if rblinkFrame < 4 then
			rblinkFrame = rblinkFrame + 1
		end
  
		-- restart blink if frame is greater than 4
		if lblinkFrame >= 4 and rblinkFrame >= 4 then
			isBlinking = false
			blinkTick  = 0
		end
	-- check blink
	elseif blinkTick >= BLINK_MIN_DELAY and math.random() < BLINK_CHANCE or blinkTick >= BLINK_MAX_DELAY then
		-- dummy blink
		if client.isHost() and math.random() < DUMMY_BLINK_CHANCE then
			ping.blink(math.random() < 0.5, armorEnabled, elytraEnabled)
		-- normal blink
		else
			isBlinking  = true
			lblinkFrame = 0
			rblinkFrame = 0
		end
	end
end
  
-- eyes animation
function eyesAnim(delta)
	local eyes = model.Head.Eyes
  
	-- eyeballs
  
	-- get rot
	local rotX = (player.getBodyYaw() - player.getRot().y) / 45
	local rotY = player.getRot().x / 135
  
	-- apply
	eyes.Eyes.setPos(math.lerp(eyes.Eyes.getPos(), vectors.of({0, math.clamp(rotY, -0.45, 0.45), 0}), delta))
	eyes.Left_Iris.setPos(math.lerp(eyes.Left_Iris.getPos(), vectors.of({math.clamp(rotX, -0.15, 1), rotY, 0}), delta))
	eyes.Right_Iris.setPos(math.lerp(eyes.Right_Iris.getPos(), vectors.of({math.clamp(rotX, -1, 0.15), rotY, 0}), delta))
  
	-- blink
  
	-- blink uv
	local x = math.clamp(lblinkFrame + delta, 0, 4)
	local lblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))
  
	local x = math.clamp(rblinkFrame + delta, 0, 4)
	local rblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))
  
	-- set blink uv
	eyes.Left_Eyelid.setUV({0, lblink / TEXTURE_HEIGHT})
	eyes.Right_Eyelid.setUV({0, rblink / TEXTURE_HEIGHT})
end

----------------------
-- Swinging Physics --
-- by  Manuel_#2867 --
----------------------

do
    local gravity = 0.1
    local friction = 0.1
    local centrifugalForce = 0.2

    local sinr = math.sin
    local cosr = math.cos
    local rad = math.rad
    local deg = math.deg
    local lerp = math.lerp
    local atan = math.atan
    local getVelocity
    local getPlayerRot
    local getBodyYaw
    local getLookDir
    local playerVelocity
    local getAnimation
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
        local lookdir = getLookDir()
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
    local downHead = vectors.of({0,0,0})
    local _yRotBody = 0
    local yRotBody = 0
    local forceBody = 0
    local downBody = vectors.of({0,0,0})
    function player_init()
        getVelocity = player.getVelocity
        getPlayerRot = player.getRot
        getLookDir = player.getLookDir
        getBodyYaw = player.getBodyYaw
        getAnimation = player.getAnimation
        _yRotHead = getPlayerRot().y
        yRotHead = _yRotHead
        _yRotBody = getBodyYaw()
        yRotBody = _yRotBody
        playerVelocity = getVelocity()
        playerVelocity.y = 0
    end
    function tick()
        moveAngle = playerMoveAngle()
        playerVelocity = getVelocity()
        playerVelocity.y = 0
        playerSpeed = playerVelocity.getLength()*6

        local playerRot = getPlayerRot()

        _yRotHead = yRotHead
        yRotHead = playerRot.y
        forceHead = (_yRotHead - yRotHead)/8
        downHead.x = playerRot.x

        _yRotBody = yRotBody
        yRotBody = getBodyYaw()
        forceBody = (_yRotBody - yRotBody)/8
        if getAnimation() == "CROUCHING" then
            downBody.x = deg(0.5)
        else
            downBody.x = 0
        end
    end
    function swingOnHead(part, dir, limits, root, depth)
        local _rot = vectors.of({0,0,0})
        local rot = vectors.of({0,0,0})
        local velocity = vectors.of({0,0,0})
        if depth == nil then depth = 0 end
        local fric = friction*math.pow(1.5, depth)
        function tick()
            _rot = rot

            local grav
            if root ~= nil then
                grav = ((downHead - root.getRot()) - rot) * gravity
            else
                grav = (downHead - rot) * gravity
            end
            
            velocity = velocity + grav + vectors.of({
                sin(dir)*forceHead-cos(moveAngle)*playerSpeed+cos(dir)*math.abs(forceHead)*centrifugalForce,
                0,
                cos(dir)*forceHead+sin(moveAngle)*playerSpeed-sin(dir)*math.abs(forceHead)*centrifugalForce
            })
            velocity = velocity * (1-fric)

            rot = rot + velocity
        end
        if limits ~= nil then function tick()
            if rot.x < limits[1] then rot.x = limits[1] velocity.x = 0 end
            if rot.x > limits[2] then rot.x = limits[2] velocity.x = 0 end
            if rot.y < limits[3] then rot.y = limits[3] velocity.y = 0 end
            if rot.y > limits[4] then rot.y = limits[4] velocity.y = 0 end
            if rot.z < limits[5] then rot.z = limits[5] velocity.z = 0 end
            if rot.z > limits[6] then rot.z = limits[6] velocity.z = 0 end
        end end
        function render(delta)
            part.setRot(lerp(_rot, rot, delta))
        end
    end
    function swingOnBody(part, dir, limits, root, depth)
        local _rot = vectors.of({0,0,0})
        local rot = vectors.of({0,0,0})
        local velocity = vectors.of({0,0,0})
        if depth == nil then depth = 0 end
        local fric = friction*math.pow(1.5, depth)
        function tick()
            _rot = rot

            local grav
            if root ~= nil then
                grav = ((downBody - root.getRot()) - rot) * gravity
            else
                grav = (downBody - rot) * gravity
            end

            velocity = velocity + grav + vectors.of({
                sin(dir)*forceBody-cos(moveAngle)*playerSpeed+cos(dir)*math.abs(forceBody)*centrifugalForce,
                0,
                cos(dir)*forceBody+sin(moveAngle)*playerSpeed-sin(dir)*math.abs(forceBody)*centrifugalForce
            })
            velocity = velocity * (1-fric)

            rot = rot + velocity
        end
        if limits ~= nil then function tick()
            if rot.x < limits[1] then rot.x = limits[1] velocity.x = 0 end
            if rot.x > limits[2] then rot.x = limits[2] velocity.x = 0 end
            if rot.y < limits[3] then rot.y = limits[3] velocity.y = 0 end
            if rot.y > limits[4] then rot.y = limits[4] velocity.y = 0 end
            if rot.z < limits[5] then rot.z = limits[5] velocity.z = 0 end
            if rot.z > limits[6] then rot.z = limits[6] velocity.z = 0 end
        end end
        function render(delta)
            part.setRot(lerp(_rot, rot, delta))
        end
    end
end