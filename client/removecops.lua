Citizen.CreateThread(function()
    while true do
        Citizen.Wait(750)
        local playerPed = PlayerPedId()
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
    end
end)