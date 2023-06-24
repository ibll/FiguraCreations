local RISE_ANIMATION = animations.Horsey.rise
local FALL_ANIMATION = animations.Horsey.fall

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

	if RISE_ANIMATION:getPlayState() == "STOPPED"  and FALL_ANIMATION:getTime() >= FALL_ANIMATION:getLength() then
		nameplate.ENTITY:setPos(0, 0.2, 0)
	else
		nameplate.ENTITY:setPos(0, 1, 0)
	end

    lazySync()
end

function riseAPI.riseRender()
	local height
	if RISE_ANIMATION:getPlayState() == "PLAYING" then
		height = math.lerp(0, 1, RISE_ANIMATION:getTime()/RISE_ANIMATION:getLength())
	else
		local fallTime = FALL_ANIMATION:getTime()
		if fallTime == 0 then height = 0 return end
		height = 1 - math.lerp(0, 1, FALL_ANIMATION:getTime()/FALL_ANIMATION:getLength())
	end

	renderer:setOffsetCameraPivot(0, height, 0)
	nameplate.ENTITY:setPos(0, height * 2/3 + 0.5, 0)
end

return riseAPI