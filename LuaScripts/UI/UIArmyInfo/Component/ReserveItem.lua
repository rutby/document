---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/24 18:09
---

local ReserveItem = BaseClass("ReserveItem", UIBaseContainer)
local base = UIBaseContainer

local icon_txt_path = "icon"
local name_txt_path = "Text_title"
local level_txt_path = "Text_level"
local solider_path = "Text_forces"

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
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    self.icon = self:AddComponent(UIImage,icon_txt_path)
    self.level = self:AddComponent(UITextMeshProUGUIEx,level_txt_path)
    self.solider = self:AddComponent(UITextMeshProUGUIEx, solider_path)
end

local function ComponentDestroy(self)
    self.name = nil
    self.icon = nil
    self.level =nil
    self.solider = nil
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

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self,param)
    self.param = param
    if self.param ~= nil then
        self.solider:SetText(self.param.value)
        if self.param.key ~= nil then
            local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.key)
            if template ~= nil then
                self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
                self.level:SetText(RomeNum[template.show_level])
                self.name:SetLocalText(template.name)
                self.level:SetActive(true)
            elseif self.param.key == ForceTypeTrainAndUpgrade then
                self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, "SoldierIcons_train_1"))
                self.name:SetLocalText(120143)
                self.level:SetActive(false)
            elseif self.param.key == ForceTypeInjured then
                self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, "SoldierIcons_injuried_1"))
                self.name:SetLocalText(130062)
                self.level:SetActive(false)
            end
        end
    end
end

ReserveItem.OnCreate = OnCreate
ReserveItem.OnDestroy = OnDestroy
ReserveItem.OnEnable = OnEnable
ReserveItem.OnDisable = OnDisable
ReserveItem.ComponentDefine = ComponentDefine
ReserveItem.ComponentDestroy = ComponentDestroy
ReserveItem.DataDefine = DataDefine
ReserveItem.DataDestroy = DataDestroy
ReserveItem.OnAddListener = OnAddListener
ReserveItem.OnRemoveListener = OnRemoveListener
ReserveItem.ReInit = ReInit

return ReserveItem
