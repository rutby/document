---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/8 18:03
---


local UIDecorateUnlockItem_CommonItem = BaseClass("UIDecorateUnlockItem_CommonItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local icon_path = "UICommonItem"
local name_path = "NameText"
local get_btn_path = "GetBtn"
local get_btn_text_path = "GetBtn/GetBtnLabel"

local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnLabel"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.icon = self:AddComponent(UICommonItem, icon_path)
    self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)

    self.get_btn = self:AddComponent(UIButton, get_btn_path)
    self.get_btn_text = self:AddComponent(UITextMeshProUGUIEx, get_btn_text_path)
    self.get_btn_text:SetLocalText(100547)
    self.get_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ClickGetBtn()
    end)

    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn_text = self:AddComponent(UITextMeshProUGUIEx, use_btn_text_path)
    self.use_btn_text:SetLocalText(110046)
    self.use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ClickUseBtn()
    end)
end

local function ComponentDestroy(self)

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

local function ReInit(self, data)
    self.data = data
    self:RefreshView()
end

local function RefreshView(self)
    local param = {}
    local itemCount = DataCenter.ItemData:GetItemCount(self.data.id)
    DataCenter.DecorationDataManager:SetNewItemFlag(self.data.id)

    local template = DataCenter.ItemTemplateManager:GetItemTemplate(tostring(self.data.id))
    self.name:SetLocalText(template.name)
    param.count = itemCount
    param.rewardType = RewardType.GOODS
    param.itemId = self.data.id
    self.icon:ReInit(param)
    self.use_btn:SetActive(itemCount > 0)
    self.get_btn:SetActive(itemCount <= 0)
end

local function ClickGetBtn(self)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = self.data.id
    param.targetNum = 1
    table.insert(lackTab,param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function ClickUseBtn(self)
    DataCenter.DecorationDataManager:CovertSkin(self.data.skinId, self.data.index)
end

UIDecorateUnlockItem_CommonItem.OnCreate = OnCreate
UIDecorateUnlockItem_CommonItem.OnDestroy = OnDestroy
UIDecorateUnlockItem_CommonItem.OnEnable = OnEnable
UIDecorateUnlockItem_CommonItem.OnDisable = OnDisable
UIDecorateUnlockItem_CommonItem.ComponentDefine = ComponentDefine
UIDecorateUnlockItem_CommonItem.ComponentDestroy = ComponentDestroy
UIDecorateUnlockItem_CommonItem.DataDefine = DataDefine
UIDecorateUnlockItem_CommonItem.DataDestroy = DataDestroy
UIDecorateUnlockItem_CommonItem.ReInit = ReInit
UIDecorateUnlockItem_CommonItem.RefreshView = RefreshView
UIDecorateUnlockItem_CommonItem.ClickGetBtn = ClickGetBtn
UIDecorateUnlockItem_CommonItem.ClickUseBtn = ClickUseBtn

return UIDecorateUnlockItem_CommonItem