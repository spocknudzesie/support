str = str or {}


function str:hecho(label, col, text)
    hecho(string.format("[%s" .. label .. "#r] #aaaaaa%s#r\n", col, text))
end


function str:herror(label, text)
    self:hecho(label, "#7f0000", text)
end


function str:hwarn(label, text)
    self:hecho(label, '#ffdd00', text)
end


function str:hok(label, text)
    self:hecho(label, "#007f00", text)
end


function str:print(label, color, fmt, ...)
    fmt = fmt:gsub('%%S', string.format('%s%%%%s#r', color))
    hecho(string.format('[%s%s#r] %s\n', color, label, string.format(fmt, unpack(arg))))
end


-------------------------
-- wylapuje ze stringa podany pattern i przyporzadkowuje kolejne wyniki do podanych w tablicy indeksow
-- @param pattern - pattern do wylapania
-- @param keys - tablica indeksow, ktore maja zostac wygenerowane
-------------------------
function string:capture(pattern, keys)
    local res
    -- print("STRING="..self)
    string_matches = nil
    if not keys then
        string_matches = {unpack({self:find(pattern)}, 3)}
        -- print("MATCHES="..dump_table(string_matches))
        if #string_matches == 0 then string_matches = nil end
        -- if string_matches then hecho("#00bb00MATCH#r " .. dump_table(string_matches)) end
        return string_matches
    else
        local tokens = {unpack({self:find(pattern)}, 3)}
        -- print(dump_table(tokens))
        if #tokens == 0 then return nil end
        local res = {}
        for i, key in ipairs(keys) do
            res[key] = tokens[i]
        end
        string_matches = res
        -- if string_matches then
        --     hecho("#00bb00MATCH#r " .. dump_table(string_matches))
        -- end
        return string_matches
    end
end


-------------------------
-- centruje tekst
-- @param width - szerokosc calego tekstu
-- @param padding - znak, jakim wypelnione beda puste miejsca
-------------------------
function string:center(width, padding)
    local l = width - self:len()
    local left, right
    if l % 2 == 0 then
        left = l/2
        right = l/2
    else
        left = math.floor(l/2-0.5)
        right = math.floor(l/2+0.5)
    end

    padding = padding or ' '
    return string.format("%s%s%s", string.rep(padding, left), self, string.rep(padding, right))
end


------------------------------------------
-- formatuje string, zastepujac kolejne wystapienia #{tekst} odpowiednimi
-- elementami podanej tablicy
-- @param args - tablica tekstow do zastapienia
------------------------------------------
function string:fmt(args)
    local res = self:gsub('#{(%a+)}', function(m)
        return args[m]
    end)

    return res
end


-------------------------
-- degnomizuje tekst, dodajac spacje przed kazda wielka litera
-------------------------
function string:degnome()
    local t = {}
    local res = ""
    for wrd in self:gmatch("%u%U*") do 
        wrd = wrd:match "^%s*(.-)%s*$"
        table.insert(t, wrd)
    end
    res = string.join(t, " ")
    -- echo(dump_table(t))
    return res
end

