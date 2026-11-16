local PlayerData = {}
local isLoaded = false

local function UpdatePlayerData()
    if Bridge.Framework == 'qbx' then
        if exports.qbx_core then
            local qbxPlayer = exports.qbx_core:GetPlayerData()
            if qbxPlayer and next(qbxPlayer) then
                PlayerData = qbxPlayer
                isLoaded = true
            end
        end
    elseif Bridge.Framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions.GetPlayerData then
            PlayerData = QBCore.Functions.GetPlayerData()
            isLoaded = LocalPlayer.state.isLoggedIn or (PlayerData and PlayerData.citizenid ~= nil)
        end
    elseif Bridge.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX and ESX.GetPlayerData then
            PlayerData = ESX.GetPlayerData()
            isLoaded = PlayerData and PlayerData.identifier ~= nil
        end
    end
end

-- Framework Events: Player Loaded
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    UpdatePlayerData()
    TriggerEvent('antarixa-bridge:client:OnPlayerLoaded', PlayerData)
end)

RegisterNetEvent('qbx_core:client:playerLoaded', function()
    UpdatePlayerData()
    TriggerEvent('antarixa-bridge:client:OnPlayerLoaded', PlayerData)
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    isLoaded = true
    TriggerEvent('antarixa-bridge:client:OnPlayerLoaded', PlayerData)
end)

-- Framework Events: Job & Gang Updates
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    TriggerEvent('antarixa-bridge:client:OnJobUpdate', JobInfo)
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    TriggerEvent('antarixa-bridge:client:OnJobUpdate', job)
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
    TriggerEvent('antarixa-bridge:client:OnGangUpdate', GangInfo)
end)

-- Core Framework Client Functions
function Bridge.GetPlayerData()
    if not next(PlayerData) then
        UpdatePlayerData()
    end
    return PlayerData
end

function Bridge.IsPlayerLoaded()
    if not isLoaded then
        UpdatePlayerData()
    end
    return isLoaded
end

function Bridge.GetJob()
    local pData = Bridge.GetPlayerData()
    if pData and pData.job then
        return {
            name = pData.job.name or 'unemployed',
            label = pData.job.label or 'Unemployed',
            grade = (pData.job.grade and (pData.job.grade.level or pData.job.grade)) or 0,
            gradeLabel = (pData.job.grade and (pData.job.grade.name or pData.job.grade.label)) or 'Freelance',
            isBoss = pData.job.isboss or false
        }
    end
    return { name = 'unemployed', label = 'Unemployed', grade = 0, gradeLabel = 'Freelance', isBoss = false }
end

function Bridge.GetGang()
    local pData = Bridge.GetPlayerData()
    if pData and pData.gang then
        return {
            name = pData.gang.name or 'none',
            label = pData.gang.label or 'None',
            grade = (pData.gang.grade and (pData.gang.grade.level or pData.gang.grade)) or 0,
            isBoss = pData.gang.isboss or false
        }
    end
    return { name = 'none', label = 'None', grade = 0, isBoss = false }
end

function Bridge.IsDead()
    local pData = Bridge.GetPlayerData()
    if pData and (pData.metadata and (pData.metadata['isdead'] or pData.metadata['inlaststand'])) then
        return true
    end
    if pData and pData.isDead then
        return true
    end
    return IsEntityDead(PlayerPedId())
end

-- Exports
exports('GetPlayerData', Bridge.GetPlayerData)
exports('IsPlayerLoaded', Bridge.IsPlayerLoaded)
exports('GetJob', Bridge.GetJob)
exports('GetGang', Bridge.GetGang)
exports('IsDead', Bridge.IsDead)
