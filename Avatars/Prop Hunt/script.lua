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

    SeekerToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:grass_block")
		:title("Current Mode: Prop")
		:color(DISABLED_COLOR)
		:onToggle(ToggleSeeker)
        :toggleItem("minecraft:netherite_sword")
		:toggleTitle("Current Mode: Seeker")
		:toggleColor(ENABLED_COLOR)
    SeekerToggleAction:setToggled(SeekerEnabled)

    SnapModeAction = ActionWheelPg1:newAction()
        :item("minecraft:ender_pearl")
        :title("Snap Mode: Rounded")
        :onLeftClick(CycleSnapMode)

        BuildModeToggleAction = ActionWheelPg1:newAction()
		:item("minecraft:diamond_shovel")
		:title("Building Mode: Disabled")
		:color(DISABLED_COLOR)
		:onToggle(ToggleBuildMode)
        :toggleItem("minecraft:lantern")
		:toggleTitle("Building Mode: Enabled")
		:toggleColor(ENABLED_COLOR)
    BuildModeToggleAction:setToggled(BuildModeEnabled)

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

function events.MOUSE_PRESS(button, state, modifiers)
    if BuildModeEnabled and state == 1 then
        TargetedBlock, HitPos, Side = player:getTargetedBlock(true, 6)

        Pos = TargetedBlock:getPos()*16
        Pos = vec(Pos.x+8, Pos.y + 0.01, Pos.z+8)

            if Side == "up" then IntendedBlock = vec(Pos.x, Pos.y + 16, Pos.z)
        elseif Side == "down" then IntendedBlock = vec(Pos.x, Pos.y - 16, Pos.z)
        elseif Side == "north" then IntendedBlock = vec(Pos.x, Pos.y, Pos.z - 16)
        elseif Side == "south" then IntendedBlock = vec(Pos.x, Pos.y, Pos.z + 16)
        elseif Side == "east" then IntendedBlock = vec(Pos.x + 16, Pos.y, Pos.z)
        elseif Side == "west" then IntendedBlock = vec(Pos.x - 16, Pos.y, Pos.z)
        end

        pings.place(IntendedBlock)
    end
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
            BlockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16 + 0.01, math.floor(pos.z)*16 + 8)
        elseif SnapMode == "Rounded" then
            BlockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16 + 0.01, math.floor(pos.z)*16 + 8)
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

function ToggleBuildMode(state)
    PrintState("Build Mode", state)
    BuildModeEnabled = state
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

function pings.place(Pos)
    Copy = models.model.root:copy("Block")
    models.model.World:addChild(Copy)
    Copy:setVisible(true)
    Copy:setPos(Pos)
end