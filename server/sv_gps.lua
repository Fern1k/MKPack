
ESX = exports.es_extended:getSharedObject()

local Config = {
	['police'] = {
		label = 'LSPD',
		color = 3,
	},
	['ambulance'] = {
		label = 'EMS',
		color = 1
	},
	['mechanic'] = {
		label = 'LSC',
		color = 58
	},

}

local blips = {}

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	local xPlayer = ESX.GetPlayerFromId(playerId) 
	if xPlayer ~= nil then
		if Config[job.name] and not Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			if item and item.count >= 1 then
				if not blips[playerId] then
					if xPlayer ~= nil then
						local data = Config[job.name]
						if data then
							local playerPed = GetPlayerPed(playerId)
							local badge = json.decode(xPlayer.variables.job_id)
							if not badge.id then
								badge.id = 0
							end
							local grade = xPlayer.job.grade_label
							if data then
								local unit = data.label
								local colorek = data.color
								blips[playerId] = {
									text = '['..unit..'] ['..badge.id..'] '.. xPlayer.getName() ..' - '..grade,
									badge = badge.id,
									color = colorek,
									coords =  GetEntityCoords(playerPed),
									heading = GetEntityHeading(playerPed)
								}
							end
						end
					end
				end	
			end
		elseif not Config[job.name] and Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			if item.name == 'gps' then
				if blips[playerId] then
					blips[playerId] = nil
					TriggerClientEvent('punch_gps:cleanup', playerId)	
					for k, v in pairs(blips) do
						TriggerClientEvent('punch_gps:removeGPSForID', k, playerId)
					end
				end
			end
		elseif Config[job.name] and Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			if item and item.count >= 1 then
				if not blips[playerId] then
					if xPlayer ~= nil then
						local data = Config[job.name]
						if data then
							local playerPed = GetPlayerPed(playerId)
							local badge = exports.radiolist:GetPlayerBadge(xPlayer.source)
							if not badge then
								badge = 0
							end
							local grade = xPlayer.job.grade_label
							if data then
								local unit = data.label
								local colorek = data.color
								blips[playerId] = {
									text = '['..unit..'] ['..badge..'] '.. xPlayer.getName() ..' - '..grade,
									badge = badge,
									color = colorek,
									coords =  GetEntityCoords(playerPed),
									heading = GetEntityHeading(playerPed)
								}
							end
						end
					end
				end	
			end	
		end
	end
end)

RegisterNetEvent("punch_gps:gpsaction", function(type)
	local playerId = source
	if type == 'add' then
		if not blips[playerId] then
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer ~= nil then
				local data = Config[xPlayer.job.name]
				if data then
					local playerPed = GetPlayerPed(playerId)
					local badge = json.decode(xPlayer.variables.job_id)
					if not badge.id then
						badge.id = 0
					end
					local grade = xPlayer.job.grade_label
					if data then
						local unit = data.label
						local colorek = data.color
						blips[playerId] = {
							text = '['..unit..'] ['..badge.id..'] '..xPlayer.variables.firstname..' '..xPlayer.variables.lastname..' - '..grade,
							badge = badge.id,
							color = colorek,
							coords =  GetEntityCoords(playerPed),
							heading = GetEntityHeading(playerPed)
						}
					end
				end
			end
		end
	elseif type == 'remove' then
		if blips[playerId] then
			blips[playerId] = nil
			TriggerClientEvent('punch_gps:cleanup', playerId)
			for k, v in pairs(blips) do
				TriggerClientEvent('punch_gps:removeGPSForID', k, playerId)
			end
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	if blips[playerId] then
		blips[playerId] = nil
		for k, v in pairs(blips) do
			TriggerClientEvent('punch_gps:removeGPSForID', k, playerId)
		end
	end
end)

CreateThread(function()
	while true do
		for playerId, data in pairs(blips) do
			local playerPed = GetPlayerPed(playerId)
			if playerPed then
				data.coords = GetEntityCoords(playerPed)
				data.heading = GetEntityHeading(playerPed)
			end
		end
		for playerId, data in pairs(blips) do
			TriggerClientEvent('punch_gps:updateBlip', playerId, blips)
		end
		Citizen.Wait(1000)
	end
end)