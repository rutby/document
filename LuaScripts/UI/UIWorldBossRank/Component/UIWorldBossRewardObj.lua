---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/24 12:02
---
local UIWorldBossRewardItem = require "UI.UIWorldBossRank.Component.UIWorldBossRewardItem"
local UIWorldBossRewardObj = BaseClass("UIWorldBossRewardObj",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local select_obj_path = "select"
-- local rank_text_path = "select/rankDes"
-- local reward_text_path = "select/rewardDes"
local scroll_path = "ScrollView"
local empty_txt_path = "TxtEmpty"
local function OnCreate(self)
    base.OnCreate(self)
    -- self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
    -- self.desc_text:SetText(Localization:GetString("302625") .. "\n" .. Localization:GetString("302627"))
    self.select_obj = self:AddComponent(UIBaseContainer, select_obj_path)
    -- self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
    -- self.rank_text:SetLocalText(302043)
    -- self.reward_text = self:AddComponent(UITextMeshProUGUIEx, reward_text_path)
    -- self.reward_text:SetLocalText(130065)
    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.showDatalist ={}
    self.alreadyCreate = false
    self.empty_txt = self:AddComponent(UITextMeshProUGUIEx, empty_txt_path)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(UIWorldBossRewardItem)
    self.showDatalist = {}
end

local function RefreshData(self)
    if self.alreadyCreate == false then
        self:ClearScroll()
        self.showDatalist = self.view.ctrl:GetActivityRewardList()
        if #self.showDatalist>0 then
            self.alreadyCreate = true
            self.ScrollView:SetTotalCount(#self.showDatalist)
            self.ScrollView:RefillCells()
            self.empty_txt:SetActive(false)
        else
            self.empty_txt:SetLocalText(302188)
            self.empty_txt:SetActive(true)
        end
    end
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(UIWorldBossRewardItem, itemObj)
    cellItem:SetItemShow(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, UIWorldBossRewardItem)
end
UIWorldBossRewardObj.OnCreate = OnCreate
UIWorldBossRewardObj.OnDestroy = OnDestroy
UIWorldBossRewardObj.RefreshData = RefreshData
UIWorldBossRewardObj.OnEnable = OnEnable
UIWorldBossRewardObj.OnDisable = OnDisable
UIWorldBossRewardObj.ClearScroll =ClearScroll
UIWorldBossRewardObj.OnItemMoveOut =OnItemMoveOut
UIWorldBossRewardObj.OnItemMoveIn =OnItemMoveIn
return UIWorldBossRewardObj