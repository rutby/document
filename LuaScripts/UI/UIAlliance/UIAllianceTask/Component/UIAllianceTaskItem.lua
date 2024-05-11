local UIAllianceTaskItem = BaseClass("UIAllianceTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIGray = CS.UIGray

local taskName_path = "Txt_Title"
local bg_path = "bg"
local taskDesc_path = "Txt_Complete"
local shareBtn_path = "shareBtn"
local claimRank_path = "Rect_Reward/Txt_QuestCondition"
local rewardsContainer_path = "ScrollView/Viewport/Content"
local rewards_path = "ScrollView/Viewport/Content/UIRewardCell"
local prog_path = "ProgressSlider"
local progTxt_path = "ProgressSlider/Txt_Progress"
local progEndTime_path = "ProgressSlider/Txt_Time"
local startTime_path = "startTime"
local finishTime_path = "finishTip"
local endTip_path = "endTip"
local arrowL_path = "Rect_Reward/arrowL"
local arrowR_path = "Rect_Reward/arrowR"
local rewardBg_path = "Rect_Reward/RewardBg2"
local claimBtn_path = "Btn_AcceptReward"
local completeMark_path = "completeMark"
local jumpBtn_path = "jumpBtn"
local taskStatus_path = "Rect_Reward/Txt_QuestState"
local unlockModule_path = "ScrollView/Viewport/Content/UIRewardCell4"
local unlockModuleIcon_path = "ScrollView/Viewport/Content/UIRewardCell4/UICommonItem/clickBtn/ItemIcon"
local unlockModuleBtn_path = "ScrollView/Viewport/Content/UIRewardCell4/UICommonItem/clickBtn"
local claimEff_path = "Rect_Reward/claimEff"
local questBg_path = "bgIcon"

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

--控件的定义
local function ComponentDefine(self)
	self.taskNameN = self:AddComponent(UIText, taskName_path)
	self.bgN = self:AddComponent(UIImage, bg_path)
	self.taskDescN = self:AddComponent(UIText, taskDesc_path)
	self.claimRankN = self:AddComponent(UIText, claimRank_path)
	self.shareBtnN = self:AddComponent(UIButton, shareBtn_path)
	self.shareBtnN:SetOnClick(function()
		self:OnClickShareBtn()
	end)
	self.taskProgN = self:AddComponent(UISlider, prog_path)
	self.progTxtN = self:AddComponent(UIText, progTxt_path)
	self.progEndTimeN = self:AddComponent(UIText, progEndTime_path)
	self.startTimeN = self:AddComponent(UIText, startTime_path)
	self.finishedTipN = self:AddComponent(UIText, finishTime_path)
	self.endTipN = self:AddComponent(UIText, endTip_path)
	self.arrowLN = self:AddComponent(UIButton, arrowL_path)
	self.arrowLN:SetOnClick(function()
		self:OnClickArrowL()
	end)
	self.arrowRN = self:AddComponent(UIButton, arrowR_path)
	self.arrowRN:SetOnClick(function()
		self:OnClickArrowR()
	end)
	self.rewardBgN = self:AddComponent(UIImage, rewardBg_path)
	self.rewardsContainerN = self:AddComponent(UIBaseContainer, rewardsContainer_path)
	self.rewardItemsTb = {}
	for i = 1, 3 do
		local newOne = {}
		local tempItem = self:AddComponent(UIBaseContainer, rewards_path .. i)
		newOne.rootN = tempItem
		newOne.itemN = tempItem:AddComponent(UICommonItem, "UICommonItem")
		newOne.effN = tempItem:AddComponent(UIBaseContainer, "Rect_RewardEffect")
		table.insert(self.rewardItemsTb, newOne)
	end
	self.claimEffN = self:AddComponent(UIBaseContainer, claimEff_path)
	self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
	self.claimBtnN:SetOnClick(function()
		self:OnClickClaimBtn()
	end)
	self.completeMarkN = self:AddComponent(UIBaseContainer, completeMark_path)
	self.completeMarkN:SetActive(false)
	self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
	self.jumpBtnN:SetOnClick(function()
		self:OnClickJumpBtn()
	end)
	self.taskStautsN = self:AddComponent(UIText, taskStatus_path)
	self.timerTxtN = nil
	self.unlockModuleN = self:AddComponent(UIBaseContainer, unlockModule_path)
	self.unlockModuleIconN = self:AddComponent(UIImage, unlockModuleIcon_path)
	self.unlockModuleBtnN = self:AddComponent(UIButton, unlockModuleBtn_path)
	self.unlockModuleBtnN:SetOnClick(function()
		self:OnClickUnlockModule()
	end)
	self.questBgN = self:AddComponent(UIImage, questBg_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.taskNameN = nil
	self.taskDescN = nil
	self.claimRankN = nil
	self.shareBtnN = nil
	self.taskProgN = nil
	self.progTxtN = nil
	self.progEndTimeN = nil
	self.startTimeN = nil
	self.finishedTipN = nil
	self.endTipN = nil
	self.arrowLN = nil
	self.arrowRN = nil
	self.rewardItemsTb = nil
	self.claimBtnN = nil
	self.jumpBtnN = nil
	self.timerTxtN = nil
	self.questBgN = nil
end

--变量的定义
local function DataDefine(self)
	self.taskInfo = nil
	self.taskConf = nil
	self.curRewardRank = 1
	if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
		self.curRewardRank = 1
	elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
		self.curRewardRank = 2
	else
		self.curRewardRank = 3
	end
end

--变量的销毁
local function DataDestroy(self)
	self.taskInfo = nil
	self.taskConf = nil
	self.curRewardRank = nil
end

local function OnAddListener(self)
	base.OnAddListener(self)
	self:AddUIListener(EventId.OnUpdateAllianceTask, self.OnUpdateAllianceTask)
end

local function OnUpdateAllianceTask(self, taskId)
	if taskId then
		if self.taskInfo.taskId == taskId then
			self:RefreshAll()
		end
	else
		self:RefreshAll()
	end
end

local function OnRemoveListener(self)
	self:RemoveUIListener(EventId.OnUpdateAllianceTask, self.OnUpdateAllianceTask)
	base.OnRemoveListener(self)
end

local function SetItem(self, taskConf)
	self.taskConf = taskConf
	
	self:RefreshAll()
end

local function RefreshAll(self)
	self.taskInfo = DataCenter.AllianceTaskManager:GetTaskInfo(self.taskConf.id)

	self.taskNameN:SetLocalText(self.taskConf.name)
	self.taskDescN:SetLocalText(self.taskConf.desc, self.taskConf.param, self.taskConf.param2)
	self.jumpBtnN:SetActive(self.taskConf.jump and self.taskConf.jump > 0)
	self.questBgN:LoadSprite(string.format(LoadPath.UIWorldTrend, self.taskConf.quest_pic))
	
	local strRewardBg = "Assets/Main/Sprites/UI/UIWorldTrend/milepost_bg_board1"
	local strBg = "Assets/Main/Sprites/UI/UIWorldTrend/UIWorldTrend_icon_board"
	self.claimRankN:SetColor(Color.New(216/255, 122/255, 65/255, 1))
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local taskStatus, tempTime = self.taskInfo:GetTaskStatus()
	if taskStatus == 1 then
		self.startTimeN:SetActive(true)
		self.timerEndT = tempTime
		self.timerTxtN = self.startTimeN
		local days = (tempTime - curTime) / 86400000
		if days >= 1 then
			self:DelTimer()
			local strD = math.ceil(days) .. Localization:GetString("100104")
			self.timerTxtN:SetLocalText(302011, strD)
		else
			self:AddTimer()
			self:SetRemainTime()
		end
		
		self.taskProgN:SetActive(false)
		self.finishedTipN:SetActive(false)
		self.endTipN:SetActive(false)
		self.completeMarkN:SetActive(false)
	elseif taskStatus == 2 then
		self.taskProgN:SetActive(true)
		self.taskProgN:SetValue(self.taskInfo.curProg / self.taskConf.param)
		self.progTxtN:SetText(self.taskInfo.curProg .. "/" .. self.taskConf.param)
		self.timerEndT = tempTime
		self.timerTxtN = self.progEndTimeN
		self:AddTimer()
		self:SetRemainTime()

		self.startTimeN:SetActive(false)
		self.finishedTipN:SetActive(false)
		self.endTipN:SetActive(false)
		self.completeMarkN:SetActive(false)
	elseif taskStatus == 3 then
		self.finishedTipN:SetActive(true)
		local strFinishTime = UITimeManager:GetInstance():GetTimeToMD(math.modf(tempTime / 1000))
		self.finishedTipN:SetLocalText(390979, strFinishTime)
		self.timerEndT = 0
		self.timerTxtN = nil
		self:DelTimer()
		self.completeMarkN:SetActive(true)
		local canClaim = self.taskInfo:CheckIfCanClaim()
		self.finishedTipN:SetColor(Color.New(182/255, 137/255, 112/255, 1))
		if canClaim then
			strRewardBg = "Assets/Main/Sprites/UI/UIWorldTrend/milepost_bg_board2"
			strBg = "Assets/Main/Sprites/UI/UIWorldTrend/world_icon_board_h.png"
			self.claimRankN:SetColor(Color.New(255/255, 242/255, 197/255, 1))
			self.finishedTipN:SetColor(Color.New(122/255, 157/255, 0/255, 1))
			self.completeMarkN:SetActive(false)
		end
		self.startTimeN:SetActive(false)
		self.taskProgN:SetActive(false)
		self.endTipN:SetActive(false)
		
	else		
		self.endTipN:SetActive(true)
		self.endTipN:SetLocalText(390980)
		self.timerEndT = 0
		self.timerTxtN = nil
		self:DelTimer()
		
		self.startTimeN:SetActive(false)
		self.taskProgN:SetActive(false)
		self.finishedTipN:SetActive(false)
		self.completeMarkN:SetActive(false)
	end
	self.rewardBgN:LoadSprite(strRewardBg)
	self.bgN:LoadSprite(strBg)
	if taskStatus == 1 then
		CS.UIGray.SetGray(self.rewardBgN.transform, true, false)
		CS.UIGray.SetGray(self.bgN.transform, true, false)
		self.claimRankN:SetColor(Color.New(100/255, 100/255, 100/255, 1))
		self.taskNameN:SetColor(Color.New(100/255, 100/255, 100/255, 1))
	else
		CS.UIGray.SetGray(self.rewardBgN.transform, false, false)
		CS.UIGray.SetGray(self.bgN.transform, false, false)
		self.taskNameN:SetColor(Color.New(220/255, 120/255, 39/255, 1))
	end

	if taskStatus == 1 then
		self.taskStautsN:SetLocalText(390978)
	else
		self.taskStautsN:SetText("")
	end
	
	self:RefreshRewards()
end

local function RefreshRewards(self)
	local status = self.taskInfo:GetTaskStatus()
	local canClaim = self.taskInfo:CheckIfCanClaim()
	local rewardsArr = self.taskInfo.rewards[self.curRewardRank]
	local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardsArr)
	--if self.taskConf.func and self.taskConf.func > 0 then
	--	local tempReward = {}
	--	tempReward.rewardType = RewardType.UnlockModule
	--	tempReward.itemId = self.taskConf.func
	--	tempReward.itemIcon = self.taskConf.funcIcon
	--	tempReward.itemName = self.taskConf.funcName
	--	tempReward.itemDesc = self.taskConf.funcDesc
	--	table.insert(rewardsList, tempReward)
	--end
	
	for i, v in ipairs(self.rewardItemsTb) do
		if i <= #rewardsList then
			v.rootN:SetActive(true)
			v.itemN:ReInit(rewardsList[i])
			v.effN:SetActive(canClaim)
		else
			v.rootN:SetActive(false)
		end
	end

	if self.taskConf.func and self.taskConf.func > 0 then
		self.rewardItemsTb[3].rootN:SetActive(false)
		self.unlockModuleN:SetActive(true)
		self.unlockModuleIconN:LoadSprite(string.format(LoadPath.UIChronicle, self.taskConf.funcIcon), nil, function()
			self.unlockModuleIconN:SetNativeSize()
		end)
	else
		self.unlockModuleN:SetActive(false)
	end
	
	self.claimBtnN:SetActive(canClaim)
	self.claimEffN:SetActive(canClaim)

	if self.curRewardRank == 1 then
		self.claimRankN:SetLocalText(390975)
	elseif self.curRewardRank == 2 then
		self.claimRankN:SetLocalText(390977)
	elseif self.curRewardRank == 3 then
		self.claimRankN:SetLocalText(390976)
	end
end

local function AddTimer(self)
	self.TimerAction = function()
		self:SetRemainTime()
	end

	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction , self, false,false,false)
	end
	self.timer:Start()
