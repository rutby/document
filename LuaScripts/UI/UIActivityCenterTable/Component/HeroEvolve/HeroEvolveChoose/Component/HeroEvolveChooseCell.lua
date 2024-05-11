---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/25 14:47
---

local HeroEvolveChooseCell = BaseClass("HeroEvolveChooseCell", UIBaseContainer)
local base = UIBaseContainer

local bg_path = ""
local select_path = "select"
local has_hero_path = "hasHero"
local has_hero_text_path = "hasHero/hasHeroText"
local btn_path = "btn"
local camp_icon_path = "campIcon"
local level_path = "campIcon/levelTxt"
local heroName_txt_path = "Txt_HeroName"
local heroNick_txt_path = "Txt_HeroNick"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.select = self:AddComponent(UIImage, select_path)
    
    self.has_hero = self:AddComponent(UIBaseContainer, has_hero_path)
    self.has_hero_text = self:AddComponent(UIText, has_hero_text_path)
    self.has_hero_text:SetLocalText(361097)
    
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnSelectClick()
    end)
    
    self.camp_icon = self:AddComponent(UIImage, camp_icon_path)
    self.level_text = self:AddComponent(UIText, level_path)
    self._heroName_txt = self:AddComponent(UIText,heroName_txt_path)
    self._heroNick_txt = self:AddComponent(UIText,heroNick_txt_path)
end

--控件的销毁
local function ComponentDestroy(self)
    
end

--变量的定义
local function DataDefine(self)

end

--变量的销毁
local function DataDestroy(self)

end

local function OnSelectClick(self)
    EventManager:GetInstance():Broadcast(EventId.HeroEvolveCellSelect, self.data.heroId)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroEvolveCellSelect, self.OnSelectEvent)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroEvolveCellSelect, self.OnSelectEvent)
    base.OnRemoveListener(self)
end

local function OnSelectEvent(self, para)
    self.curSelect = para
    self:RefreshState()
end

local function SetData(self, data, curSelect)
    self.data = data
    self.curSelect = curSelect
    self:RefreshView()
end

local function RefreshView(self)
    self.bg:LoadSprite(self.data.icon_path)
    self.camp_icon:LoadSprite(self.data.camp_icon)
    self.level_text:SetText("Lv." .. tostring(self.data.level))
    self._heroName_txt:SetLocalText(self.data.name)
    self._heroNick_txt:SetLocalText(self.data.nick)
    self:RefreshState()
end

local function RefreshState(self)
    self.has_hero:SetActive(self.data.hasHero)
    self.select:SetActive(self.curSelect == self.data.heroId)
    if self.curSelect == self.data.heroId then
        self.bg:SetLocalScaleXYZ(1.1,1.1,1)
    else
        self.bg:SetLocalScaleXYZ(1,1,1)
    end
end

HeroEvolveChooseCell.OnCreate = OnCreate
HeroEvolveChooseCell.OnDestroy = OnDestroy
HeroEvolveChooseCell.ComponentDefine = ComponentDefine
HeroEvolveChooseCell.ComponentDestroy = ComponentDestroy
HeroEvolveChooseCell.DataDefine = DataDefine
HeroEvolveChooseCell.DataDestroy = DataDestroy
HeroEvolveChooseCell.OnSelectClick = OnSelectClick
HeroEvolveChooseCell.SetData = SetData
HeroEvolveChooseCell.OnAddListener = OnAddListener
HeroEvolveChooseCell.OnRemoveListener = OnRemoveListener
HeroEvolveChooseCell.OnSelectEvent = OnSelectEvent
HeroEvolveChooseCell.RefreshView = RefreshView
HeroEvolveChooseCell.RefreshState = RefreshState

return HeroEvolveChooseCell