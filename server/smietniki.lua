RegisterServerEvent("fusionpack:babkarobipizzkeiwalibabciekonikaprzeszukaniesmietnika")
AddEventHandler("fusionpack:babkarobipizzkeiwalibabciekonikaprzeszukaniesmietnika", function(item)
    if item == "phone" or item == "radio" or item == "handcuffs" then 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, 1)
    else
        DropPlayer(source, "Skurwysynku co mi tu dodajesz itemki przez smietniki frajerze?")
    end

end)