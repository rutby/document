local UIBox = BaseClass("UIBox", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local des_text_path = "ActiveNum"
local icon_path = "icon"
local ReceImg_path = "ReceImg"
local effectGo_path = "icon/eff"

local Param = DataClass("Param", ParamData)
local ParamData =  {
	callBack,
	index,
	state,
	count,
}

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
	self:RefreshState()
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end

--控件的定义
local function ComponentDefine(self)
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
	self.icon = self:AddComponent(UIAnimator,icon_path)
	self.receimg = self:AddComponent(UIImage, ReceImg_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()  
CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
	
	self.eff = self:AddComponent(UIBaseContainer, effectGo_path)
	
end

--控件的销毁
local function ComponentDestroy(self)
	self.des_text = nil
	self.icon = nil
	self.gray = nil
	self.btn = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.isSend = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	if param.count ~= nil then
		self.des_text:SetText(param.count)
	end
	self:RefreshState()
	self.isSend = false
end

--刷新箱子状态
local function RefreshState(self, curState)
	if self.param == nil and curState == nil then
		return
	end
	local state
	if curState ~= nil then
		state = curState
	else
		state = self.param.state
	end
	self.param.state = state
	if state == TaskState.NoComplete then
		self.icon:SetActive(true)
		self.receimg:SetActive(false)
		self.eff:SetActive(false)
		self.icon:Play("NoComplete",0,0)
	elseif state == TaskState.CanReceive then
		self.icon:SetActive(true)
		self.receimg:SetActive(false)
		self.eff:SetActive(true)
		self.icon:Play("CanReceive",0,0)
	elseif state == TaskState.Received then
		self.icon:SetActive(false)
		self.receimg:SetActive(true)
		self.eff:SetActive(false)
		self.icon:Enable(false)
	end
end

local function OnBtnClick(self)
	if self.param.state == TaskState.CanReceive then
		if self.isSend then
			return
		end
		local unlock = LuaEntry.DataConfig:TryGetNum("center_building_unlock", "k3")
		if unlock and unlock <= DataCenter.BuildManager.MainLv then
			--检查其他档位奖励
			local curActiveValue = DataCenter.DailyTaskManager:GetCurValue()
			local tab = {}
			for i = 1 ,5 do
				local state = DataCenter.DailyTaskManager:GetBoxState(i,curActiveValue)
				if state == TaskState.CanReceive then
					local count = DataCenter.DailyTaskManager:GetDailyCurValue(i)
					local param = {}
					param.index = i
					param.count = count
					table.insert(tab,param)
				end
			end
			local sendTab = {}
			for i = 1 ,table.count(tab) do
				table.insert(sendTab,tab[i].index)
			end

			if next(sendTab) then
				self.isSend = true
				for i = 1 ,table.count(sendTab) do
					DataCenter.DailyTaskManager:SetCurReward(sendTab[i])
				end
				SFSNetwork.SendMessage(MsgDefines.DailyQuestRewardMulti,sendTab)
			end
		else
			self.isSend = true
			DataCenter.DailyTaskManager:SetCurReward(self.param.index)
			SFSNetwork.SendMessage(MsgDefines.DailyQuestReward,self.param.index)
		end
	else
		if self.param.callBack ~= nil then
			self.param.callBack(self.param.index,self.transform.position,self.btn.rectTransform.rect.width)
		end
	end
end

UIBox.OnCreate = OnCreate
UIBox.OnDestroy = OnDestroy
UIBox.Param = Param
UIBox.OnEnable = OnEnable
UIBox.OnDisable = OnDisable
UIBox.ComponentDefine = ComponentDefine
UIBox.ComponentDestroy = ComponentDestroy
UIBox.DataDefine = DataDefine
UIBox.DataDestroy = DataDestroy
UIBox.ReInit = ReInit
UIBox.RefreshState = RefreshState
UIBox.OnBtnClick = OnBtnClick

return UIBox