scripts.lang = scripts.lang or {}

function scripts.lang:adjNomToAcc(str)
    if str:sub(-1) == 'a' then return str end
    return str
end


function scripts.lang:nounNomToAcc(str)
    if str:sub(-1) == 'a' then return str:sub(1,-2) .. 'e' end
    return str
end


function scripts.lang:plAdjGenToNom(str, female)
  if female then
    return str:sub(1,-4) .. 'a'
  else
    return str:sub(1,-3)
  end
end


function scripts.lang:nounGenToNom(str)
  if str:sub(-1) == 'y' then return str:sub(1,-2) .. 'a' end
  if str:sub(-1) == 'i' then return str:sub(1,-2) .. 'a' end
  if str:sub(-2) == 'ka' then return str:sub(1,-3) .. 'ek' end
  if str:sub(-2) == 'ia' then return str:sub(1,-3) .. '' end
  if str:sub(-1) == 'a' then return str:sub(1,-2) .. '' end
  return str
end


function scripts.lang:nomToAcc(str)
  local przydawka, rest
  
  przydawka, rest = self:findAttributive(str)

  if przydawka then
    return self:nomToAcc(rest) .. przydawka
  end

    rest = str:gsub(' para ', ' pare ')
    local words = string.split(rest, ' ')

    if #words == 2 then
      return string.join({words[1], self:nounNomToAcc(words[2])}, ' ')
    elseif #words == 3 then
      return string.join({words[1], words[2], self:nounNomToAcc(words[3])}, ' ')
    elseif #words == 4 then
      return string.join({words[1], words[2], self:nounNomToAcc(words[3]), words[4]}, ' ')
    end
end


function scripts.lang:genToNom(str)
  local przydawka, rest
  
  przydawka, rest = self:findAttributive(str)

  if przydawka then
    return self:nomToAcc(rest) .. przydawka
  end

    rest = str:gsub(' para ', ' pare ')
    local words = string.split(rest, ' ')

    if #words == 2 then
      return string.join({words[1], self:nounNomToAcc(words[2])}, ' ')
    elseif #words == 3 then
      return string.join({words[1], words[2], self:nounNomToAcc(words[3])}, ' ')
    elseif #words == 4 then
      return string.join({words[1], words[2], self:nounNomToAcc(words[3]), words[4]}, ' ')
    end
end


function scripts.lang:findAttributive(str)
  local attributives = {
    {attr='( z .+)$',  sub=' z .+'},
    {attr='( ze .+)$', sub=' ze .+'},
    {attr='( na .+)$', sub=' na .+'},
    {attr='( o .+)$',  sub=' o .+'},
    {attr='( w .+)$', sub=' w .+'} 
  }

  for _, a in ipairs(attributives) do
    local attr = str:match(a.attr)
    if attr then
      str = str:gsub(a.sub, '')
      return attr, str
    end
  end

  return false
end

function scripts.lang:nomToGen(str)
  local przydawka, rest
  
  przydawka, rest = self:findAttributive(str)

  if przydawka then
    return self:nomToGen(rest) .. przydawka
  end

    rest = str:gsub(' para ', ' pare ')
    local words = string.split(rest, ' ')

  if #words == 3 then
    return string.join({self:adjNomToGen(words[1]), self:adjNomToGen(words[2]), self:nounNomToGen(words[3])}, ' ')
  elseif #words == 2 then
    return string.join({self:adjNomToGen(words[1]), self:nounNomToGen(words[2])}, ' ')
  elseif #words == 1 then
    return self:nounNomToGen(words[1])
  end
end


function scripts.lang:adjNomToGen(str)
  local soft
  soft = str:sub(-2,-2) == 'k' or str:sub(-2,-2) == 'g'

  if str:sub(-1) == 'a' then
    if soft then
      return str:sub(1,-2) .. "iej"
    else
      return str:sub(1,-2) .. "ej"
    end
  elseif str:sub(-1) == 'i' then
    return str .. "ego"
  elseif str:sub(-1) == 'y' then
    return str:sub(1, -2) .. 'ego'
  elseif str:sub(-1) == 'e' then
    if soft then
      return str:sub(1,-2) .. 'ich'
    else
      return str:sub(1,-2) .. 'ych'
    end
  end
end


function scripts.lang:nounNomToGen(str)
  local soft = str:sub(-1) == 'a' and (str:sub(-2,-2) == 'g' or str:sub(-2,-2) == 'k')

  if str == 'pies' then return 'psa' end
  if str == 'osiol' then return 'osla' end
  if str == 'waz' then return 'weza' end
  if str == 'golab' then return 'golebia' end

  if str:sub(-1) == 'a' then
    if soft then return str:sub(1,-2) .. 'i'
    else return str:sub(1,-2) .. 'y'
    end
  elseif str:sub(-1) == 'e' or str:sub(-1) == 'o' then return str:sub(1,-2) .. 'a'
  else
    if str:sub(-2, -1) == 'ek' then return str:sub(1,-3) .. 'ka'
    else return str..'a'
    end
  end

end

