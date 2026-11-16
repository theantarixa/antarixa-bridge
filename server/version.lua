local function ParseVersion(versionStr)
    return versionStr and versionStr:match('%d+%.%d+%.%d+') or versionStr
end

local function PadVersion(version)
    local parts = {}
    for num in (version or '0.0.0'):gmatch('%d+') do
        table.insert(parts, tonumber(num) or 0)
    end
    while #parts < 3 do
        table.insert(parts, 0)
    end
    return parts
end

-- Returns: -1 if v1 < v2 (outdated), 0 if equal, 1 if v1 > v2 (newer/dev)
local function CompareVersions(v1, v2)
    local a, b = PadVersion(v1), PadVersion(v2)
    for i = 1, 3 do
        if a[i] < b[i] then return -1
        elseif a[i] > b[i] then return 1 end
    end
    return 0
end

function Bridge.CheckVersion(resourceName, currentVersion, githubRepo, branch)
    if not Config.VersionCheck then return end
    resourceName = resourceName or GetCurrentResourceName()
    githubRepo = githubRepo or Config.GitHubRepo
    branch = branch or Config.GitHubBranch or 'main'

    if not currentVersion then
        local rawVersion = GetResourceMetadata(resourceName, 'version', 0)
        currentVersion = ParseVersion(rawVersion) or '1.0.0'
    end

    local rawUrl = string.format('https://raw.githubusercontent.com/%s/%s/version.json', githubRepo, branch)

    PerformHttpRequest(rawUrl, function(statusCode, responseText, headers)
        if statusCode == 200 and responseText then
            local data = json.decode(responseText)
            if data and data.version then
                local latestVersion = ParseVersion(data.version)
                local comparison = CompareVersions(currentVersion, latestVersion)

                if comparison == -1 then
                    print(string.format([[
^1========================================================================^7
^3[Antarixa:UPDATE AVAILABLE]^7 ^5%s^7
Current Version: ^1v%s^7 ───> Latest Version: ^2v%s^7
Download / Release: ^5https://github.com/%s/releases/latest^7
^1========================================================================^7]], 
                    string.upper(resourceName), currentVersion, latestVersion, githubRepo))
                    
                    if data.changelog and type(data.changelog) == 'table' then
                        print('^3Patch Notes & Bug Fixes:^7')
                        for _, change in ipairs(data.changelog) do
                            print('  ^2•^7 ' .. tostring(change))
                        end
                        print('^1------------------------------------------------------------------------^7')
                    end
                elseif comparison == 0 then
                    if Config.Debug then
                        print(string.format('^2[Antarixa:OK]^7 %s is up-to-date (v%s).', resourceName, currentVersion))
                    end
                else
                    if Config.Debug then
                        print(string.format('^3[Antarixa:DEV]^7 %s is running a future/unreleased build (v%s vs remote v%s).', resourceName, currentVersion, latestVersion))
                    end
                end
            end
        end
    end, 'GET', '', { ['User-Agent'] = 'Antarixa-Telemetry' })
end

-- Reusable registration for any other resource in the server
function Bridge.RegisterVersionCheck(resourceName, githubRepo, branch)
    CreateThread(function()
        Wait(3000) -- Small delay to avoid boot spam
        Bridge.CheckVersion(resourceName, nil, githubRepo, branch)
    end)
end

-- Auto-check Bridge itself on server boot
CreateThread(function()
    Wait(2500)
    Bridge.CheckVersion(GetCurrentResourceName(), nil, Config.GitHubRepo, Config.GitHubBranch)
end)

-- Exports
exports('CheckVersion', Bridge.CheckVersion)
exports('RegisterVersionCheck', Bridge.RegisterVersionCheck)
