---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/9 15:23
---

local UIChampionBattleRankViewCtrl = BaseClass("UIChampionBattleRankViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleRankView)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function ShowPlayerInfo(self, userUid)
    if string.IsNullOrEmpty(userUid) then
        return ""
    end
    if userUid == LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo, userUid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, userUid)
    end
end

local function SetHeadImg(self, userHead, guluFrame, userUid, pic, picvec, isGuluFrame, headSkinId, headSkinET)
    userHead:SetData(userUid, pic, picvec)
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(headSkinId, headSkinET, isGuluFrame == 1)
    guluFrame:SetActive(headBgImg ~= nil)
    if headBgImg ~= nil then
        guluFrame:LoadSprite(headBgImg)
    end
end

local function GetPanelData(self, message)
    --if message == nil then
    --    return
    --end
    --local re
end

local function ShowPlayerInfo(self, userUid)
    if string.IsNullOrEmpty(userUid) then
        return ""
    end
    if userUid == LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo, userUid)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, userUid)
    end
end

UIChampionBattleRankViewCtrl.CloseSelf = CloseSelf
UIChampionBattleRankViewCtrl.Close = Close
UIChampionBattleRankViewCtrl.SetHeadImg = SetHeadImg
UIChampionBattleRankViewCtrl.ShowPlayerInfo = ShowPlayerInfo
UIChampionBattleRankViewCtrl.GetPanelData = GetPanelData
UIChampionBattleRankViewCtrl.ShowPlayerInfo = ShowPlayerInfo

return UIChampionBattleRankViewCtrl