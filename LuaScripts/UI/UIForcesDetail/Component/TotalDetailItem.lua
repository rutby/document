local TotalDetailItem = BaseClass("TotalDetailItem", UIBaseContainer)
local base = UIBaseContainer

local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

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
            end
            self.level:SetText(RomeNum[template.show_level])
            self.name:SetLocalText(template.name) 
        end
        
    end
end

local function OnItemClick(self)
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
