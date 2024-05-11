---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/3/26 18:06
---
local UIHeroEquipSlot = BaseClass("UIHeroEquipSlot", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "icon"
local btn_path = "btn"
local red_path = "RedPointNum"

function UIHeroEquipSlot:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIHeroEquipSlot:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroEquipSlot:ComponentDefine()
    self.icon = self:AddComponent(UIImage, icon_path)
    self.red = self:AddComponent(UIBaseContainer, red_path)
    self.red:SetActive(false)
    
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
end

function UIHeroEquipSlot:ComponentDestroy()

end

function UIHeroEquipSlot:DataDefine()
    self.heroId = 0
    self.slot = 0
    self.callBack = nil
end

function UIHeroEquipSlot:DataDestroy()
    self.heroId = 0
    self.slot = 0
    self.callBack = nil
end

function UIHeroEquipSlot:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroEquipSlot:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroEquipSlot:SetData(heroId, slot, callBack)
    self.heroId = heroId
    self.slot = slot
    self.callBack = callBack

    self.icon:LoadSprite(HeroEquipUtil:GetEquipmentSlotIcon(slot))
end

function UIHeroEquipSlot:CheckRed()
    if self.slot ~= nil then
        local hasRed = DataCenter.HeroEquipManager:PosHasRedDot(self.heroId, self.slot)
        self.red:SetActive(hasRed)   
    end
end

function UIHeroEquipSlot:OnClick()
    if self.callBack ~= nil then
        self.callBack()
    end
end

return UIHeroEquipSlot