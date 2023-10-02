fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

Dependency 'Rocks'

shared_script '@ox_lib/init.lua'

server_script '@oxmysql/lib/MySQL.lua'
shared_script '@MP-Base/shared/shared.lua'

server_scripts {
    -- Change job file
    'server.lua',
    -- Add item(s) to miner's inventory
    'miner/sv_miner.lua',
    -- Police Actions
    'police/server.lua',
    -- adding more later
}
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    -- Blips
    'blips/blips_config.lua',
    'blips/blips_manager.lua',
    -- Taxi Job
    'taxi/cl_taxi.lua',
    -- Miner Job
    'miner/cl_miner.lua',
    -- Police Job
    'police/cl_police.lua',
    -- adding more later
}