---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/1 20:52
---

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_SeasonPass = BaseClass("ResLackItem_SeasonPass", ResLackItemBase)

function ResLackItem_SeasonPass:CheckIsOk( _resType, _needCnt)
    if  CS.SceneManager.IsInPVE() then
        return false
    end
    local para1 = self._config.para1
    local list = string.split(para1,";")
    for k = 1 ,table.count(list) do
        if DataCenter.ActivityListDataManager:IsActivityOpen(list[k]) then
            local actData = DataCenter.SeasonPassManager:GetSeasonPassInfo(tonumber(self._config.para1))
            if actData and next(actData) then
                local unlock = actData.passInfo.unlock == 0 and 0 or 1
                if actData.passInfo.unlock ~= 0 then
                    local rewardList = actData.stateInfo
                    for i = 1 ,table.count(rewardList) do
                        if rewardList[i].specialState ~= 1 and unlock == 1 and actData.passInfo.level <= rewardList[i].level then
                            local reward = rewardList[i].specialReward
                            for k = 1 ,table.count(reward) do
                                if reward[k].rewardType == RewardType.GOODS then
                                    if _resType == tonumber(reward[k].itemId) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                else
                    return true
                end
            end
        end
    end
  
    return false
end

function ResLackItem_SeasonPass:TodoAction()
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, self._config.para1)
end

return ResLackItem_SeasonPass