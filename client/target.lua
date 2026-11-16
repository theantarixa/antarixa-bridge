local function ConvertOptionsToOx(options)
    local oxOptions = {}
    for _, opt in ipairs(options) do
        table.insert(oxOptions, {
            name = opt.name or opt.label,
            label = opt.label or opt.name,
            icon = opt.icon or 'fa-solid fa-hand',
            distance = opt.distance or 2.5,
            groups = opt.job,
            items = opt.item,
            canInteract = opt.canInteract,
            onSelect = function(data)
                if opt.action then
                    opt.action(data and data.entity)
                elseif opt.event then
                    if opt.type == 'server' then
                        TriggerServerEvent(opt.event, opt.args)
                    elseif opt.type == 'client' then
                        TriggerEvent(opt.event, opt.args)
                    else
                        TriggerEvent(opt.event, opt.args)
                    end
                end
            end
        })
    end
    return oxOptions
end

local function ConvertOptionsToQb(options)
    local qbOptions = {}
    for _, opt in ipairs(options) do
        table.insert(qbOptions, {
            type = opt.type or 'client',
            event = opt.event,
            icon = opt.icon or 'fa-solid fa-hand',
            label = opt.label or opt.name,
            job = opt.job,
            item = opt.item,
            action = opt.action,
            canInteract = opt.canInteract
        })
    end
    return qbOptions
end

function Bridge.AddBoxZone(name, coords, size, heading, options)
    if Bridge.Target == 'ox' then
        return exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size or vec3(1.0, 1.0, 1.0),
            rotation = heading or 0.0,
            options = ConvertOptionsToOx(options)
        })
    elseif Bridge.Target == 'qb' then
        return exports['qb-target']:AddBoxZone(name, coords, size.y or 1.0, size.x or 1.0, {
            name = name,
            heading = heading or 0.0,
            debugPoly = Config.Debug,
            minZ = coords.z - ((size.z or 1.0) / 2),
            maxZ = coords.z + ((size.z or 1.0) / 2)
        }, {
            options = ConvertOptionsToQb(options),
            distance = 2.5
        })
    end
end

function Bridge.AddSphereZone(name, coords, radius, options)
    if Bridge.Target == 'ox' then
        return exports.ox_target:addSphereZone({
            name = name,
            coords = coords,
            radius = radius or 1.5,
            options = ConvertOptionsToOx(options)
        })
    elseif Bridge.Target == 'qb' then
        return exports['qb-target']:AddCircleZone(name, coords, radius or 1.5, {
            name = name,
            debugPoly = Config.Debug
        }, {
            options = ConvertOptionsToQb(options),
            distance = radius or 2.5
        })
    end
end

function Bridge.AddTargetModel(models, options)
    if Bridge.Target == 'ox' then
        return exports.ox_target:addModel(models, ConvertOptionsToOx(options))
    elseif Bridge.Target == 'qb' then
        return exports['qb-target']:AddTargetModel(models, {
            options = ConvertOptionsToQb(options),
            distance = 2.5
        })
    end
end

function Bridge.AddTargetEntity(entity, options)
    if Bridge.Target == 'ox' then
        return exports.ox_target:addLocalEntity(entity, ConvertOptionsToOx(options))
    elseif Bridge.Target == 'qb' then
        return exports['qb-target']:AddTargetEntity(entity, {
            options = ConvertOptionsToQb(options),
            distance = 2.5
        })
    end
end

function Bridge.RemoveZone(id)
    if Bridge.Target == 'ox' then
        exports.ox_target:removeZone(id)
    elseif Bridge.Target == 'qb' then
        exports['qb-target']:RemoveZone(id)
    end
end

exports('AddBoxZone', Bridge.AddBoxZone)
exports('AddSphereZone', Bridge.AddSphereZone)
exports('AddTargetModel', Bridge.AddTargetModel)
exports('AddTargetEntity', Bridge.AddTargetEntity)
exports('RemoveZone', Bridge.RemoveZone)
