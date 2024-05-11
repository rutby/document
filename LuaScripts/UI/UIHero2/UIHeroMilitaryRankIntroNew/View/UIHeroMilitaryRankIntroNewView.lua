---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/1 21:43
---

local UIHeroMilitaryRankIntroNewView = BaseClass("UIHeroMilitaryRankIntroNewView", UIBaseView)
local base = UIBaseView

local UIHeroMilitaryRankIntroCell = require "UI.UIHero2.UIHeroMilitaryRankIntroNew.Component.UIHeroMilitaryRankIntroNewCell"

local Localization = CS.GameEntry.Localization

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local close_panel_path = "UICommonMidPopUpTitle/panel"

local intro_text_path = "Root/IntroText"
local scroll_view_path = "Root/ScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshView()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    --self.title:SetLocalText(129117)
    self.intro_text = self:AddComponent(UITextMeshProUGUIEx, intro_text_path)
    self.intro_text:SetLocalText(129281)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_panel = self:AddComponent(UIButton, close_panel_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)
end

local function OnRankItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(UIHeroMilitaryRankIntroCell, itemObj)
    cellItem:SetData(self.rankList[index])
end
local function OnRankItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, UIHeroMilitaryRankIntroCell)
end
local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(UIHeroMilitaryRankIntroCell)
end

local function ComponentDestroy(self)
    self:ClearScroll()
end

local function DataDefine(self)

end

local function DataDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshView(self)
    local heroId, curRank = self:GetUserData()
    self.data = self.ctrl:GetShowData(heroId, curRank)
    self.rankList = self.data.rankList
    local total = #self.rankList
    self.title:SetLocalText(HeroUtils.GetMilitaryRankName(self.data.currentMilitaryRankId))
    if total > 0 then
        self.ScrollView:SetTotalCount(total)
        self.ScrollView:RefillCells()
        local toIndex = self.data.currentMilitaryRankLv or 1
        local showNum = 3
        --if toIndex > showNum then
            toIndex = math.min(toIndex, total - showNum + 1)
            self.ScrollView:ScrollToCell(toIndex, 5000)
        --end
    end
end

UIHeroMilitaryRankIntroNewView.OnCreate= OnCreate
UIHeroMilitaryRankIntroNewView.OnDestroy = OnDestroy
UIHeroMilitaryRankIntroNewView.OnEnable = OnEnable
UIHeroMilitaryRankIntroNewView.OnDisable = OnDisable
UIHeroMilitaryRankIntroNewView.ComponentDefine = ComponentDefine
UIHeroMilitaryRankIntroNewView.ComponentDestroy = ComponentDestroy
UIHeroMilitaryRankIntroNewView.DataDefine = DataDefine
UIHeroMilitaryRankIntroNewView.DataDestroy = DataDestroy
UIHeroMilitaryRankIntroNewView.RefreshView = RefreshView
UIHeroMilitaryRankIntroNewView.ClearScroll = ClearScroll
UIHeroMilitaryRankIntroNewView.OnRankItemMoveIn = OnRankItemMoveIn
UIHeroMilitaryRankIntroNewView.OnRankItemMoveOut = OnRankItemMoveOut

return UIHeroMilitaryRankIntroNewView