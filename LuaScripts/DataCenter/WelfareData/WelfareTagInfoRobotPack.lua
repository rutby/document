require "DataCenter.WelfareData.WelfareTagInfo"

---@class WelfareTagInfoRobotPack : WelfareTagInfo 单屏礼包页签信息
local WelfareTagInfoRobotPack = BaseClass("WelfareTagInfoRobotPack", WelfareTagInfo)
local M = WelfareTagInfoRobotPack

function M:ctor()
    WelfareTagInfo.ctor(self)
    self.packIdList = {}
end

function M:parse(data)
    WelfareTagInfo.parse(self, data)
    local _para1 = data:getValue("para1")
    if _para1 ~= nil and _para1 ~= "" then
        self.packIdList = string.split(_para1, ';')
    end
end

function M:isShow()
    local list = self:getPackList(false)
    return list ~= nil and #list > 0 and WelfareTagInfo.isShow(self)
end

function M:getPackList(isSort)
    local list = GiftPackageData.getRobotPacksByRechargeId(self:getID())
    for _, v in ipairs(list) do
        v:setTagID(self:getID())
    end
    return list
end

function M:getPopPackList(isSort)
    local list = GiftPackageData.getRobotPacksByRechargeId(self:getID())
    for _, v in ipairs(list) do
        v:setTagID(self:getID())
    end
    return list
end

return M