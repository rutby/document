---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/7/26 18:01
---

local UIHeroOfficialSlot = BaseClass("UIHeroOfficialSlot", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall_TextMeshPro"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local CampDetailItem = require "UI.UIFormation.UIFormationTableNew.Component.CampDetailItem"
local bg_path = "Bg"
local add_path = "Add"
local add_icon_path = "Add/AddIcon"
local btn_path = "Btn"
local name_path = "NameBg/Name"
local lock_path = "Lock"
local lock_icon_path = "Lock/LockIcon"
local unlock_lv_path = "Lock/UnlockLv"
local fetter_lock_path = "FetterLock"
local fetter_unlock_lv_path = "FetterLock/FetterUnlockLv"
local hero_path = "UIHeroCellSmall"
local fetter_path = "Fetter"
local camp_path = "Camp"

local NameColor =
{
    [1] = Color.New(234/255, 219/255, 255/255, 1),
    [2] = Color.New(93/255, 91/255, 136/255, 1),
    [3] = Color.New(237/255, 203/255, 176/255, 1),
}

local NameShadowColor =
{
    [1] = Color.New(86/255, 56/255, 155/255, 1),
    [2] = Color.New(0.0000000, 0.0000000, 0.0000000, 0),
    [3] = Color.New(73/255, 39/255, 9/255, 1),
}

local LvToNum =
{
    [1] = 2,
    [2] = 3,
    [3] = 4,
    [4] = 5,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.bg_image = self:AddComponent(UIImage, bg_path)
    self.add_go = self:AddComponent(UIBaseContainer, add_path)
    self.add_icon_image = self:AddComponent(UIImage, add_icon_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
    self.lock_icon_image = self:AddComponent(UIImage, lock_icon_path)
    self.unlock_lv_text = self:AddComponent(UITextMeshProUGUIEx, unlock_lv_path)
    self.fetter_lock_go = self:AddComponent(UIBaseContainer, fetter_lock_path)
    self.fetter_unlock_lv_text = self:AddComponent(UITextMeshProUGUIEx, fetter_unlock_lv_path)
    self.hero = self:AddComponent(UIHeroCellSmall, hero_path)
    self.fetter_image = self:AddComponent(CampDetailItem, fetter_path)
    self.camp_image = self:AddComponent(UIImage, camp_path)
end

local function ComponentDestroy(self)
    self.bg_image = nil
    self.add_go = nil
    self.add_icon_image = nil
    self.btn = nil
    self.name_text = nil
    self.lock_go = nil
    self.lock_icon_image = nil
    self.unlock_lv_text = nil
    self.fetter_lock_go = nil
    self.fetter_unlock_lv_text = nil
    self.hero = nil
    self.fetter_image = nil
    self.camp_image = nil
end

local function DataDefine(self)
    self.camp = 0
    self.pos = 0
end

local function DataDestroy(self)
    self.camp = nil
    self.pos = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self, camp, pos)
    self.camp = camp
    self.pos = pos
    self.template = DataCenter.HeroOfficialManager:GetTemplate(camp, pos)
    self.data = DataCenter.HeroOfficialManager:GetData(self.template.id)

    local buildingLv = DataCenter.HeroOfficialManager:GetBuildingLv()
    local isLocked = buildingLv < self.template.unlockLv

    self.unlock_lv_text:SetText("Lv." .. self.template.unlockLv)
    self.fetter_unlock_lv_text:SetText("Lv." .. self.template.unlockLv)
    self:SetCamp(camp)
    if self.template.type == 1 then
        -- hero
        if isLocked then
            self.bg_image:SetActive(false)
            self.lock_go:SetActive(true)
            self.add_go:SetActive(false)
            self.hero:SetActive(false)
        else
            self.bg_image:SetActive(true)
            self.lock_go:SetActive(false)
            if self.data and self.data.heroUuid then
                self.add_go:SetActive(false)
                self.hero:SetActive(true)
                self.hero:SetData(self.data.heroUuid, nil, nil, true)
            else
                self.add_go:SetActive(true)
                self.hero:SetActive(false)
            end
        end
        self.fetter_image:SetActive(false)
        self.fetter_lock_go:SetActive(false)
        self.camp_image:SetActive(false)
        self.name_text:SetLocalText(self.template.name)
    elseif self.template.type == 2 then
        -- fetter
        local num = 0
        if isLocked then
            num = LvToNum[4]
            self.name_text:SetLocalText(self.template.name)
            self.fetter_lock_go:SetActive(true)
        else
            num =LvToNum[self.template.buffLv]
            self.name_text:SetText(Localization:GetString(tostring(self.template.name)) .. self.template.buffLv)
            self.fetter_lock_go:SetActive(false)
        end
        local oneData = {}
        oneData.camp = self.camp
        oneData.num = 5
        local list = {oneData}
        self.fetter_image:InitData(list)
        self.bg_image:SetActive(false)
        self.lock_go:SetActive(false)
        self.add_go:SetActive(false)
        self.hero:SetActive(false)
        self.fetter_image:SetActive(true)
        self.camp_image:SetActive(false)
        UIGray.SetGray(self.fetter_image.transform, isLocked)
    elseif self.template.type == 3 then
        -- counter
        if isLocked then
            self.name_text:SetLocalText(self.template.name)
            UIGray.SetGray(self.camp_image.transform, true)
            self.fetter_lock_go:SetActive(true)
        else
            self.name_text:SetText(Localization:GetString(tostring(self.template.name)) .. self.template.buffLv)
            UIGray.SetGray(self.camp_image.transform, false)
            self.fetter_lock_go:SetActive(false)
        end
        self.bg_image:SetActive(false)
        self.lock_go:SetActive(false)
        self.add_go:SetActive(false)
        self.hero:SetActive(false)
        self.fetter_image:SetActive(false)
        self.camp_image:SetActive(true)
        self.camp_image:LoadSprite(HeroUtils.GetCampIconPath(camp))
    end
end

local function SetHeroUuid(self, heroUuid)
    self.lock_go:SetActive(false)
    self.bg_image:SetActive(true)
    self.fetter_image:SetActive(false)
    self.camp_image:SetActive(false)
    
    if heroUuid ~= nil then
        self.add_go:SetActive(false)
        self.hero:SetActive(true)
        self.hero:SetData(heroUuid, nil, nil, true)
    else
        self.add_go:SetActive(true)
        self.hero:SetActive(false)
    end
end

local function SetCamp(self, camp)
    local shadows = self.name_text.transform:GetComponentsInChildren(typeof(CS.UnityEngine.UI.Shadow))
    for i = 0, shadows.Length - 1 do
        shadows[i].effectColor = NameShadowColor[camp]
    end
    self.name_text:SetColor(NameColor[camp])
    self.bg_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIStationed_slot_" .. camp)
    self.add_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIStationed_add_" .. camp)
    self.lock_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIStationed_lock_" .. camp)
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

local function OnClick(self)
    if self.onClick then
        self.onClick()
    end
end

UIHeroOfficialSlot.OnCreate= OnCreate
UIHeroOfficialSlot.OnDestroy = OnDestroy
UIHeroOfficialSlot.ComponentDefine = ComponentDefine
UIHeroOfficialSlot.ComponentDestroy = ComponentDestroy
UIHeroOfficialSlot.DataDefine = DataDefine
UIHeroOfficialSlot.DataDestroy = DataDestroy
UIHeroOfficialSlot.OnEnable = OnEnable
UIHeroOfficialSlot.OnDisable = OnDisable

UIHeroOfficialSlot.SetData = SetData
UIHeroOfficialSlot.SetHeroUuid = SetHeroUuid
UIHeroOfficialSlot.SetCamp = SetCamp
UIHeroOfficialSlot.SetOnClick = SetOnClick
UIHeroOfficialSlot.OnClick = OnClick

return UIHeroOfficialSlot