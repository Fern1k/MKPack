ESX = exports["es_extended"]:getSharedObject()



ESX.RegisterServerCallback('fusion_lombard:getplayeritemcount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(item).count
    if count then
        cb(count)
    else
        cb(0)
    end
    cb(0)
end)


RegisterServerEvent("fusion_lombard:requestsellitem")
AddEventHandler("fusion_lombard:requestsellitem", function(item, price, quantity)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local cash = price * quantity -- Prosta matematyka, niestety dla GLN to za duzo
	local itemname = ESX.GetItemLabel(item)

    if xPlayer ~= nil then

    xPlayer.addMoney(price * quantity)
    xPlayer.removeInventoryItem(item, quantity)
    xPlayer.showNotification("Sprzedałeś "..quantity.."x "..itemname.." za "..cash.."$", "success")
    end
end)

