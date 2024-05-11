
local UIMainBuildUpgradeItem = BaseClass("UIMainBuildUpgradeItem", UIBaseContainer)
local base = UIBaseContainer

local nameText_path = "NameText"
local itemIcon_path = "ItemIcon"

function UIMainBuildUpgradeItem:OnCreate()
    base.OnCreate(self)
    self.nameText = self:AddComponent(UITextMeshProUGUIEx,nameText_path)
    self.icon = self:AddComponent(UIImage,itemIcon_path)
end

function UIMainBuildUpgradeItem:OnDestroy()
   
    base.OnDestroy(self)
end

function UIMainBuildUpgradeItem:SetData(unlockData)
    local textId = 0
    local iconStr = ""
    if unlockData then
        if unlockData.type == 1 then --活动id
            textId = tonumber(GetTableData(TableName.ActivityPanel, unlockData.id, "name"))
            local iconConfig = GetTableData(TableName.ActivityPanel, unlockData.id, "list_icon")
            iconStr =string.format(LoadPath.ActivityIconPath, iconConfig)
        elseif unlockData.type == 2 then
            textId =  GetTableData(DataCenter.BuildTemplateManager:GetTableName(), unlockData.id,"name")
            local iconConfig = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), unlockData.id,"pic")
            iconStr =string.format(LoadPath.BuildIconOutCity, iconConfig)
        end
    end
    self.nameText:SetLocalText(textId)
    self.icon:LoadSprite(iconStr)
end

return UIMainBuildUpgradeItem

