---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
--- DateTime: 2024/1/11 2:42 PM
---

---@class UIFormationTrailHeroCell
local UIFormationTrailHeroCell = BaseClass("UIFormationTrailHeroCell", UIBaseContainer)
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
    self.heroCell = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
    self.formationBg = self:AddComponent(UIImage,"UIHeroCellSmall/FormationTag")
    self.formationText = self:AddComponent(UIText,"UIHeroCellSmall/FormationTag/FormationText")
    
    self.trailIcon = self:AddComponent(UIBaseContainer, "trailIcon")
    self.trailText = self:AddComponent(UIText, "trailIcon/trailText")
    self.trailText:SetLocalText("trail_icon_tips")
    self.selectGo = self:AddComponent(UIBaseContainer, "Selected")
end

local function ComponentDestroy(self)
    self.heroCell = nil
    self.formationBg = nil
    self.formationText = nil
    
    self.trailIcon = nil
    self.trailText = nil
    self.selectGo = nil
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
    if heroDisplayData.heroData.fromTemplate then
        --从template中创建的英雄数据
        self.heroCell:InitWithConfigId(heroDisplayData.heroData.heroId, nil, heroDisplayData.heroData.level, heroDisplayData.heroData:GetRank())
        self.heroCell.callBack = self.clickCallBack
        
        self.trailIcon:SetActive(true)
    else
        local heroUuid = heroDisplayData.heroData.uuid
        self.heroCell:SetData(heroUuid,self.clickCallBack,false,false)

        self.trailIcon:SetActive(false)
    end

    local belongFormation = heroDisplayData.squadIndex
    if showFormation then
        if belongFormation then
            self.formationBg:SetActive(true)
            self.formationText:SetText(belongFormation)
            --self.heroCell:SetMask(true)
        else
            self.formationBg:SetActive(false)
            --self.heroCell:SetMask(false)
        end
    else
        self.formationBg:SetActive(false)
        --self.heroCell:SetMask(false)
    end
    if heroDisplayData.canUse ~= nil then
        local canUse = heroDisplayData.canUse
        --self.heroCell:SetAllImageGrey(not canUse, canUse)
    else
        --self.heroCell:SetAllImageGrey(false, true)
    end
end

--- 改变英雄选中状态
local function SetSelected(self,selected)
    --self.heroCell:SetSelected(selected)
    self.selectGo:SetActive(selected)
end


UIFormationTrailHeroCell.OnCreate = OnCreate
UIFormationTrailHeroCell.OnDestroy = OnDestroy
UIFormationTrailHeroCell.OnEnable = OnEnable
UIFormationTrailHeroCell.OnDisable = OnDisable
UIFormationTrailHeroCell.ComponentDefine = ComponentDefine
UIFormationTrailHeroCell.ComponentDestroy = ComponentDestroy
UIFormationTrailHeroCell.DataDefine = DataDefine
UIFormationTrailHeroCell.DataDestroy = DataDestroy
UIFormationTrailHeroCell.SetData = SetData
UIFormationTrailHeroCell.SetSelected = SetSelected

return UIFormationTrailHeroCell