--- Created by shimin.
--- DateTime: 2024/03/18 18:15
--- 暴风雪预览界面死亡居民cell
local UIPreviewStormDeadCell = BaseClass("UIPreviewStormDeadCell", UIBaseContainer)
local base = UIBaseContainer

local icon_img_path = "ItemIcon"
local name_text_path = "name_text"

function UIPreviewStormDeadCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIPreviewStormDeadCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPreviewStormDeadCell:ComponentDefine()
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

function UIPreviewStormDeadCell:ComponentDestroy()
end

function UIPreviewStormDeadCell:DataDefine()
    self.param = {}
end

function UIPreviewStormDeadCell:DataDestroy()
    self.param = {}
end

function UIPreviewStormDeadCell:OnEnable()
    base.OnEnable(self)
end

function UIPreviewStormDeadCell:OnDisable()
    base.OnDisable(self)
end

function UIPreviewStormDeadCell:OnAddListener()
    base.OnAddListener(self)
end

function UIPreviewStormDeadCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIPreviewStormDeadCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIPreviewStormDeadCell:Refresh()
    local id = self.param
    local icon = GetTableData(TableName.VitaResident, id, "icon")
    self.icon_img:LoadSprite(string.format(LoadPath.Resident, icon))

    local name = GetTableData(TableName.VitaResident, id, "name")
    self.name_text:SetLocalText(name)
end

return UIPreviewStormDeadCell