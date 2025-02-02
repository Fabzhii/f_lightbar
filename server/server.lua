
local locales = Config.Locales[Config.Language]

ESX.RegisterCommand({Config.Menu.command}, 'user', function(xPlayer, args, showError)
    for k,v in pairs(Config.Menu.jobs) do 
        if v == xPlayer.getJob().name then 
            TriggerClientEvent('flightbar:openMainMenu', xPlayer.source)
        end 
    end 
  end, false, {help = Config.Menu.help})

RegisterServerEvent('flightbar:resetStateBags')
AddEventHandler('flightbar:resetStateBags', function(lightId, vehId, xPos, yPos, zPos, xRot, yRot, zRot, lightbarModel)
    local vehicle = NetworkGetEntityFromNetworkId(vehId)

    local lightbars = Entity(vehicle).state.lightbars or {}
    table.insert(lightbars, {
        entity = lightId,
        xPos = xPos,
        yPos = yPos,
        zPos = zPos,
        xRot = xRot,
        yRot = yRot,
        zRot = zRot,
        model = lightbarModel,
    })

    Entity(vehicle).state:set('addLights', true, true)
	Entity(vehicle).state:set('sirenMode', 0, true)
	Entity(vehicle).state:set('horn', false, true)
	Entity(vehicle).state:set('lightsOn', false, true)
    Entity(vehicle).state:set('lightbars', lightbars, true)
end)

RegisterServerEvent('flightbar:saveLights')
AddEventHandler('flightbar:saveLights', function(plate, lightbars)
    MySQL.Async.execute('UPDATE owned_vehicles SET lightbar = @lightbar WHERE plate = @plate', {
        ['@lightbar']  = json.encode(lightbars),
        ['@plate'] = plate,
    })
end)    

ESX.RegisterServerCallback('flightbar:getLights', function(source, cb, plate)

    print(plate)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['plate'] = plate, 
    }, function(data)
        cb(data[1].lightbar)
    end)
end)

