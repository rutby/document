local UIHeroTrial = BaseClass("UIHeroTrial", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local RewardUtil = require "Util.RewardUtil"
local UIHeroTrialTaskCell = require "UI.UIActivityCenterTable.Component.UIHeroTrial.UIHeroTrialTaskCell"
local UIGray = CS.UIGray
local heroPos = {
    {[1]=Vector3.New(154,-309,0),[2]=Vector3.New(-153,-309,0)},
    {[1]=Vector3.New(-0.5,-84,0),[2]=Vector3.New(-250,-309,0),[3]=Vector3.New(250,-309,0)} -- 71 116 127
}

function UIHeroTrial:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UIHeroTrial:OnEnable()
    base.OnEnable(self)
end

function UIHeroTrial:ComponentDefine()
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, "RightView/title")
    self.subTitleN = self:AddComponent(UITextMeshProUGUIEx, "RightView/Top/subTitle")
    self.infoBtnN = self:AddComponent(UIButton, "RightView/infoBtn")
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.activityTimeN = self:AddComponent(UITextMeshProUGUIEx, "RightView/Top/actTime")
    self.remainTimeN = self:AddComponent(UITextMeshProUGUIEx, "RightView/ActTime/remainTime")

    self.task_scroll_view = self:AddComponent(UIScrollView, "RightView/ScrollView")
    self.task_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.task_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    
    self.rewardContent = self:AddComponent(UIBaseContainer, "RightView/ScrollView/StageRewardContent")
    self.rewardTitle = self:AddComponent(UITextMeshProUGUIEx,"RightView/StageRewardTitle")
    
    self.rewardShowBtn = self:AddComponent(UIButton,"RightView/RewardShowBtn")
    self.rewardShowBtn:SetOnClick(function() 
        self:OnClickRewardShowBtn()
    end)
    self.rewardShowBtn_text = self:AddComponent(UITextMeshProUGUIEx, "RightView/RewardShowBtn/RewardShowBtnText")

    self.receiveRewardBtn = self:AddComponent(UIButton, "RightView/ReceiveRewardBtn")
    self.receiveRewardBtn:SetOnClick(function()
        self:OnClickReceiveBtn()
    end)
    self.receiveRewardBtnText = self:AddComponent(UITextMeshProUGUIEx, "RightView/ReceiveRewardBtn/ReceiveRewardBtnText")
    
    self.imageTab = {}
    for i = 1, 3 do
        local tab = {
                        root = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/HeroMask/"..i),
                        image = self:AddComponent(UIImage,"RightView/HeroMaskRoot/HeroMask/"..i.."/HeroImage"..i),
                        spine = self.transform:Find("RightView/HeroMaskRoot/HeroMask/"..i.."/HeroSpine"..i):GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic)),
                        rect = self:AddComponent(UIBaseContainer, "RightView/HeroMaskRoot/HeroMask/"..i.."/HeroSpineRect"..i),
                        
                        infoRoot = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i),
                        name = self:AddComponent(UITextMeshProUGUIEx,"RightView/HeroMaskRoot/info"..i.."/heroName"..i),
                        heroStar1 = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i.."/UIHeroStars"..i.."/star_bg1/lightstar_1_"..i),
                        heroStar2 = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i.."/UIHeroStars"..i.."/star_bg2/lightstar_2_"..i),
                        heroStar3 = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i.."/UIHeroStars"..i.."/star_bg3/lightstar_3_"..i),
                        heroStar4 = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i.."/UIHeroStars"..i.."/star_bg4/lightstar_4_"..i),
                        heroStar5 = self:AddComponent(UIBaseContainer,"RightView/HeroMaskRoot/info"..i.."/UIHeroStars"..i.."/star_bg5/lightstar_5_"..i),
        }
        table.insert(self.imageTab,tab)
    end
    self.starObj = {}
    for i = 1, 5 do
        local star = { imageObj = self:AddComponent(UIImage,"RightView/RewardShowBtn/Star/Image"..i) }
        table.insert(self.starObj, star)
    end
end

