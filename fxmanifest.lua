fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- client_script '@punch_loader/c_loader.lua'
-- server_script '@punch_loader/s_loader.lua'
-- my_data 'client_files' { 
--     "client/apartsy.lua",
--     "client/apartsyciuszek.lua",
--     "client/cl_licencje.lua",
--     "client/cl_lombard.lua",
--     "client/cl_robnpc.lua",
--     "client/cl_szafkaobywatelalspd.lua",
--     "client/cl_urzad.lua",
--     "client/coords.lua",
--     "client/discordrpc.lua",
--     "client/dzwon.lua",
--     "client/hudcomponentsy.lua",
--     "client/kolejka.lua",
--     "client/komendassn.lua",
--     "client/propfix.lua",
--     "client/removecops.lua",
--     "client/smietniki.lua",
--     "client/wodopoje.lua",
--     "client/zadryngaj.lua",
-- }

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/kierowca-autobusu.png',
    'html/smieciarz.png',
    'html/lifeguard.png',
    'html/widlak.png',
}
