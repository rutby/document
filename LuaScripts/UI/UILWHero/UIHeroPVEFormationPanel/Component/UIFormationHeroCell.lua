---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2023/1/4 15:46
---

local UIFormationHeroCell = BaseClass("UIFormationHeroCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.heroCell = self:AddComponent(UIHeroCellSmall, "")
    self.formationBg = self:AddComponent(UIImage,"FormationTag")
    self.formationText = self:AddComponent(UIText,"FormationTag/FormationText")
end

local function ComponentDestroy(self)
    self.heroCell = nil
    self.formationBg = nil
    self.formationText = nil
end

local function OnClickCell(self,transform,heroUuid)
    self.view:OnClickHeroCell(self.displayData,self)
end

local function DataDefine(self)
    self.clickCallBack = BindCallback(self,OnClickCell)
end

local function DataDestroy(self)
    self.clickCallBack = nil
end

local function SetData(self,heroDisplayData,showFormation)

    if heroDisplayData == nil then
        self:SetActive(false)
        return
    end
    self:SetActive(true)

    self.displayData = heroDisplayData
    local heroUuid = heroDisplayData.heroData.uuid
    self.heroCell:SetData(heroUuid,self.clickCallBack,false,false)
    
    local belongFormation = heroDisplayData.squadIndex
    if showFormation then
        if belongFormation then
            self.formationBg:SetActive(true)
            self.formationText:SetText(belongFormation)
            self.heroCell:SetMask(true)
        else
            self.formationBg:SetActive(false)
            self.heroCell:SetMask(false)
        end
    else
        self.formationBg:SetActive(false)
        self.heroCell:SetMask(false)
    end
end

--- 改变英雄选中状态
local function SetSelected(self,selected)
    self.heroCell:SetSelected(selected)
end

UIFormationHeroCell.OnCreate = OnCreate
UIFormationHeroCell.OnDestroy = OnDestroy
UIFormationHeroCell.OnEnable = OnEnable
UIFormationHeroCell.OnDisable = OnDisable
UIFormationHeroCell.ComponentDefine = ComponentDefine
UIFormationHeroCell.ComponentDestroy = ComponentDestroy
UIFormationHeroCell.DataDefine = DataDefine
UIFormationHeroCell.DataDestroy = DataDestroy
UIFormationHeroCell.SetData = SetData
UIFormationHeroCell.SetSelected = SetSelected

return UIFormationHeroCell