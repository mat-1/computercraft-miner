--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
function __TS__StringSubstring(self, start, ____end)
    if ____end ~= ____end then
        ____end = 0
    end
    if (____end ~= nil) and (start > ____end) then
        start, ____end = __TS__Unpack({____end, start})
    end
    if start >= 0 then
        start = start + 1
    else
        start = 1
    end
    if (____end ~= nil) and (____end < 0) then
        ____end = 0
    end
    return string.sub(self, start, ____end)
end

function __TS__StringSplit(source, separator, limit)
    if limit == nil then
        limit = 4294967295
    end
    if limit == 0 then
        return {}
    end
    local out = {}
    local index = 0
    local count = 0
    if (separator == nil) or (separator == "") then
        while (index < (#source - 1)) and (count < limit) do
            out[count + 1] = __TS__StringAccess(source, index)
            count = count + 1
            index = index + 1
        end
    else
        local separatorLength = #separator
        local nextIndex = (string.find(source, separator, nil, true) or 0) - 1
        while (nextIndex >= 0) and (count < limit) do
            out[count + 1] = __TS__StringSubstring(source, index, nextIndex)
            count = count + 1
            index = nextIndex + separatorLength
            nextIndex = (string.find(
                source,
                separator,
                math.max(index + 1, 1),
                true
            ) or 0) - 1
        end
    end
    if count < limit then
        out[count + 1] = __TS__StringSubstring(source, index)
    end
    return out
end

__TS__parseInt_base_pattern = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTvVwWxXyYzZ"
function __TS__ParseInt(numberString, base)
    if base == nil then
        base = 10
        local hexMatch = string.match(numberString, "^%s*-?0[xX]")
        if hexMatch then
            base = 16
            numberString = ((string.match(hexMatch, "-") and (function() return "-" .. tostring(
                __TS__StringSubstr(numberString, #hexMatch)
            ) end)) or (function() return __TS__StringSubstr(numberString, #hexMatch) end))()
        end
    end
    if (base < 2) or (base > 36) then
        return 0 / 0
    end
    local allowedDigits = (((base <= 10) and (function() return __TS__StringSubstring(__TS__parseInt_base_pattern, 0, base) end)) or (function() return __TS__StringSubstr(__TS__parseInt_base_pattern, 0, 10 + (2 * (base - 10))) end))()
    local pattern = ("^%s*(-?[" .. allowedDigits) .. "]*)"
    local number = tonumber(
        string.match(numberString, pattern),
        base
    )
    if number == nil then
        return 0 / 0
    end
    if number >= 0 then
        return math.floor(number)
    else
        return math.ceil(number)
    end
end

turtle.refuel()
function makeCoordinate(self, north, up, east)
    return {north = north, east = east, up = up}
end
TOTAL_SLOTS = 4 * 4
function refuelAll(self)
    local couldRefuel = false
    do
        local i = 1
        while i < TOTAL_SLOTS do
            turtle.select(i)
            local r = turtle.refuel()
            if r then
                couldRefuel = true
            end
            i = i + 1
        end
    end
    if couldRefuel then
        print("Refueled turtle!")
    else
        print("Couldn't find any fuel :(")
    end
    turtle.select(1)
end
function stringifyPosition(self, position)
    if position then
        return (((tostring(position.north) .. ",") .. tostring(position.up)) .. ",") .. tostring(position.east)
    else
        return "?,?,?"
    end
end
function unstringifyPosition(self, position)
    local north, up, east = unpack(
        __TS__StringSplit(position, ",")
    )
    return makeCoordinate(
        _G,
        __TS__ParseInt(north),
        __TS__ParseInt(up),
        __TS__ParseInt(east)
    )
end
function loadPosition(self)
    local file = fs.open("position.txt", "r")
    local data
    if file == nil then
        return makeCoordinate(_G, 0, 0, 0)
    else
        data = file.readAll()
        file.close()
        return unstringifyPosition(_G, data)
    end
end
currentPosition = loadPosition(_G)
function savePosition(self)
    local file = fs.open("position.txt", "w")
    if file ~= nil then
        file.write(
            stringifyPosition(_G, currentPosition)
        )
        file.close()
    end
end
function loadWorld(self)
    local file = fs.open("world.txt", "r")
    local data
    if file == nil then
        return {}
    else
        data = file.readAll()
        file.close()
        return textutils.unserialize(data)
    end
end
