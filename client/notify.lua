function Bridge.Notify(msg, nType, duration, title)
    nType = nType or 'info'
    duration = duration or 5000
    title = title or 'System'

    -- Normalize notification types
    local oxType = 'inform'
    if nType == 'success' then oxType = 'success'
    elseif nType == 'error' then oxType = 'error'
    elseif nType == 'warning' or nType == 'warn' then oxType = 'warning'
    end

    if GetResourceState('ox_lib') == 'started' then
        lib.notify({
            title = title,
            description = msg,
            type = oxType,
            duration = duration,
            position = 'top-right'
        })
    elseif Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions.Notify then
            QBCore.Functions.Notify(msg, nType, duration)
        else
            TriggerEvent('chat:addMessage', { args = { '^5' .. title .. '^7', msg } })
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification(msg)
        else
            TriggerEvent('chat:addMessage', { args = { '^5' .. title .. '^7', msg } })
        end
    else
        TriggerEvent('chat:addMessage', { args = { '^5' .. title .. '^7', msg } })
    end
end

RegisterNetEvent('antarixa-bridge:client:Notify', function(msg, nType, duration, title)
    Bridge.Notify(msg, nType, duration, title)
end)

exports('Notify', Bridge.Notify)
