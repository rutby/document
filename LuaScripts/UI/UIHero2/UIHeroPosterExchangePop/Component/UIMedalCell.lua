
local UIMedalCell = BaseClass("UIMedalCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityOutline = typeof(CS.UnityEngine.UI.Outline)

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self.itemId = nil
    self.itemNum = nil
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.imgQuality = self:AddComponent(UIImage, "ImgQuality")
    self.imgIcon = self:AddComponent(UIImage, "ImgIcon")
    --self.imgExtra = self:AddComponent(UIImage, "ImgIcon/Mask/ImgExtra")
    self.imgExtra = self:AddComponent(UIImage, "ImgExtra")
    --self.textExtra = self:AddComponent(UIText, "TextExtra")
    self.textNum = self:AddComponent(UIText, "TextNum")
    self.textName = self:AddComponent(UIText, "TextName")
    self.imgExtra:SetActive(false)
end

local function ComponentDestroy(self)
    self.imgQuality = nil
    self.imgIcon = nil
    self.imgExtra = nil
    --self.textExtra = nil
    self.textNum = nil
end

local function SetData(self, itemId, itemNum)
    self.itemId = itemId
    self.itemNum = itemNum

    local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    self.imgQuality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
    self.imgIcon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))

    --if template.para2 ~= nil and template.para2 ~= '' then
    --    self.imgExtra:LoadSprite(HeroUtils.GetHeroIconPath(template.para2))
    --end

    --self.textName:SetLocalText(template.name) 
    self.textName:SetText(DataCenter.ItemTemplateManager:GetName(itemId))
    self.textNum:SetText(string.GetFormattedSeperatorNum(itemNum))
end

local function SetNumDisplay(self, text)
    self.textNum:SetText(text)
end

local function SetNumColor(self, color)
    self.textNum:SetColor(color)
end

local function ToggleNumOutline(self, t)
    local outlines = self.textNum.gameObject:GetComponents(UnityOutline)
    if outlines ~= nil then
        for i = 0, outlines.Length -1 do
            outlines[i].enabled = t
        end
    end
end

local function OnBtnClick(self)
end

UIMedalCell.OnCreate = OnCreate
UIMedalCell.OnDestroy = OnDestroy
UIMedalCell.ComponentDefine = ComponentDefine
UIMedalCell.ComponentDestroy = ComponentDestroy
UIMedalCell.SetData = SetData
UIMedalCell.SetNumDisplay = SetNumDisplay
UIMedalCell.SetNumColor = SetNumColor
UIMedalCell.ToggleNumOutline = ToggleNumOutline

UIMedalCell.OnBtnClick = OnBtnClick


return UIMedalCell