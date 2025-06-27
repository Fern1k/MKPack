ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback("mk:checkUbezpieczenia", function(src, cb)
    local result = {
        caroc = false,
        med = false
    }
    TriggerEvent("esx_license:checkLicense", src, "caroc", function(res)
        result.caroc = res
    end)
    TriggerEvent("esx_license:checkLicense", src, "med", function(res)
        result.med = res
    end)
    Wait(500)
    cb(result)
end)

RegisterServerEvent("mk:buyLicense", function(licka)
    local xPlayer = ESX.GetPlayerFromId(source)
    if licka == "caroc" then 
        if xPlayer.getAccount('money').money >= 7000 then
            xPlayer.removeAccountMoney('money', 7000)
            TriggerEvent("esx_license:addLicense", source, "caroc")
        else
            xPlayer.showNotification("Nie posiadasz 7,000$ w gotówce")
        end
    elseif licka == "med" then 
        if xPlayer.getAccount('money').money >= 5000 then
            xPlayer.removeAccountMoney('money', 5000)
            TriggerEvent("esx_license:addLicense", source, "med")
        else
            xPlayer.showNotification("Nie posiadasz 5,000$ w gotówce")
        end
    else
        print("[MK-SECURE] Kolezka chce sobie dodac licke o nazwie", licka)
    end
end)