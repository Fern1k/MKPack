local smietniki = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
ESX = exports["es_extended"]:getSharedObject()
local matajmaut = false
CreateThread(function()
    while true do
        if matajmaut then 
            Citizen.Wait(4500)
            matajmaut = false

        end
        Citizen.Wait(2000)
    end
end)

local smietnikidrop = {
    { item = "phone", label = "Telefon" },
    { item = "radio", label = "Krótkofalówke" },
    { item = "handcuffs", label = "Kajdanki" },
}

function OtworzSmietnik()
    FreezeEntityPosition(PlayerPedId(), true)
    if lib.progressBar({
        duration = 5000, 
        label = 'Przeszukujesz śmietnik', 
        useWhileDead = false, 
        canCancel = true,
        disable = {car = false,}, 
        anim = {dict = 'amb@prop_human_bum_bin@base', clip = 'base'}})
    -- })
    then 
        FreezeEntityPosition(PlayerPedId(), false)
        local niger = math.random(0, 1)
        if (niger == 1) then 
            local isaidnigga = smietnikidrop[math.random(#smietnikidrop)]
            ESX.ShowNotification("Znalazłeś " .. isaidnigga.label, "success")
            TriggerServerEvent("fusionpack:babkarobipizzkeiwalibabciekonikaprzeszukaniesmietnika", isaidnigga.item)
            matajmaut = true 
        else
            ESX.ShowNotification("Nic nie znaleziono", "error")
            matajmaut = true 
        end
        
        
    else 
        FreezeEntityPosition(PlayerPedId(), false)
        ESX.ShowNotification("Przestałeś przeszukiwać śmietnik", "error")
        matajmaut = true
    end 
end
exports.ox_target:addModel(smietniki, {
    {
        name = 'smietnik',
        event = 'przeszukajsmietnik',
        icon = 'fa-solid fa-dumpster',
        label = "Przeszukaj śmietnik",
    }
})

RegisterNetEvent("przeszukajsmietnik")
AddEventHandler("przeszukajsmietnik", function()

    if not IsPedInAnyVehicle(PlayerPedId()) then if not matajmaut then  return OtworzSmietnik() else ESX.ShowNotification("Musisz chwile odczekać aby ponownie otworzyć śmietnik", "error")  end else ESX.ShowNotification("Nie możesz przeszukiwać śmietnika będąc w pojeździe", "error") end 
end)


exports('mobilephone', function(data, slot)
	exports.ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('sfphone:showPhone')
		end
	end)
end)
exports('simcard', function(data, slot)
	exports.ox_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("sfphone:simUpdate", data)
		end
	end)
end)