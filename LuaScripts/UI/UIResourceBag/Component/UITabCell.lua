local UITabCell = BaseClass("UITabCell", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	resourceType,
	callBack,
	isSelect,
}

local icon_path = "Icon"
local this_path = ""
local selectName_path = "selectName"
local unselectName_path = "unselectName"




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
	self.icon = self:AddComponent(UIImage, icon_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.selectName = self:AddComponent(UIText, selectName_path)
	self.unselectName = self:AddComponent(UIText, unselectName_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.icon = nil
	self.btn = nil
	self.tab_icon = nil
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
local function ReInit(self,param)
	self.param = param
	self:SetSelect(param.isSelect)
	self.selectName:SetLocalText(ResourceTabName[self.param.resourceType])
	self.unselectName:SetLocalText(ResourceTabName[self.param.resourceType])
end


local function OnBtnClick(self)
	if self.param.callBack ~= nil then
		self.param.callBack(self.param.resourceType)
	end
end

local function SetSelect(self,value)
	if value then
		self.btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_up"))
		self.icon:LoadSprite(ResourceTabSelectImage[self.param.resourceType])
		self.selectName:SetActive(true)
		self.unselectName:SetActive(false)
	else
		self.btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_down"))
		self.icon:LoadSprite(ResourceTabUnSelectImage[self.param.resourceType])
		self.selectName:SetActive(false)
		self.unselectName:SetActive(true)
	end
end

UITabCell.OnCreate = OnCreate
UITabCell.OnDestroy = OnDestroy
UITabCell.Param = Param
UITabCell.OnEnable = OnEnable
UITabCell.OnDisable = OnDisable
UITabCell.ComponentDefine = ComponentDefine
UITabCell.ComponentDestroy = ComponentDestroy
UITabCell.DataDefine = DataDefine
UITabCell.DataDestroy = DataDestroy
UITabCell.ReInit = ReInit
UITabCell.OnBtnClick = OnBtnClick
UITabCell.SetSelect = SetSelect

return UITabCell