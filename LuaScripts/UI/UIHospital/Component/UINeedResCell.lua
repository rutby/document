local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer

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
	self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
	self.btn = self:AddComponent(UIButton, this_path)

	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)	
		self:OnBtnClick()
	end)
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
local function ReInit(self,param)
	self.param = param
	self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.resourceType))
	if self.param.isRed then
		self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.format(TextColorStr, TextColorRed,
				string.GetFormattedStr(self.param.own)), string.GetFormattedStr(self.param.count))
	else
		self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.GetFormattedStr(self.param.own),
				string.GetFormattedStr(self.param.count))
	end
end

local function OnBtnClick(self)
	if self.param.isRed then
		local lackTab = {}
		local param = {}
		param.type = ResLackType.Res
		param.id = self.param.resourceType
		param.targetNum = self.param.count
		table.insert(lackTab,param)
		GoToResLack.GoToItemResLackList(lackTab)
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

return UINeedResCell