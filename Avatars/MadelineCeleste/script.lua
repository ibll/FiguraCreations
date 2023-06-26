local swing = require("swing")
local eyes = require("eyes")
local ibllVA = require("IbllVA")

local ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
local DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

local SHRINK_ANIM = animations.Madeline.shrink
local FEATHER_SHRINK_ANIM = animations.Feather.shrink

local tick = 0
local featherTimer = 0

local particlesEnabled = false
local particlesToggleAction

local jumpKey = keybinds:fromVanilla("key.jump")
local isJumping = false

local conditionalModelParts = {
	head = {
		models.Madeline.Head.TopHair.Swoosh
	},
	body = {
		notOnBack = {
			models.Madeline.Body.Bust
		},
		onBackOnly = {
			models.Madeline.Head.ExtendedHair
		}
	}
}

-----------
-- PINGS --
-----------

function pings.sync(particleState)
    particlesEnabled = particleState
end

local function quickSync()
    pings.sync(particlesEnabled)
end

local function lazySync()
	tick = tick + 1
	if tick > 200 then
		if host:isHost() then
			quickSync()
		end
		tick = 0
	end
end

function pings.jumpPressed()
	isJumping = true
end

------------------
-- ACTION WHEEL --
------------------

local function printState(string, state)
    local function fancyState(value)
        if value == true or value == false then
            if value then return "§aEnabled" else return "§cDisabled" end
        else
            return "§b" .. value
        end
    end
    print(string .. ": " .. (fancyState(state)))
end

local function toggleParticles()
    particlesEnabled = not particlesEnabled
    config:save("ParticlesEnabled", particlesEnabled)
    particlesToggleAction:setToggled(particlesEnabled)
    quickSync()
    printState("Particles", particlesEnabled)
end

-------------
-- VISUALS --
-------------

local function spawnParticle(pos, color)
    particles:newParticle("minecraft:dust " .. color[1] .. " " .. color[2] .. " " .. color[3] .. " " .. "1.0", pos, player:getVelocity():length() * 2)
end

local function customParts()
	-- Hair Colour
	if isJumping then
		models.Madeline.Head.ExtendedHair:setUV(16/128, 0)
		models.Madeline.Head.TopHair:setUV(0, 16/64)
	else
		models.Madeline.Head.ExtendedHair:setUV(0, 0)
		models.Madeline.Head.TopHair:setUV(0, 0)
	end

	-- Golden Feather
	if player:getPose() == "FALL_FLYING" then
		ibllVA.armorOverride = false
		ibllVA.elytraOverride = false

		if SHRINK_ANIM:getPlayState() == "STOPPED" then
			SHRINK_ANIM:setSpeed(1)
			SHRINK_ANIM:loop("HOLD")
			SHRINK_ANIM:play()

			FEATHER_SHRINK_ANIM:setSpeed(1)
			FEATHER_SHRINK_ANIM:loop("HOLD")
			FEATHER_SHRINK_ANIM:play()
		end

		-- Flicker red when falling too far down
		if (player:getRot().x > 45) then
			featherTimer = featherTimer + 1
			if featherTimer % 2 ~= 0 then
				if models.Feather.GoldenFeather:getColor()[1] ~= 1 then
					models.Feather.GoldenFeather:setColor(1, 1, 1)
				else
					models.Feather.GoldenFeather:setColor(2, 0.5, 0.5)
				end
			end
		else
			models.Feather.GoldenFeather:setColor(1, 1, 1)
			featherTimer = 0
		end

		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then
			models.Madeline:setVisible(false)
		end
	else
		ibllVA.armorOverride = nil
		ibllVA.elytraOverride = nil

		if math.abs(SHRINK_ANIM:getTime()) >= SHRINK_ANIM:getLength() then
		--if animations.Madeline.shrink:getPlayState() == "ENDED" then
			SHRINK_ANIM:stop()
			FEATHER_SHRINK_ANIM:stop()
		end
		if not models.Madeline.Head:getVisible() then
			models.Madeline:setVisible(true)
		end

	end

	if animations.Madeline.shrink:getPlayState() == "STOPPED" then
		models.Feather.GoldenFeather:setVisible(false)
	else
		models.Feather.GoldenFeather:setVisible(true)
	end
end

local function particles()
	if renderer:isFirstPerson() then return end
	if math.abs(player:getVelocity():length()) <= 0.225 then return end

	if player:getPose() ~= "FALL_FLYING" then
		if isJumping then
			HandParticleColor = {131/255, 221/255, 235/255}
			FootParticleColor = {39/255, 117/255, 211/255}
		else
			HandParticleColor = {225/255, 114/255, 78/255}
			FootParticleColor = {202/255, 53/255, 37/255}
		end

		spawnParticle(models.Madeline.RightArm:partToWorldMatrix():apply(0, -10, 0), HandParticleColor)
		spawnParticle(models.Madeline.LeftArm:partToWorldMatrix():apply(0, -10, 0), HandParticleColor)
		spawnParticle(models.Madeline.RightLeg:partToWorldMatrix():apply(0, -10, 0), FootParticleColor)
		spawnParticle(models.Madeline.LeftLeg:partToWorldMatrix():apply(0, -10, 0), FootParticleColor)
	else
		if models.Feather.GoldenFeather:getColor()[1] ~= 1 then
			spawnParticle(models.Feather.GoldenFeather:partToWorldMatrix():apply(0, 0, 0), {255/255, 96/255, 95/255})
		else
			spawnParticle(models.Feather.GoldenFeather:partToWorldMatrix():apply(0, 0, 0), {255/255, 255/255, 95/255})
		end
	end

end

------------
-- FIGURA --
------------

function events.entity_init()
	vanilla_model.PLAYER:setVisible(false)

	local functionsPage = ibllVA.init(conditionalModelParts, true)

	if config:load("ParticlesEnabled") == true then particlesEnabled = true end
	
	-- action wheel
	particlesToggleAction = functionsPage:newAction()
		:item("minecraft:nether_star")
		:title("Enable Particles")
		:color(DISABLED_COLOR)
		:onToggle(toggleParticles)
		:toggleTitle("Disable Particles")
		:toggleColor(ENABLED_COLOR)
	particlesToggleAction:setToggled(particlesEnabled)

	swing.head(models.Madeline.Head.ExtendedHair, 180, {-120, 65, -30, 30, -30, 30})
	swing.head(models.Madeline.Head.ExtendedHair.Hair1, 180, {-120, 65, -30, 30, -30, 30}, models.Madeline.Head.ExtendedHair, 1)
	swing.head(models.Madeline.Head.ExtendedHair.Hair1.Hair2, 180, {-120, 65, -30, 30, -30, 30}, models.Madeline.Head.ExtendedHair, 2)

	swing.head(models.Feather.GoldenFeather.Feather1, 180)
	swing.head(models.Feather.GoldenFeather.Feather1.Feather2, 180, nil, models.Feather.GoldenFeather.Feather1, 1)
	swing.head(models.Feather.GoldenFeather.Feather1.Feather2.Feather3, 180, nil, models.Feather.GoldenFeather.Feather1, 2)

	models.Feather.GoldenFeather:setLight(vectors.vec2(15, 15))
end

function events.tick()
	ibllVA.tick()
	eyes.tick()
	
	if jumpKey:isPressed() and isJumping == false then
		pings.jumpPressed()
	end
	
	if isJumping and player:getVelocity().y == 0 then
		isJumping = false
	end
	
	lazySync()
	customParts()
end

function events.render(delta, context)
	eyes.render(delta)
	if particlesEnabled then particles() end
end