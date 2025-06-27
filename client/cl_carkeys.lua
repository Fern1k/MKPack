local LockTask = false
local isDead = false
local Timer = 0

local Config = {
    percentage = 50,
    key = 'U',
    enterKey = 'G',
    engineKey = 'Y',
    RandomMessages = {
        "Znalazłeś klucze w stacyjce",
        "Znalazłeś klucze na siedzeniu",
        "Znalazłeś klucze w schowku",
    }
}

local doors = {
    ["seat_dside_f"] = -1,
    ["seat_pside_f"] = 0,
    ["seat_dside_r"] = 1,
    ["seat_pside_r"] = 2
}

-- Timer odliczający cooldown
Citizen.CreateThread(function()
    while true do
        if Timer > 0 then
            Timer = Timer - 1
        end
        Citizen.Wait(1000)
    end
end)

-- Obsługa śmierci gracza
AddEventHandler('playerSpawned', function()
    isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
end)

-- Funkcja uruchamiania/gaszenia silnika
function EngineVehicle(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then return end

    if Timer > 0 then
        ESX.ShowNotification("Odczekaj "..Timer.." sekund")
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
        local plate = GetVehicleNumberPlateText(vehicle)
        if type(plate) == 'string' then
            plate = plate:gsub("%s+$", "")
        end

        local status = IsVehicleEngineOn(vehicle)
        if not status then
            ESX.TriggerServerCallback('ls:check', function(hasKey, isOwned, isLocked)
                if hasKey then
                    SetVehicleEngineOn(vehicle, true, false, true)
                    ESX.ShowNotification("Silnik włączony")
                else
                    ESX.ShowNotification("Włączanie silnika...")
                    SetVehicleNeedsToBeHotwired(vehicle, true)
                end
                Timer = 3
            end, plate)
        else
            SetVehicleEngineOn(vehicle, false, false, true)
            ESX.ShowNotification("Silnik wyłączony")
        end
    end
end

-- Funkcja wsiadania do pojazdu - wybiera najbliższy otwór drzwi
function EnterVehicle(playerPed)
    local vehicleInFront = ESX.Game.GetVehicleInDirection(0.0, 20.0, -0.95)
    if not vehicleInFront or vehicleInFront == 0 then return end

    if GetVehiclePedIsTryingToEnter(playerPed) ~= 0 then return end

    local doorDistances = {}
    local playerCoords = GetEntityCoords(playerPed)
    for bone, seat in pairs(doors) do
        local doorBone = GetEntityBoneIndexByName(vehicleInFront, bone)
        if doorBone ~= -1 then
            local doorCoords = GetWorldPositionOfEntityBone(vehicleInFront, doorBone)
            if doorCoords then
                local dist = #(playerCoords - doorCoords)
                table.insert(doorDistances, {seat = seat, distance = dist})
            end
        end
    end

    if #doorDistances == 0 then return end

    table.sort(doorDistances, function(a, b) return a.distance < b.distance end)
    local closestSeat = doorDistances[1].seat

    TaskEnterVehicle(playerPed, vehicleInFront, -1, closestSeat, 1.0, 1, 0)
end

-- Funkcja zwraca najbliższy pojazd w promieniu 'radius' od gracza
function GetClosestVehicleToPlayer(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = ESX.Game.GetVehicles()
    local closestVehicle = nil
    local minDist = radius + 1

    for i=1, #vehicles do
        local vehCoords = GetEntityCoords(vehicles[i])
        local dist = #(playerCoords - vehCoords)
        if dist < minDist then
            minDist = dist
            closestVehicle = vehicles[i]
        end
    end

    if minDist <= radius then
        return closestVehicle
    else
        return nil
    end
end

-- Funkcja obsługi zamykania/otwierania pojazdu
function LockSystem(playerPed, vehicle)
    if Timer > 0 and not LockTask then
        ESX.ShowNotification("Odczekaj "..Timer.." sekund")
        return
    end

    local isInside = false
    local inVehicle = IsPedInAnyVehicle(playerPed, false)

    if not vehicle then
        if inVehicle then
            vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
                vehicle = nil
            end
            isInside = true
        else
            vehicle = GetClosestVehicleToPlayer(5.0)
        end
    end

    if vehicle and vehicle ~= 0 then
        LockTask = true
        ClearPedTasks(playerPed)

        local plate = GetVehicleNumberPlateText(vehicle)
        if type(plate) == 'string' then
            plate = plate:gsub("%s+$", "")
        end

        local lockStatus = GetVehicleDoorLockStatus(vehicle)

        ESX.TriggerServerCallback('ls:check', function(hasKey, isOwned, isLocked)
            if hasKey then
                Citizen.CreateThread(function()
                    local id = NetworkGetNetworkIdFromEntity(vehicle)
                    SetNetworkIdCanMigrate(id, true)

                    local tries = 0
                    while not NetworkHasControlOfNetworkId(id) and tries < 10 do
                        tries = tries + 1
                        NetworkRequestControlOfNetworkId(id)
                        Citizen.Wait(100)
                    end

                    SetNetworkIdCanMigrate(id, false)

                    if lockStatus < 2 then
                        SetVehicleDoorsLocked(vehicle, 4)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
                        SetVehicleDoorsShut(vehicle, false)
                        SetVehicleAlarm(vehicle, true)
                        if not inVehicle then
                            SetVehicleInteriorlight(vehicle, false)
                        end

                        ESX.ShowNotification("Pojazd zamknięty ("..plate..")")
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'lock', 0.3)
                        if not IsPedInAnyVehicle(playerPed, true) then
                            PlayLockAnimation(playerPed)
                        end
                    elseif lockStatus > 1 then
                        SetVehicleDoorsLocked(vehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                        SetVehicleAlarm(vehicle, false)
                        if not inVehicle then
                            SetVehicleInteriorlight(vehicle, true)
                        end

                        ESX.ShowNotification("Pojazd otwarty ("..plate..")")
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'unlock', 0.3)
                        if not IsPedInAnyVehicle(playerPed, true) then
                            PlayLockAnimation(playerPed)
                        end
                    end

                    if not inVehicle then
                        FlashVehicleLights(vehicle)
                    end

                    SetNetworkIdCanMigrate(id, true)
                    LockTask = false
                    Timer = 3
                end)
            elseif not isInside then
                LockTask = false -- nic nie rób jeśli nie jesteś w pojeździe i nie masz kluczy
            elseif isLocked or isOwned then
                ESX.ShowNotification("Niestety nie znalazłeś kluczy ("..plate..")")
                LockTask = false
            elseif GetRandomIntInRange(1, 100) < Config.percentage then
                TriggerServerEvent('ls:addKeys', plate)
                ESX.ShowNotification(Config.RandomMessages[GetRandomIntInRange(1, #Config.RandomMessages)].." ("..plate..")")
                LockTask = false
            else
                TriggerServerEvent("ls:lockTheVehicle", plate)
                ESX.ShowNotification("Niestety nie znalazłeś kluczy ("..plate..")")
                LockTask = false
            end
        end, plate)
    else
        Citizen.Wait(500)
    end
end

function PlayLockAnimation(playerPed)
    local animDict = "gestures@m@standing@casual"
    local animName = "gesture_you_soft"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(playerPed, animDict, animName, 3.0, 1.0, -1, 48, 0, false, false, false)
end

function FlashVehicleLights(vehicle)
    for i = 1, 2 do
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Citizen.Wait(200)
        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
        Citizen.Wait(200)
    end
end

-- Obsługa eventu po użyciu kluczy
RegisterNetEvent('ls:useKeys')
AddEventHandler('ls:useKeys', function()
    local playerPed = PlayerPedId()
    LockSystem(playerPed, nil)
end)

-- Komendy i klawisze
RegisterKeyMapping('wait_vehEngine', 'Uruchom/Zgaś silnik pojazdu', 'keyboard', Config.engineKey)
RegisterCommand("wait_vehEngine", function()
    if isDead then return end
    EngineVehicle(PlayerPedId())
end)

RegisterKeyMapping('wait_vehEnter', 'Wsiądź do pojazdu', 'keyboard', Config.enterKey)
RegisterCommand("wait_vehEnter", function()
    if isDead then return end
    EnterVehicle(PlayerPedId())
end)

RegisterKeyMapping('vehKeys', 'Otwórz/Zamknij Pojazd', 'keyboard', Config.key)
RegisterCommand("vehKeys", function()
    if isDead then return end
    LockSystem(PlayerPedId())
end)

CreateThread(function()
    TriggerEvent("chat:removeSuggestion", "/wait_vehEngine")
    TriggerEvent("chat:removeSuggestion", "/wait_vehEnter")
    TriggerEvent("chat:removeSuggestion", "/vehKeys")
end)

-- Export na użycie kluczy z inventory
exports("useKeys", function(data)
    if isDead then return end
    local keys = exports.ox_inventory:Search('slots', 'carkey')
	print("DEBUG: Klucze znalezione: ", json.encode(keys))
    local allItems = exports.ox_inventory:Search('slots')
	print("DEBUG: Przedmioty w ekwipunku: ", json.encode(allItems))
    for _, v in pairs(keys) do
        if v.slot == data.slot then
            useKey(v.metadata.plate or v.metadata.type)
	    print("DEBUG: Klucz metadata:", json.encode(v.metadata))
            break
        end
    end
end)

-- Funkcja do używania klucza (zamknięcie/otwarcie pojazdu po numerze rejestracyjnym)
function useKey(plate)
    if Timer > 0 and not LockTask then
        ESX.ShowNotification("Odczekaj "..Timer.." sekund")
        return
    end

    local playerPed = PlayerPedId()
    local vehs = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), 35.0)
    local vehicle = nil

    for _, veh in pairs(vehs) do
        local platet = GetVehicleNumberPlateText(veh)
        if platet == plate then
            vehicle = veh
            break
        end
    end

    if vehicle and vehicle ~= 0 then
        LockTask = true
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(id, false)

        local tries = 0
        while not NetworkHasControlOfNetworkId(id) and tries < 10 do
            tries = tries + 1
            NetworkRequestControlOfNetworkId(id)
            Citizen.Wait(100)
        end

        if lockStatus < 2 then
            SetVehicleDoorsLocked(vehicle, 4)
            SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            ESX.ShowNotification("Pojazd zamknięty ("..plate..")")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'lock', 0.3)
            PlayLockAnimation(playerPed)
        elseif lockStatus > 1 then
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ESX.ShowNotification("Pojazd otwarty ("..plate..")")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'unlock', 0.3)
            PlayLockAnimation(playerPed)
        end

        SetNetworkIdCanMigrate(id, true)
        LockTask = false
        Timer = 3
    end
end
