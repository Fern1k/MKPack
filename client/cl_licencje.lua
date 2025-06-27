ESX = exports.es_extended:getSharedObject()

-- * MANAGE LICENSE * --
RegisterNetEvent('heidrun:zarzadzajlickami')
AddEventHandler('heidrun:zarzadzajlickami', function(data)
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
    ESX.TriggerServerCallback("hr_licencje:getLicenses", function(licenses)
        local licencje = {}
        for i, k in ipairs(licenses) do
            table.insert(licencje,
                { type = 'checkbox', label = string.upper(licenses[i].license), checked = licenses[i].have })
        end
        Citizen.Wait(500)
        local input = lib.inputDialog('Licencje', licencje)
        if not input then return end
        for i, k in ipairs(licencje) do
            if licencje[i].checked ~= input[i] then
                licencje[i].checked = input[i]
            end
        end

        Citizen.Wait(500)
        TriggerServerEvent('heidrun:updatelicencji', target, licencje)
    end, target)
end)


-- * TARGET * -- 
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    print(PlayerData.job.grade_name)
    if PlayerData.job.name == 'police' and PlayerData.job.grade_name == Config.BossName then
        print('powwino dodac')
        exports.ox_target:addGlobalPlayer({
            {
                name = 'zarzadzajlickami',
                icon = 'fa-solid fa-file',
                label = "Zarządzaj Licencjami",
                event = "heidrun:zarzadzajlickami"
            },
        })
    end
end)
