-- Użycie przedmiotu "klucze"
ESX.RegisterUsableItem('klucze', function(source)
    TriggerClientEvent('ls:useKeys', source)
end)

-- Dodawanie klucza do gracza
RegisterNetEvent("ls:addKeys")
AddEventHandler("ls:addKeys", function(plate)
    local src = source
    local lowerPlate = tostring(string.lower(plate))
    local metadata = { plate = lowerPlate }

    print(("DEBUG: Dodawanie klucza do gracza %d z tablicą %s"):format(src, lowerPlate))

    local success = exports.ox_inventory:AddItem(src, "carkey", 1, metadata)
    print("DEBUG: AddItem success:", success)

    Citizen.SetTimeout(500, function()
        local inventory = exports.ox_inventory:GetInventory(src)
        print("DEBUG: Ekwipunek po dodaniu:")
        for i, item in pairs(inventory) do
            print(string.format("Item %d: %s x%d, metadata: %s", i, item.name, item.count, json.encode(item.metadata)))
        end
    end)

    TriggerClientEvent('ox_inventory:refresh', src)
    TriggerClientEvent("chat:addMessage", src, { args = { "[INFO]", "Dodano klucz do pojazdu: " .. lowerPlate } })
end)

-- Usuwanie kluczy z wszystkich graczy dla danej tablicy
RegisterNetEvent("ls:removeKeysFromAllPlayers")
AddEventHandler("ls:removeKeysFromAllPlayers", function(plate)
    local lowerPlate = tostring(string.lower(plate))
    print("DEBUG: Usuwanie kluczy dla tablicy: " .. lowerPlate)
    for _, playerId in pairs(ESX.GetPlayers()) do
        local items = exports.ox_inventory:Search(playerId, 'slots') or {}
        for _, item in pairs(items) do
            if item.name == "carkey" and item.metadata and item.metadata.plate == lowerPlate then
                print(("DEBUG: Usuwam klucz od %d dla tablicy %s"):format(playerId, lowerPlate))
                exports.ox_inventory:RemoveItem(playerId, 'carkey', 1, item.metadata)
                -- Możesz tu dodać TriggerClientEvent('ox_inventory:refresh', playerId) jeśli chcesz odświeżać
                break
            end
        end
    end
end)

-- Callback sprawdzający, czy gracz ma klucz do pojazdu
ESX.RegisterServerCallback("ls:check", function(source, cb, plate)
    local src = source
    local lowerPlate = tostring(string.lower(plate))
    print("DEBUG: Sprawdzanie kluczy dla gracza " .. src .. " tablica: " .. lowerPlate)

    local hasKey = false

    local items = exports.ox_inventory:Search(src, 'slots') or {}
    print("DEBUG: Ilość przedmiotów w ekwipunku: " .. #items)
    for _, item in pairs(items) do
        print(("DEBUG: Item: %s, metadata.plate: %s"):format(item.name, item.metadata and item.metadata.plate or "nil"))
        if item.name == "carkey" and item.metadata and item.metadata.plate == lowerPlate then
            hasKey = true
            break
        end
    end

    -- Przydałoby się też sprawdzać właściciela i blokadę pojazdu, jeśli masz takie dane w bazie
    local isOwned = false
    local isLocked = false

    cb(hasKey, isOwned, isLocked)
end)
