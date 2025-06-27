ESX = exports["es_extended"]:getSharedObject()


pawnshopcoords = vector3(-222.52, 6233.46, 31.79)
sellerpedcoords = vector3(-221.59, 6232.54, 30.79)
coords = vector3(0.0, 0.0, 0.0)

items = {
    {label = 'Kajdanki', value = 'handcuffs', baseprice = 200},
    {label = 'Krótkofalówka', value = 'radio', baseprice = 500},
    -- {label = 'Zapalniczka', value = 'zapalniczka', baseprice = 25},
    --{label = 'Zestaw Naprawczy', value = 'fixkit', baseprice = 1500},
    -- {label = 'Knebel', value = 'gag', baseprice = 2500},
    {label = 'Lornetka', value = 'lornetka', baseprice = 100},
    {label = 'Telefon', value = 'phone', baseprice = 600},
    -- {label = 'Wiertło', value = 'drill', baseprice = 17500},
   -- {label = 'Wytrych', value = 'wytrych', baseprice = 2500},
}

prices = {}

blockbargaining = {}

local sellerped = nil
local sellerped2 = nil

Citizen.CreateThread(function()


    PlayerData = ESX.GetPlayerData()

    generateprices()
    initped()
    initped2()
end)

Citizen.CreateThread(function()
    pawnshopblip = AddBlipForCoord(pawnshopcoords)

    SetBlipSprite (pawnshopblip, 77)
    SetBlipDisplay(pawnshopblip, 4)
    SetBlipScale  (pawnshopblip, 0.7)
    SetBlipColour(pawnshopblip, 46)
    SetBlipAsShortRange(pawnshopblip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Lombard')
    EndTextCommandSetBlipName(pawnshopblip)
    ------------------------
    pawnshopblip2 = AddBlipForCoord(vector3(175.54, -1318.06, 29.36))

    SetBlipSprite (pawnshopblip2, 77)
    SetBlipDisplay(pawnshopblip2, 4)
    SetBlipScale  (pawnshopblip2, 0.7)
    SetBlipColour(pawnshopblip2, 46)
    SetBlipAsShortRange(pawnshopblip2, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Lombard')
    EndTextCommandSetBlipName(pawnshopblip2)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)



CreateThread(function ()
    exports.qtarget:AddBoxZone("lombard",vector3(-222.18, 6233.01, 31.79), 1, 1, { -- -93.49
        name = "lombard",
        heading = 0,
        minZ = 30.79,
        maxZ = 32.79,
    }, {
		options = {
			{
				event = "otworzlombard",
				icon = "fa-solid fa-users",
				label = "Otwórz lombard",
			},
		},
		distance = 1.5
})
    exports.qtarget:AddBoxZone("lombard",vector3(173.15, -1322.17, 29.36), 1, 1, { -- -93.49
        name = "lombard",
        heading = 0,
        minZ = 28.79,
        maxZ = 30.79,
    }, {
		options = {
			{
				event = "otworzlombard",
				icon = "fa-solid fa-users",
				label = "Otwórz lombard",
			},
		},
		distance = 1.5
})

end)

RegisterNetEvent("otworzlombard")
AddEventHandler("otworzlombard", function()
    pawnshopmenu()

end)


pawnshopmenu = function()
    PlayAmbientSpeech1(sellerped, 'Generic_Hi', 'Speech_Params_Force')
    PlayAmbientSpeech1(sellerped2, 'Generic_Hi', 'Speech_Params_Force')
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawnshop', {
        title    = 'Lombard',
        align    = 'center',
        elements = prices
    }, function(data, menu)
        ESX.TriggerServerCallback('fusion_lombard:getplayeritemcount', function(result)
            if result > 0 then
                menu.close()
                local choose = {}
                if not blockbargaining[data.current.value] then
                    table.insert(choose, {label = 'Targuj się', value = 'changeprice'})
                end
                table.insert(choose, {label = 'Sprzedaj', value = 'sell'})
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawnshop_choose', {
                    title    = 'Co chcesz zrobić?',
                    align    = 'center',
                    elements = choose
                }, function(data2, menu2)
                    menu2.close()
                    if data2.current.value == 'changeprice' then
                        changeprice(data.current.label, data.current.value, data.current.price, true)
                    else
                        openquantitymenu(data.current.value, data.current.price)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            else
                ESX.ShowNotification('Nie posiadasz tego przedmiotu', "error")
            end
        end, data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

generateprices = function()
    for k,v in pairs(items) do
        chance = math.random(10,20)
        chancenumber = tonumber('1.'..chance)
        finalprice = math.floor(v.baseprice*chancenumber)
        newlabel = v.label..' <font color=lightgreen>'..finalprice..'$</font>'
        table.insert(prices, {label = newlabel, value = v.value, price = finalprice})
    end
    table.sort(prices, function(a, b)
        return a.price > b.price
    end)
end

changeprice = function(label, item, price, canbargaining)
    local elements = {}
    if canbargaining then
        table.insert(elements, {label = 'Oferta <font color=lightgreen>'..price..'$</font>', value = 'atmprice'})
        table.insert(elements, {label = 'Targuj cenę', value = 'changeprice'})
        table.insert(elements, {label = 'Sprzedaj', value = 'sell'})
    else
        table.insert(elements, {label = 'Ostateczna oferta <font color=lightgreen>'..price..'$</font>', value = 'atmprice'})
        table.insert(elements, {label = 'Sprzedaj', value = 'sell'})
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bargaining', {
        title    = 'Targowanie',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'changeprice' then
            menu.close()
            local chance = math.random(0, 100)
            if chance >= 50 then
                local multiplierchange = math.random(2,5)
                local multiplierchangenumber = tonumber('1.0'..multiplierchange)
                local finalmultiplierprice = math.floor(price*multiplierchangenumber)
                changeprice(label, item, finalmultiplierprice, true)
            else
                blockbargaining[item] = true
                ESX.ShowNotification('Pracownik lombardu: nie ma chuja, drożej nie kupie!', "error")
                PlayAmbientSpeech1(sellerped, 'Generic_Curse_High', 'Speech_Params_Force_Shouted_Critical')
                PlayAmbientSpeech1(sellerped2, 'Generic_Curse_High', 'Speech_Params_Force_Shouted_Critical')
                ESX.PlayAnimOnPed(sellerped, 'anim@heists@ornate_bank@chat_manager', 'fail', 8.0, -1, 0)
                ESX.PlayAnimOnPed(sellerped2, 'anim@heists@ornate_bank@chat_manager', 'fail', 8.0, -1, 0)
                changeprice(label, item, price, false)
                updateprice(label, item, price)
            end
        elseif data.current.value == 'sell' then
            menu.close()
            openquantitymenu(item, price)
            blockbargaining[item] = true
            updateprice(label, item, price)
        end
    end, function(data, menu)
        menu.close()
    end)
