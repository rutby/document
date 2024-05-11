-- AllianceCitySelectItem.lua

local AllianceCitySelectItem = BaseClass("AllianceCitySelectItem", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "Bg/icon"
local level_path = "Bg/icon/level"
local name_path = "Bg/name"
local pos_path = "Bg/pos"
local selectBtn_path = "Bg/selectBtn"
local selectBtnTxt_path = "Bg/selectBtn/selectTxt"

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
	self.iconN = self:AddComponent(UIImage, icon_path)
	self.levelN = self:AddComponent(UIText, level_path)
	self.nameN = self:AddComponent(UIText, name_path)
	self.posN = self:AddComponent(UIText, pos_path)
	self.selectBtnN = self:AddComponent(UIButton, selectBtn_path)
	self.selectBtnN:SetOnClick(function()
		self:OnClickSelectBtn()
	end)
	self.selectBtnTxtN = self:AddComponent(UIText, selectBtnTxt_path)
	self.selectBtnTxtN:SetLocalText(110108)
end

--控件的销毁
local function ComponentDestroy(self)
	self.iconN = nil
	self.levelN = nil
	self.nameN = nil
	self.posN = nil
	self.selectBtnN = nil
	self.selectBtnTxtN = nil
end

--变量的定义
local function DataDefine(self)
	self.cityId = nil
	self.cityTemplate = nil
end

--变量的销毁
local function DataDestroy(self)
	self.cityId = nil
	self.cityTemplate = nil
end

local function SetItem(self, cityId)
	self.cityId = cityId
	self.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId)
	self:RefreshAll()
end

local function RefreshAll(self)
	self.levelN:SetText("Lv."..self.cityTemplate.level)
	self.nameN:SetLocalText(self.cityTemplate.name)
	self.posN:SetText(" ( " .. self.cityTemplate.pos.x .. "," .. self.cityTemplate.pos.y .. " ) ") 
end

local function OnClickSelectBtn(self)
	self.view:OnSelectRuin(self.cityId)
end

AllianceCitySelectItem.OnCreate = OnCreate
AllianceCitySelectItem.OnDestroy = OnDestroy
AllianceCitySelectItem.Param = Param
AllianceCitySelectItem.OnBtnClick = OnBtnClick
AllianceCitySelectItem.OnEnable = OnEnable
AllianceCitySelectItem.OnDisable = OnDisable
AllianceCitySelectItem.ComponentDefine = ComponentDefine
AllianceCitySelectItem.ComponentDestroy = ComponentDestroy
AllianceCitySelectItem.DataDefine = DataDefine
AllianceCitySelectItem.DataDestroy = DataDestroy


AllianceCitySelectItem.SetItem = SetItem
AllianceCitySelectItem.RefreshAll = RefreshAll
AllianceCitySelectItem.OnClickSelectBtn = OnClickSelectBtn

return AllianceCitySelectItem