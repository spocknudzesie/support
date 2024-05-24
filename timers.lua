function waitUntil(conditionFun, onSuccessFun, onFailureFun, options)
    local r = string.format('%d-%d', os.time(), math.random(1, 1000000))
    local timerVar = "_timer" ..  r
    local counterVar = '_counter' .. r
    options = options or {}
    
    local timeout = options.timeout or 5.0
    local interval = options.interval or 0.1
    options = {timeout=timeout, interval=interval}

    -- print("Initializing timer " .. timerVar)

    scripts[counterVar] = 0
    scripts[timerVar] = tempTimer(options.interval, function()
        timerTick(timerVar, counterVar, conditionFun, onSuccessFun, onFailureFun, options)
    end)
end


function timerTick(timerVar, counterVar, conditionFun, onSuccessFun, onFailureFun, options)
    -- print("Tick... " .. scripts[counterVar])
    if conditionFun() then
        killTimer(scripts[timerVar])
        scripts[timerVar] = nil
        scripts[counterVar] = nil
        -- print("Timer " .. timerVar .. " killed")

        if onSuccessFun then
            onSuccessFun()
        end

        return true
    end

    scripts[counterVar] = scripts[counterVar] + options.interval

    if scripts[counterVar] > options.timeout then
        killTimer(scripts[timerVar])
        scripts[timerVar] = nil
        scripts[counterVar] = nil
        if onFailureFun then
            return onFailureFun()
        else
            return false
        end
    end

    scripts[timerVar] = tempTimer(options.interval, function()
        timerTick(timerVar, counterVar, conditionFun, onSuccessFun, onFailureFun, options)
    end)

end
