-- by TheGoodDude#6142

----------------------
-- Figura Functions --
----------------------

function player_init()
	-- vars
	lastHeldItem="minecraft:air"
	heldItemTimer=5

	-- hide vanilla parts
	for key, value in pairs(vanilla_model) do
		value.setEnabled(false)
	end
	
	for key, value in pairs(armor_model) do
		value.setEnabled(false)
	end

	for key, value in pairs(elytra_model) do
		value.setEnabled(false)
	end

	-- animations and visuals
	nameplate.ENTITY.setPos({0,-1,0})

end

function tick()
	-- play walking animation when standing or walking
	if player.getAnimation() == "STANDING" then
		-- start walking when standing
		if animation["walkin"].getPlayState() ~= "PLAYING" then
			animation["walkin"].play()
		end

		-- stop leg pedalling when jumping
		if player.getVelocity().y ~= 0 then
			animation["walkin"].setSpeed(1)
		else
			animation["walkin"].setSpeed(player.getVelocity().getLength() * 10)
		end

	else
		if animation["walkin"].getPlayState ~= "STOPPED" then
			animation["walkin"].stop()
		end
	end

	--make legs go down when jumping upwards
	if player.getVelocity().y <= 0 then
		animation["fall"].stop()
	else
		animation["fall"].play()
	end

	-- hand hiding
	local item=player.getEquipmentItem(1).getType()
    
	if item~= lastHeldItem then
        heldItemTimer=5
        lastHeldItem=item
        if item=="minecraft:air" then
            first_person_model.MAIN_HAND.setEnabled(false)
        end
    end

    if heldItemTimer==0 then
        first_person_model.MAIN_HAND.setEnabled(item~="minecraft:air")
    end

    heldItemTimer=heldItemTimer-1

end

function world_render()
	-- eye stalk rotations
	headXRot = model.MIMIC_HEAD.getRot().x
	headYRot = model.MIMIC_HEAD.getRot().y
	headZRot = model.MIMIC_HEAD.getRot().z

	if headXRot < 0 then
		model.MIMIC_HEAD.BASE.EYES.setRot({-headXRot/3, 0 - headYRot*0.75, headZRot})
	else
		model.MIMIC_HEAD.BASE.EYES.setRot({headXRot/2, 0 - headYRot*0.75, headZRot})
	end

	if headXRot < 0 then
		model.MIMIC_HEAD.BASE.setRot({headXRot,0,0})
	end
	
end