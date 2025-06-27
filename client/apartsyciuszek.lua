function OpenSavedClothesMenu()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}

		for i=1, #dressing, 1 do
			table.insert(elements, {
				label = dressing[i],
				value = i
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fc-apartaments', {
			title    = "Zapisane stroje",
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
					TriggerEvent('skinchanger:loadClothes', skin, clothes)
					TriggerEvent('esx_skin:setLastSkin', skin)

					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
				end, data2.current.value)
			end)
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

AddEventHandler('ciuchy', function()
	OpenSavedClothesMenu()
end)

AddEventHandler('usun', function()
	xd()
end)

function xd()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for i=1, #dressing, 1 do
			table.insert(elements, {label = dressing[i], value = i})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fc-apartaments', {
			title    = ('Usun ubranie'),
			align    = 'left',
			elements = elements,
		}, function(data, menu)
			menu.close()
			TriggerServerEvent('esx_kriss_clotheshop:deleteOutfit', data.current.value)
			ESX.ShowNotification('Poprawnie usunieto stroj')

		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('zapisz', function()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
		title = ('Nazwa stroju')
	}, function(data3, menu3)
		menu3.close()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
		end)
	end, function(data3, menu3)
		menu3.close()
	end)
end)
