---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---

local base = UIBaseView--Variable
local UIAlLeaderElectResultView = BaseClass("UIAlLeaderElectResultView", base)--Variable
local AlLeaderElectResult_Leader = require "UI.UIAlliance.UIAlLeaderElectResult.Component.AlLeaderElectResult_Leader"
local AlLeaderElectResult_R4 = require "UI.UIAlliance.UIAlLeaderElectResult.Component.AlLeaderElectResult_R4"
local Localization = CS.GameEntry.Localization

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local leader_path = "ImgBg/AlElectResult_Leader"
local r4Players_path = "ImgBg/AlElectReuslt_R4"

local function OnCreate(self)
    base.OnCreate(self)
    DataCenter.AlLeaderElectManager:SetCurStageChecked()
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshAll()
    SFSNetwork.SendMessage(MsgDefines.GetAlLeaderElectCandidates)
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(390923)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.leaderN = self:AddComponent(AlLeaderElectResult_Leader, leader_path)
    self.leaderN:SetActive(false)
    self.r4PlayersN = self:AddComponent(AlLeaderElectResult_R4, r4Players_path)
    self.r4PlayersN:SetActive(false)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.leaderN = nil
    self.r4PlayersN = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnUpdateAlLeaderCandidates, self.RefreshAll)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnUpdateAlLeaderCandidates, self.RefreshAll)
end

local function RefreshAll(self)
    self.leaderN:SetActive(false)
    self.r4PlayersN:SetActive(false)
    local curStage = DataCenter.AlLeaderElectManager:GetCurElectStage()
    local playerList = DataCenter.AlLeaderElectManager:GetCandidatesList()
    if curStage == SysAlState.LeaderResult then
        if #playerList > 0 then
            self.leaderN:SetActive(true)
            self.r4PlayersN:SetActive(false)
            local leaderInfo = playerList[1]
            self.leaderN:SetItem(leaderInfo)
        end
    else
        if #playerList > 0 then
            self.leaderN:SetActive(false)
            self.r4PlayersN:SetActive(true)
            self.r4PlayersN:SetItem(playerList)
        end
    end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UIAlLeaderElectResultView.OnCreate = OnCreate
UIAlLeaderElectResultView.OnDestroy = OnDestroy
UIAlLeaderElectResultView.OnAddListener = OnAddListener
UIAlLeaderElectResultView.OnRemoveListener = OnRemoveListener
UIAlLeaderElectResultView.ComponentDefine = ComponentDefine
UIAlLeaderElectResultView.ComponentDestroy = ComponentDestroy
UIAlLeaderElectResultView.DataDefine = DataDefine
UIAlLeaderElectResultView.DataDestroy = DataDestroy

UIAlLeaderElectResultView.RefreshAll = RefreshAll
UIAlLeaderElectResultView.OnClickCloseBtn = OnClickCloseBtn

return UIAlLeaderElectResultView