scripts.numerals = scripts.numerals or {}


function scripts.numerals:subLiczebnik(text, no_sub)
    local words = string.split(text, " ")
    local word = words[1]
    local number = 0
    local w = 2

    if word:match("^%d+") then
        number = tonumber(word)
    elseif word:match("^jeden") or word:match("^jedn%a+$") then
        number = 1
    elseif word:match("^dwie") or word:match("^dwa$") or word:match("^dwanasci") or word:match("^dwoch") or word:match("^dwunastu") or word:match("^dwudziest") or word:match("^dwadziesc") then
        number = 2
    elseif word:match("^trzy") or word:match("^trzech") or word:match("^troje") then
        number = 3
    elseif word:match("^czter") or word:match("^czwor") then
        number = 4
    elseif word:match("^piec$") or word:match("^pieciu$") or word:match("^piecdzie") or word:match("^pietnas") then
        number = 5
    elseif word:match("^szesciu") or word:match("^szescdzie") or word:match("^szesnas") or word:match("^szesc$") then
        number = 6
    elseif word:match("^sied%a*m") then
        number = 7 
    elseif word:match("^osiem") or word:match("^osmiu") then
        number = 8
    elseif word:match("^dziewie.") then
        number = 9        
    elseif word:match("^dziesiec") then
        number = 10
    end

    if word:match("nascie$") or word:match("nastu$") then
        number = number + 10
    elseif word:match("dziescia$") or word:match("dziesci$") or word:match("dzies%a*t") or word:match("dziesiec.") and number ~= 10 then
        number = number*10
    end
    
    if number >= 20 then
        local units 
        units = self:subLiczebnik(words[2], true)
        if units > 0 then
            number = number + units
            w = 3
        end
    end

    if no_sub then
        return number
    else
        return number, string.join({unpack(words, w)}, " ")
    end
end


setModulePriority("support", 1)
