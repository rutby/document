---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/22/21 2:48 PM
--- UIAlContributeCtrl.lua
local UIAllianceBossDamageRankCtrl = BaseClass("UIAllianceBossDamageRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceBossDamageRank)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

-- 获取伤害排行数据
local function GetBossRankData(self)
    return {}
end

-- 获取奖励排行数据
local function GetActivityRewardList(self)
    return {}
end

UIAllianceBossDamageRankCtrl.CloseSelf = CloseSelf
UIAllianceBossDamageRankCtrl.Close = Close
UIAllianceBossDamageRankCtrl.GetBossRankData = GetBossRankData
UIAllianceBossDamageRankCtrl.GetActivityRewardList = GetActivityRewardList

return UIAllianceBossDamageRankCtrl