function UIHeroTrial:SetData(activityId)
    self.activityId = activityId
    if not self.activityId then
        return
    end
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    self.titleN:SetText(Localization:GetString(self.activityData.name))
    self.subTitleN:SetText(Localization:GetString(self.activityData.desc_info))
    if string.IsNullOrEmpty(self.activityData.story) then
        self.infoBtnN:SetActive(false)
    else
        self.infoBtnN:SetActive(true)
    end
    local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
    local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime)
    self.activityTimeN:SetText(startT .. "-" .. endT)
    self:AddCountDownTimer()
    self:RefreshRemainTime()

    self.rewardShowBtn_text:SetLocalText(111239)
    self:OnRefresh()
end

function UIHeroTrial:AddCountDownTimer()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

function UIHeroTrial:RefreshRemainTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if remainTime > 0 then
        if self.activityData:CheckIfIsToEnd() then
            self.remainTimeN:SetColorRGBA(0.91, 0.26, 0.26, 1)
        end
        self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.remainTimeN:SetText("")
        self:DelCountDownTimer()
    end
end

function UIHeroTrial:DelCountDownTimer()
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

function UIHeroTrial:OnQuestRewardSuccess()
    self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
    self:OnRefreshTask()
    self:OnRefreshReceiveBtn()
end

function UIHeroTrial:OnReceiveStageRewardSuccess()
    self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
    local newCurRewardIndex = self.sevenDayInfo:GetCurMaxRewardIndex()
    if newCurRewardIndex ~= self.curRewardIndex then
        self:OnRefresh()
    else
        self:OnRefreshReceiveBtn()
    end
end

function UIHeroTrial:OnRefresh()
    self.sevenDayInfo = DataCenter.ActSevenDayData:GetInfoByActId(tonumber(self.activityId))
    self.curRewardIndex = self.sevenDayInfo:GetCurMaxRewardIndex()
    self:OnRefreshTask()
    self:OnRefreshReceiveBtn()
    self:OnRefreshReward()
    self:OnRefreshHeroHeadIcon()
    self:OnRefreshStar()
end

function UIHeroTrial:OnRefreshStar()
    for i = 1, #self.starObj do
        self.starObj[i].imageObj.gameObject:SetActive(i <= self.curRewardIndex)
    end
end

function UIHeroTrial:OnRefreshReceiveBtn()
	if self.sevenDayInfo.scoreReward[self.curRewardIndex] then  
        local rewardFlag = self.sevenDayInfo.scoreReward[self.curRewardIndex].rewardFlag  -- 0 未领取 1 已领取
        if rewardFlag == 0 then
            local tasks = self.sevenDayInfo.dayActs[self.curRewardIndex].tasks
            local isCanReceive = true
            for i = 1, #tasks do
                local taskId = tasks[i].id
                local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
                if taskValue and taskValue.state <= 1 then
                    isCanReceive = false
                    break
                end
            end
            if isCanReceive then
                self.receiveRewardBtnText:SetLocalText(371058)
                UIGray.SetGray(self.receiveRewardBtn.transform, false, true)
            else
                self.receiveRewardBtnText:SetLocalText(371058)
                UIGray.SetGray(self.receiveRewardBtn.transform, true, false)
            end
        elseif rewardFlag == 1 then
            self.receiveRewardBtnText:SetLocalText(110461)
            UIGray.SetGray(self.receiveRewardBtn.transform, true, false)
        end
	else
		self.receiveRewardBtn:SetActive(false)
	end
end

