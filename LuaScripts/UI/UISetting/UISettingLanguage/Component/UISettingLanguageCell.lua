local UISettingLanguageCell = BaseClass("UISettingLanguageCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local Param = DataClass("Param", ParamData)
local ParamData =  {
	index,
	name,
	isSelect,
	callBack,
	languageIndex,
}

local this_path = ""
local select_go_path = "Common_duihao"
--local select_go_path = "SelectGo"
--local unselect_go_path = "UnSelectGo"
local des_path = "Name"

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
	self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
	self.des = self:AddComponent(UITextMeshProUGUIEx, des_path)
	--self.unselect_go = self:AddComponent(UIBaseContainer, unselect_go_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.select_go = nil
	self.des = nil
	--self.unselect_go = nil
	self.btn = nil
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
	if param.name ~= nil then
		self.des:SetText(param.name)
	end
	self:SetSelect(param.isSelect)
end


local function OnBtnClick(self)
--	if self.param.callBack ~= nil then
--		self.param.callBack(self.param.index)
	if self.param.languageIndex ~= nil then
		UIUtil.ShowMessage(Localization:GetString("280075", Localization:GetString(SuportedLanguagesLocalName[self.param.languageIndex])), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			Localization:SetLanguage(self.param.languageIndex)
		--	UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain)
			CS.ApplicationLaunch.Instance:ReStartGame()
		end)
	end
--	end
end

local function SetSelect(self,value)
	if value then
		self.select_go:SetActive(true)
	--	self.unselect_go:SetActive(false)
	--	self.des:SetColor(SelectTextColor)
	else
		self.select_go:SetActive(false)
	--	self.unselect_go:SetActive(true)
	--	self.des:SetColor(WhiteColor)
	end
end

UISettingLanguageCell.OnCreate = OnCreate
UISettingLanguageCell.OnDestroy = OnDestroy
UISettingLanguageCell.Param = Param
UISettingLanguageCell.OnEnable = OnEnable
UISettingLanguageCell.OnDisable = OnDisable
UISettingLanguageCell.ComponentDefine = ComponentDefine
UISettingLanguageCell.ComponentDestroy = ComponentDestroy
UISettingLanguageCell.DataDefine = DataDefine
UISettingLanguageCell.DataDestroy = DataDestroy
UISettingLanguageCell.ReInit = ReInit
UISettingLanguageCell.OnBtnClick = OnBtnClick
UISettingLanguageCell.SetSelect = SetSelect

return UISettingLanguageCell