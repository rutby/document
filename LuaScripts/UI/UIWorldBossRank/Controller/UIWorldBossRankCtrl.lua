---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/24 12:01
---
local UIWorldBossRankCtrl = BaseClass("UIWorldBossRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldBossRank)
end

local function GetBossRankData(self,uuid)
   local data = DataCenter.ActBossDataManager:GetBossRankDataByUuid(uuid)
    if data~=nil then
        return data
    end
    return {}
end

local function GetActivityRewardList(self)
    local list = DataCenter.ActivityListDataManager:GetActBossRankRewardDataList()
    if list~=nil then
        return list
    end
    return {}
end
local function GetActivityPersonRewardList(self)
    local list = DataCenter.ActivityListDataManager:GetActBossRankPersonRewardDataList()
    if list~=nil then
        return list
    end
    return {}
end
UIWorldBossRankCtrl.CloseSelf = CloseSelf
UIWorldBossRankCtrl.GetActivityRewardList = GetActivityRewardList
UIWorldBossRankCtrl.GetBossRankData = GetBossRankData
UIWorldBossRankCtrl.GetActivityPersonRewardList = GetActivityPersonRewardList
return UIWorldBossRankCtrl