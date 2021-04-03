
local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file)
    if ____moduleCache[file] then
        return ____moduleCache[file]
    end
    if ____modules[file] then
        ____moduleCache[file] = ____modules[file]()
        return ____moduleCache[file]
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["lualib_bundle"] = function() function __TS__ArrayIsArray(value)
    return (type(value) == "table") and ((value[1] ~= nil) or (next(value, nil) == nil))
end

function __TS__ArrayConcat(arr1, ...)
    local args = {...}
    local out = {}
    for ____, val in ipairs(arr1) do
        out[#out + 1] = val
    end
    for ____, arg in ipairs(args) do
        if __TS__ArrayIsArray(arg) then
            local argAsArray = arg
            for ____, val in ipairs(argAsArray) do
                out[#out + 1] = val
            end
        else
            out[#out + 1] = arg
        end
    end
    return out
end

function __TS__ArrayEvery(arr, callbackfn)
    do
        local i = 0
        while i < #arr do
            if not callbackfn(_G, arr[i + 1], i, arr) then
                return false
            end
            i = i + 1
        end
    end
    return true
end

function __TS__ArrayFilter(arr, callbackfn)
    local result = {}
    do
        local i = 0
        while i < #arr do
            if callbackfn(_G, arr[i + 1], i, arr) then
                result[#result + 1] = arr[i + 1]
            end
            i = i + 1
        end
    end
    return result
end

function __TS__ArrayForEach(arr, callbackFn)
    do
        local i = 0
        while i < #arr do
            callbackFn(_G, arr[i + 1], i, arr)
            i = i + 1
        end
    end
end

function __TS__ArrayFind(arr, predicate)
    local len = #arr
    local k = 0
    while k < len do
        local elem = arr[k + 1]
        if predicate(_G, elem, k, arr) then
            return elem
        end
        k = k + 1
    end
    return nil
end

function __TS__ArrayFindIndex(arr, callbackFn)
    do
        local i = 0
        local len = #arr
        while i < len do
            if callbackFn(_G, arr[i + 1], i, arr) then
                return i
            end
            i = i + 1
        end
    end
    return -1
end

function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k, len do
        if self[i + 1] == searchElement then
            return true
        end
    end
    return false
end

function __TS__ArrayIndexOf(arr, searchElement, fromIndex)
    local len = #arr
    if len == 0 then
        return -1
    end
    local n = 0
    if fromIndex then
        n = fromIndex
    end
    if n >= len then
        return -1
    end
    local k
    if n >= 0 then
        k = n
    else
        k = len + n
        if k < 0 then
            k = 0
        end
    end
    do
        local i = k
        while i < len do
            if arr[i + 1] == searchElement then
                return i
            end
            i = i + 1
        end
    end
    return -1
end

function __TS__ArrayJoin(self, separator)
    if separator == nil then
        separator = ","
    end
    local result = ""
    for index, value in ipairs(self) do
        if index > 1 then
            result = tostring(result) .. tostring(separator)
        end
        result = tostring(result) .. tostring(
            tostring(value)
        )
    end
    return result
end

function __TS__ArrayMap(arr, callbackfn)
    local newArray = {}
    do
        local i = 0
        while i < #arr do
            newArray[i + 1] = callbackfn(_G, arr[i + 1], i, arr)
            i = i + 1
        end
    end
    return newArray
end

function __TS__ArrayPush(arr, ...)
    local items = {...}
    for ____, item in ipairs(items) do
        arr[#arr + 1] = item
    end
    return #arr
end

function __TS__ArrayReduce(arr, callbackFn, ...)
    local len = #arr
    local k = 0
    local accumulator = nil
    if select("#", ...) ~= 0 then
        accumulator = select(1, ...)
    elseif len > 0 then
        accumulator = arr[1]
        k = 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k, len - 1 do
        accumulator = callbackFn(_G, accumulator, arr[i + 1], i, arr)
    end
    return accumulator
end

function __TS__ArrayReduceRight(arr, callbackFn, ...)
    local len = #arr
    local k = len - 1
    local accumulator = nil
    if select("#", ...) ~= 0 then
        accumulator = select(1, ...)
    elseif len > 0 then
        accumulator = arr[k + 1]
        k = k - 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k, 0, -1 do
        accumulator = callbackFn(_G, accumulator, arr[i + 1], i, arr)
    end
    return accumulator
end

function __TS__ArrayReverse(arr)
    local i = 0
    local j = #arr - 1
    while i < j do
        local temp = arr[j + 1]
        arr[j + 1] = arr[i + 1]
        arr[i + 1] = temp
        i = i + 1
        j = j - 1
    end
    return arr
end

function __TS__ArrayShift(arr)
    return table.remove(arr, 1)
end

function __TS__ArrayUnshift(arr, ...)
    local items = {...}
    do
        local i = #items - 1
        while i >= 0 do
            table.insert(arr, 1, items[i + 1])
            i = i - 1
        end
    end
    return #arr
end

function __TS__ArraySort(arr, compareFn)
    if compareFn ~= nil then
        table.sort(
            arr,
            function(a, b) return compareFn(_G, a, b) < 0 end
        )
    else
        table.sort(arr)
    end
    return arr
end

function __TS__ArraySlice(list, first, last)
    local len = #list
    local relativeStart = first or 0
    local k
    if relativeStart < 0 then
        k = math.max(len + relativeStart, 0)
    else
        k = math.min(relativeStart, len)
    end
    local relativeEnd = last
    if last == nil then
        relativeEnd = len
    end
    local final
    if relativeEnd < 0 then
        final = math.max(len + relativeEnd, 0)
    else
        final = math.min(relativeEnd, len)
    end
    local out = {}
    local n = 0
    while k < final do
        out[n + 1] = list[k + 1]
        k = k + 1
        n = n + 1
    end
    return out
end

function __TS__ArraySome(arr, callbackfn)
    do
        local i = 0
        while i < #arr do
            if callbackfn(_G, arr[i + 1], i, arr) then
                return true
            end
            i = i + 1
        end
    end
    return false
end

function __TS__ArraySplice(list, ...)
    local len = #list
    local actualArgumentCount = select("#", ...)
    local start = select(1, ...)
    local deleteCount = select(2, ...)
    local actualStart
    if start < 0 then
        actualStart = math.max(len + start, 0)
    else
        actualStart = math.min(start, len)
    end
    local itemCount = math.max(actualArgumentCount - 2, 0)
    local actualDeleteCount
    if actualArgumentCount == 0 then
        actualDeleteCount = 0
    elseif actualArgumentCount == 1 then
        actualDeleteCount = len - actualStart
    else
        actualDeleteCount = math.min(
            math.max(deleteCount or 0, 0),
            len - actualStart
        )
    end
    local out = {}
    do
        local k = 0
        while k < actualDeleteCount do
            local from = actualStart + k
            if list[from + 1] then
                out[k + 1] = list[from + 1]
            end
            k = k + 1
        end
    end
    if itemCount < actualDeleteCount then
        do
            local k = actualStart
            while k < (len - actualDeleteCount) do
                local from = k + actualDeleteCount
                local to = k + itemCount
                if list[from + 1] then
                    list[to + 1] = list[from + 1]
                else
                    list[to + 1] = nil
                end
                k = k + 1
            end
        end
        do
            local k = len
            while k > ((len - actualDeleteCount) + itemCount) do
                list[k] = nil
                k = k - 1
            end
        end
    elseif itemCount > actualDeleteCount then
        do
            local k = len - actualDeleteCount
            while k > actualStart do
                local from = (k + actualDeleteCount) - 1
                local to = (k + itemCount) - 1
                if list[from + 1] then
                    list[to + 1] = list[from + 1]
                else
                    list[to + 1] = nil
                end
                k = k - 1
            end
        end
    end
    local j = actualStart
    for i = 3, actualArgumentCount do
        list[j + 1] = select(i, ...)
        j = j + 1
    end
    do
        local k = #list - 1
        while k >= ((len - actualDeleteCount) + itemCount) do
            list[k + 1] = nil
            k = k - 1
        end
    end
    return out
end

function __TS__ArrayToObject(array)
    local object = {}
    do
        local i = 0
        while i < #array do
            object[i] = array[i + 1]
            i = i + 1
        end
    end
    return object
end

function __TS__ArrayFlat(array, depth)
    if depth == nil then
        depth = 1
    end
    local result = {}
    for ____, value in ipairs(array) do
        if (depth > 0) and __TS__ArrayIsArray(value) then
            result = __TS__ArrayConcat(
                result,
                __TS__ArrayFlat(value, depth - 1)
            )
        else
            result[#result + 1] = value
        end
    end
    return result
end

function __TS__ArrayFlatMap(array, callback)
    local result = {}
    do
        local i = 0
        while i < #array do
            local value = callback(_G, array[i + 1], i, array)
            if (type(value) == "table") and __TS__ArrayIsArray(value) then
                result = __TS__ArrayConcat(result, value)
            else
                result[#result + 1] = value
            end
            i = i + 1
        end
    end
    return result
end

function __TS__ArraySetLength(arr, length)
    if (((length < 0) or (length ~= length)) or (length == math.huge)) or (math.floor(length) ~= length) then
        error(
            "invalid array length: " .. tostring(length),
            0
        )
    end
    do
        local i = #arr - 1
        while i >= length do
            arr[i + 1] = nil
            i = i - 1
        end
    end
    return length
end

function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

function __TS__CloneDescriptor(____bindingPattern0)
    local enumerable
    enumerable = ____bindingPattern0.enumerable
    local configurable
    configurable = ____bindingPattern0.configurable
    local get
    get = ____bindingPattern0.get
    local set
    set = ____bindingPattern0.set
    local writable
    writable = ____bindingPattern0.writable
    local value
    value = ____bindingPattern0.value
    local descriptor = {enumerable = enumerable == true, configurable = configurable == true}
    local hasGetterOrSetter = (get ~= nil) or (set ~= nil)
    local hasValueOrWritableAttribute = (writable ~= nil) or (value ~= nil)
    if hasGetterOrSetter and hasValueOrWritableAttribute then
        error("Invalid property descriptor. Cannot both specify accessors and a value or writable attribute.", 0)
    end
    if get or set then
        descriptor.get = get
        descriptor.set = set
    else
        descriptor.value = value
        descriptor.writable = writable == true
    end
    return descriptor
end

function __TS__Decorate(decorators, target, key, desc)
    local result = target
    do
        local i = #decorators
        while i >= 0 do
            local decorator = decorators[i + 1]
            if decorator then
                local oldResult = result
                if key == nil then
                    result = decorator(_G, result)
                elseif desc == true then
                    local value = rawget(target, key)
                    local descriptor = __TS__ObjectGetOwnPropertyDescriptor(target, key) or ({configurable = true, writable = true, value = value})
                    local desc = decorator(_G, target, key, descriptor) or descriptor
                    local isSimpleValue = (((desc.configurable == true) and (desc.writable == true)) and (not desc.get)) and (not desc.set)
                    if isSimpleValue then
                        rawset(target, key, desc.value)
                    else
                        __TS__SetDescriptor(
                            target,
                            key,
                            __TS__ObjectAssign({}, descriptor, desc)
                        )
                    end
                elseif desc == false then
                    result = decorator(_G, target, key, desc)
                else
                    result = decorator(_G, target, key)
                end
                result = result or oldResult
            end
            i = i - 1
        end
    end
    return result
end

function __TS__DecorateParam(paramIndex, decorator)
    return function(____, target, key) return decorator(_G, target, key, paramIndex) end
end

function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors") or ({})
end

function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. ".",
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    if target[key] ~= nil then
        target[key] = nil
        return true
    end
    return false
end

function __TS__DelegatedYield(iterable)
    if type(iterable) == "string" then
        for index = 0, #iterable - 1 do
            coroutine.yield(
                __TS__StringAccess(iterable, index)
            )
        end
    elseif iterable.____coroutine ~= nil then
        local co = iterable.____coroutine
        while true do
            local status, value = coroutine.resume(co)
            if not status then
                error(value, 0)
            end
            if coroutine.status(co) == "dead" then
                return value
            else
                coroutine.yield(value)
            end
        end
    elseif iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                return result.value
            else
                coroutine.yield(result.value)
            end
        end
    else
        for ____, value in ipairs(iterable) do
            coroutine.yield(value)
        end
    end
end

function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

function __TS__GetErrorStack(self, constructor)
    local level = 1
    while true do
        local info = debug.getinfo(level, "f")
        level = level + 1
        if not info then
            level = 1
            break
        elseif info.func == constructor then
            break
        end
    end
    return debug.traceback(nil, level)
end
function __TS__WrapErrorToString(self, getDescription)
    return function(self)
        local description = getDescription(self)
        local caller = debug.getinfo(3, "f")
        if (_VERSION == "Lua 5.1") or (caller and (caller.func ~= error)) then
            return description
        else
            return (tostring(description) .. "\n") .. self.stack
        end
    end
end
function __TS__InitErrorClass(self, Type, name)
    Type.name = name
    return setmetatable(
        Type,
        {
            __call = function(____, _self, message) return __TS__New(Type, message) end
        }
    )
end
Error = __TS__InitErrorClass(
    _G,
    (function()
        local ____ = __TS__Class()
        ____.name = ""
        function ____.prototype.____constructor(self, message)
            if message == nil then
                message = ""
            end
            self.message = message
            self.name = "Error"
            self.stack = __TS__GetErrorStack(_G, self.constructor.new)
            local metatable = getmetatable(self)
            if not metatable.__errorToStringPatched then
                metatable.__errorToStringPatched = true
                metatable.__tostring = __TS__WrapErrorToString(_G, metatable.__tostring)
            end
        end
        function ____.prototype.__tostring(self)
            return (((self.message ~= "") and (function() return (self.name .. ": ") .. self.message end)) or (function() return self.name end))()
        end
        return ____
    end)(),
    "Error"
)
for ____, errorName in ipairs({"RangeError", "ReferenceError", "SyntaxError", "TypeError", "URIError"}) do
    _G[errorName] = __TS__InitErrorClass(
        _G,
        (function()
            local ____ = __TS__Class()
            ____.name = ____.name
            __TS__ClassExtends(____, Error)
            function ____.prototype.____constructor(self, ...)
                Error.prototype.____constructor(self, ...)
                self.name = errorName
            end
            return ____
        end)(),
        errorName
    )
end

__TS__Unpack = table.unpack or unpack

function __TS__FunctionBind(fn, thisArg, ...)
    local boundArgs = {...}
    return function(____, ...)
        local args = {...}
        do
            local i = 0
            while i < #boundArgs do
                table.insert(args, i + 1, boundArgs[i + 1])
                i = i + 1
            end
        end
        return fn(
            thisArg,
            __TS__Unpack(args)
        )
    end
end

____symbolMetatable = {
    __tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end
}
function __TS__Symbol(description)
    return setmetatable({description = description}, ____symbolMetatable)
end
Symbol = {
    iterator = __TS__Symbol("Symbol.iterator"),
    hasInstance = __TS__Symbol("Symbol.hasInstance"),
    species = __TS__Symbol("Symbol.species"),
    toStringTag = __TS__Symbol("Symbol.toStringTag")
}

function __TS__GeneratorIterator(self)
    return self
end
function __TS__GeneratorNext(self, ...)
    local co = self.____coroutine
    if coroutine.status(co) == "dead" then
        return {done = true}
    end
    local status, value = coroutine.resume(co, ...)
    if not status then
        error(value, 0)
    end
    return {
        value = value,
        done = coroutine.status(co) == "dead"
    }
end
function __TS__Generator(fn)
    return function(...)
        local args = {...}
        local argsLength = select("#", ...)
        return {
            ____coroutine = coroutine.create(
                function() return fn(
                    (unpack or table.unpack)(args, 1, argsLength)
                ) end
            ),
            [Symbol.iterator] = __TS__GeneratorIterator,
            next = __TS__GeneratorNext
        }
    end
end

function __TS__InstanceOf(obj, classTbl)
    if type(classTbl) ~= "table" then
        error("Right-hand side of 'instanceof' is not an object", 0)
    end
    if classTbl[Symbol.hasInstance] ~= nil then
        return not (not classTbl[Symbol.hasInstance](classTbl, obj))
    end
    if type(obj) == "table" then
        local luaClass = obj.constructor
        while luaClass ~= nil do
            if luaClass == classTbl then
                return true
            end
            luaClass = luaClass.____super
        end
    end
    return false
end

function __TS__InstanceOfObject(value)
    local valueType = type(value)
    return (valueType == "table") or (valueType == "function")
end

function __TS__IteratorGeneratorStep(self)
    local co = self.____coroutine
    local status, value = coroutine.resume(co)
    if not status then
        error(value, 0)
    end
    if coroutine.status(co) == "dead" then
        return
    end
    return true, value
end
function __TS__IteratorIteratorStep(self)
    local result = self:next()
    if result.done then
        return
    end
    return true, result.value
end
function __TS__IteratorStringStep(self, index)
    index = index + 1
    if index > #self then
        return
    end
    return index, string.sub(self, index, index)
end
function __TS__Iterator(iterable)
    if type(iterable) == "string" then
        return __TS__IteratorStringStep, iterable, 0
    elseif iterable.____coroutine ~= nil then
        return __TS__IteratorGeneratorStep, iterable
    elseif iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        return __TS__IteratorIteratorStep, iterator
    else
        return __TS__Unpack(
            {
                ipairs(iterable)
            }
        )
    end
end

Map = (function()
    local Map = __TS__Class()
    Map.name = "Map"
    function Map.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "Map"
        self.items = {}
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self:set(value[1], value[2])
            end
        else
            local array = entries
            for ____, kvp in ipairs(array) do
                self:set(kvp[1], kvp[2])
            end
        end
    end
    function Map.prototype.clear(self)
        self.items = {}
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Map.prototype.delete(self, key)
        local contains = self:has(key)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[key]
            local previous = self.previousKey[key]
            if next and previous then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[key] = nil
            self.previousKey[key] = nil
        end
        self.items[key] = nil
        return contains
    end
    function Map.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(
            self:keys()
        ) do
            callback(_G, self.items[key], key, self)
        end
    end
    function Map.prototype.get(self, key)
        return self.items[key]
    end
    function Map.prototype.has(self, key)
        return (self.nextKey[key] ~= nil) or (self.lastKey == key)
    end
    function Map.prototype.set(self, key, value)
        local isNewValue = not self:has(key)
        if isNewValue then
            self.size = self.size + 1
        end
        self.items[key] = value
        if self.firstKey == nil then
            self.firstKey = key
            self.lastKey = key
        elseif isNewValue then
            self.nextKey[self.lastKey] = key
            self.previousKey[key] = self.lastKey
            self.lastKey = key
        end
        return self
    end
    Map.prototype[Symbol.iterator] = function(self)
        return self:entries()
    end
    function Map.prototype.entries(self)
        local ____ = self
        local items = ____.items
        local nextKey = ____.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, items[key]}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.values(self)
        local ____ = self
        local items = ____.items
        local nextKey = ____.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = items[key]}
                key = nextKey[key]
                return result
            end
        }
    end
    Map[Symbol.species] = Map
    return Map
end)()

__TS__MathAtan2 = math.atan2 or math.atan

function __TS__Number(value)
    local valueType = type(value)
    if valueType == "number" then
        return value
    elseif valueType == "string" then
        local numberValue = tonumber(value)
        if numberValue then
            return numberValue
        end
        if value == "Infinity" then
            return math.huge
        end
        if value == "-Infinity" then
            return -math.huge
        end
        local stringWithoutSpaces = string.gsub(value, "%s", "")
        if stringWithoutSpaces == "" then
            return 0
        end
        return 0 / 0
    elseif valueType == "boolean" then
        return (value and 1) or 0
    else
        return 0 / 0
    end
end

function __TS__NumberIsFinite(value)
    return (((type(value) == "number") and (value == value)) and (value ~= math.huge)) and (value ~= -math.huge)
end

function __TS__NumberIsNaN(value)
    return value ~= value
end

____radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
function __TS__NumberToString(self, radix)
    if ((((radix == nil) or (radix == 10)) or (self == math.huge)) or (self == -math.huge)) or (self ~= self) then
        return tostring(self)
    end
    radix = math.floor(radix)
    if (radix < 2) or (radix > 36) then
        error("toString() radix argument must be between 2 and 36", 0)
    end
    local integer, fraction = math.modf(
        math.abs(self)
    )
    local result = ""
    if radix == 8 then
        result = string.format("%o", integer)
    elseif radix == 16 then
        result = string.format("%x", integer)
    else
        repeat
            do
                result = tostring(
                    __TS__StringAccess(____radixChars, integer % radix)
                ) .. tostring(result)
                integer = math.floor(integer / radix)
            end
        until not (integer ~= 0)
    end
    if fraction ~= 0 then
        result = tostring(result) .. "."
        local delta = 1e-16
        repeat
            do
                fraction = fraction * radix
                delta = delta * radix
                local digit = math.floor(fraction)
                result = tostring(result) .. tostring(
                    __TS__StringAccess(____radixChars, digit)
                )
                fraction = fraction - digit
            end
        until not (fraction >= delta)
    end
    if self < 0 then
        result = "-" .. tostring(result)
    end
    return result
end

function __TS__ObjectAssign(to, ...)
    local sources = {...}
    if to == nil then
        return to
    end
    for ____, source in ipairs(sources) do
        for key in pairs(source) do
            to[key] = source[key]
        end
    end
    return to
end

function ____descriptorIndex(self, key)
    local value = rawget(self, key)
    if value ~= nil then
        return value
    end
    local metatable = getmetatable(self)
    while metatable do
        local rawResult = rawget(metatable, key)
        if rawResult ~= nil then
            return rawResult
        end
        local descriptors = rawget(metatable, "_descriptors")
        if descriptors then
            local descriptor = descriptors[key]
            if descriptor then
                if descriptor.get then
                    return descriptor.get(self)
                end
                return descriptor.value
            end
        end
        metatable = getmetatable(metatable)
    end
end
function ____descriptorNewindex(self, key, value)
    local metatable = getmetatable(self)
    while metatable do
        local descriptors = rawget(metatable, "_descriptors")
        if descriptors then
            local descriptor = descriptors[key]
            if descriptor then
                if descriptor.set then
                    descriptor.set(self, value)
                else
                    if descriptor.writable == false then
                        error(
                            ((("Cannot assign to read only property '" .. key) .. "' of object '") .. tostring(self)) .. "'",
                            0
                        )
                    end
                    descriptor.value = value
                end
                return
            end
        end
        metatable = getmetatable(metatable)
    end
    rawset(self, key, value)
end
function __TS__SetDescriptor(target, key, desc, isPrototype)
    if isPrototype == nil then
        isPrototype = false
    end
    local metatable = ((isPrototype and (function() return target end)) or (function() return getmetatable(target) end))()
    if not metatable then
        metatable = {}
        setmetatable(target, metatable)
    end
    local value = rawget(target, key)
    if value ~= nil then
        rawset(target, key, nil)
    end
    if not rawget(metatable, "_descriptors") then
        metatable._descriptors = {}
    end
    local descriptor = __TS__CloneDescriptor(desc)
    metatable._descriptors[key] = descriptor
    metatable.__index = ____descriptorIndex
    metatable.__newindex = ____descriptorNewindex
end

function __TS__ObjectDefineProperty(target, key, desc)
    local luaKey = (((type(key) == "number") and (function() return key + 1 end)) or (function() return key end))()
    local value = rawget(target, luaKey)
    local hasGetterOrSetter = (desc.get ~= nil) or (desc.set ~= nil)
    local descriptor
    if hasGetterOrSetter then
        if value ~= nil then
            error(
                "Cannot redefine property: " .. tostring(key),
                0
            )
        end
        descriptor = desc
    else
        local valueExists = value ~= nil
        descriptor = {
            set = desc.set,
            get = desc.get,
            configurable = (((desc.configurable ~= nil) and (function() return desc.configurable end)) or (function() return valueExists end))(),
            enumerable = (((desc.enumerable ~= nil) and (function() return desc.enumerable end)) or (function() return valueExists end))(),
            writable = (((desc.writable ~= nil) and (function() return desc.writable end)) or (function() return valueExists end))(),
            value = (((desc.value ~= nil) and (function() return desc.value end)) or (function() return value end))()
        }
    end
    __TS__SetDescriptor(target, luaKey, descriptor)
    return target
end

function __TS__ObjectEntries(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = {key, obj[key]}
    end
    return result
end

function __TS__ObjectFromEntries(entries)
    local obj = {}
    local iterable = entries
    if iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                break
            end
            local value = result.value
            obj[value[1]] = value[2]
        end
    else
        for ____, entry in ipairs(entries) do
            obj[entry[1]] = entry[2]
        end
    end
    return obj
end

function __TS__ObjectGetOwnPropertyDescriptor(object, key)
    local metatable = getmetatable(object)
    if not metatable then
        return
    end
    if not rawget(metatable, "_descriptors") then
        return
    end
    return rawget(metatable, "_descriptors")[key]
end

function __TS__ObjectKeys(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = key
    end
    return result
end

function __TS__ObjectRest(target, usedProperties)
    local result = {}
    for property in pairs(target) do
        if not usedProperties[property] then
            result[property] = target[property]
        end
    end
    return result
end

function __TS__ObjectValues(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = obj[key]
    end
    return result
end

function __TS__ParseFloat(numberString)
    local infinityMatch = string.match(numberString, "^%s*(-?Infinity)")
    if infinityMatch then
        return (((__TS__StringAccess(infinityMatch, 0) == "-") and (function() return -math.huge end)) or (function() return math.huge end))()
    end
    local number = tonumber(
        string.match(numberString, "^%s*(-?%d+%.?%d*)")
    )
    return number or (0 / 0)
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

Set = (function()
    local Set = __TS__Class()
    Set.name = "Set"
    function Set.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "Set"
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self:add(result.value)
            end
        else
            local array = values
            for ____, value in ipairs(array) do
                self:add(value)
            end
        end
    end
    function Set.prototype.add(self, value)
        local isNewValue = not self:has(value)
        if isNewValue then
            self.size = self.size + 1
        end
        if self.firstKey == nil then
            self.firstKey = value
            self.lastKey = value
        elseif isNewValue then
            self.nextKey[self.lastKey] = value
            self.previousKey[value] = self.lastKey
            self.lastKey = value
        end
        return self
    end
    function Set.prototype.clear(self)
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Set.prototype.delete(self, value)
        local contains = self:has(value)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[value]
            local previous = self.previousKey[value]
            if next and previous then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[value] = nil
            self.previousKey[value] = nil
        end
        return contains
    end
    function Set.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(
            self:keys()
        ) do
            callback(_G, key, key, self)
        end
    end
    function Set.prototype.has(self, value)
        return (self.nextKey[value] ~= nil) or (self.lastKey == value)
    end
    Set.prototype[Symbol.iterator] = function(self)
        return self:values()
    end
    function Set.prototype.entries(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, key}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.values(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    Set[Symbol.species] = Set
    return Set
end)()

WeakMap = (function()
    local WeakMap = __TS__Class()
    WeakMap.name = "WeakMap"
    function WeakMap.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "WeakMap"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self.items[value[1]] = value[2]
            end
        else
            for ____, kvp in ipairs(entries) do
                self.items[kvp[1]] = kvp[2]
            end
        end
    end
    function WeakMap.prototype.delete(self, key)
        local contains = self:has(key)
        self.items[key] = nil
        return contains
    end
    function WeakMap.prototype.get(self, key)
        return self.items[key]
    end
    function WeakMap.prototype.has(self, key)
        return self.items[key] ~= nil
    end
    function WeakMap.prototype.set(self, key, value)
        self.items[key] = value
        return self
    end
    WeakMap[Symbol.species] = WeakMap
    return WeakMap
end)()

WeakSet = (function()
    local WeakSet = __TS__Class()
    WeakSet.name = "WeakSet"
    function WeakSet.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "WeakSet"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self.items[result.value] = true
            end
        else
            for ____, value in ipairs(values) do
                self.items[value] = true
            end
        end
    end
    function WeakSet.prototype.add(self, value)
        self.items[value] = true
        return self
    end
    function WeakSet.prototype.delete(self, value)
        local contains = self:has(value)
        self.items[value] = nil
        return contains
    end
    function WeakSet.prototype.has(self, value)
        return self.items[value] == true
    end
    WeakSet[Symbol.species] = WeakSet
    return WeakSet
end)()

function __TS__SourceMapTraceBack(fileName, sourceMap)
    _G.__TS__sourcemap = _G.__TS__sourcemap or ({})
    _G.__TS__sourcemap[fileName] = sourceMap
    if _G.__TS__originalTraceback == nil then
        _G.__TS__originalTraceback = debug.traceback
        debug.traceback = function(thread, message, level)
            local trace
            if ((thread == nil) and (message == nil)) and (level == nil) then
                trace = _G.__TS__originalTraceback()
            else
                trace = _G.__TS__originalTraceback(thread, message, level)
            end
            if type(trace) ~= "string" then
                return trace
            end
            local result = string.gsub(
                trace,
                "(%S+).lua:(%d+)",
                function(file, line)
                    local fileSourceMap = _G.__TS__sourcemap[tostring(file) .. ".lua"]
                    if fileSourceMap and fileSourceMap[line] then
                        return (file .. ".ts:") .. tostring(fileSourceMap[line])
                    end
                    return (file .. ".lua:") .. line
                end
            )
            return result
        end
    end
end

function __TS__Spread(iterable)
    local arr = {}
    if type(iterable) == "string" then
        do
            local i = 0
            while i < #iterable do
                arr[#arr + 1] = __TS__StringAccess(iterable, i)
                i = i + 1
            end
        end
    else
        for ____, item in __TS__Iterator(iterable) do
            arr[#arr + 1] = item
        end
    end
    return __TS__Unpack(arr)
end

function __TS__StringAccess(self, index)
    if (index >= 0) and (index < #self) then
        return string.sub(self, index + 1, index + 1)
    end
end

function __TS__StringCharAt(self, pos)
    if pos ~= pos then
        pos = 0
    end
    if pos < 0 then
        return ""
    end
    return string.sub(self, pos + 1, pos + 1)
end

function __TS__StringCharCodeAt(self, index)
    if index ~= index then
        index = 0
    end
    if index < 0 then
        return 0 / 0
    end
    return string.byte(self, index + 1) or (0 / 0)
end

function __TS__StringConcat(str1, ...)
    local args = {...}
    local out = str1
    for ____, arg in ipairs(args) do
        out = tostring(out) .. tostring(arg)
    end
    return out
end

function __TS__StringEndsWith(self, searchString, endPosition)
    if (endPosition == nil) or (endPosition > #self) then
        endPosition = #self
    end
    return string.sub(self, (endPosition - #searchString) + 1, endPosition) == searchString
end

function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

function __TS__StringPadEnd(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if (maxLength == -math.huge) or (maxLength == math.huge) then
        error("Invalid string length", 0)
    end
    if (#self >= maxLength) or (#fillString == 0) then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = tostring(fillString) .. tostring(
            string.rep(
                fillString,
                math.floor(maxLength / #fillString)
            )
        )
    end
    return tostring(self) .. tostring(
        string.sub(
            fillString,
            1,
            math.floor(maxLength)
        )
    )
end

function __TS__StringPadStart(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if (maxLength == -math.huge) or (maxLength == math.huge) then
        error("Invalid string length", 0)
    end
    if (#self >= maxLength) or (#fillString == 0) then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = tostring(fillString) .. tostring(
            string.rep(
                fillString,
                math.floor(maxLength / #fillString)
            )
        )
    end
    return tostring(
        string.sub(
            fillString,
            1,
            math.floor(maxLength)
        )
    ) .. tostring(self)
end

function __TS__StringReplace(source, searchValue, replaceValue)
    searchValue = string.gsub(searchValue, "[%%%(%)%.%+%-%*%?%[%^%$]", "%%%1")
    if type(replaceValue) == "string" then
        replaceValue = string.gsub(replaceValue, "%%", "%%%%")
        local result = string.gsub(source, searchValue, replaceValue, 1)
        return result
    else
        local result = string.gsub(
            source,
            searchValue,
            function(match) return replaceValue(_G, match) end,
            1
        )
        return result
    end
end

function __TS__StringSlice(self, start, ____end)
    if (start == nil) or (start ~= start) then
        start = 0
    end
    if ____end ~= ____end then
        ____end = 0
    end
    if start >= 0 then
        start = start + 1
    end
    if (____end ~= nil) and (____end < 0) then
        ____end = ____end - 1
    end
    return string.sub(self, start, ____end)
end

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

function __TS__StringStartsWith(self, searchString, position)
    if (position == nil) or (position < 0) then
        position = 0
    end
    return string.sub(self, position + 1, #searchString + position) == searchString
end

function __TS__StringSubstr(self, from, length)
    if from ~= from then
        from = 0
    end
    if length ~= nil then
        if (length ~= length) or (length <= 0) then
            return ""
        end
        length = length + from
    end
    if from >= 0 then
        from = from + 1
    end
    return string.sub(self, from, length)
end

function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

function __TS__StringTrimEnd(self)
    local result = string.gsub(self, "[%s ﻿]*$", "")
    return result
end

function __TS__StringTrimStart(self)
    local result = string.gsub(self, "^[%s ﻿]*", "")
    return result
end

____symbolRegistry = {}
function __TS__SymbolRegistryFor(key)
    if not ____symbolRegistry[key] then
        ____symbolRegistry[key] = __TS__Symbol(key)
    end
    return ____symbolRegistry[key]
end
function __TS__SymbolRegistryKeyFor(sym)
    for key in pairs(____symbolRegistry) do
        if ____symbolRegistry[key] == sym then
            return key
        end
    end
end

function __TS__TypeOf(value)
    local luaType = type(value)
    if luaType == "table" then
        return "object"
    elseif luaType == "nil" then
        return "undefined"
    else
        return luaType
    end
end

end,
["vec3"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.Vec3 = __TS__Class()
local Vec3 = ____exports.Vec3
Vec3.name = "Vec3"
function Vec3.prototype.____constructor(self, x, y, z)
    self.north = math.floor(x)
    self.up = math.floor(y)
    self.east = math.floor(z)
end
function Vec3.prototype.__tostring(self)
    return (((tostring(self.north) .. ",") .. tostring(self.up)) .. ",") .. tostring(self.east)
end
function Vec3.prototype.plus(self, x, y, z)
    return __TS__New(____exports.Vec3, self.north + x, self.up + y, self.east + z)
end
function ____exports.parse(self, position)
    local north, up, east = unpack(
        __TS__StringSplit(position, ",")
    )
    return __TS__New(
        ____exports.Vec3,
        __TS__ParseInt(north),
        __TS__ParseInt(up),
        __TS__ParseInt(east)
    )
end
____exports.DIRECTIONS_OFFSETS = {
    north = __TS__New(____exports.Vec3, 1, 0, 0),
    south = __TS__New(____exports.Vec3, -1, 0, 0),
    east = __TS__New(____exports.Vec3, 0, 0, 1),
    west = __TS__New(____exports.Vec3, 0, 0, -1),
    up = __TS__New(____exports.Vec3, 0, 1, 0),
    down = __TS__New(____exports.Vec3, 0, -1, 0)
}
____exports.directionsBack = {north = "south", south = "north", east = "west", west = "east", up = "down", down = "up"}
____exports.directionsRight = {north = "east", south = "west", east = "south", west = "north"}
____exports.directionsLeft = {north = "west", south = "east", east = "north", west = "south"}
function ____exports.spiral(self, size, around, ____until)
    local x = 0
    local z = 0
    local dx = 0
    local dz = -1
    local results = {}
    do
        local i = 0
        while i < (size ^ 2) do
            local position = __TS__New(____exports.Vec3, around.north + x, 0, around.east + z)
            if ____until and ____until(nil, position) then
                return {position}
            end
            __TS__ArrayPush(results, position)
            if ((x == z) or ((x < 0) and (x == -z))) or ((x > 0) and (x == (1 - z))) then
                dx, dz = unpack({-dz, dx})
            end
            x, z = unpack({x + dx, z + dz})
            i = i + 1
        end
    end
    return results
end
function ____exports.positionBetween(self, position1, position2)
    return __TS__New(____exports.Vec3, (position1.north + position2.north) / 2, (position1.up + position2.up) / 2, (position1.east + position2.east) / 2)
end
function ____exports.getDistanceTo(self, position, position2)
    return (math.abs(position.north - position2.north) + math.abs(position.east - position2.east)) + math.abs(position.up - position2.up)
end
return ____exports
end,
["state"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local vec3 = require("vec3")
local function loadPosition(self)
    local file = fs.open("position.txt", "r")
    local data
    print(file)
    if file == nil then
        return __TS__New(vec3.Vec3, 0, 0, 0)
    else
        data = file.readAll()
        file.close()
        return vec3:parse(data)
    end
end
local function loadDirection(self)
    local file = fs.open("direction.txt", "r")
    if file == nil then
        return "north"
    else
        local data = file.readAll()
        file.close()
        return data
    end
end
____exports.currentPosition = loadPosition(nil)
function ____exports.savePosition(self, position)
    ____exports.currentPosition = position
    local file = fs.open("position.txt", "w")
    if file ~= nil then
        file.write(
            tostring(____exports.currentPosition)
        )
        file.close()
    end
end
____exports.currentDirection = loadDirection(nil)
function ____exports.saveDirection(self, direction)
    ____exports.currentDirection = direction
    local file, reason = fs.open("direction.txt", "w")
    file.write(____exports.currentDirection)
    file.close()
end
function ____exports.getPositionForDirection(self, dir)
    local directionOffsets = vec3.DIRECTIONS_OFFSETS[dir]
    return ____exports.currentPosition:plus(directionOffsets.north, directionOffsets.up, directionOffsets.east)
end
____exports.inventoryFull = false
function ____exports.updateInventoryFull(self)
    ____exports.inventoryFull = turtle.getItemCount(4 * 4) > 0
    return ____exports.inventoryFull
end
____exports.headingToSpawn = false
function ____exports.setHeadingToSpawn(self, value)
    ____exports.headingToSpawn = value
end
return ____exports
end,
["world"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local vec3 = require("vec3")
local state = require("state")
local function loadWorld(self)
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
____exports.world = loadWorld(nil)
function ____exports.saveWorld(self)
    local file = fs.open("world.txt", "w")
    file.write(
        textutils.serialize(____exports.world)
    )
    file.close()
end
____exports.ORES = {"minecraft:coal_ore", "minecraft:iron_ore", "minecraft:gold_ore", "minecraft:lapis_ore", "minecraft:diamond_ore", "minecraft:redstone_ore", "minecraft:emerald_ore"}
____exports.UNDERGROUND_MINEABLE = {"minecraft:stone", "minecraft:cobblestone", "minecraft:andesite", "minecraft:granite", "minecraft:diorite", "minecraft:obsidian", "minecraft:dirt", "crumbs:cobbled_andesite", "crumbs:cobbled_granite", "crumbs:cobbled_diorite", "wild_explorer:blunite", "wild_explorer:carbonite", "blockus:bluestone"}
function ____exports.setBlock(self, position, block)
    ____exports.world[tostring(position)] = block
end
function ____exports.getBlock(self, position)
    return ____exports.world[tostring(position)]
end
____exports.setBlock(
    nil,
    __TS__New(vec3.Vec3, 0, 0, 0),
    "minecraft:air"
)
function ____exports.isDirectionVisitedAir(self, dir)
    local directionCoordinates = state:getPositionForDirection(dir)
    if ____exports.getBlock(nil, directionCoordinates) then
        return ____exports.getBlock(nil, directionCoordinates) == "minecraft:air"
    else
        return false
    end
end
function ____exports.findNearestBlockPosition(self, blocks, height, center)
    if center == nil then
        center = state.currentPosition
    end
    local nearestOreDistance = 99999
    local nearestOrePosition = nil
    for ____, ____value in ipairs(
        __TS__ObjectEntries(____exports.world)
    ) do
        local blockPositionString
        blockPositionString = ____value[1]
        local block
        block = ____value[2]
        if __TS__ArrayIncludes(blocks, block) then
            local blockPosition = vec3:parse(blockPositionString)
            if ((height == nil) or (height == blockPosition.up)) and (blockPositionString ~= tostring(state.currentPosition)) then
                local blockDistance = vec3:getDistanceTo(blockPosition, center)
                if blockDistance < nearestOreDistance then
                    nearestOreDistance = blockDistance
                    nearestOrePosition = blockPosition
                end
            end
        end
    end
    return nearestOrePosition
end
function ____exports.countUnknownBlocksAround(self, position, ____debug)
    local count = 0
    for ____, direction in ipairs(
        __TS__ObjectValues(vec3.DIRECTIONS_OFFSETS)
    ) do
        local checkPosition = position:plus(direction.north, direction.up, direction.east)
        if ____exports.getBlock(nil, checkPosition) == nil then
            if ____debug then
                print(checkPosition, direction)
            end
            count = count + 1
        end
    end
    return count
end
function ____exports.findNearestUnexplored(self)
    local nearestUnexplored = vec3:spiral(
        512,
        __TS__New(vec3.Vec3, 0, 0, 0),
        function(____, position)
            local block = ____exports.getBlock(nil, position)
            return (block == nil) and (((position.north ~= state.currentPosition.north) or (position.up ~= state.currentPosition.up)) or (position.east ~= state.currentPosition.east))
        end
    )
    if #nearestUnexplored >= 1 then
        return nearestUnexplored[1]
    else
        return nil
    end
end
return ____exports
end,
["movement"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local world = require("world")
local vec3 = require("vec3")
local state = require("state")
local suckInDirection
function ____exports.turnInDirection(self, dir)
    local previousDirection = state.currentDirection
    state:saveDirection(dir)
    local success, reason = false, nil
    if dir == previousDirection then
        return
    elseif dir == vec3.directionsBack[previousDirection] then
        success, reason = turtle.turnRight()
        turtle.turnRight()
    elseif dir == vec3.directionsLeft[previousDirection] then
        success, reason = turtle.turnLeft()
    elseif dir == vec3.directionsRight[previousDirection] then
        success, reason = turtle.turnRight()
    else
        state:saveDirection(previousDirection)
        error(
            ("ERROR: unknown turn direction \"" .. tostring(dir)) .. "\"",
            0
        )
    end
    if not success then
        state:saveDirection(previousDirection)
        error(
            "Error turning: " .. tostring(reason),
            0
        )
    end
end
function ____exports.inspectInDirection(self, dir)
    local directionCoordinates = state:getPositionForDirection(dir)
    if world:getBlock(directionCoordinates) then
        return world:getBlock(directionCoordinates)
    end
    local inspectResponse = nil
    if dir == "up" then
        inspectResponse = {
            turtle.inspectUp()
        }
    elseif dir == "down" then
        inspectResponse = {
            turtle.inspectDown()
        }
    else
        ____exports.turnInDirection(nil, dir)
        inspectResponse = {
            turtle.inspect()
        }
    end
    local block
    local success = inspectResponse[1]
    if type(inspectResponse[2]) == "string" then
        if inspectResponse[2] == "No block to inspect" then
            block = {name = "minecraft:air"}
        else
            print("error inspecting", inspectResponse[2])
            return
        end
    else
        block = inspectResponse[2]
    end
    local blockName = ((success and (function() return block.name end)) or (function() return "minecraft:air" end))()
    world:setBlock(directionCoordinates, blockName)
    return block
end
function ____exports.scanAround(self, blocks)
    local forward, left, right, back = state.currentDirection, vec3.directionsLeft[state.currentDirection], vec3.directionsRight[state.currentDirection], vec3.directionsBack[state.currentDirection]
    ____exports.inspectInDirection(nil, "up")
    ____exports.inspectInDirection(nil, "down")
    ____exports.inspectInDirection(nil, forward)
    if world:getBlock(
        state:getPositionForDirection(right)
    ) then
        ____exports.inspectInDirection(nil, left)
        ____exports.inspectInDirection(nil, back)
    else
        ____exports.inspectInDirection(nil, right)
        ____exports.inspectInDirection(nil, back)
        ____exports.inspectInDirection(nil, left)
    end
    if blocks then
        return world:findNearestBlockPosition(blocks)
    else
        return nil
    end
end
function suckInDirection(self, dir)
    local success
    local reason
    if dir == "up" then
        success, reason = turtle.suckUp()
    elseif dir == "down" then
        success, reason = turtle.suckDown()
    else
        ____exports.turnInDirection(nil, dir)
        success, reason = turtle.suck()
    end
    state:updateInventoryFull()
end
function ____exports.refuelAll(self)
    local couldRefuel = false
    do
        local i = 1
        while i <= 16 do
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
function ____exports.moveInDirection(self, dir)
    local success
    local reason
    local previousPosition = state.currentPosition
    local newPosition = state:getPositionForDirection(dir)
    state:savePosition(newPosition)
    if dir == "up" then
        success, reason = turtle.up()
    elseif dir == "down" then
        success, reason = turtle.down()
    else
        ____exports.turnInDirection(nil, dir)
        success, reason = turtle.forward()
    end
    if success then
        world:setBlock(newPosition, "minecraft:air")
        ____exports.inspectInDirection(nil, dir)
    else
        state:savePosition(previousPosition)
        if reason == "Out of fuel" then
            ____exports.refuelAll(nil)
        elseif reason == "Movement obstructed" then
            ____exports.scanAround(nil)
        end
        print(
            "Error moving: " .. tostring(reason)
        )
    end
end
function ____exports.digInDirection(self, dir)
    local success
    local reason
    if dir == "up" then
        success, reason = turtle.digUp()
    elseif dir == "down" then
        success, reason = turtle.digDown()
    else
        ____exports.turnInDirection(nil, dir)
        success, reason = turtle.dig()
    end
    if not success then
        if reason ~= "Nothing to dig here" then
            error(
                "Error digging: " .. tostring(reason),
                0
            )
        else
            suckInDirection(nil, dir)
        end
    end
    local blockPosition = state:getPositionForDirection(dir)
    world:setBlock(blockPosition, "minecraft:air")
end
return ____exports
end,
["pathing"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local state = require("state")
local vec3 = require("vec3")
local world = require("world")
local movement = require("movement")
function ____exports._getDirectionTo(self, position, preferVisited)
    local allowedDirections = {}
    if preferVisited then
        if position.north > state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "north")
        end
        if position.north < state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "south")
        end
        if position.east > state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "east")
        end
        if position.east < state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "west")
        end
        if position.up > state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "up")
        end
        if position.up < state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "down")
        end
    else
        if (position.north + 2) >= state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "north")
        end
        if (position.north - 2) <= state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "south")
        end
        if (position.east + 2) >= state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "east")
        end
        if (position.east - 2) <= state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "west")
        end
        if (position.up + 2) >= state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "up")
        end
        if (position.up - 2) <= state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "down")
        end
    end
    local bestDirection = nil
    local bestDirectionScore = -999
    for ____, direction in ipairs(allowedDirections) do
        local theoreticalPosition = state:getPositionForDirection(direction)
        local directionScore = 0
        local unknownBlocksAround = world:countUnknownBlocksAround(
            state:getPositionForDirection(direction)
        )
        if preferVisited then
            if (direction == "up") or (direction == "down") then
                directionScore = directionScore - (unknownBlocksAround / 4)
            else
                directionScore = directionScore - unknownBlocksAround
            end
        else
            if (direction == "up") or (direction == "down") then
                directionScore = directionScore + (unknownBlocksAround / 4)
            else
                directionScore = directionScore + (unknownBlocksAround / 1.2)
            end
        end
        if direction == state.currentDirection then
            directionScore = directionScore + 1
        end
        if (direction == "north") and (position.north > state.currentPosition.north) then
            directionScore = directionScore + 1.1
        elseif (direction == "south") and (position.north < state.currentPosition.north) then
            directionScore = directionScore + 1.1
        elseif (direction == "east") and (position.east > state.currentPosition.east) then
            directionScore = directionScore + 1.1
        elseif (direction == "west") and (position.east < state.currentPosition.east) then
            directionScore = directionScore + 1.1
        elseif (direction == "up") and (position.up > state.currentPosition.up) then
            directionScore = directionScore + 1.1
        elseif (direction == "down") and (position.up > state.currentPosition.up) then
            directionScore = directionScore + 1.1
        end
        directionScore = directionScore - (vec3:getDistanceTo(position, theoreticalPosition) / 2)
        if directionScore > bestDirectionScore then
            bestDirectionScore = directionScore
            bestDirection = direction
        end
    end
    local bestUnknownBlocksAround = world:countUnknownBlocksAround(
        state:getPositionForDirection(bestDirection),
        true
    )
    print("best:", bestUnknownBlocksAround)
    return bestDirection
end
function ____exports.getDirectionTo(self, position, preferVisited, nextTo)
    local allowedDirections = {}
    if preferVisited then
        if position.north > state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "north")
        end
        if position.north < state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "south")
        end
        if position.east > state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "east")
        end
        if position.east < state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "west")
        end
        if position.up > state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "up")
        end
        if position.up < state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "down")
        end
    else
        if (position.north + 2) >= state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "north")
        end
        if (position.north - 2) <= state.currentPosition.north then
            __TS__ArrayPush(allowedDirections, "south")
        end
        if (position.east + 2) >= state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "east")
        end
        if (position.east - 2) <= state.currentPosition.east then
            __TS__ArrayPush(allowedDirections, "west")
        end
        if (position.up + 2) >= state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "up")
        end
        if (position.up - 2) <= state.currentPosition.up then
            __TS__ArrayPush(allowedDirections, "down")
        end
    end
    local bestDirection = nil
    local bestDirectionScore = -999
    for ____, direction in ipairs(allowedDirections) do
        local theoreticalPosition = state:getPositionForDirection(direction)
        local directionScore = 0
        local unknownBlocksAround = world:countUnknownBlocksAround(
            state:getPositionForDirection(direction)
        )
        if preferVisited then
            if (direction == "up") or (direction == "down") then
                directionScore = directionScore - (unknownBlocksAround / 4)
            else
                directionScore = directionScore - unknownBlocksAround
            end
        else
            if (direction == "up") or (direction == "down") then
                directionScore = directionScore + (unknownBlocksAround / 4)
            else
                directionScore = directionScore + (unknownBlocksAround / 1.2)
            end
        end
        if direction == state.currentDirection then
            directionScore = directionScore + 1
        end
        if (direction == "north") and (position.north > state.currentPosition.north) then
            directionScore = directionScore + 1.1
        elseif (direction == "south") and (position.north < state.currentPosition.north) then
            directionScore = directionScore + 1.1
        elseif (direction == "east") and (position.east > state.currentPosition.east) then
            directionScore = directionScore + 1.1
        elseif (direction == "west") and (position.east < state.currentPosition.east) then
            directionScore = directionScore + 1.1
        elseif (direction == "up") and (position.up > state.currentPosition.up) then
            directionScore = directionScore + 1.1
        elseif (direction == "down") and (position.up > state.currentPosition.up) then
            directionScore = directionScore + 1.1
        end
        directionScore = directionScore - (vec3:getDistanceTo(position, theoreticalPosition) / 2)
        if directionScore > bestDirectionScore then
            bestDirectionScore = directionScore
            bestDirection = direction
        end
    end
    local bestUnknownBlocksAround = world:countUnknownBlocksAround(
        state:getPositionForDirection(bestDirection),
        true
    )
    print("best:", bestUnknownBlocksAround)
    return bestDirection
end
____exports["goto"] = function(self, position)
    while not (((state.currentPosition.north == position.north) and (state.currentPosition.east == position.east)) and (state.currentPosition.up == position.up)) do
        local recommendedDirection = ____exports.getDirectionTo(nil, position, true)
        movement:digInDirection(recommendedDirection)
        movement:moveInDirection(recommendedDirection)
    end
end
return ____exports
end,
["index"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local world = require("world")
local movement = require("movement")
local vec3 = require("vec3")
local state = require("state")
local pathing = require("pathing")
local TOTAL_SLOTS = 4 * 4
local function returnToSpawn(self)
    state:setHeadingToSpawn(true)
    print("Going to spawn...")
    local spawnPosition = __TS__New(vec3.Vec3, 0, 0, 0)
    while not (((state.currentPosition.north == 0) and (state.currentPosition.east == 0)) and (state.currentPosition.up == 0)) do
        local recommendedDirection = pathing:getDirectionTo(spawnPosition, true)
        print(",,recommendedDirection", recommendedDirection)
        movement:digInDirection(recommendedDirection)
        movement:moveInDirection(recommendedDirection)
    end
    movement:turnInDirection("north")
    state:setHeadingToSpawn(false)
end
local function returnToStartingHeight(self)
    if state.currentPosition.up == 0 then
        return
    end
    if state.currentPosition.up > 0 then
        do
            local i = 1
            while i < state.currentPosition.up do
                movement:digInDirection("down")
                movement:moveInDirection("down")
                i = i + 1
            end
        end
    elseif state.currentPosition.up < 0 then
        do
            local i = 1
            while i < -state.currentPosition.up do
                movement:digInDirection("up")
                movement:moveInDirection("up")
                i = i + 1
            end
        end
    end
end
local function depositAllAtSpawn(self)
    returnToSpawn(nil)
    do
        local i = 1
        while i <= TOTAL_SLOTS do
            turtle.select(i)
            turtle.refuel()
            local success, reason = turtle.dropDown()
            if reason then
                print(reason)
            end
            i = i + 1
        end
    end
    turtle.select(1)
end
print("Ok")
depositAllAtSpawn(nil)
state:updateInventoryFull()
if state.inventoryFull then
    depositAllAtSpawn(nil)
end
local miningOres = false
while true do
    local nearestOrePosition = movement:scanAround(world.ORES)
    if nearestOrePosition then
        print(
            "To " .. tostring(nearestOrePosition)
        )
        local recommendedDirection = pathing:getDirectionTo(nearestOrePosition, true)
        movement:digInDirection(recommendedDirection)
        movement:moveInDirection(recommendedDirection)
        miningOres = true
    else
        returnToStartingHeight(nil)
        local nearestMineablePosition = world:findNearestUnexplored()
        local recommendedDirection
        if nearestMineablePosition then
            recommendedDirection = pathing:getDirectionTo(nearestMineablePosition)
        else
            recommendedDirection = state.currentDirection
        end
        print(
            ((".To " .. tostring(nearestMineablePosition)) .. " ") .. tostring(recommendedDirection)
        )
        movement:digInDirection(recommendedDirection)
        movement:moveInDirection(recommendedDirection)
    end
    movement:scanAround()
    if state.currentPosition.up == 0 then
        movement:inspectInDirection("up")
        local upBlock = world:getBlock(
            state:getPositionForDirection("up")
        )
        if __TS__ArrayIncludes(world.UNDERGROUND_MINEABLE, upBlock) then
            movement:digInDirection("up")
        end
    end
    if state.inventoryFull then
        depositAllAtSpawn(nil)
    end
    world:saveWorld()
end
return ____exports
end,
}
return require("index")
