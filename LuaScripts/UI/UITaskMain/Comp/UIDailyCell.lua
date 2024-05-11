

local UIDailyCell = BaseClass("UIDailyCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TaskRewardItem = require "UI.UITaskMain.Comp.TaskRewardItem"

local bg_path = "Bg"
local desText_path = "Bg/TaskName"
local goBtn_path = "Bg/GoButton"
local goText_path = "Bg/GoButton/goText"
local rewardItem_path = "Bg/rewardContent/item"
local imgCompleted_path = "Bg/imgCompleted"
local scoreItem_path = "Bg/rewardContent/scoreItem"
local anim_path = "Bg"

local maxRewardItemCount = 3

--创建
function UIDailyCell : OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

-- 销毁
function UIDailyCell : OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIDailyCell : ComponentDefine()
	self.bgImg = self:AddComponent(UIImage, anim_path)
	self.goTextMat = self.transform:Find("Bg/GoButton/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
	self.bg = self:AddComponent(UIBaseContainer, bg_path)
	self.desText = self:AddComponent(UITextMeshProUGUIEx, desText_path)

	self.goBtn = self:AddComponent(UIButton, goBtn_path)
	self.goBtn:SetOnClick(function()
		self:OnClickGoBtn()
	end)
	self.goBtnText = self:AddComponent(UITextMeshProUGUIEx, goText_path)
	self.goBtnImg = self:AddComponent(UIImage, goBtn_path)
	self.imgCompleted = self:AddComponent(UIBaseContainer, imgCompleted_path)

	for i = 1,maxRewardItemCount do
		local item = self:AddComponent(TaskRewardItem, rewardItem_path..i)
		table.insert(self.rewardItemList, item)
	end
	self.scoreItem = self:AddComponent(TaskRewardItem, scoreItem_path)
	self.scoreItem:SetActive(true)

	self.anim = self:AddComponent(UIAnimator, anim_path)
	self:SetActive(true)
end

function UIDailyCell : ComponentDestroy()

end

function UIDailyCell : DataDefine()
	self.rewardItemList = {}
end

function UIDailyCell : DataDestroy()
	self.rewardItemList = nil
end

function UIDailyCell : SetData(param)
	self.param = param
	self.template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(param.id)
	self.isClick = false
	if self.template ~= nil then
		--self.name_text:SetLocalText(self.template.name)
		if self.template.para2 == 1 then
			self.desText:SetLocalText(self.template.desc, self.template.para2)
		else
			self.desText:SetText(Localization:GetString(self.template.desc,self.template.para2)..string.format("(%d/%d)",self.param.num,self.template.para2))
		end

		if self.param.state == TaskState.NoComplete then		--未完成
			self.goBtn:SetActive(true)
			self.goBtnImg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_blue_samll"))
			self.goBtnText:SetMaterial(self.goTextMat.sharedMaterials[1])
			self.goBtnText:SetLocalText(110003)
			self.imgCompleted:SetActive(false)
			--self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02.png")
		elseif self.param.state == TaskState.CanReceive then	--已完成未领奖
			self.goBtn:SetActive(true)
			self.goBtnImg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green71"))
			self.goBtnText:SetMaterial(self.goTextMat.sharedMaterials[2])
			self.goBtnText:SetLocalText(170004)
			self.imgCompleted:SetActive(false)
			--self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02_2.png")
		elseif self.param.state == TaskState.Received then	--已完成
			self.goBtn:SetActive(false)
			self.imgCompleted:SetActive(true)
			--self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02.png")
		end
		self:ShowRewardCell()
	end
end

function UIDailyCell : ShowRewardCell()
	local perPoint = tonumber(self.template.point)
	self.scoreItem:ShowEveryDayScoreItem(perPoint)
	for i = 1,maxRewardItemCount do
		local item = self.rewardItemList[i]
		item:SetActive(self.param.reward ~= nil and i <= #self.param.reward)
		if self.param.reward ~= nil and i <= #self.param.reward then
			local rewardParam = self.param.reward[i]
			local param = {}
			param.rewardType = rewardParam.rewardType
			param.itemId = rewardParam.itemId
			param.count = rewardParam.count
			item:ReInit(param)
		end
	end
end

function UIDailyCell : OnClickGoBtn()
	if self.param.state == TaskState.NoComplete then
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Task_Goto)
		UIManager.Instance:DestroyWindow(UIWindowNames.UITaskMain)
		GoToUtil.GoToByQuestId(self.template)
	elseif self.param.state == TaskState.CanReceive then
		if self.view:GetIsTween() then
			return
		end
		self.param.callBack(self.param.index, self.gameObject)
		self:GetForward()
		SFSNetwork.SendMessage(MsgDefines.DailyTaskReward,self.param.id)
		--self:SetActive(false)
	end
end

function UIDailyCell : GetForward()
	local tempType = {}
	if self.param==nil or self.param.reward == nil then
		return
	end
	for i = 1, 3 do
		if self.param.reward[i] then
			if self.param.reward[i].rewardType ~= RewardType.MONEY then
				table.insert(tempType,RewardToResType[self.param.reward[i].rewardType])
			end
		end
	end
	EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp,tempType)
	for i = 1, maxRewardItemCount do
		local result = self.rewardItemList[i].gameObject.activeSelf
		local flyPos =Vector3.New(0,0,0)
		local rewardTyp
		local pic = ""
		if result ==true then
			if i ~= 4 then
				if self.param.reward[i] then
					rewardTyp = self.param.reward[i].rewardType
					pic = DataCenter.RewardManager:GetPicByType(rewardTyp)
				end
			else
				flyPos = self.param.flyPos.position
				rewardTyp= RewardType.ALLIANCE_POINT
				pic="Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_activity.png"
			end
			UIUtil.DoFly(tonumber(rewardTyp),4,pic,self.rewardItemList[i].transform.position,flyPos,40,40)
		end
	end
end

function UIDailyCell : PlayAnim(name)
	local success, time = self.anim:PlayAnimationReturnTime(name)
	return time
end

return UIDailyCell