local function FormatPlayerObject(src, rawPlayer)
    if not rawPlayer then return nil end

    local playerObj = {
        source = src,
        raw = rawPlayer
    }

    if Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        playerObj.citizenid = rawPlayer.PlayerData.citizenid
        playerObj.identifier = rawPlayer.PlayerData.license or rawPlayer.PlayerData.citizenid
        playerObj.name = (rawPlayer.PlayerData.charinfo and (rawPlayer.PlayerData.charinfo.firstname .. ' ' .. rawPlayer.PlayerData.charinfo.lastname)) or GetPlayerName(src)
        
        local job = rawPlayer.PlayerData.job or {}
        playerObj.job = {
            name = job.name or 'unemployed',
            label = job.label or 'Unemployed',
            grade = (job.grade and (job.grade.level or job.grade)) or 0,
            gradeLabel = (job.grade and (job.grade.name or job.grade.label)) or 'Freelance',
            isBoss = job.isboss or false,
            payment = job.payment or 0
        }

        local gang = rawPlayer.PlayerData.gang or {}
        playerObj.gang = {
            name = gang.name or 'none',
            label = gang.label or 'None',
            grade = (gang.grade and (gang.grade.level or gang.grade)) or 0,
            isBoss = gang.isboss or false
        }

        playerObj.money = {
            cash = (rawPlayer.PlayerData.money and rawPlayer.PlayerData.money.cash) or 0,
            bank = (rawPlayer.PlayerData.money and rawPlayer.PlayerData.money.bank) or 0,
            crypto = (rawPlayer.PlayerData.money and rawPlayer.PlayerData.money.crypto) or 0
        }

        playerObj.getMoney = function(mType)
            return rawPlayer.Functions.GetMoney(mType or 'cash')
        end

        playerObj.addMoney = function(mType, amount, reason)
            return rawPlayer.Functions.AddMoney(mType or 'cash', amount, reason or 'bridge-add')
        end

        playerObj.removeMoney = function(mType, amount, reason)
            return rawPlayer.Functions.RemoveMoney(mType or 'cash', amount, reason or 'bridge-remove')
        end

        playerObj.setJob = function(jobName, grade)
            return rawPlayer.Functions.SetJob(jobName, grade or 0)
        end

        playerObj.setGang = function(gangName, grade)
            return rawPlayer.Functions.SetGang(gangName, grade or 0)
        end

    elseif Bridge.Framework == 'esx' then
        playerObj.citizenid = rawPlayer.identifier
        playerObj.identifier = rawPlayer.identifier
        playerObj.name = rawPlayer.getName and rawPlayer.getName() or GetPlayerName(src)
        
        local job = rawPlayer.getJob and rawPlayer.getJob() or {}
        playerObj.job = {
            name = job.name or 'unemployed',
            label = job.label or 'Unemployed',
            grade = job.grade or 0,
            gradeLabel = job.grade_label or 'Freelance',
            isBoss = (job.grade_name == 'boss') or false,
            payment = job.grade_salary or 0
        }

        playerObj.gang = { name = 'none', label = 'None', grade = 0, isBoss = false }

        local accounts = rawPlayer.getAccounts and rawPlayer.getAccounts() or {}
        local cash = rawPlayer.getMoney and rawPlayer.getMoney() or 0
        local bank = 0
        for _, acc in pairs(accounts) do
            if acc.name == 'bank' then bank = acc.money end
        end

        playerObj.money = { cash = cash, bank = bank, crypto = 0 }

        playerObj.getMoney = function(mType)
            if mType == 'cash' or mType == 'money' then
                return rawPlayer.getMoney()
            elseif mType == 'bank' then
                return rawPlayer.getAccount('bank').money
            end
            return 0
        end

        playerObj.addMoney = function(mType, amount, reason)
            if mType == 'cash' or mType == 'money' then
                rawPlayer.addMoney(amount)
                return true
            elseif mType == 'bank' then
                rawPlayer.addAccountMoney('bank', amount)
                return true
            end
            return false
        end

        playerObj.removeMoney = function(mType, amount, reason)
            if mType == 'cash' or mType == 'money' then
                if rawPlayer.getMoney() >= amount then
                    rawPlayer.removeMoney(amount)
                    return true
                end
            elseif mType == 'bank' then
                if rawPlayer.getAccount('bank').money >= amount then
                    rawPlayer.removeAccountMoney('bank', amount)
                    return true
                end
            end
            return false
        end

        playerObj.setJob = function(jobName, grade)
            rawPlayer.setJob(jobName, grade or 0)
            return true
        end

        playerObj.setGang = function(gangName, grade)
            return false
        end
    end

    -- Inventory shortcut methods bound to player
    playerObj.addItem = function(item, count, metadata, slot)
        return Bridge.AddItem(src, item, count, metadata, slot)
    end

    playerObj.removeItem = function(item, count, metadata, slot)
        return Bridge.RemoveItem(src, item, count, metadata, slot)
    end

    playerObj.hasItem = function(item, count)
        return Bridge.HasItem(src, item, count)
    end

    return playerObj
end

function Bridge.GetPlayer(source)
    local src = tonumber(source)
    if not src then return nil end

    if Bridge.Framework == 'qbx' then
        if exports.qbx_core then
            local qbxPlayer = exports.qbx_core:GetPlayer(src)
            return FormatPlayerObject(src, qbxPlayer)
        end
    elseif Bridge.Framework == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions.GetPlayer then
            local qbPlayer = QBCore.Functions.GetPlayer(src)
            return FormatPlayerObject(src, qbPlayer)
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject()
        if ESX and ESX.GetPlayerFromId then
            local esxPlayer = ESX.GetPlayerFromId(src)
            return FormatPlayerObject(src, esxPlayer)
        end
    end
    return nil
end

function Bridge.GetPlayerByCitizenId(citizenid)
    if Bridge.Framework == 'qbx' and exports.qbx_core then
        local qbxPlayer = exports.qbx_core:GetPlayerByCitizenId(citizenid)
        if qbxPlayer then return FormatPlayerObject(qbxPlayer.PlayerData.source, qbxPlayer) end
    elseif Bridge.Framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local qbPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
        if qbPlayer then return FormatPlayerObject(qbPlayer.PlayerData.source, qbPlayer) end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        local esxPlayer = ESX.GetPlayerFromIdentifier(citizenid)
        if esxPlayer then return FormatPlayerObject(esxPlayer.source, esxPlayer) end
    end
    return nil
end

function Bridge.GetOnlinePlayers()
    local players = {}
    local rawList = GetPlayers()
    for _, srcStr in ipairs(rawList) do
        local src = tonumber(srcStr)
        local p = Bridge.GetPlayer(src)
        if p then
            table.insert(players, p)
        end
    end
    return players
end

function Bridge.GetMoney(source, mType)
    local p = Bridge.GetPlayer(source)
    return p and p.getMoney(mType) or 0
end

function Bridge.AddMoney(source, mType, amount, reason)
    local p = Bridge.GetPlayer(source)
    return p and p.addMoney(mType, amount, reason) or false
end

function Bridge.RemoveMoney(source, mType, amount, reason)
    local p = Bridge.GetPlayer(source)
    return p and p.removeMoney(mType, amount, reason) or false
end

-- Exports
exports('GetPlayer', Bridge.GetPlayer)
exports('GetPlayerByCitizenId', Bridge.GetPlayerByCitizenId)
exports('GetOnlinePlayers', Bridge.GetOnlinePlayers)
exports('GetMoney', Bridge.GetMoney)
exports('AddMoney', Bridge.AddMoney)
exports('RemoveMoney', Bridge.RemoveMoney)
