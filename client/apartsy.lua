local ox_inventory = exports.ox_inventory
ESX = exports["es_extended"]:getSharedObject()

CreateThread(function ()
    exports.qtarget:AddBoxZone("drzwiwyjsciowe",vector3(48.32, -973.84, -93.49), 2, 2, { -- -93.49
        name = "drzwiwyjsciowe",
        heading = 0,
        minZ = -91.49,
        maxZ = -95.49,
    }, {
		options = {
			{
				event = "wyjdz",
				icon = "fa-solid fa-door-open",
				label = "Wyjdz",
			},
		},
		distance = 1.5
})

end)

CreateThread(function()
    exports.qtarget:AddBoxZone("drzwiwejsciowe",vector3(-270.43-1, -958.55, 31.22), 2, 2, {
        name = "drzwiwejsciowe",
        heading = 25,
        minZ = 30.22,
        maxZ = 34.22
    }, {
		options = {
			{
				event = "wejdz",
				icon = "fa-solid fa-door-open",
				label = "Wejdz",
			},
		},
		distance = 1.5
      })
    
end)

CreateThread(function ()
	exports.qtarget:AddBoxZone("szafka",vector3(48.7, -981.1, -90.62), 1, 1, {
		name = "szafka",
		heading = 0,
		minZ = -89,
		maxZ = -92.62
	}, {
		options = {
			{
				event = "eloszafka",
				icon = "fa-solid fa-list",
				label = "Szafka z przedmiotami",
			},
			{
				event = "fivem-appearance:browseOutfits",
				icon = "fa-solid fa-shirt",
				label = "Szafka z ciuchami",
			},
			{
				event = "fivem-appearance:saveOutfit",
				icon = "fa-solid fa-clipboard",
				label = "Zapisz ciuchy",
			},
			{
				event = "fivem-appearance:deleteOutfitMenu",
				icon = "fa-solid fa-clipboard",
				label = "Usun ciuchy",
			},
		},
		distance = 1.5
      })
end)

AddEventHandler('wyjdz', function()
	local playerPed = PlayerPedId()
	ESX.Game.Teleport(playerPed, {x = -270.60, y = -958.10, z = 31.21-1, heading = 100.0}, function() -- 48.39 -974.04 -93.49
		Citizen.CreateThread(function()
			SetEntityVisible(playerPed, true)
			while true do
				Citizen.Wait(0)
				SetEntityLocallyVisible(playerPed)
			end
			end)
		end)
	end)

AddEventHandler('wejdz', function()
	local playerPed = PlayerPedId()
	ESX.Game.Teleport(playerPed, {x = 50, y = -977, z = -95, heading = 100.0}, function() --
		Citizen.CreateThread(function()
			SetEntityVisible(playerPed, false)
			while true do
				Citizen.Wait(0)
		
				SetEntityLocallyVisible(playerPed)
			end
		end)
	end)
end)

RegisterNetEvent('eloszafka', function(identifier, lockername)
	ESX.TriggerServerCallback('kriss:getPropertyInventory', function(inventory)
		ox_inventory:openInventory("stash",  {id = "nigger", owner = identifier, lockername})
	end, identifier, lockername)
end)
