---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UILeagueMatchAlliancesView.lua

local base = UIBaseView--Variable
local UILeagueMatchAlliancesView = BaseClass("UILeagueMatchAlliancesView", base)--Variable
local Localization = CS.GameEntry.Localization
local LeagueMatchAllianceItem = require "UI.LeagueMatch.UILeagueMatchAlliances.Component.LeagueMatchAllianceItem"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local scrollView_path = "ImgBg/ScrollView"
local headName_path = "ImgBg/select/allianceName"
local headCountry_path = "ImgBg/select/language"
local headPower_path = "ImgBg/select/power"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText("372624")
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.scrollViewN = self:AddComponent(UIScrollView, scrollView_path)
    self.scrollViewN:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scrollViewN:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.headNameN = self:AddComponent(UITextMeshProUGUIEx, headName_path)
    self.headNameN:SetLocalText(390288)
    self.headCountryN = self:AddComponent(UITextMeshProUGUIEx, headCountry_path)
    self.headCountryN:SetLocalText(143589)
    self.headPowerN = self:AddComponent(UITextMeshProUGUIEx, headPower_path)
    self.headPowerN:SetLocalText(100644)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.scrollViewN = nil
    self.headNameN = nil
    self.headCountryN = nil
    self.headPowerN = nil
end

local function DataDefine(self)
    self.allianceList = {}
end

local function DataDestroy(self)
    self.allianceList = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnUpdateCandidates)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnUpdateCandidates)
end

local function InitUI(self)
    self.allianceList = DataCenter.LeagueMatchManager:GetMatchGroupInfo()

    self.scrollViewN:SetTotalCount(#self.allianceList)
    self.scrollViewN:RefillCells()
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollViewN:AddComponent(LeagueMatchAllianceItem, itemObj)
    cellItem:SetItem(self.allianceList[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.scrollViewN:RemoveComponent(itemObj.name, LeagueMatchAllianceItem)
end

local function ClearScroll(self)
    self.scrollViewN:ClearCells()
    self.scrollViewN:RemoveComponents(LeagueMatchAllianceItem)
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UILeagueMatchAlliancesView.OnCreate = OnCreate
UILeagueMatchAlliancesView.OnDestroy = OnDestroy
UILeagueMatchAlliancesView.OnAddListener = OnAddListener
UILeagueMatchAlliancesView.OnRemoveListener = OnRemoveListener
UILeagueMatchAlliancesView.ComponentDefine = ComponentDefine
UILeagueMatchAlliancesView.ComponentDestroy = ComponentDestroy
UILeagueMatchAlliancesView.DataDefine = DataDefine
UILeagueMatchAlliancesView.DataDestroy = DataDestroy

UILeagueMatchAlliancesView.InitUI = InitUI
UILeagueMatchAlliancesView.OnItemMoveIn = OnItemMoveIn
UILeagueMatchAlliancesView.OnItemMoveOut = OnItemMoveOut
UILeagueMatchAlliancesView.ClearScroll = ClearScroll
UILeagueMatchAlliancesView.OnClickCloseBtn = OnClickCloseBtn

return UILeagueMatchAlliancesView