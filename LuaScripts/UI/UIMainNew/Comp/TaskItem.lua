
local TaskItem = BaseClass("TaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local taskBtn_path = ""
local redDot_path = "Ani/redIcon"
local redText_path = "Ani/redIcon/redText"
local shortcutButton_path = "Ani/shoortcutButton"
local des1_path = "Ani/shoortcutButton/des1"
local des2_path = "Ani/DesRoot/Di/des2"
local eff_path = "Ani/VX/Eff"

local TaskType = {
    ChapterTask = 1,
    MainTask = 2,
    EveryDayTask = 3
}

function TaskItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function TaskItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function TaskItem : ComponentDefine()
    self.taskBtn = self:AddComponent(UIButton, taskBtn_path)
    self.taskBtn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_Task)
        self:OnClickTaskBtn()
    end)
    self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
    self.redText = self:AddComponent(UITextMeshProUGUIEx, redText_path)
    self.shortcutBtn = self:AddComponent(UIButton, shortcutButton_path)
    self.shortcutBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Task_Goto)
        self:OnClickShortcutBtn()
    end)
    --self._desc1_txt = self:AddComponent(UITextMeshProUGUIEx, des1_path)
    self._desc2_txt = self:AddComponent(UITextMeshProUGUIEx, des2_path)
    self.eff = self:AddComponent(UIBaseContainer, eff_path)
end

function TaskItem : ComponentDestroy()

end

function TaskItem : DataDefine()
    local data = DataCenter.ChapterTaskManager:GetAllChapterTask()
    self.taskData = data[1]
    self.taskType = TaskType.ChapterTask
    self.checkedChapterIdList = {} 
end

function TaskItem : DataDestroy()
    self.taskData = nil
    self.taskType = nil
    self.checkedChapterIdList = nil
end

function TaskItem : OnClickTaskBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITaskMain, HideBlurPanelAnim ,self.taskType)
end

function TaskItem : OnClickShortcutBtn()
    local show =  DataCenter.ChapterTaskManager:CheckShowChapterTask()
    if show then   -- 有章节任务
        self:ClickChapterShortcut()
    else
        self:ClickMainShortcut()
    end
end

--章节领奖
function TaskItem : GetChapterReward()
    local chapterId = DataCenter.ChapterTaskManager.chapterId
    for k,v in pairs(self.checkedChapterIdList) do
        if v == chapterId then
            return
        end
    end
    table.insert(self.checkedChapterIdList, chapterId)
    local param = {}
    param.chapterId = DataCenter.ChapterTaskManager.chapterId
    local flag = DataCenter.GuideManager:GetSaveGuideValue(SaveNoShowGarbage)
    if flag == SaveGuideDoneValue then
        param.garbageRefresh = false
    end
    SFSNetwork.SendMessage(MsgDefines.ChapterTask,param)
end

function TaskItem : ClickChapterShortcut()
    local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
    local allNum =  DataCenter.ChapterTaskManager:GetAllNum()
    if completeNum >= allNum then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITaskMain, HideBlurPanelAnim , TaskType.ChapterTask)
        --self:GetChapterReward()
    elseif self.taskData.state == TaskState.CanReceive then
        if self.taskData.id ~= nil then
            local rewardList = self.taskData.rewardList
            local count = 0
            if rewardList and next(rewardList) then
                for i = 1 ,table.count(rewardList) do
                    if rewardList[i].rewardType and rewardList[i].rewardType == RewardType.RESOURCE_ITEM then
                        count = count + rewardList[i].count
                    end
                end
            end
            if count and count > 0 then
                if DataCenter.ResourceItemDataManager:CheckIsStorageFull(count) then
                    --UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
                    return
                end
            end
            self:GetForward()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
            SFSNetwork.SendMessage(MsgDefines.TaskRewardGet,{id = self.taskData.id})
        elseif self.taskData.nextGuideId ~= nil then
            local questId = self.taskData.nextGuideId
            TimerManager:GetInstance():DelayInvoke(function()
                DataCenter.GuideManager:SetCurGuideId(questId)
                DataCenter.GuideManager:DoGuide()
            end, 0.3)
        end
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Quest,tostring(self.taskData.id))
    else
        if self.taskData.nextGuideId ~= nil then
            DataCenter.GuideManager:SetCurGuideId(self.taskData.nextGuideId)
            DataCenter.GuideManager:DoGuide()
        else
            if not DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ShowNewQuest, tostring(self.taskData.id)) then
                local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.taskData.id)
                if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.QuestGoto, tostring(template.id)) then
                else
                    GoToUtil.GoToByQuestId(template)
                end
            end
        end
    end
end

function TaskItem : ClickMainShortcut()
    if self.taskData == nil then
        return
    end
    if self.taskData.state == TaskState.CanReceive then
        local rewardList = self.taskData.rewardList
        local count = 0
        if rewardList and next(rewardList) then
            for i = 1 ,table.count(rewardList) do
                if rewardList[i].rewardType then
                    count = count + rewardList[i].count
                end
            end
        end
        self:GetForward()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
        SFSNetwork.SendMessage(MsgDefines.TaskRewardGet,{id = self.taskData.id})
    else
        GoToUtil.GoToByQuestId(LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.taskData.id)
        )
    end
end

function TaskItem : GetForward()
    local tempType = {}
    if self.taskData==nil or self.taskData.rewardList == nil then
        return
    end
    if self.template ~= nil then
        for i = 1, table.count(self.taskData.rewardList) do
            if self.taskData.rewardList[i] then
                if self.taskData.rewardList[i].rewardType ~= RewardType.MONEY then
                    table.insert(tempType,RewardToResType[self.taskData.rewardList[i].rewardType])
                end
            end
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp,tempType)
        for i = 1, table.count(self.taskData.rewardList) do
            local flyPos =Vector3.New(0,0,0)
            local rewardTyp
            local pic = ""
            rewardTyp = self.taskData.rewardList[i].rewardType
            pic = DataCenter.RewardManager:GetPicByType(rewardTyp,self.taskData.rewardList[i].itemId)
            UIUtil.DoFly(tonumber(rewardTyp),4,pic,self.taskBtn.transform.position,flyPos,40,40)
        end
    end
