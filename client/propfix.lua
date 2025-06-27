ESX = exports["es_extended"]:getSharedObject()
local wait = false


RegisterCommand("propfix", function()
    local ped = PlayerPedId()
    local hp = GetEntityHealth(ped)
    if hp > 0 then
    	if not IsPedInAnyVehicle(ped, false) then
            if not wait then
                wait = true
                local model = GetEntityModel(ped)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetPedDefaultComponentVariation(ped)
                TriggerEvent('skinchanger:getSkin', function(result)
                TriggerEvent('skinchanger:loadSkin', result)
                TriggerEvent('esx:restoreLoadout')
                end)

                Citizen.CreateThread(function()
                    Citizen.Wait(100)
                    SetEntityHealth(PlayerPedId(), hp)
                    Citizen.Wait(10000)
                    wait = false
                end)    
            else
                ESX.ShowNotification('Nie możesz używac tej komendy tak często')
            end
        else
            ESX.ShowNotification('Nie możesz używac tej komendy będąc w pojeździe')
        end
    else
        ESX.ShowNotification('Nie możesz używac tej komendy na bw')
    end
end)
