local SERVER_TOKEN = "fusion_robnpc:token:"..math.random(99999, 9999999999)
local REWARD_TRIGGER = "fusion_robnpc:giveReward:"..math.random(99999, 9999999999)

RegisterNetEvent(REWARD_TRIGGER)
AddEventHandler(REWARD_TRIGGER, function(token)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if SERVER_TOKEN == token then
		local money = math.random(200, 800)
		exports.ox_inventory:AddItem(_source, 'money', money)
		TriggerClientEvent('esx:showNotification', _source, 'Ukradłeś ' .. money .. "$ ", "success")
		
	else
	end
end)

local recived_token_robnpc = {}
RegisterNetEvent('fusion_robnpc:request')
AddEventHandler('fusion_robnpc:request', function()
	if not recived_token_robnpc[source] then
		TriggerClientEvent("fusion_robnpc:getrequest", source, SERVER_TOKEN, REWARD_TRIGGER)
		recived_token_robnpc[source] = true
	else
	end
end)

AddEventHandler('playerDropped', function()
	recived_token_robnpc[source] = nil
end)