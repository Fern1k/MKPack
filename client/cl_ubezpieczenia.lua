CreateThread(function()
    exports.qtarget:AddBoxZone('Ubezpieczenia', vector3(-259.763, -965.494, 31.224), 0.8, 1.8,  {
        name= 'Ubezpieczenia',
        debugPoly=false,
        minZ=30.0,
        maxZ=32.0,
        }, {
            options = {
                {
                    icon = "fas fa-sign-in-alt",
                    label = "Zakup Ubezpieczenie",
                    action = function() 
                        local jajo =  math.random(0,500000)
                        ESX.TriggerServerCallback("mk:checkUbezpieczenia", function(res) 
                            local opcje = {}
                            
                            if res.med == true then 
                                table.insert(opcje, {
                                    title = 'MED',
                                    description = 'Ubezpieczenie medyczne.',
                                    icon        = "fa-check",
                                    iconColor   = "#32CD32",
                                    onSelect = function()
                                        
                                    end,
                                })
                            else
                                table.insert(opcje, {
                                    title = 'MED',
                                    description = 'Cena 5,000$',
                                    icon        = "fa-check",
                                    iconColor   = "red",
                                    onSelect = function()
                                        TriggerServerEvent("mk:buyLicense", "med")
                                    end,
                                })
                            end

                            if res.caroc == true then 
                                table.insert(opcje, {
                                    title = 'OC',
                                    description = 'Ubezpieczenie na auto.',
                                    icon        = "fa-check",
                                    iconColor   = "#32CD32",
                                    onSelect = function()
                                        
                                    end,
                                })
                            else
                                table.insert(opcje, {
                                    title = 'OC',
                                    description = 'Cena 7,000$',
                                    icon        = "fa-check",
                                    iconColor   = "red",
                                    onSelect = function()
                                        TriggerServerEvent("mk:buyLicense", "caroc")
                                    end,
                                })
                            end
                            lib.registerContext({
                                id = 'KupUbezpieczenie' .. jajo,
                                title = 'Które chcesz kupić?',
                                options = opcje
                            })
                            lib.showContext('KupUbezpieczenie' .. jajo) 
                        end)

                    end,
                },
            },
            distance = 1.5
    })
    
    local pozycjaziomka = vector3(-259.763, -965.494, 31.224 - 1.0)
    local headingziomka = 132.109
    local jakitoped = GetHashKey("a_m_y_business_02")
    
    Citizen.CreateThread(function()
        RequestModel(jakitoped)
        while not HasModelLoaded(jakitoped) do Citizen.Wait(1) end
        infoziomka = CreatePed(4, jakitoped, pozycjaziomka, headingziomka, false, false)
    
    
        SetEntityAsMissionEntity(infoziomka)
        SetPedDiesWhenInjured(infoziomka, false)
        SetEntityInvincible(infoziomka, true)
        SetPedFleeAttributes(infoziomka, 0, 0)
        SetBlockingOfNonTemporaryEvents(infoziomka, true)
        FreezeEntityPosition(infoziomka, true)
    end)
end)