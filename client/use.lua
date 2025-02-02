
-- Teil dieses Codes stammt aus Renewed-Sirensync von Renewed, lizenziert unter der MIT License.
-- Siehe: https://github.com/Renewed-Scripts/Renewed-Sirensync

local sirenVehicles = {}
local hornVehicles = {}

local horn = Config.Sirens['2'].horn
local siren1 = Config.Sirens['2'].siren1
local siren2 = Config.Sirens['2'].siren2
local siren3 = Config.Sirens['2'].siren3

RegisterCommand('setsiren', function(source, args, rawCommand)
    local siren = tostring(args[1])

    horn = Config.Sirens[siren].horn
    siren1 = Config.Sirens[siren].siren1
    siren2 = Config.Sirens[siren].siren2
    siren3 = Config.Sirens[siren].siren3
end)

CreateThread(function()
    while true do
        for veh, soundId in pairs(sirenVehicles) do
            if releaseSound(veh, soundId, true) then
                sirenVehicles[veh] = nil
            end
        end

        for veh, soundId in pairs(hornVehicles) do
            if releaseSound(veh, soundId, true) then
                hornVehicles[veh] = nil
            end
        end

        Wait(1000)
    end
end)

lib.onCache('seat', function(seat)
    if seat ~= -1 then return end
    if not IsPedInAnyVehicle(PlayerPedId(), false) then return end
    if not Entity(cache.vehicle).state.addLights then return end 
    inAddonLightbarCar()
end)

function inAddonLightbarCar()
    SetVehRadioStation(cache.vehicle, 'OFF')
    SetVehicleRadioEnabled(cache.vehicle, false)

    while GetPedInVehicleSeat(cache.vehicle, -1) == PlayerPedId() do
        DisableControlAction(0, 80, true) -- R
        DisableControlAction(0, 81, true) -- .
        DisableControlAction(0, 82, true) -- ,
        DisableControlAction(0, 83, true) -- =
        DisableControlAction(0, 84, true) -- -
        DisableControlAction(0, 85, true) -- Q
        DisableControlAction(0, 86, true) -- E
        DisableControlAction(0, 172, true) -- Up arrow
        Wait(0)
    end
end

local function stateBagWrapper(keyFilter, cb)
    return AddStateBagChangeHandler(keyFilter, '', function(bagName, _, value, _, replicated)
        local netId = tonumber(bagName:gsub('entity:', ''), 10)

        local loaded = netId and lib.waitFor(function()
            if NetworkDoesEntityExistWithNetworkId(netId) then return true end
        end, 'Timeout while waiting for entity to exist', 5000)

        local entity = loaded and NetToVeh(netId)

        if entity then
            local amOwner = NetworkGetEntityOwner(entity) == cache.playerId

            if amOwner == replicated then
                cb(entity, value)
            end
        end
    end)
end

stateBagWrapper('lightsOn', function(veh, value)
    local lightbars = Entity(veh).state.lightbars or {}
    for k,v in pairs(lightbars) do 
        local veh = NetworkGetEntityFromNetworkId(v.entity)
        SetVehicleHasMutedSirens(veh, true)
        SetVehicleSiren(veh, value)
    end 
end)

local policeLights = lib.addKeybind({
    name = 'policeLights',
    description = 'policeLights',
    defaultKey = Config.Controls.PoliceLights,
    onPressed = function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if not Entity(cache.vehicle).state.addLights then return end 
        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

        local state = Entity(cache.vehicle).state
        local curMode = state.lightsOn
        state:set('lightsOn', not curMode, true)
        if not curMode or state.sirenMode == 0 then return end
        state:set('sirenMode', 0, true)
    end
})

local restoreSiren = 0
stateBagWrapper('horn', function(veh, value)
    local relHornId = hornVehicles[veh]

    if relHornId then
        if releaseSound(veh, relHornId) then
            hornVehicles[veh] = nil
        end
    end

    if not value then return end
    local soundId = GetSoundId()
    hornVehicles[veh] = soundId
    PlaySoundFromEntity(soundId, horn.string, veh, horn.ref, false, 0)
end)

local policeHorn = lib.addKeybind({
    name = 'policeHorn',
    description = 'policeHorn',
    defaultKey = Config.Controls.policeHorn,
    onPressed = function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if not Entity(cache.vehicle).state.addLights then return end 

        local state = Entity(cache.vehicle).state
        if state.sirenMode == 0 then
            restoreSiren = state.sirenMode
            state:set('sirenMode', 0, true)
        end

        state:set('horn', not state.horn, true)
    end,
    onReleased = function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if not Entity(cache.vehicle).state.addLights then return end 

        local state = Entity(cache.vehicle).state
        SetTimeout(0, function()
            if state.horn then
                state:set('horn', false, true)
            end

            if state.lightsOn and state.sirenMode == 0 and restoreSiren > 0 then
                state:set('sirenMode', restoreSiren, true)
                restoreSiren = 0
            end
        end)
    end,
})

stateBagWrapper('sirenMode', function(veh, soundMode)
    local usedSound = sirenVehicles[veh]

    if usedSound then
        if releaseSound(veh, usedSound) then
            sirenVehicles[veh] = nil
        end
    end

    if soundMode == 0 or not soundMode then return end

    local soundId = GetSoundId()
    sirenVehicles[veh] = soundId

    if soundMode == 1 then
        PlaySoundFromEntity(soundId, siren1.string, veh, siren1.ref, false, 0)
    elseif soundMode == 2 then
        PlaySoundFromEntity(soundId, siren2.string, veh, siren2.ref, false, 0)
    elseif soundMode == 3 then
        PlaySoundFromEntity(soundId, siren3.string, veh, siren3.ref, false, 0)
    end
end)

local sirenToggle = lib.addKeybind({
    name = 'sirenToggle',
    description = 'sirenToggle',
    defaultKey = Config.Controls.sirenToggle,
    onPressed = function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then return end 
        if not Entity(cache.vehicle).state.addLights then return end 
        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

        local state = Entity(cache.vehicle).state
        if not state.lightsOn or state.horn then return end
        local newSiren = state.sirenMode > 0 and 0 or 1
        state:set('sirenMode', newSiren, true)
    end
})

local Rpressed = false
lib.addKeybind({
    name = 'sirenCycle',
    description = 'sirenCycle',
    defaultKey = Config.Controls.sirenCycle,
    onPressed = function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if not Entity(cache.vehicle).state.addLights then return end 
        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
        local state = Entity(cache.vehicle).state

        if state.sirenMode == 0 and not Rpressed then
            local sirenMode = state.sirenMode > 0 and 0 or 1
            state:set('sirenMode', sirenMode, true)
            sirenToggle:disable(true)
            policeLights:disable(true)
            policeHorn:disable(true)
            Rpressed = true
        elseif state.sirenMode > 0 and state.lightsOn and not Rpressed then
            local newSiren = state.sirenMode + 1 > 3 and 1 or state.sirenMode + 1
            state:set('sirenMode', newSiren, true)
        end
    end,
    onReleased = function()
        if not Rpressed then return end
        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

        sirenToggle:disable(false)
        policeLights:disable(false)
        policeHorn:disable(false)

        if cache.vehicle then
            SetTimeout(0, function()
                local state = Entity(cache.vehicle).state
                if state.sirenMode > 0 then
                    state:set('sirenMode', 0, true)
                end
                Rpressed = false
            end)
        end
        
    end
})