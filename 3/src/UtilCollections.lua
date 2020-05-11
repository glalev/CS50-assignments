--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--[[
    Utility function for slicing tables, a la Python.

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

-- Concatenate two arrays, treating every non-table value as an array with one element /this value/
-- NOTE If a table which is not array is passed the same is ignored in
function table.concat(a, b)
    local tbl1 = type(a) == 'table' and a or {a}
    local tbl2 = type(b) == 'table' and b or {b}
    local result = table.slice(tbl1)
    for i = 1, #tbl2 do
        table.insert(result, tbl2[i])
    end

    return result
end

function table.filter(arr, predicate)
    local result = {}
    for i, element in ipairs(arr) do
        if predicate(element, i) then
            table.insert(result, element)
        end
    end

    return result;
end

function table.map(arr, func)
    local result = {}

    for i, element in ipairs(arr) do
        table.insert(result, func(element, i, arr))
    end

    return result
end

function table.keys(table)
    local keys = { }
    local n = 0

    for k, v in pairs(table) do
      n = n + 1
      keys[n]=k
    end

    return keys
end

function table.reduce(arr, callback, initialValue)
    local acc

    if (initialValue) then
        acc = initialValue
        for i = 1, #arr do
            acc = callback(acc, arr[i], i, arr)
        end
    else
        acc = arr[1]
        for i = 2, #arr do
            acc = callback(acc, arr[i], i, arr)
        end
    end

    return acc;
end