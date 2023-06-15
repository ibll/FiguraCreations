ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

-- figura functions

function events.entity_init()
    -- setup
    VisibleAsProp(true)

    -- vars
    SyncTick = 0
    SnapMode = "Rounded"
    SeekerEnabled = false
    SeekerApplied = false
    TicksInSameBlock = 0
    SoundEffectPlayed = false

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

    SnapModeAction = ActionWheelPg1:newAction()
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :onLeftClick(CycleSnapMode)

    SeekerToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:grass_block")
		:title("Current Mode: Prop")
		:color(DISABLED_COLOR)
		:onToggle(ToggleSeeker)
        :toggleItem("minecraft:netherite_sword")
		:toggleTitle("Current Mode: Seeker")
		:toggleColor(ENABLED_COLOR)
    SeekerToggleAction:setToggled(SeekerEnabled)
end

function events.tick()
    if SeekerEnabled then
        if not SeekerApplied then VisibleAsProp(false) end
    else
        if SeekerApplied then VisibleAsProp(true) end
        ModelPos()
    end
    SyncTimer()
end

-- helpers

function VisibleAsProp(state)
    SeekerApplied = not state

    vanilla_model.ALL:setVisible(not state)
    nameplate.ENTITY:setVisible(not state)
    models.model.root:setVisible(state)
    if state == true then ShadowSize = 0 else ShadowSize = 0.5 end
    renderer:setShadowRadius(ShadowSize)
end

function ModelPos() 
    local pos = player:getPos()
    if SnapMode == "Floored" then
        CurrentPosition = pos:floor()
    else
        CurrentPosition = vec(math.floor(pos.x), math.round(pos.y), math.floor(pos.z))
    end

    if OldPosition == CurrentPosition then
        TicksInSameBlock = TicksInSameBlock + 1
    else
        TicksInSameBlock = 0
    end

    if TicksInSameBlock >= 20 and SnapMode ~= "Disabled" then
        models.model:setParentType("WORLD")
        if SnapMode == "Floored" then
            BlockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16, math.floor(pos.z)*16 + 8)
        elseif SnapMode == "Rounded" then
            BlockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16, math.floor(pos.z)*16 + 8)
        end
        models.model:setPos(BlockPos)

        if SoundEffectPlayed == false then
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.25, 2, false)
            SoundEffectPlayed = true
        end
    else
        models.model:setParentType("None")
        models.model:setPos(0, 0, 0)
        SoundEffectPlayed = false
    end

    OldPosition = CurrentPosition
end

function CycleSnapMode()
    if SnapMode == "Rounded" then
        SnapMode = "Floored"
        SnapModeAction:title("Snap Mode: Floored")
        SnapModeAction:item("minecraft:black_carpet")
    elseif SnapMode == "Floored" then
        SnapMode = "Disabled"
        SnapModeAction:title("Snap Mode: Disabled")
        SnapModeAction:item("minecraft:barrier")
    else 
        SnapMode = "Rounded"
        SnapModeAction:title("Snap Mode: Rounded")
        SnapModeAction:item("minecraft:ender_pearl")
    end
    config:save("SnapMode", SnapMode)
    Sync()
    PrintState("Snapping",  SnapMode)
end

function ToggleSeeker(state)
	PrintState("Seeker", state)
	SeekerEnabled = state
	Sync()
end

function PrintState(string, state)
    function State(value)
        if value == true or value == false then
            if value then return "§aEnabled" else return "§cDisabled" end
        else
            return "§b" .. value
        end
    end
    print(string .. ": " .. (State(state)))
end

function SyncTimer()
    SyncTick = SyncTick + 1
    if SyncTick < 200 then return end
    if not host:isHost() then return end
    Sync()
    SyncTick = 0
end

function Sync()
    pings.sync(SnapMode, SeekerEnabled)
end

-- pings

function pings.sync(SnapState, SeekerState)
    SnapMode = SnapState
    SeekerEnabled = SeekerState
end