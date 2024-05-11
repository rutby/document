---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---

--[[
联盟军备
]]

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_ActAllianceArmy = BaseClass("ResLackItem_ActAllianceArmy", ResLackItemBase)

function ResLackItem_ActAllianceArmy:CheckIsOk( _resType, _needCnt )
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    self.index = 0
    if activityInfo ~= nil then
        local eventInfo = activityInfo:GetEventInfo()
        if eventInfo == nil then
            return false
        end
        --获取所有奖励
        local targetReward = eventInfo.targetReward
        if targetReward then
            local stage = {}
            --检查是否有对应奖励以及对应组
            for i ,v in pairs(targetReward) do
                for k = 1 ,table.count(v) do
                    if tonumber(v[k].itemId) == _resType then
                        table.insert(stage,i)
                    end
                end
            end
            local str = string.split(eventInfo.target,"|")
            for i = 1 ,table.count(str) do
                for k = 1 ,table.count(stage) do
                    if stage[k] == tonumber(str[i]) then
                        local unlocked = false
                        if i <= 3 then
                            unlocked = true
                        elseif i <= 6 then
                            unlocked = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_2) == 1
                        elseif i <= 9 then
                            unlocked = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_3) == 1
                        end
                        --已解锁
                        if unlocked then
                            --未达成或未领取
                            if eventInfo.newRewardFlagList then
                                if eventInfo.newRewardFlagList[i] ~= i then
                                    self.index = i
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

function ResLackItem_ActAllianceArmy:TodoAction()
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteNew, { anim = true, UIMainAnim = UIMainAnimType.AllHide },1,self.index)
end

return ResLackItem_ActAllianceArmy

