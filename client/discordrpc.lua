Citizen.CreateThread(function()
	while true do
        -- This is the Application ID (Replace this with you own)
		SetDiscordAppId(1198035542781210847)
        SetRichPresence(GetPlayerName(PlayerId()).." ["..GetPlayerServerId(PlayerId()).."]")
        -- Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('logo')
        
        -- (11-11-2018) New Natives:

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('MK-STORE FREE')
       
        -- Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('discord')

        -- Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('https://discord.gg/E5vSmdTXrd')


        -- (26-02-2021) New Native:

        --[[ 
            Here you can add buttons that will display in your Discord Status,
            First paramater is the button index (0 or 1), second is the title and 
            last is the url (this has to start with "fivem://connect/" or "https://") 
        ]]--
        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/E5vSmdTXrd")
        -- SetDiscordRichPresenceAction(1, "Second Button!", "fivem://connect/localhost:30120")

        -- It updates every minute just in case.
		Citizen.Wait(60000)
	end
end)

SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_LOST"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))

SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))