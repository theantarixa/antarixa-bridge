function Bridge.SendDiscordLog(webhook, title, description, color, fields)
    local targetWebhook = webhook or Config.Discord.DefaultWebhook
    if not targetWebhook or targetWebhook == '' then return end

    local embed = {
        {
            ['title'] = title or 'Antarixa Telemetry Log',
            ['description'] = description or '',
            ['color'] = color or Config.Discord.Color,
            ['footer'] = {
                ['text'] = 'antarixa-bridge • ' .. os.date('%Y-%m-%d %H:%M:%S')
            },
            ['fields'] = fields or {}
        }
    }

    PerformHttpRequest(targetWebhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.BotName,
        avatar_url = Config.Discord.AvatarURL,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

exports('SendDiscordLog', Bridge.SendDiscordLog)
