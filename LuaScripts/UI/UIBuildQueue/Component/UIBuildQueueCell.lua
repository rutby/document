--- Created by shimin.
--- DateTime: 2023/12/20 15:26
--- 建筑队列界面

local UIBuildQueueCell = BaseClass("UIBuildQueueCell", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "icon_bg/icon"
local name_text_path = "name_text"
local des_text_path = "des_text"
local free_text_path = "free_text"
local arrow_path = "arrow"
local cur_level_text_path = "arrow/cur_level_bg/cur_level_text"
local next_level_text_path = "arrow/next_level_bg/next_level_text"
local select_btn_path = "select_btn"
local select_btn_text_path = "select_btn/select_btn_text"
local slider_path = "slider"
local slider_text_path = "slider/slider_text"

local SliderLength = 280
local UIBuildQueueImageTypeScale =
{
	Free = Vector3.New(1,1,1),--正常大小
	Build = Vector3.New(0.7, 0.7, 1),--建筑缩放
}

function UIBuildQueueCell:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

function UIBuildQueueCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIBuildQueueCell:OnEnable()
	base.OnEnable(self)
end

function UIBuildQueueCell:OnDisable()
	base.OnDisable(self)
end

function UIBuildQueueCell:ComponentDefine()
	self.icon = self:AddComponent(UIImage, icon_path)
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.free_text = self:AddComponent(UITextMeshProUGUIEx, free_text_path)
	self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
	self.select_btn = self:AddComponent(UIButton, select_btn_path)
	self.select_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnSelectBtnClick()
	end)
	self.select_btn_text = self:AddComponent(UITextMeshProUGUIEx, select_btn_text_path)
	self.cur_level_text = self:AddComponent(UITextMeshProUGUIEx, cur_level_text_path)
	self.next_level_text = self:AddComponent(UITextMeshProUGUIEx, next_level_text_path)
	self.slider = self:AddComponent(UISlider, slider_path)
	self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
end

function UIBuildQueueCell:ComponentDestroy()
end

function UIBuildQueueCell:DataDefine()
	self.param = {}
	self.lastTime = 0
	self.lastCurTime = 0
	self.lastLeftTime = 0
	self.endTime = 0
	self.startTime = 0
end

function UIBuildQueueCell:DataDestroy()
	self.param = {}
	self.lastTime = 0
	self.lastCurTime = 0
	self.lastLeftTime = 0
	self.endTime = 0
	self.startTime = 0
end

function UIBuildQueueCell:OnAddListener()
	base.OnAddListener(self)
end

function UIBuildQueueCell:OnRemoveListener()
	base.OnRemoveListener(self)
end

function UIBuildQueueCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIBuildQueueCell:Refresh()
	if self.param.queueData ~= nil then
		if self.param.queueData.expireTime ~= 0 then
			self.des_text:SetActive(true)
		else
			self.des_text:SetActive(false)
		end
		
		if self.param.queueData.occupyUuid == 0 then
			self.free_text:SetActive(true)
			self.free_text:SetLocalText(GameDialogDefine.QUEUE_FREE)
			self.slider:SetActive(false)
			self.icon:LoadSprite(string.format(LoadPath.BuildIconOutCity, "UIBuild_icon_free_robot"))
			self.endTime = 0
			self.startTime = 0
			self.arrow:SetActive(false)
			if self.param.enterParam ~= nil then
				if self.param.enterParam.enterType == UIBuildQueueEnterType.Build then
					self.select_btn_text:SetLocalText(GameDialogDefine.BUILD)
				elseif self.param.enterParam.enterType == UIBuildQueueEnterType.Upgrade then
					self.select_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
				end
			end
			
			self.name_text:SetLocalText(GameDialogDefine.BUILD_QUEUE_WITH, self.param.queueData.index)
		else
			self.free_text:SetActive(false)
			self.slider:SetActive(true)
			local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.queueData.occupyUuid)
			if buildData ~= nil then
				self.endTime = buildData.updateTime
				local cur = UITimeManager:GetInstance():GetServerTime()
				self.startTime = buildData.startTime
				if self.startTime > cur then
					self.startTime = cur
				end
				self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(buildData.itemId, buildData.level), nil, function()
				
				end)
				self.name_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildData.itemId + buildData.level,"name"))
				self.arrow:SetActive(true)
				self.cur_level_text:SetText(buildData.level)
				self.next_level_text:SetText(buildData.level + 1)
				if LuaEntry.Player:IsInAlliance() and buildData.isHelped == 0 then
					self.select_btn_text:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
				else
					self.select_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
				end
			end
		end
	end
