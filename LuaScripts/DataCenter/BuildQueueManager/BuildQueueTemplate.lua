--- Created by shimin
--- DateTime: 2023/12/20 22:10
local BuildQueueTemplate = {}

function BuildQueueTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if BuildQueueTemplate[key] ~= nil then
            return BuildQueueTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

return BuildQueueTemplate