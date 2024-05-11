local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	resourceType,
	count,
	isRed,
}

local item_icon_path = "Common_icon_cp"
local num_text_path = "Common_icon_cp/content_num_new"
local this_path = ""


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
	self.item_icon = self:AddComponent(UIImage, item_icon_path)
	self.num_text = self:AddComponent(UIText, num_text_path)
	self.btn = self:AddComponent(UIButton, this_path)

	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)	
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.item_icon = nil
	self.num_text = nil
	self.btn = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.isRed = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.isRed = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.resourceType))
	self.num_text:SetText(string.GetFormattedSeperatorNum(param.count))
	self.isRed = nil
	self:RefreshColor(param.isRed)
end

local function RefreshColor(self,isRed)
	if self.isRed ~= isRed then
		self.isRed = isRed
		if isRed then
			self.num_text:SetColor(RedColor)
		else
			self.num_text:SetColor(WhiteColor)
		end
	end
end

local function OnBtnClick(self)
	if self.isRed then
		local lackTab = {}
		local param = {}
		param.type = ResLackType.Res
		param.id = self.param.resourceType
		param.targetNum = self.param.count
		table.insert(lackTab,param)
		GoToResLack.GoToItemResLackList(lackTab)
	else
		if self.param.resourceType ~= nil then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag,{anim = true},self.param.resourceType)
		end
	end
end

UINeedResCell.OnCreate = OnCreate
UINeedResCell.OnDestroy = OnDestroy
UINeedResCell.Param = Param
UINeedResCell.OnBtnClick = OnBtnClick
UINeedResCell.OnEnable = OnEnable
UINeedResCell.OnDisable = OnDisable
UINeedResCell.ComponentDefine = ComponentDefine
UINeedResCell.ComponentDestroy = ComponentDestroy
UINeedResCell.DataDefine = DataDefine
UINeedResCell.DataDestroy = DataDestroy
UINeedResCell.ReInit = ReInit
UINeedResCell.RefreshColor = RefreshColor

return UINeedResCell