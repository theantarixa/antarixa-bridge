function Bridge.Progress(options)
    local duration = options.duration or 5000
    local label = options.label or 'Processing...'
    local useCircle = options.useCircle ~= false -- Default to circle if ox_lib

    if GetResourceState('ox_lib') == 'started' then
        local progressConfig = {
            duration = duration,
            label = label,
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel ~= false,
            disable = {
                move = options.disableMovement or false,
                car = options.disableCar or false,
                combat = options.disableCombat ~= false,
                mouse = options.disableMouse or false
            },
            anim = options.anim and {
                dict = options.anim.dict,
                clip = options.anim.clip,
                flag = options.anim.flag or 49
            } or nil,
            prop = options.prop and {
                model = options.prop.model,
                bone = options.prop.bone,
                pos = options.prop.pos,
                rot = options.prop.rot
            } or nil
        }

        local success = false
        if useCircle then
            success = lib.progressCircle(progressConfig)
        else
            success = lib.progressBar(progressConfig)
        end

        if success then
            if options.onComplete then options.onComplete() end
            return true
        else
            if options.onCancel then options.onCancel() end
            return false
        end
    elseif Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions.Progressbar then
            local p = promise.new()
            QBCore.Functions.Progressbar(
                options.name or 'antarixa_progress',
                label,
                duration,
                options.useWhileDead or false,
                options.canCancel ~= false,
                {
                    disableMovement = options.disableMovement or false,
                    disableCarMovement = options.disableCar or false,
                    disableMouse = options.disableMouse or false,
                    disableCombat = options.disableCombat ~= false
                },
                options.anim and {
                    animDict = options.anim.dict,
                    anim = options.anim.clip,
                    flags = options.anim.flag or 49
                } or {},
                options.prop and {
                    model = options.prop.model,
                    bone = options.prop.bone,
                    coords = options.prop.pos,
                    rotation = options.prop.rot
                } or {},
                {},
                function()
                    if options.onComplete then options.onComplete() end
                    p:resolve(true)
                end,
                function()
                    if options.onCancel then options.onCancel() end
                    p:resolve(false)
                end
            )
            return Citizen.Await(p)
        end
    end

    -- Standalone fallback: simple Wait
    Wait(duration)
    if options.onComplete then options.onComplete() end
    return true
end

exports('Progress', Bridge.Progress)
