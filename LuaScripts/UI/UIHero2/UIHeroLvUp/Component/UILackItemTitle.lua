---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/8 10:25
---


local UILackItemTitle = BaseClass('UILackItemTitle', UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.text = self:AddComponent(UITextMeshProUGUIEx, "desTxt")
    self.text:SetLocalText(110292)
end

local function ComponentDestroy(self)
    self.cellObjList = nil
end

UILackItemTitle.OnCreate= OnCreate
UILackItemTitle.OnDestroy = OnDestroy
UILackItemTitle.ComponentDefine = ComponentDefine
UILackItemTitle.ComponentDestroy = ComponentDestroy

return UILackItemTitle