function UIHeroTrial:OnRefreshTask()
    local tasks = self.sevenDayInfo.dayActs[self.curRewardIndex].tasks
    self.taskList = self.sevenDayInfo:SortTask(tasks)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    self.str = string.split(actListData.para1,"|")
    local taskNum = #self.taskList
    if taskNum > 0 then
        self.task_scroll_view:SetTotalCount(#self.taskList)
        self.task_scroll_view:RefillCells()
    end
    local hasReceived = 0
    for i = 1, taskNum do
        local taskValue = DataCenter.TaskManager:FindTaskInfo(self.taskList[i].id)
        if taskValue.state == 2 then
            hasReceived = hasReceived + 1
        end
    end
    self.rewardTitle:SetText(Localization:GetString(450119,hasReceived,taskNum))
end

function UIHeroTrial:OnRefreshHeroHeadIcon()
    for i = 1, #self.imageTab do
        self.imageTab[i].root:SetActive(false)
        self.imageTab[i].infoRoot:SetActive(false)
        self.imageTab[i].image:SetActive(false)
        self.imageTab[i].spine.gameObject:SetActive(false)
    end
    local curSevenDayId = self.sevenDayInfo.dayActs[self.curRewardIndex].id
    local sevenDayCfg = LocalController:instance():getLine(TableName.ActSeven, curSevenDayId)
    local heroIdS = string.split(sevenDayCfg.type1,";")
	local showHeroNum = #heroIdS
    self:OnUnloadSpineAsset()
    self.spinePathTab = {}
    for i = 1, #heroIdS do
        local nodeIndex = showHeroNum == 2 and (i+1) or i
        if self.imageTab[nodeIndex] then
            self.imageTab[nodeIndex].name:SetText(HeroUtils.GetHeroNameByConfigId(heroIdS[i]))
            self:OnRefreshHeroStar(heroIdS[i],self.imageTab[nodeIndex])
            local inHistory = DataCenter.HeroDataManager:IsInHistory(heroIdS[i])
            if inHistory then
                local curSpinePath = HeroUtils.GetSpinePath(heroIdS[i])
                if curSpinePath then
                    table.insert(self.spinePathTab,curSpinePath)
                    CommonUtil.LoadAsset(curSpinePath, "UIHeroInfoSpine", typeof(CS.Spine.Unity.SkeletonDataAsset), function(asset)
                        if asset then
                            local curPos = heroPos[showHeroNum-1][i]
                            self.imageTab[nodeIndex].root.rectTransform.anchoredPosition = Vector2.New(curPos.x,curPos.y)
                            self.imageTab[nodeIndex].root:SetActive(true)
                            self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition = Vector2.New(curPos.x,self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition.y)
                            self.imageTab[nodeIndex].infoRoot:SetActive(true)
                            self.imageTab[nodeIndex].spine.gameObject:SetActive(true)
                            self.imageTab[nodeIndex].spine.skeletonDataAsset = asset
                            self.imageTab[nodeIndex].spine:Initialize(true)
                            self.imageTab[nodeIndex].spine:MatchRectTransformWithBounds()
                            self.imageTab[nodeIndex].spine.AnimationState:SetAnimation(0, "Idle", true)
                            --local animations = asset:GetSkeletonData().Animations
                            --if animations.Count > 0 then
                            --    local animation = animations.Items[0]
                            --   
                            --end
                        end
                    end)
                else
					local curPos = heroPos[showHeroNum-1][i]
					self.imageTab[nodeIndex].root.rectTransform.anchoredPosition = Vector2.New(curPos.x,curPos.y)
                    self.imageTab[nodeIndex].root:SetActive(true)
                    self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition = Vector2.New(curPos.x,self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition.y)
                    self.imageTab[nodeIndex].infoRoot:SetActive(true)
                    local picPath = HeroUtils.GetHeroBigPic(heroIdS[i])
                    self.imageTab[nodeIndex].image:LoadSprite(picPath)
                    self.imageTab[nodeIndex].image:SetActive(true)
                end
            else
				local curPos = heroPos[showHeroNum-1][i]
				self.imageTab[nodeIndex].root.rectTransform.anchoredPosition = Vector2.New(curPos.x,curPos.y)
                self.imageTab[nodeIndex].root:SetActive(true)
                self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition = Vector2.New(curPos.x,self.imageTab[nodeIndex].infoRoot.rectTransform.anchoredPosition.y)
                self.imageTab[nodeIndex].infoRoot:SetActive(true)
                local picPath = HeroUtils.GetHeroBigPic(heroIdS[i])
                self.imageTab[nodeIndex].image:LoadSprite(picPath)
                self.imageTab[nodeIndex].image:SetColor(Color.New(0.55,0.55,0.55,1))
                self.imageTab[nodeIndex].image:SetActive(true)
            end
        end
    end
end

function UIHeroTrial:OnRefreshHeroStar(heroId,imageTab)
    local heroData = DataCenter.HeroDataManager:GetHeroById(tonumber(heroId))
    for i = 1, 5 do
        imageTab["heroStar"..i]:SetActive(false)
    end
	if heroData ~= nil then
		local curRankId = heroData:GetCurMilitaryRankId()
        local intRankValue = (curRankId - 1)/5
        for i = 1, 5 do
            if i <= intRankValue then
                imageTab["heroStar"..i]:SetActive(true)
            end
        end
	else
        
	end
end

function UIHeroTrial:OnRefreshReward()
    self:SetAllRewardsDestroy()
    self.rewardModelCount =0
    local list =  self.sevenDayInfo.scoreReward[self.curRewardIndex].reward
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.rewardModelCount= self.rewardModelCount+1
            self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.rewardContent.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.rewardContent:AddComponent(UICommonItem,nameStr)
                cell:ReInit(list[i])
                table.insert(self.rewardItemsList,cell)
            end)
        end
    end
