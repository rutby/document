

local UITaskItem = BaseClass("UITaskItem", UIBaseContainer)
local base = UIBaseContainer

local TaskRewardItem = require "UI.UITaskMain.Comp.TaskRewardItem"

local bg_path = "Bg"
local desText_path = "Bg/TaskName"
local goBtn_path = "Bg/GoButton"
local goText_path = "Bg/GoButton/goText"
local rewardItem_path = "Bg/rewardContent/item"
local imgCompleted_path = "Bg/imgCompleted"
local anim_path = "Bg"

local maxRewardItemCount = 4

--创建
function UITaskItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UITaskItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UITaskItem : ComponentDefine()
    self.goTextMat = self.transform:Find("Bg/GoButton/goTextMat"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.bg = self:AddComponent(UIBaseContainer, bg_path)
    self.bgImg = self:AddComponent(UIImage, bg_path)
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

    self.anim = self:AddComponent(UIAnimator, anim_path)
end

function UITaskItem : ComponentDestroy()

end

function UITaskItem : DataDefine()
    self.rewardItemList = {}
    self.isAnim = false
end

function UITaskItem : DataDestroy()
    self.rewardItemList = nil
    self.isAnim = false
end

function UITaskItem : SetData(param)
    self.param = param
    self:SetActive(true)
    if self.param.state == TaskState.Lock then --未解锁
        self.bg:SetActive(false)
        return
    else
        self.bg:SetActive(true)
    end
    
    self.template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), param.id)
    self.isClick = false
    if self.template ~= nil then
        local str = ""
        if tonumber(self.template.progressshow) == 1 then
            local num = 0
            if self.param.num >= self.template.para2 then
                num = self.template.para2
            else
                num = self.param.num
            end
            if self.param.state == 2 then
                num = self.template.para2
            end
            str = string.format("(%d/%d)",num,self.template.para2)
        else
            str = ""
        end
        self.desText:SetText(DataCenter.QuestTemplateManager:GetDesc(self.template)..str)
        self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02.png")
        if self.param.state == TaskState.NoComplete then		--未完成
            self.goBtn:SetActive(true)
            self.goBtnImg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_blue_samll"))
            self.goBtnText:SetMaterial(self.goTextMat.sharedMaterials[1])
            self.goBtnText:SetLocalText(110003)
            self.imgCompleted:SetActive(false)
           -- self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_bg_di02.png")
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

function UITaskItem : ShowRewardCell()
    for i = 1,maxRewardItemCount do
        local item = self.rewardItemList[i]
        item:SetActive(self.param.rewardList ~= nil and i <= #self.param.rewardList)
        if self.param.rewardList ~= nil and i <= #self.param.rewardList then
            local rewardParam = self.param.rewardList[i]
            local param = {}
            param.rewardType = rewardParam.rewardType
            param.itemId = rewardParam.itemId
            param.count = rewardParam.count
            item:ReInit(param)
        end
    end
end

function UITaskItem : OnClickGoBtn()
    if self.param.state == TaskState.NoComplete then --跳转
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Task_Goto)
        DataCenter.ChapterTaskManager:RecordLastTaskId(self.template.id)
        if self.param.nextGuideId ~= nil then
            DataCenter.GuideManager:SetCurGuideId(self.param.nextGuideId)
            GoToUtil.CloseAllWindows()
            DataCenter.GuideManager:DoGuide()
        else
            if not DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ShowNewQuest, tostring(self.param.id)) then
                local template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.param.id)
                GoToUtil.CloseAllWindows()
                if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.QuestGoto, tostring(template.id)) then

                else
                    GoToUtil.GoToByQuestId(template)
                end
            end
        end
        
    elseif self.param.state == TaskState.CanReceive then --已完成未领取
        if self.isAnim then
            return
        end
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
        DataCenter.ChapterTaskManager:SetTaskState(self.param.id)
        self:GetForward()
        self.param.callBack(self.param.index)
        if self.param.id ~= nil then
            DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UIMainChapterTaskRefresh, true)
            SFSNetwork.SendMessage(MsgDefines.TaskRewardGet,{id = self.param.id})
        elseif self.param.nextGuideId ~= nil then
            local questId = self.param.nextGuideId
            TimerManager:GetInstance():DelayInvoke(function()
                DataCenter.GuideManager:SetCurGuideId(questId)
                DataCenter.GuideManager:DoGuide()
            end, 0.3)
        end
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Quest,tostring(self.param.id))
        self:SetActive(false)
    end

end

function UITaskItem : GetForward()
    local tempType = {}
    if self.param==nil or self.param.rewardList == nil then
        return
    end
    if self.template ~= nil then
        for i = 1, table.count(self.param.rewardList) do
            if self.param.rewardList[i] then
                if self.param.rewardList[i].rewardType ~= RewardType.MONEY then
                    table.insert(tempType,RewardToResType[self.param.rewardList[i].rewardType])
                end
            end
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp,tempType)
        for i = 1, Mathf.Min(table.count(self.param.rewardList), maxRewardItemCount) do
            local result = self.rewardItemList[i].gameObject.activeSelf
            local flyPos =Vector3.New(0,0,0)
            local rewardTyp
            local pic = ""
            if result ==true then
                rewardTyp = self.param.rewardList[i].rewardType
                pic = DataCenter.RewardManager:GetPicByType(rewardTyp,self.param.rewardList[i].itemId)
                UIUtil.DoFly(tonumber(rewardTyp),4,pic,self.rewardItemList[i].transform.position,flyPos,40,40)
            end
        end
    end
end

function UITaskItem : GetTaskId()
    if self.param then
        return self.param.id
    end
    return -1
end

function UITaskItem : GetBtnGo()
    return self.goBtn.gameObject
end

function UITaskItem : GetItemState()
    return self.param.state
end

function UITaskItem : SetIsAnim(value)
    self.isAnim = value
end

function UITaskItem : PlayAnim(name)
    local success, time = self.anim:PlayAnimationReturnTime(name)
    return time
end

return UITaskItem