---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/20/21 4:10 PM
---


local UICampCell = BaseClass("UICampCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.imgIcon      = self:AddComponent(UIText,  'ImgIcon')
    self.textName     = self:AddComponent(UIText,  'ImgNameBg/TextName')
    self.textTime     = self:AddComponent(UIText,  'ImgNameBg/TextTime')
    self.imgCamp      = self:AddComponent(UIImage, 'ImgCampIcon')
    self.imgMask      = self:AddComponent(UIImage, 'ImgMask')
    self.imgSelect    = self:AddComponent(UIImage, 'ImgSelect')
    self.textNextOpen = self:AddComponent(UIText,  'TextNextOpen')
    
    local btn = self:AddComponent(UIButton, '')
    btn:SetOnClick(BindCallback(self, self.OnClick))

    self.textNextOpen:SetLocalText(110125) 
end

local function ComponentDestroy(self)
    self.imgIcon      = nil
    self.textName     = nil
    self.textTime     = nil
    self.imgCamp      = nil
    self.imgMask      = nil
    self.imgSelect    = nil
    self.textNextOpen = nil
end

local function DataDefine(self)
    self.campId = nil
end

local function DataDestroy(self)
    self.campId = nil
end

local function SetData(self, campId, curCampId, nextCampId)
    self.campId = campId
    local isCurrent = campId == curCampId
    local isNext = campId == nextCampId
    
    local campName, _ = HeroUtils.GetCampNameAndDesc(campId)
    self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(campId))
    self.textName:SetText(campName)
    self.textTime:SetActive(isCurrent)
    self.textNextOpen:SetActive(isNext)
    self.textNextOpen.transform:Set_localPosition(117, isCurrent and -42.5 or 23, 0) 
    self.imgMask:SetActive(not isCurrent)
    self.imgSelect:SetActive(isCurrent)
end

local function ToggleSelect(self, campId)
    self.imgSelect:SetActive(self.campId == tonumber(campId))
end

local function UpdateTimeText(self, text) 
    self.textTime:SetText(text)
end

local function OnClick(self)
    self.view:OnCellClick(self.campId)
end



UICampCell.OnCreate = OnCreate
UICampCell.OnDestroy = OnDestroy
UICampCell.OnEnable = OnEnable
UICampCell.OnDisable = OnDisable
UICampCell.ComponentDefine = ComponentDefine
UICampCell.ComponentDestroy = ComponentDestroy
UICampCell.DataDefine = DataDefine
UICampCell.DataDestroy = DataDestroy
UICampCell.SetData = SetData
UICampCell.UpdateTimeText = UpdateTimeText

UICampCell.ToggleSelect = ToggleSelect
UICampCell.OnClick = OnClick


return UICampCell