function table.sub(t, from, to)
    return {unpack(t, from, to)}
end

-- function table.map(t, func)
--     local res = {}

--     for k, v in pairs(t) do
--         res[k] = func(v)
--     end

--     return res
-- end

-- function table.filter(t, func)
--     local res = {}
--     for k, v in pairs(t) do
--         if func(v) theng
--             res[k] = v
--         end
--     end
--     return res
-- end

function table.contains(t, el)
    for i=1, #t do
        if t[i] == el then return i end
    end
    return false
end

function table.length(t)
    local s = 0

    for _, e in pairs(t) do
        s = s+1
    end

    return s
end

function table.group(t, func)
    local res = {}
    for _, e in ipairs(t) do
        local discriminator

        if type(func) == 'string' then
            discriminator = e[func]
        else
            discriminator = func(e)
        end
        
        res[discriminator] = res[discriminator] or {}
        table.insert(res[discriminator], e)
        
    end

    return res
end

function table.dup(t)
    local res = {}
    for k, v in pairs(t) do
        res[k] = v
    end

    return res
end

