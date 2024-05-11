require "DataCenter.WelfareData.WelfareTagInfo"

---@class WelfareTagInfoStorePack : WelfareTagInfo 礼包商城页签信息
local WelfareTagInfoStorePack = BaseClass("WelfareTagInfoStorePack", WelfareTagInfo)
local M = WelfareTagInfoStorePack


function M:isShow()
    --return true
    local list = self:getPackList()
    return list ~= nil and #list > 0 and WelfareTagInfo.isShow(self)
end

function M:getPackList()
    return GiftPackageData.getStorePacks()
end

function M:hasRedPoint()
    return self:getRedDotNum() > 0
end

function M:getRedDotNum()
    local num = 0
    if DataCenter.WatchAdManager:CanShowRedByLocation(WatchAdLocation.GiftPackage) then
        num = num + 1
    end
    return num
end

return M