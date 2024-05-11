---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/20 14:48
---
local FormationDefenceHeroItem = BaseClass("FormationDefenceHeroItem",UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellBig"
local hero_path = "UIHeroCellBig"
local in_march_obj_path = "inMarchObj"
local in_march_des_path = "inMarchObj/inMarchDes"

local function OnCreate(self)
    base.OnCreate(self)
    self.heroBase = self:AddComponent(UIHeroCell,hero_path)
    self.in_march_obj = self:AddComponent(UIBaseContainer,in_march_obj_path)
    self.in_march_des = self:AddComponent(UITextMeshProUGUIEx,in_march_des_path)
    self.in_march_des:SetLocalText(120166)
    self.btn = self:AddComponent(UIButton, hero_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSelectClick()
    end)
end

local function InitData(self,data, formationIndex, formationUid)
    self.uuid = data
    self.formationUid = formationUid
    self.formationIndex = formationIndex
    self.heroBase:SetData(self.uuid)
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.heroId = self.data.heroId
    self.in_march_obj:SetActive(self.data.isInMarch)
end

local function OnSelectClick(self)
    self.view:OnSelectClick(self.formationUid, self.formationIndex)
end

FormationDefenceHeroItem.OnCreate = OnCreate
FormationDefenceHeroItem.InitData = InitData
FormationDefenceHeroItem.OnSelectClick =OnSelectClick
return FormationDefenceHeroItem