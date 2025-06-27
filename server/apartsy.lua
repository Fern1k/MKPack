ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterServerCallback('kriss:getPropertyInventory', function(source, cb)
    local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = 0
	local items      = {}

	TriggerEvent('esx_addoninventory:getInventory', 'nigger', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

RegisterServerEvent('esx_kriss_clotheshop:deleteOutfit')
AddEventHandler('esx_kriss_clotheshop:deleteOutfit', function(label)

    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

        local dressing = store.get('dressing')

        if dressing == nil then
            dressing = {}
        end

        label = label
        
        table.remove(dressing, label)

        store.set('dressing', dressing)

    end)

end)


