--- Created by shimin
--- DateTime: 2021/6/23 10:47
local ItemTemplate = {}

function ItemTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if ItemTemplate[key] ~= nil then
            return ItemTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

return ItemTemplate