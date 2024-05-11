---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/7/12 16:57
---

local UIPVEBloodItem = BaseClass("UIPVEBloodItem", UIBaseContainer)
local base = UIBaseContainer

local a_path = "A"
local b_path = "B"

local ColorPath =
{
    [0] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_empty.png",
    [1] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_orange.png",
    [2] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_yellow.png",
    [3] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_green.png",
    [4] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_blue.png",
    [5] = "Assets/Main/Sprites/pve/UIbattle_icon_soldiers_pur.png",
}

local Width = 10
local Height = 27 --20

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.a_image = self:AddComponent(UIImage, a_path)
    self.b_image = self:AddComponent(UIImage, b_path)
    self.b_image.rectTransform:Set_sizeDelta(Width, 0)
end

local function ComponentDestroy(self)
    self.a_image = nil
    self.b_image = nil
end

local function DataDefine(self)
    self.lastK = 0
end

local function DataDestroy(self)
    self.lastK = nil
end

local function TweenColor(self, k, percent, duration)
    self.a_image:LoadSprite(self:GetColorPath(k))
    self.b_image:LoadSprite(self:GetColorPath(k + 1))
    if self.lastK < k then
        self.b_image.rectTransform:Set_sizeDelta(Width, 0)
    elseif self.lastK > k then
        self.b_image.rectTransform:Set_sizeDelta(Width, Height)
    end
    self.lastK = k
    return self.b_image.rectTransform:DOSizeDelta(Vector2.New(Width, Height * percent), duration):SetEase(CS.DG.Tweening.Ease.Linear)
end

local function SetColor(self, k, percent)
    self.a_image:LoadSprite(self:GetColorPath(k))
    self.b_image:LoadSprite(self:GetColorPath(k + 1))
    self.b_image.rectTransform:Set_sizeDelta(Width, Height * percent)
    self.lastK = k
end

local function GetColorPath(self, k)
    if k < 0 then
        k = 0
    end
    if k > 5 then
        k = (k - 1) % 5 + 1
    end
    return ColorPath[k]
end

UIPVEBloodItem.OnCreate= OnCreate
UIPVEBloodItem.OnDestroy = OnDestroy
UIPVEBloodItem.ComponentDefine = ComponentDefine
UIPVEBloodItem.ComponentDestroy = ComponentDestroy
UIPVEBloodItem.DataDefine = DataDefine
UIPVEBloodItem.DataDestroy = DataDestroy

UIPVEBloodItem.TweenColor = TweenColor
UIPVEBloodItem.SetColor = SetColor
UIPVEBloodItem.GetColorPath = GetColorPath

return UIPVEBloodItem