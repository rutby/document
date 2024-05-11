local TotalDetailItem = BaseClass("TotalDetailItem", UIBaseContainer)
local base = UIBaseContainer

local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local icon_txt_path = "UISoldierItem/Icon"
local name_txt_path = "name"
local level_txt_path = "UISoldierItem/LevelText"
local solider_path = "count"

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
  --  self.cellList = {}
end

local function DataDestroy(self)
  --  self.cellList = nil
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
  --  Logger.Table(self.param," param ")
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

TotalDetailItem.OnCreate = OnCreate
TotalDetailItem.OnDestroy = OnDestroy
TotalDetailItem.OnEnable = OnEnable
TotalDetailItem.OnDisable = OnDisable
TotalDetailItem.ComponentDefine = ComponentDefine
TotalDetailItem.ComponentDestroy = ComponentDestroy
TotalDetailItem.DataDefine = DataDefine
TotalDetailItem.DataDestroy = DataDestroy
TotalDetailItem.OnAddListener = OnAddListener
TotalDetailItem.OnRemoveListener = OnRemoveListener
TotalDetailItem.ReInit = ReInit

return TotalDetailItem
