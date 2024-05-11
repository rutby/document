---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/10 14:56
---

local UIMysteriousBoxReward = BaseClass("UIMysteriousBoxReward", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local return_path = "UICommonMiniPopUpTitle/panel"
local close_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"

local box_path = "Bg/Box"
local item_path = "Bg/Box/Item"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
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
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.title_text:SetLocalText(375057)
    self.box_image = self:AddComponent(UIImage, box_path)
    self.item = self:AddComponent(UICommonItem, item_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local icon, reward = self:GetUserData()
    self.box_image:LoadSprite(icon)
    self.item:ReInit(reward)
end

UIMysteriousBoxReward.OnCreate = OnCreate
UIMysteriousBoxReward.OnDestroy = OnDestroy
UIMysteriousBoxReward.OnEnable = OnEnable
UIMysteriousBoxReward.OnDisable = OnDisable
UIMysteriousBoxReward.ComponentDefine = ComponentDefine
UIMysteriousBoxReward.ComponentDestroy = ComponentDestroy
UIMysteriousBoxReward.DataDefine = DataDefine
UIMysteriousBoxReward.DataDestroy = DataDestroy
UIMysteriousBoxReward.OnAddListener = OnAddListener
UIMysteriousBoxReward.OnRemoveListener = OnRemoveListener

UIMysteriousBoxReward.ReInit = ReInit

return UIMysteriousBoxReward