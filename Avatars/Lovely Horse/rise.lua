local RISE_ANIMATION = animations.Horsey.rise
local FALL_ANIMATION = animations.Horsey.fall

local ENABLED_COLOR = vectors.hexToRGB("#A6E3A1")
local DISABLED_COLOR = vectors.hexToRGB("#F38bA8")

local risen = false
local riseToggleAction

local lazySyncTick = 0

-- sync
function pings.sync(RisenState)
	risen = RisenState
end

local function quickSync()
    pings.sync(risen)
end

local function lazySync()
    lazySyncTick = lazySyncTick + 1
    if lazySyncTick < 200 then return end
    if not host:isHost() then return end

    quickSync()
    lazySyncTick = 0
end

-- action wheel
local function printState(state)
	if state then
		return "§aEnabled"
	else
		return "§cDisabled"
	end
end

local function toggleRise(state)
	print("§bRisen§f: §e" .. printState(state))
	risen = state
	riseToggleAction:setToggled(risen)
	quickSync()
end

---------
-- API --
---------

local riseAPI = {}

function riseAPI.addActionTo(page)
    riseToggleAction = page:newAction()
        :item("minecraft:scaffolding")
        :title("Rise")
        :color(DISABLED_COLOR)
        :onToggle(toggleRise)
        :toggleTitle("Lower")
        :toggleColor(ENABLED_COLOR)
end

function riseAPI.riseTick()
	if risen then
		if RISE_ANIMATION:getPlayState() == "STOPPED" then
			RISE_ANIMATION:setSpeed(1)
			RISE_ANIMATION:loop("HOLD")
			RISE_ANIMATION:play()
			FALL_ANIMATION:stop()
		end
	else
		if math.abs(RISE_ANIMATION:getTime()) >= RISE_ANIMATION:getLength() then
			RISE_ANIMATION:stop()
			FALL_ANIMATION:play()
		end
	end

	-- fix body when crouching
	if player:isSneaking() then
		if risen then
			models.Horsey.LowerHalf:setPos(0, 0, 6)
		else
			models.Horsey.LowerHalf:setPos(0, 0, 4)
		end
	else
		models.Horsey.LowerHalf:setPos(0, 0, 0)
	end
    lazySync()
end

function riseAPI.riseRender()
    local offset = models.Horsey.Head:getAnimPos()/16
	nameplate.ENTITY:setPivot(offset.x, offset.y + 2.5, offset.z)
	renderer:setOffsetCameraPivot(offset)
    renderer:setOffsetCameraRot(-models.Horsey.Head:getAnimRot())
end

return riseAPI