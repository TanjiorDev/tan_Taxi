game 'gta5'
author 'Tanjiro'
fx_version 'cerulean'
lua54 'yes'

shared_script 'shared/*.lua'

files {
    "ui/**"
}
ui_page "ui/index.html"

client_scripts {
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
        'client/*.lua',
        
    }
    
    server_scripts {
        "@oxmysql/lib/MySQL.lua",
        '@es_extended/locale.lua',
        'server/*.lua',
        
    }


    -- escrow_ignore {
    --     'client/cl_vestiaire.lua',
    --     'client/cl_garage.lua',
    --     'server/sv_Farm.lua',
    --     'shared/*.lua'
    --   }