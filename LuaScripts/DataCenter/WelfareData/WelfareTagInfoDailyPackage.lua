---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---

require "DataCenter.WelfareData.WelfareTagInfo"

---@class WelfareTagInfoDailyPackage : WelfareTagInfo 每日特惠
local WelfareTagInfoDailyPackage = BaseClass("WelfareTagInfoDailyPackage", WelfareTagInfo)
local M = WelfareTagInfoDailyPackage

function M:isShow()
    local list = DataCenter.DailyPackageManager:GetPackageList()
    if list~=nil and #list>0 then
        for i = 1,#list do
            local id = list[i]
            local itemStr = GetTableData("custom_dailypackage", id, "item")
            if itemStr~=nil and itemStr~="" then
                local arr = string.split(itemStr,"|")
                if #arr>0 then
                    local giftStr = arr[#arr]
                    local packArr = string.split(giftStr,";")
                    if #packArr>0 then
                        local packId = packArr[#packArr]
                        local info = GiftPackageData.get(packId)
                        if info~=nil then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function M:getRedDotNum()
    local num = 0
    if GiftPackageData.CheckIfHasFreeWeeklyPackage() then
        num =num+1
    end
    if DataCenter.DailyPackageManager:CheckShowRed() then
        num =num+1
    end
    return num
end


function M:isShowIcon()
    local info = self:getInfo()
    return info ~= nil and WelfareTagInfo.isShowIcon(self)
end

function M:getBgName()
    return "DailyPackage"
end

function M:isFullBg()
    return true
end

return M