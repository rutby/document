---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/8/21 16:29
---
local EffectTitleItem = BaseClass("EffectTitleItem", UIBaseContainer)
local base = UIBaseContainer
local btn_path =""
local txt_path = "TitleText"
--local show_arrow_path = "ShowArrow"
--local hide_arrow_path = "HideArrow"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
    --self.showArrow = self:AddComponent(UIImage, show_arrow_path)
    --self.hideArrow = self:AddComponent(UIImage, hide_arrow_path)

    --self.showArrow:SetActive(false)
    --self.hideArrow:SetActive(false)
end

local function ComponentDestroy(self)

end

local function SetData(self, data)
    self.data = data
    self.txt:SetLocalText(self.data.nameStr)
    --self.showArrow:SetActive(not self.data.isShow)
    --self.hideArrow:SetActive(self.data.isShow)
end

local function OnClick(self)
    if self.data.callBack then
        self.data.callBack(self.data)
    end
end

EffectTitleItem.OnCreate =OnCreate
EffectTitleItem.OnDestroy =OnDestroy
EffectTitleItem.OnEnable =OnEnable
EffectTitleItem.OnDisable =OnDisable
EffectTitleItem.ComponentDefine =ComponentDefine
EffectTitleItem.ComponentDestroy =ComponentDestroy
EffectTitleItem.SetData = SetData
EffectTitleItem.OnClick = OnClick

return EffectTitleItem