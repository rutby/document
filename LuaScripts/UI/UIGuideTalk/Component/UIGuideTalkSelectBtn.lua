local UIGuideTalkSelectBtn = BaseClass("UIGuideTalkSelectBtn", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	des,
	nextId,
}

local this_path = ""
local btn_name_path = "BtnNameText"


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
	self.btn = self:AddComponent(UIButton, this_path)
	self.desText = self:AddComponent(UIText, btn_name_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)	
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.btn = nil
	self.desText = nil
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
	self.desText:SetText(param.des)
end

local function OnBtnClick(self)
	DataCenter.GuideManager:SetCurGuideId(self.param.nextId)
	DataCenter.GuideManager:DoGuide()
end


UIGuideTalkSelectBtn.OnCreate = OnCreate
UIGuideTalkSelectBtn.OnDestroy = OnDestroy
UIGuideTalkSelectBtn.Param = Param
UIGuideTalkSelectBtn.OnBtnClick = OnBtnClick
UIGuideTalkSelectBtn.OnEnable = OnEnable
UIGuideTalkSelectBtn.OnDisable = OnDisable
UIGuideTalkSelectBtn.ComponentDefine = ComponentDefine
UIGuideTalkSelectBtn.ComponentDestroy = ComponentDestroy
UIGuideTalkSelectBtn.DataDefine = DataDefine
UIGuideTalkSelectBtn.DataDestroy = DataDestroy
UIGuideTalkSelectBtn.ReInit = ReInit

return UIGuideTalkSelectBtn