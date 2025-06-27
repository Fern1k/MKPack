local recoils = {
	[`WEAPON_PISTOL`] = {4.2, 5.2}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {4.2, 5.2}, -- PISTOL MK2
	[`WEAPON_COMBATPISTOL`] = {3.5, 4.0}, -- COMBAT PISTOL
	[`WEAPON_APPISTOL`] = {3.5, 4.0}, -- AP PISTOL
	[`WEAPON_STUNGUN`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.1, 1.1}, -- STUN GUN MP
	[`WEAPON_PISTOL50`] = {3.5, 4.0}, -- 50. PISTOL
	[`WEAPON_SNSPISTOL`] = {3.2, 4.2}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {2.7, 3.7}, -- SNS PISTOL MK2
	[`WEAPON_HEAVYPISTOL`] = {2.6, 3.1}, -- HEAVY PISTOL
	[`WEAPON_VINTAGEPISTOL`] = {1.5, 3.0}, -- VINTAGE PISTOL
	[`WEAPON_FLAREGUN`] = {0.9, 1.9}, -- FLARE GUN
	[`WEAPON_MARKSMANPISTOL`] = {0.9, 1.9}, -- MARKSMAN PISTOL
	[`WEAPON_REVOLVER`] = {3.2, 4.2}, -- REVOLVER PISTOL
	[`WEAPON_REVOLVER_MK2`] = {3.2, 4.2}, -- REVOLVER PISTOL MK2
	[`WEAPON_DOUBLEACTION`] = {3.0, 3.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_CERAMICPISTOL`] = {3.0, 3.5}, -- CERAMIC PISTOl
	[`WEAPON_NAVYREVOLVER`] = {3.0, 3.5}, -- NAVY REVOLVER
	[`WEAPON_GADGETPISTOL`] = {3.0, 3.5}, -- GADGET PISTOL
}

local effects = {
	[`WEAPON_PISTOL`] = {0.10, 0.20}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {0.11, 0.22}, -- PISTOL MK2
	[`WEAPON_COMBATPISTOL`] = {0.1, 0.2}, -- COMBAT PISTOL
	[`WEAPON_APPISTOL`] = {0.1, 0.2}, -- AP PISTOL
	[`WEAPON_STUNGUN`] = {0.01, 0.02}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.01, 0.02}, -- STUN GUN MP
	[`WEAPON_PISTOL50`] = {0.1, 0.2}, -- 50. PISTOL
	[`WEAPON_SNSPISTOL`] = {0.08, 0.16}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_HEAVYPISTOL`] = {0.1, 0.2}, -- HEAVY PISTOL
	[`WEAPON_VINTAGEPISTOL`] = {0.06, 0.12}, -- VINTAGE PISTOL
	[`WEAPON_FLAREGUN`] = {0.01, 0.02}, -- FLARE GUN
	[`WEAPON_MARKSMANPISTOL`] = {0.9, 1.9}, -- MARKSMAN PISTOL
	[`WEAPON_REVOLVER`] = {0.1, 0.2}, -- REVOLVER PISTOL
	[`WEAPON_REVOLVER_MK2`] = {0.1, 0.2}, -- REVOLVER PISTOL MK2
	[`WEAPON_DOUBLEACTION`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_CERAMICPISTOL`] = {0.08, 0.16}, -- CERAMIC PISTOl
	[`WEAPON_NAVYREVOLVER`] = {0.1, 0.2}, -- NAVY REVOLVER
	[`WEAPON_GADGETPISTOL`] = {0.1, 0.2}, -- GADGET PISTOL
}

CreateThread(function()
	while true do
		Citizen.Wait(9)
		DisplayAmmoThisFrame(false)

		local ped = PlayerPedId()
		if DoesEntityExist(ped) then
			local status, weapon = GetCurrentPedWeapon(ped, true)
			if status == 1 then
				if weapon == `WEAPON_FIREEXTINGUISHER` then
					Citizen.InvokeNative(0x3EDCB0505123623B, ped, true, `WEAPON_FIREEXTINGUISHER`)
				elseif IsPedShooting(ped) then
					local inVehicle = IsPedInAnyVehicle(ped, false)

					local effect = effects[weapon]
					if effect and #effect > 0 and not LocalPlayer.state.IsAffected and not LocalPlayer.state.IsInjured then
						ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (inVehicle and (effect[1] * 3) or effect[2]))
					end
					
					local recoil = recoils[weapon]
					if recoil and #recoil > 0 then
						local i, tv = (inVehicle and 2 or 1), 0
						if GetFollowPedCamViewMode() ~= 4 then
							repeat
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
								tv = tv + 0.1
								Citizen.Wait(0)
							until tv >= recoil[i]
						else
							repeat
								local t = GetRandomFloatInRange(0.1, recoil[i])
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
								tv = tv + t
								Citizen.Wait(0)
							until tv >= recoil[i]
						end
					end
				end
			else
				Citizen.Wait(100)
			end
		end
	end
end)