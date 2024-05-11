local UISettingBlockCell = BaseClass("UISettingBlockCell", UIBaseContainer)
local base = UIBaseContainer

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
	self._server_txt= self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/Txt_Server")
	self._name_txt = self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/Txt_Name")
	self.headIconN = self:AddComponent(UIPlayerHead, "Rect_Normal/UIPlayerHead/HeadIcon")
	self.headFgN = self:AddComponent(UIImage, "Rect_Normal/UIPlayerHead/Foreground")
	self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/challengeBtn/BtnTxt")
	self.btn = self:AddComponent(UIButton, "Rect_Normal/challengeBtn")
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self.btn_txt:SetLocalText(141027)
end

--控件的销毁
local function ComponentDestroy(self)
	self.btn = nil
	self._server_txt = nil
	self._name_txt = nil
	self.headIconN = nil
	self.headFgN = nil
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
	if param ~= nil then
		if param.abbr~=nil and param.abbr~="" then
			self._name_txt:SetText("["..param.abbr.."]"..param.name)
		else
			self._name_txt:SetText(param.name)
		end
		self._server_txt:SetLocalText(208236,param.server)
		self.headIconN:SetData(param.uid,param.pic,param.picVer)
	end
end


local function OnBtnClick(self)
	if self.param~=nil then
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_UNBLOCK_COMMAND, self.param.uuid)
	end
end

UISettingBlockCell.OnCreate = OnCreate
UISettingBlockCell.OnDestroy = OnDestroy
UISettingBlockCell.Param = Param
UISettingBlockCell.OnEnable = OnEnable
UISettingBlockCell.OnDisable = OnDisable
UISettingBlockCell.ComponentDefine = ComponentDefine
UISettingBlockCell.ComponentDestroy = ComponentDestroy
UISettingBlockCell.DataDefine = DataDefine
UISettingBlockCell.DataDestroy = DataDestroy
UISettingBlockCell.ReInit = ReInit
UISettingBlockCell.OnBtnClick = OnBtnClick
UISettingBlockCell.SetSelect = SetSelect

return UISettingBlockCell