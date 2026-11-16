-- Antarixa Bridge Core Shared Initialization
Bridge = Bridge or {}
Bridge.Resource = GetCurrentResourceName()
Bridge.IsServer = IsDuplicityVersion()

-- When this file is imported by another resource via `@antarixa-bridge/init.lua`
if Bridge.Resource ~= 'antarixa-bridge' then
    local ExportBridge = exports['antarixa-bridge']:GetBridge()
    for k, v in pairs(ExportBridge) do
        Bridge[k] = v
    end
    return
end

Bridge.Framework = nil
Bridge.Inventory = nil
Bridge.Target = nil
Bridge.NotifySys = nil

function Bridge.Log(msg, ...)
    if Config and Config.Debug then
        print(string.format('^5[Antarixa-Bridge]^7 ' .. msg, ...))
    end
end

function Bridge.Success(msg, ...)
    print(string.format('^2[Antarixa-Bridge:OK]^7 ' .. msg, ...))
end

function Bridge.Warn(msg, ...)
    print(string.format('^3[Antarixa-Bridge:WARN]^7 ' .. msg, ...))
end

function Bridge.Error(msg, ...)
    print(string.format('^1[Antarixa-Bridge:ERR]^7 ' .. msg, ...))
end
