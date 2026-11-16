function Bridge.HasItem(itemName, count)
    count = count or 1
    if Bridge.Inventory == 'ox' then
        local itemCount = exports.ox_inventory:Search('count', itemName)
        return (itemCount and itemCount >= count) or false
    elseif Bridge.Inventory == 'qb' then
        local pData = Bridge.GetPlayerData()
        if pData and pData.items then
            for _, item in pairs(pData.items) do
                if item and item.name == itemName and item.amount >= count then
                    return true
                end
            end
        end
    end
    return false
end

function Bridge.OpenInventory(invType, data)
    if Bridge.Inventory == 'ox' then
        if invType == 'stash' then
            exports.ox_inventory:openInventory('stash', data)
        elseif invType == 'shop' then
            exports.ox_inventory:openInventory('shop', data)
        else
            exports.ox_inventory:openInventory()
        end
    elseif Bridge.Inventory == 'qb' then
        if invType == 'stash' then
            TriggerEvent('inventory:client:SetCurrentStash', data)
            TriggerServerEvent('inventory:server:OpenInventory', 'stash', data)
        else
            TriggerServerEvent('inventory:server:OpenInventory')
        end
    end
end

function Bridge.GetItems()
    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:GetPlayerItems()
    elseif Bridge.Inventory == 'qb' then
        local pData = Bridge.GetPlayerData()
        return (pData and pData.items) or {}
    end
    return {}
end

exports('HasItem', Bridge.HasItem)
exports('OpenInventory', Bridge.OpenInventory)
exports('GetItems', Bridge.GetItems)
