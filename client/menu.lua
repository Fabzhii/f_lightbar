
local locales = Config.Locales[Config.Language]

RegisterNetEvent('flightbar:openMainMenu')
AddEventHandler('flightbar:openMainMenu', function()
    exports[GetCurrentResourceName()]:openMainMenu()
end)

exports('openMainMenu', function()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, flase) then return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return end

    options = {
        {
            title = locales['menu'].add_lights,
            description = locales['menu'].add_lights_desc,
            icon = 'plus',
            onSelect = function()
                addLights(vehicle)
            end,
        },
        {
            title = locales['menu'].del_lights,
            description = locales['menu'].del_lights_desc,
            icon = 'trash',
            onSelect = function()
                local lightbars = Entity(vehicle).state.lightbars 
                for k,v in pairs(lightbars) do 
                    DeleteVehicle(NetworkGetEntityFromNetworkId(v.entity))
                end 
                Entity(vehicle).state:set('addLights', false, true)
                Entity(vehicle).state:set('sirenMode', 0, true)
                Entity(vehicle).state:set('horn', false, true)
                Entity(vehicle).state:set('lightsOn', false, true)
                Entity(vehicle).state:set('lightbars', {}, true)
            end,
        },
        {
            title = locales['menu'].save_lights,
            description = locales['menu'].save_lights_desc,
            icon = 'floppy-disk',
            onSelect = function()
                saveLights(vehicle)
            end,
        },
    }

    local lightbars = Entity(vehicle).state.lightbars or {}
    for k,v in pairs(lightbars) do 
        for o,i in pairs(Config.Lightbars) do 
            if v.model == o and i.sign == true then 
                print(json.encode(v))
                print(json.encode(i))
                local vehicle = NetworkGetEntityFromNetworkId(v.entity)
                table.insert(options, {
                    title = locales['menu'].board,
                    description = locales['menu'].board_desc,
                    icon = 'floppy-disk',
                    onSelect = function()
                        editSign(vehicle)
                    end,
                })
            end 
        end 
    end 
    

    lib.registerContext({
        id = 'f_lightbar_main',
        title = locales['menu'].header,
        options = options,
    })
    lib.showContext('f_lightbar_main')
end)

function addLights(vehicle)
    local inCreationMenu = true 
    local lightbarModel = 1
    local xPos, yPos, zPos, xRot, yRot, zRot = 0.0, 0.0, 1.0, 0.0, 0.0, 0.0
    local moveSpeed = 1
    local rotSpeed = 1

    local lightbarCar = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))
    local clone = nil

    Citizen.CreateThread(function()
        while inCreationMenu do 
            Citizen.Wait(1)

            DisableControlAction(0, 71, true)
            DisableControlAction(0, 72, true)
            DisableControlAction(0, 86, true)

            local lightbarLabel = (Config.Lightbars)[lightbarModel].label
            lib.notify({
                id = 'f_lights_setting',
                title = locales['add_lights_settings_header'],
                description = (locales['add_lights_settings']):format(lightbarLabel, moveSpeed, xPos, yPos, zPos, zRot, ((clone == nil) and (locales['checkmark']['off']) or (locales['checkmark']['on']))),
                showDuration = false,
                position = 'center-right',
                icon = 'gear',
            })

            lib.notify({
                id = 'f_lights_help',
                title = locales['add_lights_help_header'],
                description = locales['add_lights_help'],
                showDuration = false,
                position = 'center-right',
                icon = '',
            })


            -- exit
            if IsControlJustReleased(0, 177) then 
                inCreationMenu = false 
                DeleteVehicle(lightbarCar)
                if clone ~= nil then 
                    DeleteVehicle(clone)
                end 
            end 

            -- switching lights
            if IsControlJustReleased(0, 208) then 
                if lightbarModel < #Config.Lightbars then 
                    lightbarModel = lightbarModel + 1

                    DeleteVehicle(lightbarCar)
                    lightbarCar = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))

                    if clone ~= nil then 
                        DeleteVehicle(clone)
                        clone = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))
                    end 
                end 
            end 
            if IsControlJustReleased(0, 207) then 
                if lightbarModel > 1 then 
                    lightbarModel = lightbarModel - 1

                    DeleteVehicle(lightbarCar)
                    lightbarCar = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))

                    if clone ~= nil then 
                        DeleteVehicle(clone)
                        clone = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))
                    end 
                end 
            end 

            -- changing speed
            if IsDisabledControlJustReleased(0, 38) then 
                if moveSpeed < 10 then 
                    moveSpeed = moveSpeed + 1
                end 
            end 
            if IsDisabledControlJustReleased(0, 85) then 
                if moveSpeed > 1 then 
                    moveSpeed = moveSpeed - 1
                end 
            end 

            -- changing position
            if IsDisabledControlJustReleased(0, 71) then 
                yPos = yPos + Config.MoveSpeed[tostring(moveSpeed)]
            end 
            if IsDisabledControlJustReleased(0, 72) then 
                yPos = yPos - Config.MoveSpeed[tostring(moveSpeed)]
            end 
            if IsDisabledControlJustReleased(0, 133) then 
                xPos = xPos + Config.MoveSpeed[tostring(moveSpeed)]
            end 
            if IsDisabledControlJustReleased(0, 134) then 
                xPos = xPos - Config.MoveSpeed[tostring(moveSpeed)]
            end 
            if IsDisabledControlJustReleased(0, 172) then 
                zPos = zPos + Config.MoveSpeed[tostring(moveSpeed)]
            end 
            if IsDisabledControlJustReleased(0, 173) then 
                zPos = zPos - Config.MoveSpeed[tostring(moveSpeed)]
            end 

            -- changing rotation
            if IsControlJustReleased(0, 174) then 
                zRot = zRot - Config.RotationSpeed[tostring(moveSpeed)]
            end 
            if IsControlJustReleased(0, 175) then 
                zRot = zRot + Config.RotationSpeed[tostring(moveSpeed)]
            end 

            -- cloning lightbar
            if IsControlJustReleased(0, 102) then 
                if clone == nil then 
                    clone = SpawnLightbar((Config.Lightbars)[lightbarModel], GetEntityCoords(vehicle), GetEntityHeading(vehicle))
                else 
                    DeleteVehicle(clone)
                    clone = nil
                end 
            end 

            if IsControlJustReleased(0, 176) then 
                inCreationMenu = false 
                attachLights(lightbarCar, vehicle, xPos, yPos, zPos, xRot, yRot, zRot, lightbarModel)
                if clone ~= nil then 
                    attachLights(clone, vehicle, ((-1) * xPos), yPos, zPos, xRot, yRot, zRot, lightbarModel)
                end 
                inAddonLightbarCar()
            end 

            if clone ~= nil then 
                AttachEntityToEntity(clone, vehicle, 0, ((-1) * xPos), yPos, zPos, xRot, yRot, ((-1) * zRot), true, true, true, true, false, true)
            end 
            AttachEntityToEntity(lightbarCar, vehicle, 0, xPos, yPos, zPos, xRot, yRot, zRot, true, true, true, true, false, true)
        end 
    end) 
