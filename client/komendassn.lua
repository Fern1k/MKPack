ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("pesel", function()
    ESX.TriggerServerCallback('fusionpack:getssn', function(ssnik)
        ESX.ShowNotification("Twój ssn to: " .. ssnik, "success")
    end, PlayerId())
end)

RegisterCommand("pokazpesel", function()
    local entitycoords = GetEntityCoords(PlayerPedId())
    local targecik = ESX.Game.GetClosestPlayer(entitycoords)
    if targecik ~= -1 then 
        TriggerServerEvent("fusionpack:showssn", targecik)
    else
        ESX.ShowNotification("Nie ma nikogo w pobliżu", "error")
    end
    
end)