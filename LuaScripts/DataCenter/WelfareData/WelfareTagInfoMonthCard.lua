require "DataCenter.WelfareData.WelfareTagInfo"

---@class WelfareTagInfoMonthCard : WelfareTagInfo 月卡页签信息
local WelfareTagInfoMonthCard = BaseClass("WelfareTagInfoMonthCard", WelfareTagInfo)
local M = WelfareTagInfoMonthCard
local Timer = CS.GameEntry.Timer

function M:isShow()
    local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
    return isAvailable
    --
    --local card = MonthCardManager.getDefault()
    --if card == nil then
    --    return false
    --end
    --local packInfo = GiftPackageData.get(card:getID())
    --if packInfo == nil then
    --    return false
    --end
    --return WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
    local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    if not golloesMonthCard then
        return false
    end
    if DataCenter.MonthCardNewManager:CheckIfHasGolloesGift()==true then
        return true
    end
    return false
end
function M:getRedDotNum()
    local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    if not golloesMonthCard then
        return 0
    end
    if DataCenter.MonthCardNewManager:CheckIfHasGolloesGift()==true then
        return 1
    end
    return 0
end
function M:getInfo()
    local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    return golloesMonthCard
end

--- 月卡显示规则
--- 首先由配置 show_icon 决定
--- 其次如果未购买则显示
--- 购买了如果没领取显示
--- 购买了没有未领取次数 不显示

--增加如下修改
--月卡按钮增加功能开启,,129号,不使用登记解锁
--没解锁月卡,完全显示月卡按钮,但是功能按钮是被隐藏的
--解锁月卡,,,,购买月卡走原来的逻辑,,,,,没买月卡,有试用状态月卡按钮显示,,没有试用状态走原来逻辑
function M:isShowIcon()
    return true
    --local monthCard = MonthCardManager.getDefault()
    --if monthCard == nil then
    --    return false
    --end
    --
    --local packInfo = GiftPackageData.get(monthCard:getID())
    --if packInfo == nil then
    --    return false
    --end
    ---- if not monthCard:isBought() then
    ----     return WelfareTagInfo.isShowIcon(self)
    ---- end
    ---- return WelfareTagInfo.isShowIcon(self) and self:hasRedPoint()
    --local isUnlock = CS.LFFunctionUnlockController.Instance:CheckFunctionUnlock("129")
    --if isUnlock then
    --    if monthCard:isBought() then
    --        return WelfareTagInfo.isShowIcon(self) and self:hasRedPoint()
    --    else
    --        local dwellerInfo = GameEntry.Data.DwellerController:GetDwellerByType(2030)
    --        if dwellerInfo then
    --            local isTryTime = dwellerInfo.robotTryOutTime > 0 and Timer:GetServerTime() < dwellerInfo.robotTryOutTime
    --            if isTryTime then
    --                return true
    --            else
    --                return WelfareTagInfo.isShowIcon(self)
    --            end
    --        else
    --            return WelfareTagInfo.isShowIcon(self)
    --        end
    --    end
    --else
    --    return true
    --end
end

return M