local UICumulativeRewardItem = BaseClass("UICumulativeRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local item_path = "item"

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.item = self:AddComponent(UICommonItem, item_path)
end

--控件的销毁
local function ComponentDestroy(self)

end

--变量的定义
local function DataDefine(self)
	self.param = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param,state)
	self.item:ReInit(param)
	self:SetCheckActive(state == 1, state == 1)
end

local function SetCheckActive(self,value)
	self.item:SetCheckActive(value,value)
end

UICumulativeRewardItem.OnCreate = OnCreate
UICumulativeRewardItem.OnDestroy = OnDestroy
UICumulativeRewardItem.OnBtnClick = OnBtnClick
UICumulativeRewardItem.OnEnable = OnEnable
UICumulativeRewardItem.OnDisable = OnDisable
UICumulativeRewardItem.ComponentDefine = ComponentDefine
UICumulativeRewardItem.ComponentDestroy = ComponentDestroy
UICumulativeRewardItem.DataDefine = DataDefine
UICumulativeRewardItem.DataDestroy = DataDestroy
UICumulativeRewardItem.ReInit = ReInit
UICumulativeRewardItem.SetCheckActive = SetCheckActive
return UICumulativeRewardItem