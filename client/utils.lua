
function SpawnLightbar(light, coords, heading)

    local lightbar = light.spawn_code
    local name = light.label

    if not IsModelInCdimage(lightbar) then return end
	RequestModel(lightbar)
	while not HasModelLoaded(lightbar) do Wait(0) end
	lightbarCar = CreateVehicle(lightbar, GetEntityCoords(vehicle), GetEntityHeading(vehicle), true, false)
	SetModelAsNoLongerNeeded(lightbar)
    SetEntityCollision(lightbarCar, false, false)
    SetVehicleDoorsLocked(lightbarCar, 2)
    SetEntityAsMissionEntity(lightbarCar, true, true)

    for i = 0, 20 do
        if DoesExtraExist(lightbarCar, i) then 
            SetVehicleExtra(lightbarCar, i, 1)
        end 
    end 

    for k,v in pairs(Config.Lightbars) do 
        if v.label == name then 
            local extras = v.extras
            for o,i in pairs(extras) do 
                if DoesExtraExist(lightbarCar, i) then 
                    SetVehicleExtra(lightbarCar, i, 0)
                end 
            end 

            local door = v.sign 
            if door == true then 
                SetVehicleDoorOpen(lightbarCar, 4, false, true)

            end 

        end 
    end 

    return(lightbarCar)
end 

function releaseSound(veh, soundId, forced)
    if forced and (DoesEntityExist(veh) and not IsEntityDead(veh)) then return end
    StopSound(soundId)
    ReleaseSoundId(soundId)
    return true
end
