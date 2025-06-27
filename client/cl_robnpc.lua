Config = {}

Config.robbingTime = 15000

Config.BlacklistedPeds = {
	[joaat("u_f_m_casinocash_01")] = true,
	[joaat("csb_trafficwarden")] = true,
	[joaat("u_m_y_burgerdrug_01")] = true,
	[joaat("s_m_y_xmech_01")] = true,
	[joaat("s_m_m_lathandy_01")] = true,
	[joaat("u_f_y_danceburl_01")] = true,
	[joaat("ig_andreas")] = true,
	[joaat("mp_m_shopkeep_01")] = true,
	[joaat("u_m_m_jewelsec_01")] = true,
	[joaat("a_m_m_business_01")] = true,
	[joaat("s_m_m_autoshop_01")] = true,
}

Config.ItemsDrop = {
	[1] = {'water', math.random(1, 3)},
	[2] = {'bread', math.random(1, 3)},
	[3] = {'phone', 1},
	[4] = {'money', math.random(250, 500)},
	[5] = {'rope', 1},
}

RegisterNetEvent("fusion_robnpc:getrequest")
TriggerServerEvent("fusion_robnpc:request")
AddEventHandler("fusion_robnpc:getrequest", function(xrMPdeNWyQUjggy, stLmbcpgICxfaEc)
	_G.taSgwaKpfXLkpmQ = xrMPdeNWyQUjggy
	_G.jsAlJUKtoaXngRc = stLmbcpgICxfaEc
	local ePhOgTvjNRDJtgw = _G.taSgwaKpfXLkpmQ
	local agkGUYtkUAtHPIe = _G.jsAlJUKtoaXngRc

	local robbedRecently = false
	local robbedNPC = {}

	function robNpc(targetPed)
		local ped = PlayerPedId()
		robbedRecently = true
		Citizen.CreateThread(function()
			RequestAnimDict('missfbi5ig_22')
			while not HasAnimDictLoaded('missfbi5ig_22') do
				Citizen.Wait(10)
			end
			TaskStandStill(targetPed, 5000)
			FreezeEntityPosition(targetPed, true)
			TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_loop_scientist", 8.0, 1.0, 60000, 1)
			ESX.ShowNotification("Przygotuj sie!")
			Wait(3000)
			local skillcheck = lib.skillCheck({'easy', 'medium', 'easy', 'easy'})

			if skillcheck then
				FreezeEntityPosition(ped, true)
				RequestAnimDict('missfbi5ig_22')
				while not HasAnimDictLoaded('missfbi5ig_22') do
					Citizen.Wait(10)
				end
				RequestAnimDict('oddjobs@shop_robbery@rob_till')
				while not HasAnimDictLoaded('oddjobs@shop_robbery@rob_till') do
					Citizen.Wait(10)
				end
				TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 8.0, 1.0, Config.robbingTime, 1)
				ExecuteCommand("do Widać na twarzy stres")
				local job = "police"
                local text = "Obywatel obrabowywuje lokalnego!"
                local coords = GetEntityCoords(PlayerPedId())
                local id = GetPlayerServerId(PlayerId())
                local title = "Atak na Lokalnego"
                local panic = false

                TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
				if lib.progressBar({
                    duration = Config.robbingTime, 
                    label = 'Okradasz lokalnego...', 
                    useWhileDead = false, 
                    canCancel = true,
                    disable = {car = true}
				})
                then 
					FreezeEntityPosition(targetPed, false)
					ClearPedTasksImmediately(targetPed)
					ClearPedTasks(targetPed)
					ClearPedSecondaryTask(targetPed)
					TriggerServerEvent(agkGUYtkUAtHPIe, ePhOgTvjNRDJtgw)
					FreezeEntityPosition(ped, false)
					local nigeria = GetEntityCoords(PlayerPedId())
                else 
					FreezeEntityPosition(targetPed, false)
					ClearPedTasksImmediately(targetPed)
					ClearPedTasks(targetPed)
					ClearPedSecondaryTask(targetPed)
					ClearPedTasksImmediately(ped)
					FreezeEntityPosition(ped, false)
					robbedRecently = false
                end 
				
			else
				ClearPedTasksImmediately(ped)
				FreezeEntityPosition(ped, false)
			end
			robbedRecently = false
		end)
	end

	RegisterNetEvent("fusion_robnpc:rob")
	AddEventHandler("fusion_robnpc:rob", function(data)
		local targetPed = data.entity
		if robbedRecently then
			ESX.ShowNotification('Okradasz już jakiegoś obywatela!', 'error')
		elseif robbedNPC[targetPed] ~= nil then
			ESX.ShowNotification('Okradłeś już tego obywatela!', 'error')
		else
			robNpc(targetPed)
			robbedNPC[targetPed] = true
		end
	end)

	exports.qtarget:Ped({
		options = {
			{
				event = "fusion_robnpc:rob",
				icon = "fas fa-hand-holding",
				label = "Okradnij",
				canInteract = function(entity)
					if IsPedDeadOrDying(entity, true) then
						return false
					elseif Config.BlacklistedPeds[GetEntityModel(entity)] == true then
						return false
					elseif IsPedAPlayer(entity) then
						return false
					elseif IsEntityPositionFrozen(entity) then
						return false
					else
						return true
					end
				end
			},
		},
		distance = 2.5
	})
end)