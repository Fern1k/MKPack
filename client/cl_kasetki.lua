----------------------- TARGETY --------------
-----------------------------------------

-- exports.ox_target:addBoxZone({
-- 	name = "sklep1",
-- 	coords = vec3(-3243.75, 1001.0, 13.0),
-- 	size = vec3(0.5, 0.25, 0.25),
-- 	rotation = 358.0,
--     options = {
-- 		{
-- 			icon = 'fa-solid fa-lock',
-- 			label = "Okdranij kasetke",
-- 			event = "astro-storerobbery:client:start",
--             items = "lockpick",
-- 		}
-- 	},
-- })


exports.ox_target:addModel({ 303280717,	-354930144 }, {
    {
        name = 'kasetka',
        event = "astro-storerobbery:client:start",
        icon = 'fa-solid fa-lock',
        label = "Okradnij kasetke",
        items = "lockpick",

    }
})
---------------------------------------------------------

GlobalState = false

function TimerThread()
	GlobalState = true
	local math = math.random(0, 1000)
	Citizen.Wait(math)
	GlobalState = false
end
-----------------------------------------------
--              KONIEC                       --
-----------------------------------------------
RegisterNetEvent('astro-storerobbery:client:start')
AddEventHandler('astro-storerobbery:client:start', function()
    local state = GlobalState
    ESX.TriggerServerCallback('getPoliceCount', function(policeCount)
        if policeCount > 0 then
        if state == false then
            ESX.ShowNotification("Przygotuj się!")
            Wait(4000)
            local skillcheck = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy', 'easy', 'easy', 'easy'})
            if skillcheck then
                ExecuteCommand("do Widać na twarzy stres")
                FreezeEntityPosition(PlayerPedId(), true)
                -- DISPATCH
                local job = "police"
                local text = "Obywatel okrada kasetke!"
                local coords = GetEntityCoords(PlayerPedId())
                local id = GetPlayerServerId(PlayerId())
                local title = "Rabunek Kasetki"
                local panic = false

                TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
                if lib.progressBar({
                    duration = 56666, 
                    label = 'Zbierasz gotówke...', 
                    useWhileDead = false, 
                    canCancel = true,
                    disable = {car = true,}, 
                    anim = {dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab'},  flag = 3})
                
                then 
                    FreezeEntityPosition(PlayerPedId(), false)
                    lib.callback('astro-storerobbery:server:succes')
                    TimerThread()
                else 
                    FreezeEntityPosition(PlayerPedId(), false)
                    lib.callback('astro-storerobbery:server:removeItem')
                end 
            else
                FreezeEntityPosition(PlayerPedId(), false)
		    lib.callback('astro-storerobbery:server:removeItem')
            end
        else
            lib.defaultNotify({
                status = "error",
                title = "Napad na kasetke",
                position = "top",
                description = "Nie mozesz obrabowac tej kasetki, odczekaj cooldown!",
            })
        end -- CALLBACK
    else
        lib.defaultNotify({
            status = "error",
            title = "Napad na kasetke",
            position = "top",
            description = "Brak minimalnej ilosci policji na serwerze!",
        })
        end 
    end) -- CALLBACK
end)
