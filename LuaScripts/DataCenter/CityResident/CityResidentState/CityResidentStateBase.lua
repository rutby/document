---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/15 11:40
---

local CityResidentStateBase = BaseClass("CityResidentStateBase")

local function __init(self, data)
    self.data = data
end

local function OnUpdate(self, deltaTime)
    
end

local function OnEnter(self)
    
end

local function OnExit(self)
    
end

local function OnFinish(self)
    
end

-- 显示生产进度条
local function ShowFurnitureProductSlider(self, fUuid, icon, duration)
    local hudParam = {}
    hudParam.uuid = self.data.uuid
    hudParam.type = CityHudType.ProductSlider
    hudParam.pos = self.data:GetPos()
    hudParam.icon = icon
    hudParam.offset = Vector3.New(0, 80, 0)
    hudParam.duration = duration
    hudParam.location = CityHudLocation.World
    hudParam.fUuid = fUuid
    DataCenter.CityHudManager:Create(hudParam)
end

-- 显示属性进度条
local function ShowFurnitureResidentSlider(self, fUuid, para1, offset)
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureInfo.fId, furnitureInfo.lv)
    local hudParam = {}
    hudParam.uuid = self.data.uuid
    hudParam.type = CityHudType.ResidentSlider
    hudParam.pos = self.data:GetPos()
    hudParam.para1 = para1 or tonumber(buildLevelTemplate.para1)
    hudParam.offset = offset
    hudParam.location = CityHudLocation.World
    hudParam.updateEveryFrame = true
    DataCenter.CityHudManager:Create(hudParam)
end

-- 显示生产产物
local function ShowFurnitureProductGain(self, icon, count)
    local hudParam = {}
    hudParam.type = CityHudType.PopText
    hudParam.pos = self.data:GetPos()
    hudParam.icon = icon
    hudParam.text = "+" .. Mathf.Round(count)
    hudParam.offset = Vector3.New(50, 10, 0)
    hudParam.duration = 1
    hudParam.location = CityHudLocation.World
    DataCenter.CityHudManager:Create(hudParam)
end

-- 抱怨没食物
local function TalkNoFood(self)
    local param = {}
    param.type = CityResidentDefines.TalkTriggerType.NoFood
    param.rUuid = self.data.uuid
    DataCenter.CityResidentManager:TryResidentTalk(param)
end

CityResidentStateBase.__init = __init

CityResidentStateBase.OnUpdate = OnUpdate
CityResidentStateBase.OnEnter = OnEnter
CityResidentStateBase.OnExit = OnExit
CityResidentStateBase.OnFinish = OnFinish

CityResidentStateBase.ShowFurnitureProductSlider = ShowFurnitureProductSlider
CityResidentStateBase.ShowFurnitureResidentSlider = ShowFurnitureResidentSlider
CityResidentStateBase.ShowFurnitureProductGain = ShowFurnitureProductGain
CityResidentStateBase.TalkNoFood = TalkNoFood

return CityResidentStateBase