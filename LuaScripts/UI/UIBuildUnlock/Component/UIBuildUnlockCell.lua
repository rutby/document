local UIBuildUnlockCell = BaseClass("UIBuildUnlockCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local Param = DataClass("Param", ParamData)
local ParamData =  {
	unlockInfo,
	callBack,
	index,
}

local this_path = ""
local icon_path = "Icon"
local num_text_path = "NumText"
local tag_go_path = "TagGo"
local tag_text_path = "TagGo/TagText"

local IconScaleType = {}
IconScaleType[BuildLevelUpUnlockType.Build] = Vector3.New(0.25, 0.25, 0.25)

local IconPosition = Vector3.New(0,0,0)

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
	self.tag_go = self:AddComponent(UIBaseContainer, tag_go_path)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.num_text = self:AddComponent(UIText, num_text_path)
	self.tag_text = self:AddComponent(UIText, tag_text_path)
	self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
	self.event_trigger:OnBeginDrag(function(eventData)
		self:OnBeginDrag(eventData)
	end)
	self.event_trigger:OnPointerDown(function(eventData)
		self:OnPointerDown(eventData)
	end)
	self.event_trigger:OnPointerUp(function(eventData)
		self:OnBeginDrag(eventData)
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.tag_go = nil
	self.icon = nil
	self.num_text = nil
	self.tag_text = nil
	self.event_trigger = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.isShow = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.isShow = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	if param ~= nil then
		if param.unlockInfo.unlockType == BuildLevelUpUnlockType.Build then
			self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(param.unlockInfo.id,1), nil, function()
				self.icon:SetNativeSize()
			end)
			self.icon.transform.localPosition = IconPosition
			self.icon.transform.localScale = IconScaleType[param.unlockInfo.unlockType]
		end

		if param.unlockInfo.showType == BuildLevelUpShowType.AddNum then
			self.num_text:SetActive(true)
			self.tag_go:SetActive(false)
			self.num_text:SetText("+"..param.unlockInfo.addNum)
		elseif param.unlockInfo.showType == BuildLevelUpShowType.New then
			self.num_text:SetActive(false)
			self.tag_go:SetActive(true)
			self.tag_text:SetLocalText(GameDialogDefine.NEW) 
		elseif param.unlockInfo.showType == BuildLevelUpShowType.Unlock then
			self.num_text:SetActive(false)
			self.tag_go:SetActive(true)
			self.tag_text:SetLocalText(GameDialogDefine.UNLOCK) 
		end
	end
end

local function OnPointerDown(self,eventData)
	self.isShow = true
	if self.param.callBack ~= nil then
		self.param.callBack(true,self.param.index,self:GetSelectPosition())
	end
end

local function OnBeginDrag(self,eventData)
	if self.isShow then
		self.isShow = false
		if self.param.callBack ~= nil then
			self.param.callBack(false,self.param.index,nil)
		end
	end
end

local function GetSelectPosition(self) 
	return self.transform.position
end

UIBuildUnlockCell.OnCreate = OnCreate
UIBuildUnlockCell.OnDestroy = OnDestroy
UIBuildUnlockCell.Param = Param
UIBuildUnlockCell.OnEnable = OnEnable
UIBuildUnlockCell.OnDisable = OnDisable
UIBuildUnlockCell.ComponentDefine = ComponentDefine
UIBuildUnlockCell.ComponentDestroy = ComponentDestroy
UIBuildUnlockCell.DataDefine = DataDefine
UIBuildUnlockCell.DataDestroy = DataDestroy
UIBuildUnlockCell.ReInit = ReInit
UIBuildUnlockCell.OnBeginDrag = OnBeginDrag
UIBuildUnlockCell.OnPointerDown = OnPointerDown
UIBuildUnlockCell.GetSelectPosition = GetSelectPosition

return UIBuildUnlockCell