end

local function SetRemainTime(self)
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local remainTime = self.timerEndT - curTime
	if remainTime > 0 then
		if self.timerTxtN then
			if self.timerTxtN == self.startTimeN then
				self.timerTxtN:SetLocalText(302011, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
			else
				self.timerTxtN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
			end
		end
	else
		if self.timerTxtN then
			self.timerTxtN:SetText("")
		end
		self:DelTimer()
		self:RefreshAll()
	end
end

local function DelTimer(self)
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end


local function OnClickShareBtn(self)
	local status = self.taskInfo:GetTaskStatus()
	if status == 3 or status == 4 then
		UIUtil.ShowTipsId(391036)
		return
	end
	
	self.view.ctrl:ShareTask(self.taskConf, self.taskInfo)
end

local function OnClickClaimBtn(self)
	SFSNetwork.SendMessage(MsgDefines.ClaimAllianceTaskReward, self.taskConf.id)
end

local function OnClickJumpBtn(self)
	self.view.ctrl:JumpTo(self.taskConf.jump)
end

local function OnClickArrowR(self)
	if self.curRewardRank < #self.taskInfo.rewards then
		self.curRewardRank = self.curRewardRank + 1
	else
		self.curRewardRank = 1
	end
	self:RefreshRewards()
end

local function OnClickArrowL(self)
	if self.curRewardRank > 1 then
		self.curRewardRank = self.curRewardRank - 1
	else
		self.curRewardRank = #self.taskInfo.rewards
	end
	self:RefreshRewards()
end

local function OnClickUnlockModule(self)
	local param = {}
	param.itemName = self.taskConf.funcName
	param.itemDesc = self.taskConf.funcDesc
	param["alignObject"] = self.unlockModuleIconN
	param.isLocal = false
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
end

UIAllianceTaskItem.OnCreate = OnCreate
UIAllianceTaskItem.OnDestroy = OnDestroy
UIAllianceTaskItem.ComponentDefine = ComponentDefine
UIAllianceTaskItem.ComponentDestroy = ComponentDestroy
UIAllianceTaskItem.DataDefine = DataDefine
UIAllianceTaskItem.DataDestroy = DataDestroy
UIAllianceTaskItem.OnAddListener = OnAddListener
UIAllianceTaskItem.OnRemoveListener = OnRemoveListener

UIAllianceTaskItem.RefreshAll = RefreshAll
UIAllianceTaskItem.RefreshRewards = RefreshRewards
UIAllianceTaskItem.OnUpdateAllianceTask = OnUpdateAllianceTask
UIAllianceTaskItem.OnClickShareBtn = OnClickShareBtn
UIAllianceTaskItem.OnClickClaimBtn = OnClickClaimBtn
UIAllianceTaskItem.OnClickJumpBtn = OnClickJumpBtn
UIAllianceTaskItem.AddTimer = AddTimer
UIAllianceTaskItem.SetRemainTime = SetRemainTime
UIAllianceTaskItem.DelTimer = DelTimer
UIAllianceTaskItem.OnClickArrowR = OnClickArrowR
UIAllianceTaskItem.OnClickArrowL = OnClickArrowL
UIAllianceTaskItem.OnClickUnlockModule = OnClickUnlockModule

UIAllianceTaskItem.SetItem = SetItem

return UIAllianceTaskItem