end

function UIHeroTrial:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.task_scroll_view:AddComponent(UIHeroTrialTaskCell, itemObj)
    item:ShowRewards(self.taskList[index],self.str[index])
end

function UIHeroTrial:OnDeleteCell(itemObj, index)
    if self.task_scroll_view then
        self.task_scroll_view:RemoveComponent(itemObj.name, UIHeroTrialTaskCell)
    end
end

function UIHeroTrial:SetCellDestroy()
    if self.task_scroll_view then
        self.task_scroll_view:ClearCells()
        self.task_scroll_view:RemoveComponents(UIHeroTrialTaskCell)
    end
end

function UIHeroTrial:OnClickReceiveBtn()
    SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayActReward, self.activityId, self.curRewardIndex)
end

function UIHeroTrial:GetForward()
    local list =  self.sevenDayInfo.scoreReward[self.curRewardIndex].reward
    for i, v in ipairs(list) do
        local rewardType = v.rewardType
        local itemId = v.itemId
        local pic =RewardUtil.GetPic(v.rewardType,itemId)
        local rewardPos = self.rewardItemsList[i]
        if pic~="" then
            UIUtil.DoFly(tonumber(rewardType),3,pic,rewardPos.transform.position,UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods))
        end
    end
end

function UIHeroTrial:OnClickInfoBtn()
    if self.activityData and self.activityData.story then
        UIUtil.ShowIntro(Localization:GetString(self.activityData.name), Localization:GetString("100239"), Localization:GetString(self.activityData.story))
    end
end

--打开奖励列表
function UIHeroTrial:OnClickRewardShowBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTrialReward,{anim = true, isBlur  = true}, tonumber(self.activityId))
end

function UIHeroTrial:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.QuestRewardSuccess, self.OnQuestRewardSuccess)
    self:AddUIListener(EventId.ActRewardState, self.OnReceiveStageRewardSuccess)
end

function UIHeroTrial:OnRemoveListener()
    self:RemoveUIListener(EventId.QuestRewardSuccess, self.OnQuestRewardSuccess)
    self:RemoveUIListener(EventId.ActRewardState, self.OnReceiveStageRewardSuccess)
    base.OnRemoveListener(self)
end

function UIHeroTrial:SetAllRewardsDestroy()
    self.rewardContent:RemoveComponents(UICommonItem)
    if self.rewardModels~=nil then
        for k,v in pairs(self.rewardModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rewardModels ={}
    self.rewardItemsList = {}
end

function UIHeroTrial:OnDisable()
    self:OnUnloadSpineAsset()
    self.spinePathTab = {}
    base.OnDisable(self)
end

function UIHeroTrial:OnUnloadSpineAsset()
    if self.spinePathTab and next(self.spinePathTab) then
        for i = 1, #self.spinePathTab do
            if self.spinePathTab[i] then
                CommonUtil.UnloadAsset(self.spinePathTab[i], "UIHeroInfoSpine")
                self.spinePathTab[i] = nil
            end
        end
    end
end

function UIHeroTrial:OnDestroy()
    base.OnDestroy(self)
    self:ComponentDestroy()
    self:SetCellDestroy()
    self:DelCountDownTimer()
end

function UIHeroTrial:ComponentDestroy()
    self.titleN = nil
    self.subTitleN = nil
    self.infoBtnN = nil
    self.activityTimeN = nil
    self.rewardShowBtn_text = nil
    self.rewardContent = nil
    self.task_scroll_view = nil
    self.rewardTitle = nil
    self.imageTab = {}
    self.starObj = {}
end

return UIHeroTrial