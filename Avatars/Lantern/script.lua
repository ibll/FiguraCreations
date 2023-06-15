vanilla_model.ALL:setVisible(false)

ENABLED_COLOR = vectors.hexToRGB("#a6e3a1")
DISABLED_COLOR = vectors.hexToRGB("#f38ba8")

function events.entity_init()
    Tick = 0
    StillTimer = 0
    Snap = false
    Popped = false
    OldPosBlock = vec(0, 0, 0)

    -- config loading
    SnapFloor = false
    if config:load("SnapFloor") == true then SnapFloor = true end

    -- action wheel
	ActionWheelPg1 = action_wheel:newPage("Functions")
	action_wheel:setPage(ActionWheelPg1)

    SnapToggleAction = ActionWheelPg1:newAction()
        :item("minecraft:netherite_chestplate")
        :title("Lower Snapping")
        :color(DISABLED_COLOR)
        :onToggle(ToggleSnap)
        :toggleTitle("Raise Snapping")
        :toggleColor(ENABLED_COLOR)
    SnapToggleAction:setToggled(SnapFloor)

    -- setup
    renderer:setShadowRadius(0)
    nameplate.ENTITY:setVisible(false)
end

function events.tick()
    local vel = player:getVelocity()
    local pos = player:getPos()
    if SnapFloor then
        NewPosBlock = pos:floor()
    else
        NewPosBlock = vec(math.floor(pos.x), math.round(pos.y), math.floor(pos.z))
    end

    if OldPosBlock == NewPosBlock then
        StillTimer = StillTimer + 1
    else
        StillTimer = 0
    end

    Snap = StillTimer >= 20

    function Snapping()
        if Snap then
            if NewPosBlock ~= OldPosBlock and StillTimer >= 5 then
                StillTimer = 0
                return
            end

            models.model:setParentType("WORLD")
            if SnapFloor then
                BlockPos = vec(math.floor(pos.x)*16 + 8, math.floor(pos.y)*16, math.floor(pos.z)*16 + 8)
            else
                BlockPos = vec(math.floor(pos.x)*16 + 8, math.round(pos.y)*16, math.floor(pos.z)*16 + 8)
            end
            models.model:setPos(BlockPos)

            if Popped == false then
                sounds:playSound("minecraft:ui.button.click", player:getPos(), 1, 2, false)
                Popped = true
            end
        else
            models.model:setParentType("None")
            models.model:setPos(0, 0, 0)
            Popped = false
        end
    end
    Snapping()

    OldPosBlock = NewPosBlock

    function SyncTick()
        Tick = Tick + 1
        if Tick < 200 then return end
        if not host:isHost() then return end
        Sync()
        Tick = 0
    end
    SyncTick()
end

-- helpers

function PrintState(string, state)
    function State(bool)
        if bool then return "§aEnabled" else return "§cDisabled" end
    end
    print(string .. ": " .. (State(state)))
end

-- ping inbetweens

function Sync()
    pings.sync(SnapFloor)
end

function ToggleSnap()
    SnapFloor = not SnapFloor
    config:save("SnapFloor", SnapFloor)
    Sync()
    PrintState("Lower Snapping", SnapFloor)
end

-- pings

function pings.sync(SnapFloorState)
    SnapFloor = SnapFloorState
end