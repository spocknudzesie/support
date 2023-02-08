scripts.money = scripts.money or {}

function scripts.money:descToCopper(desc)
    local sections = string.split(desc:gsub(" i ", ", "), ", ")
    local copper = 0

    for i=1, #sections do
        if #(string.split(sections[i], ' ')) < 2 then
            return 0
        end
        local count, coins = scripts.numerals:subLiczebnik(sections[i])
        if coins:find("mithryl") then
            copper = copper + count * 240*100
        elseif coins:find("zlot") then
            copper = copper + count * 240
        elseif coins:find("srebrn") then
            copper = copper + count * 12
        elseif coins:find("miedzian") then
            copper = copper + count
        end
    end

    return copper
end


function scripts.money:denominate(cc, mithril, to_table)
    local mc, gc, sc

    if cc == 0 then
        mc = 0
        gc = 0
        sc = 0
    elseif mithril then
        mc = math.floor(cc / (240*100))
        cc = cc % (240*100)
        gc = math.floor(cc / 240)
        cc = cc % 240
        sc = math.floor(cc / 12)
        cc = cc % 12
    else
        gc = math.floor(cc / 240)
        cc = cc % 240
        sc = math.floor(cc / 12)
        cc = cc % 12
    end

    if mithril then
        if to_table then
            return {[1]=mc, [2]=gc, [3]=sc, [4]=cc, mc=mc, gc=gc, sc=sc, cc=cc}
        else
            return mc, gc, sc, cc
        end
    else
        if to_table then
            return {[1]=gc, [2]=sc, [3]=cc, gc=gc, sc=sc, cc=cc}
        else
            return gc, sc, cc
        end
    end
end


function scripts.money:hCopperToDesc(cc, mithril, dropZero)
    local coins
    local types = {
        mc = {'mth', '#9ec3ff'},
        gc = {'zl', '#ffaa00'},
        sc = {'sr', '#dddddd'},
        cc = {'md', '#ff6600'}
    }    
    local relTypes
    local longDesc = {}

    if mithril then
        relTypes = {'mc', 'gc', 'sc', 'cc'}
        coins = self:denominate(cc, true, true)
    else
        relTypes = {'gc', 'sc', 'cc'}
        coins = self:denominate(cc, false, true)
    end

    for i=1, #relTypes do
        local deno = relTypes[i]
        local t = types[deno]
        -- if coins[deno] > 0 or deno == "cc"  then
            if coins[deno] == 0 and not dropZero or coins[deno] > 0 then
                table.insert(longDesc, string.format("%s%2d %s#r", t[2], coins[deno], t[1]))
            end
        -- end
    end

    return string.join(longDesc, ", ")
end


function scripts.money:hCopperToDescShort(cc)
    local str = self:hCopperToDesc(cc)
    local deno = {'md', 'sr', 'zl'}
    for _, d in ipairs(deno) do
        str = str:gsub(' ' .. d,'')
    end
    str = str:gsub(', ', '.')
    return str
end


function scripts.money:cCopperToDesc(cc, mithril)
    local coins
    local types = {
        mc = {'mth', 'PaleTurquoise'},
        gc = {'zl', 'gold'},
        sc = {'sr', 'white_smoke'},
        cc = {'md', 'OrangeRed'}
    }
    local relTtypes
    local longDesc = {}

    if mithril then
        relTypes = {'mc', 'gc', 'sc', 'cc'}
        coins = self:denominate(cc, true, true)
    else
        relTypes = {'gc', 'sc', 'cc'}
        coins = self:denominate(cc, false, true)
    end

    for i=1, #relTypes do
        local deno = relTypes[i]
        local t = types[deno]
        if coins[deno] > 0 or deno == "cc" then
            table.insert(longDesc, string.format("<%s>%2d %s<reset>", t[2], coins[deno], t[1]))
        end
    end

    return string.join(longDesc, ", ")
end


function scripts.money:simpleStringToCC(arg)
    local val = 0
    local mults = {24000, 240, 12, 1}
    local i
    local s
    
    arg = string.split(arg, " ")

    s = #arg

    while #mults > #arg do
        table.remove(mults, 1)
    end

    for i, coins in ipairs(arg) do
        val = val + coins * mults[i]
    end

    return val
end