end 

function attachLights(lightbarCar, vehicle, xPos, yPos, zPos, xRot, yRot, zRot, lightbarModel)
    TriggerServerEvent('flightbar:resetStateBags', NetworkGetNetworkIdFromEntity(lightbarCar), NetworkGetNetworkIdFromEntity(vehicle), xPos, yPos, zPos, xRot, yRot, zRot, lightbarModel)
end 

function saveLights(vehicle)

    lib.registerContext({
        id = 'f_lightbar_save',
        title = locales['menu'].header,
        options = {
            {
                title = locales['menu'].save_lights,
                description = locales['menu'].save_lights_desc,
                icon = 'floppy-disk',
                onSelect = function()
                    local save = {}
                    local lightbars = Entity(vehicle).state.lightbars
                    for k,v in pairs(lightbars) do 
                        table.insert(save, {
                            xPos = v.xPos,
                            yPos = v.yPos,
                            zPos = v.zPos,
                            xRot = v.xRot,
                            yRot = v.yRot,
                            zRot = v.zRot,
                            model = v.model,
                        })
                    end 
                    TriggerServerEvent('flightbar:saveLights', GetVehicleNumberPlateText(vehicle), save)
                end,
            },
            {
                title = locales['menu'].place_plate,
                description = locales['menu'].place_plate_desc,
                icon = 'download',
                onSelect = function()
                    ESX.TriggerServerCallback('flightbar:getLights', function(xLights)

                        local lightbar = json.decode(xLights)
                        for k,v in pairs(lightbar) do 

                            local spawn = (Config.Lightbars)[(v.model)]
                            local lightbarCar = SpawnLightbar(spawn, GetEntityCoords(vehicle), GetEntityHeading(vehicle))
                            AttachEntityToEntity(lightbarCar, vehicle, 0, v.xPos, v.yPos, v.zPos, v.xRot, v.yRot, v.zRot, true, true, true, true, false, true)
                            attachLights(lightbarCar, vehicle, v.xPos, v.yPos, v.zPos, v.xRot, v.yRot, v.zRot, v.model)

                        end 


                    end, GetVehicleNumberPlateText(vehicle))
                end,
            },
        }
    })
    lib.showContext('f_lightbar_save')

end 

function editSign(sign)

    lib.registerContext({
        id = 'f_lightbar_save',
        title = locales['menu'].header,
        options = {
            {
                title = locales['menu'].edit_board,
                description = locales['menu'].edit_board_desc,
                icon = 'laptop',
                onSelect = function()
                    if GetVehicleDoorAngleRatio(sign, 4) > 0.2 then 
                        SetVehicleDoorShut(sign, 4, true)
                    else
                        SetVehicleDoorOpen(sign, 4, false, true)
                    end
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_1,
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 1, 0)
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_2,
                
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 2, 0)
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_3,
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 3, 0)
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_4,
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 4, 0)
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_5,
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 5, 0)
                    editSign(sign)
                end,
            },
            {
                title = locales['menu'].board_6,
                description = locales['menu'].board_edit,
                icon = 'sign-hanging',
                onSelect = function()
                    for i = 0, 8 do
                        if DoesExtraExist(sign, i) then 
                            SetVehicleExtra(sign, i, 1)
                        end 
                    end 
                    SetVehicleExtra(sign, 6, 0)
                    editSign(sign)
                end,
            },
        }
    })
    lib.showContext('f_lightbar_save')

end