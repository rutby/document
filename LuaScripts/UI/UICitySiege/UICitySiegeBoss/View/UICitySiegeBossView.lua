---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/4/2 14:33
---

local UICitySiegeBoss = BaseClass("UICitySiegeBoss", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItemChange = require "UI.UICommonItem.UICommonItemChange"

local panel_path = "Panel"
local root_path = "Root"
local info_path = "Root/Top/Info"
local name_path = "Root/Top/Name"
local reward_desc_path = "Root/Top/RewardDesc"
local scroll_view_path = "Root/Top/ScrollView"
local recommend_path = "Root/Top/Recommend"
local attack_path = "Root/BuildBtnGo/City_Upgrade/BtnImage"
local attack_text_path = "Root/BuildBtnGo/City_Upgrade/BtnImage/Rect_BtnNameBg/Txt_BtnName"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
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
    self.panel_btn = self:AddComponent(UIButton, panel_path)
    self.panel_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.root_go = self:AddComponent(UIBaseContainer, root_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.reward_desc_text = self:AddComponent(UITextMeshProUGUIEx, reward_desc_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.recommend_text = self:AddComponent(UITextMeshProUGUIEx, recommend_path)
    self.attack_btn = self:AddComponent(UIButton, attack_path)
    self.attack_btn:SetOnClick(function()
        self:OnAttackClick()
    end)
    self.attack_text = self:AddComponent(UITextMeshProUGUIEx, attack_text_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.zombieId = 0
    self.rewardList = {}
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItemChange, itemObj)
    item:ReInit(self.rewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
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
    self.follow = true
    self.zombieId = self:GetUserData()
    local line = LocalController:instance():getLine(TableName.CitySiegeZombie, self.zombieId)
    local name = Localization:GetString(line.Name)
    self.name_text:SetLocalText(140205, line.Level, name)
    self.reward_desc_text:SetLocalText(130065)
    self.recommend_text:SetLocalText(line.RecommendText, line.RecommendPara)

    self.rewardList = {}
    for _, v in ipairs(string.split(line.show_reward or "", "|")) do
        local spls = string.split(v, ";")
        if #spls == 3 then
            local reward = {}
            reward.rewardType = tonumber(spls[1])
            reward.itemId = tonumber(spls[2])
            reward.count = tonumber(spls[3])
            table.insert(self.rewardList, reward)
        end
    end
    self:ShowScroll()
end

local function Update(self)
    if not self.follow then
        return
    end
    local data = DataCenter.CitySiegeManager:GetBossData(self.zombieId)
    if data and data:HasObj() then
        CS.SceneManager.World:AutoLookat(data:GetPos(), CityResidentZoom.SiegeBoss, 0.1)
    end
end

local function OnInfoClick(self)
    
end

local function OnAttackClick(self)
    self.follow = false
    DataCenter.CitySiegeManager:OnBossAttackClick(self.zombieId)
    self.ctrl:CloseSelf()
end

UICitySiegeBoss.OnCreate = OnCreate
UICitySiegeBoss.OnDestroy = OnDestroy
UICitySiegeBoss.OnEnable = OnEnable
UICitySiegeBoss.OnDisable = OnDisable
UICitySiegeBoss.ComponentDefine = ComponentDefine
UICitySiegeBoss.ComponentDestroy = ComponentDestroy
UICitySiegeBoss.DataDefine = DataDefine
UICitySiegeBoss.DataDestroy = DataDestroy
UICitySiegeBoss.OnAddListener = OnAddListener
UICitySiegeBoss.OnRemoveListener = OnRemoveListener

UICitySiegeBoss.OnCreateCell = OnCreateCell
UICitySiegeBoss.OnDeleteCell = OnDeleteCell
UICitySiegeBoss.ShowScroll = ShowScroll

UICitySiegeBoss.ReInit = ReInit
UICitySiegeBoss.Update = Update
UICitySiegeBoss.OnInfoClick = OnInfoClick
UICitySiegeBoss.OnAttackClick = OnAttackClick

return UICitySiegeBoss