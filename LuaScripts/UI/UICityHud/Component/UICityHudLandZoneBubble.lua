---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/1/18 19:24
---

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudLandZoneBubble = BaseClass("UICityHudLandZoneBubble", base)

local btn_path = "Root/Btn"

local function ComponentDefine(self)
    base.ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
end

local function DataDefine(self)
    base.DataDefine(self)
    self.lodMax = 3
end

local function SetParam(self, param)
    base.SetParam(self, param)
    self.root_go.transform.localPosition = param.offset or Vector3.zero
end

local function OnClick(self)
    if self.param.onClick then
        self.param.onClick()
    end
end

UICityHudLandZoneBubble.ComponentDefine = ComponentDefine
UICityHudLandZoneBubble.DataDefine = DataDefine
UICityHudLandZoneBubble.SetParam = SetParam

UICityHudLandZoneBubble.OnClick = OnClick

return UICityHudLandZoneBubble