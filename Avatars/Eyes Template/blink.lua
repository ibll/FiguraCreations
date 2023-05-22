-- Original eye avatar template by Fran#3814

-- MODIFY THESE!!!
local eyes = models.model.Head.Eyes
TEXTURE_HEIGHT  = 64    -- texture size (height), in pixels

-- blink constants
BLINK_MIN_DELAY = 70    -- minimum delay for blink, in ticks
BLINK_MAX_DELAY = 100   -- maximum delay for blink, in ticks  
BLINK_CHANCE    = 0.03  -- chance for blinking after the minimum delay is reached
DUMMY_BLINK_CHANCE = 0.01 -- chance to make a dummy blink (blink one eye then another)
DUMMY_BLINK_DELAY  = 5    -- delay in ticks to blink the other eye

-- blink vars
IsBlinking  = true
LblinkFrame = 0
RblinkFrame = 0
BlinkTick   = 0

BlinkAPI = {}

function BlinkAPI.tick()

    function pings.blink(dummy, eye)
        IsBlinking = true
        if dummy then
            LblinkFrame = eye and -DUMMY_BLINK_DELAY or 0
            RblinkFrame = not eye and -DUMMY_BLINK_DELAY or 0
        else
            LblinkFrame = 0
            RblinkFrame = 0
        end
    end

	-- tick
	BlinkTick = BlinkTick + 1

	-- if is already blinking
	if IsBlinking then
		-- increase blink frame
		if LblinkFrame < 4 then
			LblinkFrame = LblinkFrame + 1
		end

		if RblinkFrame < 4 then
			RblinkFrame = RblinkFrame + 1
		end

		-- restart blink if frame is greater than 4
		if LblinkFrame >= 4 and RblinkFrame >= 4 then
			IsBlinking = false
			BlinkTick  = 0
		end
	-- check blink
	elseif BlinkTick >= BLINK_MIN_DELAY and math.random() < BLINK_CHANCE or BlinkTick >= BLINK_MAX_DELAY then
		if host:isHost() then
            pings.blink(math.random() < DUMMY_BLINK_CHANCE, math.random() < 0.5)
        end
	end
end

-- eyes animation
function BlinkAPI.render(delta)
	-- get rot
	local bodyYawRaw = player:getBodyYaw()
	local bodyYaw = (bodyYawRaw - 360 * math.floor( bodyYawRaw / (360))) - 180
	local headYawRaw = player:getRot().y
	local headYaw = (headYawRaw - 360 * math.floor( headYawRaw / (360))) - 180

	local rotX = -(bodyYaw - headYaw) / 45
	local rotY = -player:getRot().x / 135

	-- print(player:getBodyYaw() - player:getRot().y) -- should be -50 through 50
	-- print(player:getBodyYaw())
	-- print(player:getRot().y)
	print("Body: " .. bodyYaw .. " Head: " .. headYaw)

	-- apply
    eyes.Eyes:setPos(math.lerp(eyes.Eyes:getPos(), vec(0, math.clamp(rotY, -0.45, 0.45), 0), delta))
	eyes.Right_Iris:setPos(math.lerp(eyes.Right_Iris:getPos(), vec(math.clamp(rotX, -0.15, 1), rotY, 0), delta))
	
	local leftEyeVec = vec(
		math.clamp(
			rotX,
			-1,
			0.15
		),
		rotY,
		0
	)
	
	eyes.Left_Iris:setPos(math.lerp(eyes.Left_Iris:getPos(), leftEyeVec, delta) )

	-- blink uv
	local LX = math.clamp(LblinkFrame + delta, 0, 4)
	local lblink = -4 * math.abs(LX / 4 - math.floor(LX / 4 + 0.5))

	local RX = math.clamp(RblinkFrame + delta, 0, 4)
	local rblink = -4 * math.abs(RX / 4 - math.floor(RX / 4 + 0.5))

	-- set blink uv
	eyes.Left_Eyelid:setUV(0, lblink / TEXTURE_HEIGHT)
	eyes.Right_Eyelid:setUV(0, rblink / TEXTURE_HEIGHT)
end

return BlinkAPI