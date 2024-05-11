---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/12/26 10:54
---

local UIJeepAdventureReward = BaseClass("UIJeepAdventureReward", UIBaseView)
local base = UIBaseView
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local panel_path = "UICommonMidPopUpTitle/panel"
local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local subtitle_path = "Subtitle"
local slider_path = "Slider"
local time_path = "Slider/Time"
local product_bg_path = "ProductList/ProductBg%s"
local product_count_path = "ProductList/ProductBg%s/ProductCount%s"
local product_icon_path = "ProductList/ProductBg%s/ProductIcon%s"
local reward_desc_path = "RewardDesc"
local scroll_view_path = "ScrollView"
local claim_path = "Claim"
local claim_text_path = "Claim/ClaimText"
local bottom_desc_path = "BottomDesc"

local ProductCount = 3

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.panel_path = self:AddComponent(UIButton, panel_path)
    self.panel_path:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(140216)
    self.subtitle_text = self:AddComponent(UITextMeshProUGUIEx, subtitle_path)
    self.subtitle_text:SetLocalText(140215)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_path)
    self.product_bg_goes = {}
    self.product_count_texts = {}
    self.product_icon_images = {}
    for i = 1, ProductCount do
        self.product_bg_goes[i] = self:AddComponent(UIBaseContainer, string.format(product_bg_path, i))
        self.product_count_texts[i] = self:AddComponent(UITextMeshProUGUIEx, string.format(product_count_path, i, i))
        self.product_icon_images[i] = self:AddComponent(UIImage, string.format(product_icon_path, i, i))
    end
    self.reward_desc_text = self:AddComponent(UITextMeshProUGUIEx, reward_desc_path)
    self.reward_desc_text:SetLocalText(104294)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.claim_btn = self:AddComponent(UIButton, claim_path)
    self.claim_btn:SetOnClick(function()
        self:OnClaimClick()
    end)
    self.claim_text = self:AddComponent(UITextMeshProUGUIEx, claim_text_path)
    self.claim_text:SetLocalText(170004)
    self.bottom_desc_text = self:AddComponent(UITextMeshProUGUIEx, bottom_desc_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.hasReward = false
    self.itemDict = {} -- Dict<index, UICommonItemChange>
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.TimerAction, self, false, false, false)
    self.timer:Start()
end

local function DataDestroy(self)
    self.hasReward = false
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.StoryGetHangupReward, self.Refresh)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.StoryGetHangupReward, self.Refresh)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    local reward = self.rewardList[index]
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(reward)
    self.itemDict[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.itemDict[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItemChange)
end

local function ShowScroll(self)
    local count = #self.rewardList
    if count > 0 then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.scroll_view:SetActive(false)
    end
end

local function ReInit(self)
    self.hasReward = false
    
    local products = DataCenter.StoryManager:GetHangupProductPerHour()
    for i = 1, ProductCount do
        local product = products[i]
        if product then
            self.product_bg_goes[i]:SetActive(true)
            self.product_count_texts[i]:SetText(string.GetFormattedStr(product.count) .. "/h")
            self.product_icon_images[i]:LoadSprite(DataCenter.RewardManager:GetPicByType(product.rewardType, product.itemId))
        else
            self.product_bg_goes[i]:SetActive(false)
        end
    end
    self.bottom_desc_text:SetLocalText(321381, Mathf.Round(DataCenter.StoryManager:GetMaxHangupTime() / 3600000))
    
    DataCenter.StoryManager:SendGetHangupReward()
end

local function Refresh(self)
    self.hasReward = true
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.rewardList = DataCenter.StoryManager:GetHangupRewardByTime(curTime)
    self:ShowScroll()
    self:TimerAction()
end

local function TimerAction(self)
    if not self.hasReward then
        return
    end
    
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local maxTime = DataCenter.StoryManager:GetMaxHangupTime()
    local hangupTime = DataCenter.StoryManager:GetHangupTime()
    local time = curTime - hangupTime
    local percent = math.max(0, math.min(time / maxTime, 1))
    self.slider:SetValue(percent)
    self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.min(time, maxTime)))
    
    self.rewardList = DataCenter.StoryManager:GetHangupRewardByTime(curTime)
    for index, item in pairs(self.itemDict) do
        item:SetItemCount(self.rewardList[index].count)
    end
end

local function OnClaimClick(self)
    DataCenter.StoryManager:SendReceiveHangupReward()
    self.ctrl:CloseSelf()
end

UIJeepAdventureReward.OnCreate = OnCreate
UIJeepAdventureReward.OnDestroy = OnDestroy
UIJeepAdventureReward.OnEnable = OnEnable
UIJeepAdventureReward.OnDisable = OnDisable
UIJeepAdventureReward.ComponentDefine = ComponentDefine
UIJeepAdventureReward.ComponentDestroy = ComponentDestroy
UIJeepAdventureReward.DataDefine = DataDefine
UIJeepAdventureReward.DataDestroy = DataDestroy
UIJeepAdventureReward.OnAddListener = OnAddListener
UIJeepAdventureReward.OnRemoveListener = OnRemoveListener

UIJeepAdventureReward.OnCreateCell = OnCreateCell
UIJeepAdventureReward.OnDeleteCell = OnDeleteCell
UIJeepAdventureReward.ShowScroll = ShowScroll

UIJeepAdventureReward.ReInit = ReInit
UIJeepAdventureReward.Refresh = Refresh
UIJeepAdventureReward.TimerAction = TimerAction
UIJeepAdventureReward.OnClaimClick = OnClaimClick

return UIJeepAdventureReward