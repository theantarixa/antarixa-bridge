function Bridge.AddItem(source, item, count, metadata, slot)
    count = count or 1
    local src = tonumber(source)
    if not src then return false end

    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:AddItem(src, item, count, metadata, slot)
    elseif Bridge.Inventory == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.AddItem(item, count, slot, metadata)
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(item, count)
            return true
        end
    end
    return false
end

function Bridge.RemoveItem(source, item, count, metadata, slot)
    count = count or 1
    local src = tonumber(source)
    if not src then return false end

    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:RemoveItem(src, item, count, metadata, slot)
    elseif Bridge.Inventory == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.RemoveItem(item, count, slot)
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeInventoryItem(item, count)
            return true
        end
    end
    return false
end

function Bridge.GetItemCount(source, item, metadata)
    local src = tonumber(source)
    if not src then return 0 end

    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:GetItemCount(src, item, metadata) or 0
    elseif Bridge.Inventory == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            local itemData = Player.Functions.GetItemByName(item)
            return itemData and itemData.amount or 0
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if xPlayer then
            local itemData = xPlayer.getInventoryItem(item)
            return itemData and itemData.count or 0
        end
    end
    return 0
end

function Bridge.HasItem(source, item, count)
    count = count or 1
    return Bridge.GetItemCount(source, item) >= count
end

function Bridge.CanCarryItem(source, item, count)
    count = count or 1
    local src = tonumber(source)
    if not src then return false end

    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:CanCarryItem(src, item, count)
    elseif Bridge.Inventory == 'qb' then
        -- QB Core does not strictly block unless weight is calculated
        return true
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if xPlayer and xPlayer.canCarryItem then
            return xPlayer.canCarryItem(item, count)
        end
        return true
    end
    return true
end

function Bridge.GetInventory(source)
    local src = tonumber(source)
    if not src then return {} end

    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:GetInventoryItems(src) or {}
    elseif Bridge.Inventory == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        return (Player and Player.PlayerData.items) or {}
    end
    return {}
end

-- Exports
exports('AddItem', Bridge.AddItem)
exports('RemoveItem', Bridge.RemoveItem)
exports('HasItem', Bridge.HasItem)
exports('GetItemCount', Bridge.GetItemCount)
exports('CanCarryItem', Bridge.CanCarryItem)
exports('GetInventory', Bridge.GetInventory)
