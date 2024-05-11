---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangjiabin.
--- DateTime: 2024/4/4 4:51 PM
---
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangjiabin.
--- DateTime: 2024/3/24 12:30 PM
---

local UIHeroEquipInfoAttrCell2 = BaseClass('UIHeroEquipInfoAttrCell2', UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

local bg_path = "Bg"
local effect_path = "Effect"
local lv_bg_path = "Effect/LvBg"
local lv_text_path = "Effect/LvBg/Lv"
local desc_text = "Effect/EffectDesc"
local value_text = "Effect/Effect_Value"
local gem_bg_path = "Effect/gemBg"
local gem_path = "Effect/gemBg/gem"
local lock_path = "Effect/Lock"
local effect2_path = "Effect2"
local desc2_text = "Effect2/EffectDesc2"
local value2_text = "Effect2/Effect_Value2"
function UIHeroEquipInfoAttrCell2:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroEquipInfoAttrCell2:OnDestroy()
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIHeroEquipInfoAttrCell2:DataDefine()
    self.data = {}
end

function UIHeroEquipInfoAttrCell2:DataDestroy()
    self.data = {}
end

function UIHeroEquipInfoAttrCell2:ComponentDefine()
    self.bg = self:AddComponent(UIImage, bg_path)
    self.effect = self:AddComponent(UIBaseContainer, effect_path)
    self.lvBg = self:AddComponent(UIImage, lv_bg_path)
    self.gemBg = self:AddComponent(UIImage, gem_bg_path)
    self.gem = self:AddComponent(UIImage, gem_path)
    self.lv = self:AddComponent(UITextMeshProUGUIEx, lv_text_path)
    self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_text)
    self.value = self:AddComponent(UITextMeshProUGUIEx, value_text)

    self.lock = self:AddComponent(UIBaseContainer, lock_path)

    self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
    self.desc2 = self:AddComponent(UITextMeshProUGUIEx, desc2_text)
    self.value2 = self:AddComponent(UITextMeshProUGUIEx, value2_text)
end

function UIHeroEquipInfoAttrCell2:ComponentDestroy()

end

function UIHeroEquipInfoAttrCell2:SetData(data)
    self.data = data
    if table.count(data) == 0 then
        self.bg:SetActive(false)
        self.effect:SetActive(false)
        self.effect2:SetActive(false)
        return
    end
    self.bg:SetActive(true)
    if self.data.isBase then
        self.effect2:SetActive(true)
        self.effect:SetActive(false)
        self.desc2:SetLocalText(self.data.desc)
        self.value2:SetText(self.data.value)
    else
        self.effect2:SetActive(false)
        if self.data.isPromoteLocked then
            self.effect:SetActive(true)
            self.lvBg:SetActive(false)
            self.gemBg:SetActive(true)
            self.gem:SetActive(false)
            self.desc:SetLocalText(self.data.desc)
            self.value:SetText(self.data.value)
            if self.data.isPromoteNew then
                self.lock:SetActive(true)
                self.gemBg:SetActive(false)
            else
                self.lock:SetActive(false)
                self.gemBg:SetActive(true)
            end
        elseif self.data.isPromote then
            self.effect:SetActive(true)
            self.lock:SetActive(false)
            self.lvBg:SetActive(false)
            self.gemBg:SetActive(true)
            self.gem:SetActive(true)
            self.desc:SetLocalText(self.data.desc)
            self.value:SetText(self.data.value)
        elseif self.data.isUpgradeLocked then
            self.effect:SetActive(true)
            self.lock:SetActive(false)
            self.lvBg:SetActive(true)
            self.gemBg:SetActive(false)
            -- UIGray.SetGray(self.lvBg.transform, true, false)
            self.lv:SetText(Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.data.unlockLevel))
            self.desc:SetLocalText(self.data.desc)
            self.value:SetText(self.data.value)
        else
            self.effect:SetActive(true)
            self.lock:SetActive(false)
            self.lvBg:SetActive(true)
            self.gemBg:SetActive(false)
            -- UIGray.SetGray(self.lvBg.transform, false, false)
            self.lv:SetText(Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.data.unlockLevel))
            self.desc:SetLocalText(self.data.desc)
            self.value:SetText(self.data.value)
        end
    end
end

return UIHeroEquipInfoAttrCell2