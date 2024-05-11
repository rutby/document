---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/2/28 18:16
---

local UIHeroInfoQualityPreviewItem = BaseClass("UIHeroInfoQualityPreviewItem", UIBaseContainer)
local base = UIBaseContainer

local title_path = "Title"
local val_path = "Val"
local add_path = "Add"

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
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.val_text = self:AddComponent(UITextMeshProUGUIEx, val_path)
    self.add_text = self:AddComponent(UITextMeshProUGUIEx, add_path)
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

local function SetTitle(self, title)
    self.title_text:SetLocalText(title)
end

local function SetValue(self, val, add)
    self.val_text:SetText(val)
    if add then
        self.add_text:SetText(add)
        self.add_text:SetActive(true)
    else
        self.add_text:SetActive(false)
    end
end

UIHeroInfoQualityPreviewItem.OnCreate = OnCreate
UIHeroInfoQualityPreviewItem.OnDestroy = OnDestroy
UIHeroInfoQualityPreviewItem.OnEnable = OnEnable
UIHeroInfoQualityPreviewItem.OnDisable = OnDisable
UIHeroInfoQualityPreviewItem.ComponentDefine = ComponentDefine
UIHeroInfoQualityPreviewItem.ComponentDestroy = ComponentDestroy
UIHeroInfoQualityPreviewItem.DataDefine = DataDefine
UIHeroInfoQualityPreviewItem.DataDestroy = DataDestroy
UIHeroInfoQualityPreviewItem.OnAddListener = OnAddListener
UIHeroInfoQualityPreviewItem.OnRemoveListener = OnRemoveListener

UIHeroInfoQualityPreviewItem.SetTitle = SetTitle
UIHeroInfoQualityPreviewItem.SetValue = SetValue

return UIHeroInfoQualityPreviewItem