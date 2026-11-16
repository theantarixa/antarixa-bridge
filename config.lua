Config = {}

-- Auto-Detect automatically resolves the active framework, inventory, target, and notify systems.
-- Set to false only if you want to force specific handlers manually.
Config.AutoDetect = true

Config.Manual = {
    Framework = 'qbx',      -- 'qbx' | 'qb' | 'esx' | 'standalone'
    Inventory = 'ox',       -- 'ox' | 'qb' | 'esx'
    Target = 'ox',          -- 'ox' | 'qb'
    Notify = 'ox_lib'       -- 'ox_lib' | 'qb' | 'esx' | 'custom'
}

-- GitHub Version & Telemetry Checker
Config.VersionCheck = true
Config.GitHubRepo = 'theantarixa/antarixa-bridge' -- Default repo for the bridge itself
Config.GitHubBranch = 'main'

-- Discord Webhook Fallback configuration
Config.Discord = {
    DefaultWebhook = '',
    BotName = 'Antarixa Bridge Telemetry',
    AvatarURL = 'https://avatars.githubusercontent.com/u/78833502?v=4',
    Color = 0x00E5FF -- Electric Cyan
}

-- Debug prints in server & client console
Config.Debug = false
