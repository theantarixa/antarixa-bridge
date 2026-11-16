local QBCore = nil
local ESX = nil

local function DetectSystems()
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

        if GetResourceState('ox_target') == 'started' then
            Bridge.Target = 'ox'
        elseif GetResourceState('qb-target') == 'started' then
            Bridge.Target = 'qb'
        else
            Bridge.Target = 'none'
        end

        if GetResourceState('ox_lib') == 'started' then
            Bridge.NotifySys = 'ox_lib'
        else
            Bridge.NotifySys = Bridge.Framework
        end
    else
        Bridge.Framework = Config.Manual.Framework
        Bridge.Inventory = Config.Manual.Inventory
        Bridge.Target = Config.Manual.Target
        Bridge.NotifySys = Config.Manual.Notify
    end

    Bridge.Log('Client initialized with Framework: %s | Inventory: %s | Target: %s', Bridge.Framework, Bridge.Inventory, Bridge.Target)
end

CreateThread(function()
    DetectSystems()
end)

-- Export GetBridge
exports('GetBridge', function()
    return Bridge
end)
