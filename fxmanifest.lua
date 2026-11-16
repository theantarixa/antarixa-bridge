fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'antarixa-bridge'
author 'theantarixa • MXI.digital Studios'
description 'Agnostic Zero-Resmon Universal FiveM Bridge (QBX, QBCore, ESX, ox_inventory)'
version '1.0.0'
license 'MXI.digital Studios EULA'
repository 'https://github.com/theantarixa/antarixa-bridge'

provide 'antarixa-bridge'
provide 'community_bridge'

shared_scripts {
    'config.lua',
    'init.lua'
}

client_scripts {
    'client/main.lua',
    'client/framework.lua',
    'client/inventory.lua',
    'client/notify.lua',
    'client/target.lua',
    'client/progress.lua'
}

server_scripts {
    'server/main.lua',
    'server/framework.lua',
    'server/inventory.lua',
    'server/discord.lua',
    'server/version.lua'
}

exports {
    'GetBridge',
    'GetPlayerData',
    'IsPlayerLoaded',
    'GetJob',
    'GetGang',
    'Notify',
    'Progress',
    'AddTargetModel',
    'AddTargetEntity',
    'AddBoxZone',
    'AddSphereZone',
    'RemoveZone'
}

server_exports {
    'GetBridge',
    'GetPlayer',
    'GetPlayerByCitizenId',
    'GetPlayerByIdentifier',
    'GetOnlinePlayers',
    'GetMoney',
    'AddMoney',
    'RemoveMoney',
    'AddItem',
    'RemoveItem',
    'HasItem',
    'GetItemCount',
    'CanCarryItem',
    'SendDiscordLog',
    'CheckVersion',
    'RegisterVersionCheck'
}
