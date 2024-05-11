---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/8 20:45
---

local UIChampionBattleResultHintViewCtrl = BaseClass("UIChampionBattleResultHintViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleResultHintView)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetLastRecordRound(self)
    
end

local function SetLastRecordRound(self)

end

local function GetRecordKey(self)
    
end

local function GetShowData(self)
    local data = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
    if data == nil and data.previewMatchObject ~= nil and data.previewMatchObject.selfData ~= nil then
        return nil
    end
    local lastRound, lastWin, lastLose = DataCenter.ActChampionBattleManager:GetLastRecordRound()
    local currentRound, currentWin, currentLose = DataCenter.ActChampionBattleManager:GetCurrentRecordRound()
    if lastRound == nil or currentRound == nil then
        return nil
    end

    local result = {}
    result.total = currentRound - lastRound
    result.win = currentWin - lastWin
    result.lose = currentLose - lastLose
    result.score = data.previewMatchObject.selfData.score
    --
    return result
end

UIChampionBattleResultHintViewCtrl.CloseSelf = CloseSelf
UIChampionBattleResultHintViewCtrl.Close = Close
UIChampionBattleResultHintViewCtrl.GetLastRecordRound = GetLastRecordRound
UIChampionBattleResultHintViewCtrl.SetLastRecordRound = SetLastRecordRound
UIChampionBattleResultHintViewCtrl.GetRecordKey = GetRecordKey
UIChampionBattleResultHintViewCtrl.GetShowData = GetShowData

return UIChampionBattleResultHintViewCtrl