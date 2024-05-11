---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
---

---@class UIParkourChoiceItem : UIBaseContainer
local UIParkourChoiceItem = BaseClass("UIParkourChoiceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local compBook = {
    {path = "Bg",           name = "bgBtn",     type = UIButton},
    {path = "NameText",     name = "nameText",  type = UINewText},
    {path = "ImgIcon",      name = "imgIcon",   type = UIImage},
    {path = "HeroIcon",     name = "heroIcon",  type = UIImage},
    
}

function UIParkourChoiceItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UIParkourChoiceItem:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIParkourChoiceItem:ComponentDefine()
    self:DefineCompsByBook(compBook)
    
    self.bgBtn:SetOnClick(function() 
        self:OnBgClick()
    end)
end

function UIParkourChoiceItem:ComponentDestroy()
    self:ClearCompsByBook(compBook)
    
end

function UIParkourChoiceItem:SetData(triggerItemId, heroUuid, callBack)

    ---@type DataCenter.LWTriggerItem.LWTriggerItemTemplate
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(triggerItemId)
    if meta then

        if not string.IsNullOrEmpty(meta.desc) then
            self.nameText:SetText(Localization:GetString(meta.desc).. meta.text)
        else
            self.nameText:SetText(meta.text)
        end

        if not string.IsNullOrEmpty(meta.icon) then
            self.imgIcon:LoadSprite(meta.icon)
        end

        if heroUuid then
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
            assert(heroData ~= nil, "TriggerGate.InitView heroData is nil ! heroUuid : ".. heroUuid)
            iconAsset = HeroUtils.GetHeroIconPath(heroData.modelId)

            self.heroIcon:LoadSprite(iconAsset)
            self.heroIcon.gameObject:SetActive(true)
        else
            self.heroIcon.gameObject:SetActive(false)
        end
    end
    
    self.triggerItemId = triggerItemId
    self.heroUuid = heroUuid
    self.callBack = callBack
end

function UIParkourChoiceItem:OnBgClick()
    if self.callBack then
        self.callBack(self.triggerItemId, self.heroUuid)
    end
end

return UIParkourChoiceItem