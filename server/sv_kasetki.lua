

lib.callback.register('astro-storerobbery:server:succes', function()
	local money = math.random(2000, 3000)
	exports.ox_inventory:AddItem(source, 'money', money)
end)

lib.callback.register('astro-storerobbery:server:removeItem', function()
	exports.ox_inventory:RemoveItem(source, 'lockpick', 1)
end)


ESX.RegisterServerCallback('getPoliceCount', function(src, cb) -- esx discord
	local policeTable = ESX.GetExtendedPlayers("job", "police")
	local policeCount = 0
  
	for v in pairs(policeTable) do
	  policeCount = policeCount + 1
	end
  
	cb(policeCount)
  end)
