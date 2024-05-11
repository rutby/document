---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/6/23 下午3:08
---


local UIHeroAdvanceView = BaseClass("UIHeroAdvanceView", UIBaseView)
local base = UIBaseView

local UIHeroPageAdvance = require("UI.UIHero2.UIHeroAdvance.Component.UIHeroPageAdvance")

local Tabs = {
    Advance = 1,
    --Reset  = 2,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

local function OnDestroy(self)
    HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
    HeroAdvanceController:GetInstance():SetPreStoreAdvanceNum()
    HeroAdvanceController:GetInstance():UpdateAdvanceNum()
    
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    local btn_back = self:AddComponent(UIButton, "Root/BtnBack")
    btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))

    self.textGoldNum = self:AddComponent(UITextMeshProUGUIEx, "Root/goldObj/goldNum")
    local btnGold = self:AddComponent(UIButton, "Root/goldObj")
    btnGold:SetOnClick(BindCallback(self.ctrl, self.ctrl.OnClickGoldBtn))
    
    self.hero_image = self:AddComponent(UIImage, "Root/HeroImage")
    self.pages = {}
    self.pages[Tabs.Advance] = self:AddComponent(UIHeroPageAdvance, "Root/PageRoot/PageAdvance")
    
    self.btnInfo = self:AddComponent(UIButton, "Root/BtnInfo")
    self.btnInfo:SetOnClick(BindCallback(self, self.OnBtnInfoClick))

    self.nodeRoot = self:AddComponent(UIBaseContainer, 'Root')
    self.nodeTabBg = self:AddComponent(UIBaseContainer, 'ImgTabBg')

    self.nodeEffect = self:AddComponent(UIBaseContainer, 'NodeEffect')
    
    self.animator = self:AddComponent(UIAnimator, '')
end

local function ComponentDestroy(self)
    self.textGoldNum = nil
    self.pages = nil
    self.gold_btn = nil
    self.gold_num = nil
    self.btnInfo = nil
end

local function SwitchTab(self, tabIdx)
    if self.currentTab == tabIdx then
        return
    end
    
    self.currentTab = tabIdx
    
    for k, pageObj in pairs(self.pages) do
        pageObj:SetActive(k == tabIdx)
    end
end

local function DataDefine(self)
    self.selectCamp = 1
    self.curSelectCell = 0
    self.cells = {}
    self.showTips = false
end

local function DataDestroy(self)
    self.selectCamp = nil
    self.curSelectCell = nil
    self.cells = nil
    self.showTips = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    --CS.SceneManager.World:DisablePostProcess()
end

local function OnDisable(self)
    if self.heroUuid ~= nil then
        local uiHeroInfoView = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroInfo)
        if uiHeroInfoView ~= nil and uiHeroInfoView.View ~= nil then
            uiHeroInfoView.View:OnBackFromAdvance()
        end
    end
    
    --CS.SceneManager.World:EnablePostProcess()
    base.OnDisable(self)
end

local function ReInit(self)
    self.hero_image:SetActive(false)
    self:SwitchTab(Tabs.Advance)
    self:RefreshGoldNum()
    
    local heroUuid, onClose = self:GetUserData()
    self.heroUuid = heroUuid
    self.ctrl.onClose = onClose
    if heroUuid ~= nil then
        local data = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if data ~= nil then
            self.pages[Tabs.Advance]:OnSwitchCamp(campType)
        end
        self.pages[Tabs.Advance]:OnSelectCore(heroUuid)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --todo: add gold change event

    self:AddUIListener(EventId.UpdateGold, self.RefreshGoldNum)
    
    --self:AddUIListener(EventId.HeroAdvanceSuccess, self.OnAdvanceSuccessShown)
    self:AddUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshGoldNum)

    --self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.OnAdvanceSuccessShown)
    self:RemoveUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosed)
    
    base.OnRemoveListener(self)
end

local function RefreshGoldNum(self)
    local gold = LuaEntry.Player.gold
    self.textGoldNum:SetText(string.GetFormattedSeperatorNum(gold))
end

local function OnBtnInfoClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceIntro, { anim = true })
end

local function OnAdvanceSuccessShown(self, message)
    --self.nodeRoot.transform.localScale = Vector3.zero
    --self.nodeTabBg:SetActive(false)
    --local coreHeroUuid = nil
    --if message ~= nil and message['heroInfo'] ~= nil then
    --    coreHeroUuid = message['heroInfo'].uuid
    --end
    --local data = DataCenter.HeroDataManager:GetHeroByUuid(coreHeroUuid)
    --if data and data.isMaster then
        self.animator:SetTrigger('hide')
    --end
end

--当关闭升阶成功界面时显示右侧及tab页面
local function OnAdvanceSuccessClosed(self)
    --self.nodeRoot.transform.localScale = Vector3.one
    --self.nodeTabBg:SetActive(true)
    self.animator:SetTrigger('show')
end

local function GetPageAdvance(self)
    return self.pages[Tabs.Advance]
end

local function GetGuideCoreBtn(self)
    return self.pages[Tabs.Advance]:GetGuideCoreBtn()
end

local function GetGuideDogFoodBtn(self)
    return self.pages[Tabs.Advance]:GetGuideDogFoodBtn()
end

UIHeroAdvanceView.OnCreate= OnCreate
UIHeroAdvanceView.OnDestroy = OnDestroy
UIHeroAdvanceView.OnEnable = OnEnable
UIHeroAdvanceView.OnDisable = OnDisable
UIHeroAdvanceView.OnAddListener = OnAddListener
UIHeroAdvanceView.OnRemoveListener = OnRemoveListener
UIHeroAdvanceView.ComponentDefine = ComponentDefine
UIHeroAdvanceView.ComponentDestroy = ComponentDestroy
UIHeroAdvanceView.DataDefine = DataDefine
UIHeroAdvanceView.DataDestroy = DataDestroy
UIHeroAdvanceView.ReInit = ReInit
UIHeroAdvanceView.SwitchTab = SwitchTab
UIHeroAdvanceView.RefreshGoldNum = RefreshGoldNum
UIHeroAdvanceView.OnBtnInfoClick = OnBtnInfoClick
UIHeroAdvanceView.GetPageAdvance = GetPageAdvance
UIHeroAdvanceView.OnAdvanceSuccessShown = OnAdvanceSuccessShown
UIHeroAdvanceView.OnAdvanceSuccessClosed = OnAdvanceSuccessClosed
UIHeroAdvanceView.GetGuideCoreBtn = GetGuideCoreBtn
UIHeroAdvanceView.GetGuideDogFoodBtn = GetGuideDogFoodBtn

return UIHeroAdvanceView