end

openquantitymenu = function(item, price)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pawnshop_quantity', {
        title = 'Ilość'
    }, function(data, menu)
        local quantity = tonumber(data.value)
        ESX.TriggerServerCallback('fusion_lombard:getplayeritemcount', function(result)
            if result > 0 then
                if quantity <= result then
                    menu.close()
                    TriggerServerEvent('fusion_lombard:requestsellitem', item, price, quantity, PlayerData.token)
                    PlayAmbientSpeech1(sellerped, 'Generic_Thanks', 'Speech_Params_Force_Shouted_Critical')
                    PlayAmbientSpeech1(sellerped2, 'Generic_Thanks', 'Speech_Params_Force_Shouted_Critical')
                else
                    ESX.ShowNotification('Posiadasz tylko '..result..' tego przedmiotu', "error")
                end
            end
        end, item)
    end, function(data,menu)
        menu.close()
    end)
end

updateprice = function(label, item, price)
    split_string = Split(label, " ")
    cuttedlabel = split_string[1]
    for k,v in pairs(prices) do
        if v.value == item then
            prices[k].price = price
            prices[k].label = cuttedlabel..' <font color=lightgreen>'..price..'$</font>'
            break
        end
    end
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

initped = function()
    RequestModel(`g_m_m_korboss_01`)
	while not HasModelLoaded(`g_m_m_korboss_01`) do
	  Wait(100)
	end

    sellerped = CreatePed(5, `g_m_m_korboss_01`, sellerpedcoords, 39.91, false, true)
    FreezeEntityPosition(sellerped, true)
	SetEntityInvincible(sellerped, true)
	SetBlockingOfNonTemporaryEvents(sellerped, true)
end

initped2 = function()
    RequestModel(`g_m_m_korboss_01`)
	while not HasModelLoaded(`g_m_m_korboss_01`) do
	  Wait(100)
	end

    sellerped2 = CreatePed(5, `g_m_m_korboss_01`, vector3(173.25, -1322.93, 28.36), 332.93, false, true)
    FreezeEntityPosition(sellerped2, true)
	SetEntityInvincible(sellerped2, true)
	SetBlockingOfNonTemporaryEvents(sellerped2, true)
end