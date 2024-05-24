function pluginMsg(tag, t, text, ...)
    local prefix = "*"
    -- print("TAG: " .. tag)
    -- print("T: " .. t)
    -- print("TEXT: " .. text)
    -- print("PLUGIN MSG: " .. dump_table(arg))
    -- debugc("PLUGIN MSG=" .. dump_table({tag=tag, t=t, text=text, arg=arg}, true))
    local message = string.format(text, unpack(arg))
    local color = "#ffffff"
    local formats = {
        info = {
            prefix = '*',
            color = '#ffffff'
        },
        warn = {
            prefix = '!',
            color = '#ffff00'
        },
        ok = {
            prefix = '+',
            color = '#00ff00'
        },
        error = {
            prefix = '-',
            color = '#ff0000'
        },
        debug = {
            prefix = '#',
            color = '#00aaff',
        }
    }

    if t == 'debug' then
        return
    end
    debugc(string.format("(%s) [%s] %s", formats[t].prefix, tag, message))
    text = string.format("(%s) [%s] %s%s#r\n", formats[t].prefix, tag, formats[t].color, message)
    hecho(text)
end



function reloadPlugin(plugin, debug)
    local name = plugin.name

    -- print(dump_table(plugin))

    pluginMsg(plugin.tag, 'ok', 'Reloading plugin %s (%s)', plugin.name, plugin.tag)

    if plugin.beforeReload then
        plugin:beforeReload()
    end

    scripts[plugin.shortName] = nil

    -- print("LOADING")
    load_plugin(name)
    -- print("LOADED")
    
    if plugin.afterReload then
        plugin:afterReload()
        -- print("AFTER AFTER")
    end
end


function loadPlugin(plugin, debug)
    if plugin.init then
        tempTimer(0.0, function() plugin:init(debug) end)
    end
end


function getCurrentCharacter()
    if not gmcp.char then
        return character_name
    else
        return gmcp.char.info.name
    end
end


function getCurrentCharacterGender()
    if not gmcp.char then
        return 'female'
    else
        return gmcp.char.info.gender
    end
end