end

function UIBuildQueueCell:OnSelectBtnClick()
	if self.param.queueData.occupyUuid == 0 then
		if self.param.enterParam ~= nil then
			local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(self.param.enterParam.uuid, self.param.enterParam.buildId)
			if ret.enough then
				if self.param.enterParam.enterType == UIBuildQueueEnterType.Build then
					self.param.enterParam.messageParam.robotUuid = self.param.queueData.uuid
					SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, self.param.enterParam.messageParam)
					self.view.ctrl:CloseSelf()
				elseif self.param.enterParam.enterType == UIBuildQueueEnterType.Upgrade then
					self.param.enterParam.messageParam.robotUuid = self.param.queueData.uuid
					SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, self.param.enterParam.messageParam)
					self.view.ctrl:CloseSelf()
				end
			elseif ret.lackList[1] ~= nil then
				local lackTab = {}
				for k, v in ipairs(ret.lackList) do
					if v.cellType == CommonCostNeedType.Resource then
						local param = {}
						param.type = ResLackType.Res
						param.id = v.resourceType
						param.targetNum = v.count
						table.insert(lackTab,param)
					elseif v.cellType == CommonCostNeedType.Goods then
						local param = {}
						param.type = ResLackType.Item
						param.id = v.itemId
						param.targetNum = v.count
						table.insert(lackTab,param)
					end
				end
				GoToResLack.GoToItemResLackList(lackTab)
				UIUtil.ShowTipsId(120020)
			end
		end
	else
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.queueData.occupyUuid)
		if buildData ~= nil then
			if LuaEntry.Player:IsInAlliance() and buildData.isHelped == 0 then
				SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.param.queueData.occupyUuid, AllianceHelpType.Building, NewQueueType.Default, "")
			else
				UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true}, ItemSpdMenu.ItemSpdMenu_City, buildData.uuid)
			end
		end
	end
end

function UIBuildQueueCell:Update()
	if self.param.queueData ~= nil then
		local curTime = UITimeManager:GetInstance():GetServerTime()
		if self.param.queueData.expireTime ~= 0 then
			local changeTime = self.param.queueData.expireTime - curTime
			if changeTime > 0 then
				local tempTimeSec = math.ceil(changeTime / 1000)
				if tempTimeSec ~= self.lastLeftTime then
					self.lastLeftTime = tempTimeSec
					local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
					self.des_text:SetLocalText(GameDialogDefine.LEFT_USE_TIME_WITH, tempTimeValue)
				end
			else
				self.view.ctrl:CloseSelf()
			end
		end
		if self.endTime > 0 then
			local changeTime = self.endTime - curTime
			local maxTime = self.endTime - self.startTime
			if changeTime < maxTime and changeTime > 0 then
				local tempTimeSec = math.ceil(changeTime / 1000)
				if tempTimeSec ~= self.lastTime then
					self.lastTime = tempTimeSec
					local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
					self.slider_text:SetText(tempTimeValue)
				end

				if maxTime > 0 then
					local tempValue = 1 - changeTime / maxTime
					if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.endTime - self.lastCurTime,maxTime,SliderLength) then
						self.lastCurTime = curTime
						self.slider:SetValue(tempValue)
					end
				end
			else
				self.lastTime = 0
				self.slider:SetValue(1)
				self.slider_text:SetText("")
			end
		end
	end
end

return UIBuildQueueCell