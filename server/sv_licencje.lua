ESX = exports.es_extended:getSharedObject()

-- * GET LICENSE * --
ESX.RegisterServerCallback("hr_licencje:getLicenses", function(source, cb, target)
    local all_licencje = {}
    local completedCount = 0

    for i, k in ipairs(Config.Licenses) do
        TriggerEvent(
            "esx_license:checkLicense",
            target, k,
            function(hasIt)
                if hasIt then
                    table.insert(all_licencje, { license = k, have = true })
                else
                    table.insert(all_licencje, { license = k, have = false })
                end

                completedCount = completedCount + 1
                if completedCount == #Config.Licenses then
                    cb(all_licencje)
                end
            end
        )
    end
end)

-- * UPDATE LICENSE * --
RegisterServerEvent('heidrun:updatelicencji')
AddEventHandler('heidrun:updatelicencji', function(target, data)
    local xTarget = ESX.GetPlayerFromId(target)
    for i, k in ipairs(data) do
        TriggerEvent("esx_license:checkLicense", target, string.lower(k.label), function(hasIt)
            if hasIt then
                if not k.checked then
                    TriggerEvent('esx_license:removeServerLicense', target, string.lower(k.label))
                    xTarget.showNotification("Usunięto ci licencje " .. k.label)
                end
            else
                if k.checked then
                    TriggerEvent('esx_license:addServerLicense', target, string.lower(k.label))
                    xTarget.showNotification("Dodano ci licencje " .. k.label)
                end
            end
        end)
    end
end)
