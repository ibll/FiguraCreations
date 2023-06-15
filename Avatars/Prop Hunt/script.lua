-- figura functions

function events.entity_init()
    -- setup
    vanilla_model.ALL:setVisible(false)
    renderer:setShadowRadius(0)
    nameplate.ENTITY:setVisible(false)

    -- vars
    SyncTick = 0
    SnapMode = "Rounded"
    TicksInSameBlock = 0
    SoundEffectPlayed = false

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

    SnapModeAction = ActionWheelPg1:newAction()
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :onLeftClick(CycleSnapMode)
end

function events.tick()
    ModelPos()
    Sync()
end

-- helpers

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
            sounds:playSound("minecraft:ui.button.click", player:getPos(), 1, 2, false)
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
    pings.sync(SnapMode)
    PrintState("Snapping",  SnapMode)
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

function Sync()
    SyncTick = SyncTick + 1
    if SyncTick < 200 then return end
    if not host:isHost() then return end
    pings.sync(SnapMode)
    SyncTick = 0
end

-- pings

function pings.sync(SnapState)
    SnapMode = SnapState
end