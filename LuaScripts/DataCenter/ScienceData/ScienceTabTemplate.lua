--- Created by shimin
--- DateTime: 2023/6/7 21:33
--- 科技Tab表

local ScienceTabTemplate = {}

function ScienceTabTemplate:New(indexList, row)
    local temp1 = setmetatable(row, {__index = function(temp1, key)
        if ScienceTabTemplate[key] ~= nil then
            return ScienceTabTemplate[key]
        elseif indexList[key] ~= nil then
            return row[indexList[key][1]]
        end
    end})
    return temp1
end

function ScienceTabTemplate:IsInBuilding(buildingId)
    if buildingId == nil then
        return false
    end
    for k, v in ipairs(self.building) do
        if v == buildingId then
            return true
        end
    end
    return false
end

--这里为了可读性，放弃性能，存性能写法没人能看懂
function ScienceTabTemplate:GetUnlockCondition()
    local result = {}
    if self.unlock_condition ~= nil and self.unlock_condition ~= "" then
        local spl = string.split_ss_array(self.unlock_condition, "|")
        if spl[1] ~= nil then
            result.conditionType = tonumber(spl[1])
            if result.conditionType == ScienceTabShowConditionType.Season then
                result.paramList = {}
                local spl1 = string.split_ss_array(spl[2], ";")
                for k, v in ipairs(spl1) do
                    local spl2 = string.split_ss_array(v, ",")
                    if spl2[3] ~= nil then
                        local param = {}
                        local spl3 = string.split_ss_array(spl2[1], "-")
                        if spl3[2] == nil then
                            --只有一个服
                            param.minServerId = tonumber(spl3[1])
                            param.maxServerId = tonumber(spl3[1])
                        else
                            --区间服
                            param.minServerId = tonumber(spl3[1])
                            param.maxServerId = tonumber(spl3[2])
                        end
                        param.season = tonumber(spl2[2])
                        param.day = tonumber(spl2[3])
                        table.insert(result.paramList, param)
                    end
                end
            end
        end
    end
    return result
end

function ScienceTabTemplate:GetUnlockConditionShow()
    local result = {}
    local count = #self.para_type
    if self.para_type[1] ~= nil and (count == #self.para1) then
        for i = 1, count, 1 do
            local condition = {}
            condition.type = self.para_type[i]
            condition.para = {}
            for k, v in ipairs(self.para1[i]) do
                condition.para[k] = v
            end
            table.insert(result ,condition)
        end
    end
    return result
end

return ScienceTabTemplate