end

function TaskItem : Refresh()
    self:RefreshRedDot()
    self:RefreshCurTaskType()
    self:OnUpdateDesc()
end

function TaskItem : RefreshRedDot()
    self.chapterRedCount = self:GetChapterRedCount()
    self.mainRedCount = self:GetMainRedCount()
    self.everyDayRedCount = self:GetEveryDayRedCount()
    local count = self.chapterRedCount + self.mainRedCount + self.everyDayRedCount
    self.redDot:SetActive(count > 0)
    self.redText:SetText(count)
end

function TaskItem : GetChapterRedCount()
    local count = 0
    local showChapterTask = DataCenter.ChapterTaskManager:CheckShowChapterTask()
    if showChapterTask then
        local list = DataCenter.ChapterTaskManager:GetCanReceivedList()
        local allNum =  DataCenter.ChapterTaskManager:GetAllNum()
        local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
        if completeNum >= allNum and allNum > 0 then
            count = 1
        end
        count = count + table.count(list)
    end
    return count
end

function TaskItem : GetMainRedCount()
    local count = 0
    local showMainTask = DataCenter.TaskManager:CheckShowMainTask()
    if showMainTask then
        local mainTaskList,sideTaskList = DataCenter.TaskManager:GetMainAndSideTaskList()
        for k,v in pairs(mainTaskList) do
            if v.state == TaskState.CanReceive then
                count = count + 1
            end
        end
        for k,v in pairs(sideTaskList) do
            if v.state == TaskState.CanReceive then
                count = count + 1
            end
        end
    end
    return count
end

function TaskItem : GetEveryDayRedCount()
    local count = 0
    local showEveryDayTask = DataCenter.DailyTaskManager:CheckShowEveryDayTask()
    if showEveryDayTask then
        count = DataCenter.DailyTaskManager:GetRedNum()
    end
    return count
end

function TaskItem : RefreshCurTaskType()
    -- 默认状态
    local show =  DataCenter.ChapterTaskManager:CheckShowChapterTask()
    if show then   -- 有章节任务
        self.taskType = TaskType.ChapterTask
    else
        self.taskType = TaskType.MainTask
    end

    -- 特殊状态
    local showChapterTask = DataCenter.ChapterTaskManager:CheckShowChapterTask()
    local showMainTask = DataCenter.TaskManager:CheckShowMainTask()
    local showEveryDayTask = DataCenter.DailyTaskManager:CheckShowEveryDayTask()
    if showEveryDayTask and self.everyDayRedCount > 0 then
        self.taskType = TaskType.EveryDayTask
    elseif showMainTask and self.mainRedCount > 0 then
        self.taskType = TaskType.MainTask
    elseif showChapterTask and self.chapterRedCount > 0 then
        self.taskType = TaskType.ChapterTask
    end
end

function TaskItem : OnUpdateDesc()
    local show =  DataCenter.ChapterTaskManager:CheckShowChapterTask()
    if show then   -- 有章节任务
        self:UpdateChapterTaskData()
    else
        self:UpdateMainTaskData()
    end
    self:SetDes()
end

function TaskItem : SetDes()
    if self.taskData == nil then
        return
    end
    self.template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.taskData.id)
    local str = ""
    if tonumber(self.template.progressshow) == 1 then
        local num = 0
        if self.taskData.num >= self.template.para2 then
            num = self.template.para2
        else
            num = self.taskData.num
        end
        str = string.format(" ( %d/%d ) ",num,self.template.para2)
    else
        str = ""
    end
    if self.taskData.state == TaskState.CanReceive then
        str = Localization:GetString("170537")
        self.eff:SetActive(true)
    else
        self.eff:SetActive(false)
    end
    self._desc2_txt:SetText(DataCenter.QuestTemplateManager:GetDesc(self.template)..str)
end

function TaskItem : UpdateChapterTaskData()
    local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
    local allNum =  DataCenter.ChapterTaskManager:GetAllNum()
    if completeNum >= allNum then
        --self._desc1_txt:SetLocalText(302118)
        self._desc2_txt:SetLocalText(170459)
        self.taskData = nil
        self.eff:SetActive(true)
        return
    end
    local data = DataCenter.ChapterTaskManager:GetAllChapterTask()
    local record = DataCenter.ChapterTaskManager:GetLastTaskId()
    self.taskData = data[1]
    if self.taskData == nil then
        return
    end
    if data[1] and data[1].state ~= TaskState.Received and data[1].state ~= TaskState.CanReceive then
        if record and record ~= 0 then
            self.taskData = DataCenter.ChapterTaskManager:FindTaskInfo(tostring(record))
        end
    end
end

function TaskItem : UpdateMainTaskData()
    local mainList,sideList = DataCenter.TaskManager:GetMainAndSideTaskList()
    local record = DataCenter.TaskManager:GetLastTaskId()
    if #mainList > 0 then
        self.taskData = mainList[1]
    elseif #sideList > 0 then
        self.taskData = sideList[1]
    else
        self.taskData = nil
        return
    end
    if self.taskData and self.taskData.state ~= TaskState.Received and self.taskData.state ~= TaskState.CanReceive then
        if record and record ~= 0 then
            self.taskData = DataCenter.TaskManager:FindTaskInfo(tostring(record))
        end
    end
end


return TaskItem