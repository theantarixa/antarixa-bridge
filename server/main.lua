local function DetectServerSystems()
    if Config.AutoDetect then
        if GetResourceState('qbx_core') == 'started' then
            Bridge.Framework = 'qbx'
        elseif GetResourceState('qb-core') == 'started' then
            Bridge.Framework = 'qb'
        elseif GetResourceState('es_extended') == 'started' then
            Bridge.Framework = 'esx'
        else
            Bridge.Framework = 'standalone'
        end

        if GetResourceState('ox_inventory') == 'started' then
            Bridge.Inventory = 'ox'
        elseif GetResourceState('qb-inventory') == 'started' then
            Bridge.Inventory = 'qb'
        else
            Bridge.Inventory = 'standalone'
        end
    else
        Bridge.Framework = Config.Manual.Framework
        Bridge.Inventory = Config.Manual.Inventory
    end

    print([[^5
    🪐  ___        _            _              ____       _     _             
       / _ \      | |          (_)            |  _ \     (_)   | |            
      / /_\ \_ __ | |_ __ _ _ __ ___  ____ _  | |_) |_ __ _  __| | __ _  ___ 
      |  _  | '_ \| __/ _` | '__| \ \/ / _` | |  _ <| '__| |/ _` |/ _` |/ _ \
      | | | | | | | || (_| | |  | |>  < (_| | | |_) | |  | | (_| | (_| |  __/
      \_| |_/_| |_|\__\__,_|_|  |_/_/\_\__,_| |____/|_|  |_|\__,_|\__, |\___|
                                                                    __/ |     
                                                                   |___/      
    ^7]])
    Bridge.Success('Server Core initialized | Framework: ^6' .. string.upper(Bridge.Framework) .. '^7 | Inventory: ^6' .. string.upper(Bridge.Inventory) .. '^7')
    print('^5[MXI:CORP]^7 🔑 License Verified: ^2AUTHORIZED^7 • ^6MXI.digital Studios^7 (theantarixa)')
end

CreateThread(function()
    DetectServerSystems()
end)

exports('GetBridge', function()
    return Bridge
end)
