--每日任务
local EveryDayTaskItem = BaseClass("EveryDayTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDailyCell = require "UI.UITaskMain.Comp.UIDailyCell"
local UIBox = require "UI.UITaskMain.Comp.UIBox"
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local BoxNum = 5

-- 创建
function EveryDayTaskItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function EveryDayTaskItem:OnDestroy()
    self:DeleteTimer()
    self:ClearAnimTimer()
    self.content:SetAnchoredPosition(Vector2.New(0,0))
    self.content:Dispose()
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function EveryDayTaskItem:OnEnable()
    base.OnEnable(self)
    self:GetNewData()
end

-- 隐藏
function EveryDayTaskItem:OnDisable()
    base.OnDisable(self)
end

--控件的定义
function EveryDayTaskItem:ComponentDefine()
    self.slider1 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider1")
    self.slider2 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider2")
    self.slider3 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider3")
    self.slider4 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider4")
    self.slider5 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider5")


    self.active_text = self:AddComponent(UITextMeshProUGUIEx, "HaveTask/ActiveBg/ActiveText")
    self.active_value = self:AddComponent(UITextMeshProUGUIEx, "HaveTask/ActiveBg/ActiveText/ActiveValue")
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, "HaveTask/TimeBg/TimeText")
    self.box = {}
    table.insert(self.box,self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box1"))
    table.insert(self.box,self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box2"))
    table.insert(self.box,self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box3"))
    table.insert(self.box,self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box4"))
    table.insert(self.box,self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box5"))
    self.scroll_view = self:AddComponent(UIBaseContainer, "HaveTask/ScrollView")

    self.content = self:AddComponent(GridInfinityScrollView, "HaveTask/ScrollView/Content")
    

    self.no_task_text = self:AddComponent(UITextMeshProUGUIEx, "NoTask/NoTaskTxt")
    self.no_task = self:AddComponent(UITextMeshProUGUIEx, "NoTask")

    self.have_task_go = self:AddComponent(UIBaseContainer, "HaveTask")

    self.bubble = self:AddComponent(UIBaseContainer, "HaveTask/SliderBg/BoxGo/Box5/bubble")
    self.bubbleItem = self:AddComponent(UICommonItem, "HaveTask/SliderBg/BoxGo/Box5/bubble/bubbleItem")
    local itemParam = {}
    itemParam.itemId = LuaEntry.DataConfig:TryGetNum("dailyQuestTips", "k1")
    itemParam.rewardType = RewardType.GOODS
    self.bubbleItem:ReInit(itemParam)
    self.bubbleItemBg = self:AddComponent(UIBaseContainer, "HaveTask/SliderBg/BoxGo/Box5/bubble/bubbleItem/clickBtn/ImgQuality")
    self.bubbleItemBg:SetActive(false)
    
    self.GetAllRewardBg = self:AddComponent(UIBaseContainer, "HaveTask/GetAllRewardBg")
    self.getAllRewardBtn = self:AddComponent(UIButton, "HaveTask/GetAllRewardBg/GetAllRewardBtn")
    self.getAllRewardBtn:SetOnClick(function()
        self:OnClickGetAllRewardBtn()
    end)
    self.getAllRewardTxt = self:AddComponent(UITextMeshProUGUIEx, "HaveTask/GetAllRewardBg/GetAllRewardBtn/GetAllRewardTxt")
    self.getAllRewardTxt:SetLocalText(110132)
end

--控件的销毁
function EveryDayTaskItem:ComponentDestroy()
    --self.slider = nil
    self.slider1 = nil
    self.slider2 = nil
    self.slider3 = nil
    self.slider4 = nil
    self.slider5 = nil
    self.active_text = nil
    self.active_value = nil
    self.box = nil
    self.scroll_view = nil
    self.no_task = nil
    self.no_task_text = nil
    self.have_task_go = nil
    self.content = nil
end

--变量的定义
function EveryDayTaskItem:DataDefine()
    self.define = false
    self.curActiveValue = 0
    self.deleteIndex = 0
    self.list = {}
    self.listGO = {}
    self.isTween = false
    self.isInit = false
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self.deleteCell = nil
    self.hasInit = false
end

--变量的销毁
function EveryDayTaskItem:DataDestroy()
    self.define = nil
    self.curActiveValue = nil
    self.deleteIndex = nil
    self.box = nil
    self.list = nil
    self.dailyvalue = nil
    self.isTween = nil
    self.isInit = false
    self.timer_action = nil
    self.deleteCell = nil
    self.hasInit = nil
end

function EveryDayTaskItem:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.DailyQuestLs, self.OnDailyQuestLs)
    self:AddUIListener(EventId.DailyQuestSuccess, self.OnDailyQuestSuccess)
    self:AddUIListener(EventId.DailyQuestReward, self.RefreshBoxState)
    self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.OnTaskForceRefreshFinish)
    self:AddUIListener(EventId.DailyQuestGetAllTaskReward, self.OnDailyQuestGetAllTaskReward)
end
function EveryDayTaskItem:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.DailyQuestLs, self.OnDailyQuestLs)
    self:RemoveUIListener(EventId.DailyQuestSuccess, self.OnDailyQuestSuccess)
    self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshBoxState)
    self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.OnTaskForceRefreshFinish)
    self:RemoveUIListener(EventId.DailyQuestGetAllTaskReward, self.OnDailyQuestGetAllTaskReward)
end

function EveryDayTaskItem : ShowSelf()
    if not self.hasInit then
        self.hasInit = true
        self:RefreshAll()
    end
end

function EveryDayTaskItem : GetNewData()
    SFSNetwork.SendMessage(MsgDefines.DailyQuestLs)
end

function EveryDayTaskItem : OnDailyQuestSuccess()
    self:RefreshAll()
    --self:ForceUpdate()
end

function EveryDayTaskItem : OnTaskForceRefreshFinish()
    --self:DoQuestShowAnimation()
    self:RefreshAll()
end

function EveryDayTaskItem : OnDailyQuestLs()
    self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
    self.content:Remark(#self.list)
end

-- 全部刷新
function EveryDayTaskItem:RefreshAll()
    self:SetAllCellsDestroy()
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.content:Init(bindFunc1,bindFunc2, bindFunc3)
    self.isInit = true
    self:AddTimer()
    self.dailyvalue = {}
    for i = 1, 5 do
        table.insert(self.dailyvalue,DataCenter.DailyTaskManager:GetDailyCurValue(i))
    end
    self:RefreshPanel()
    self:ShowCells()
end

function EveryDayTaskItem:OnInitScroll(go,index)
    local item = self.scroll_view:AddComponent(UIDailyCell, go)
    self.listGO[go] = item
end

function EveryDayTaskItem:OnUpdateScroll(go, index)
    local sub = self.list[index+1]
    local cellItem = self.listGO[go]
    if sub == nil or cellItem == nil then
        return
    end
    local param = {}
    param.id = sub.id
    param.state = sub.state
    param.reward = sub.reward
    param.index = index + 1
    param.num = sub.num
    param.flyPos = self.gameObject.transform:Find("HaveTask/ActiveBg/Image")
    param.callBack = function(tempIndex, gameObject) self:OnClickCallBack(tempIndex, gameObject) end
    cellItem:SetData(param)
    cellItem:SetActive(true)
end

function EveryDayTaskItem:OnDestroyScrollItem(go, index)

end

function EveryDayTaskItem:RefreshActive()
    self.curActiveValue = DataCenter.DailyTaskManager:GetCurValue()
    self.active_text:SetText(self.curActiveValue)
    if self.curActiveValue <= self.dailyvalue[1] then
        self.slider1:SetValue(self.curActiveValue/self.dailyvalue[1])
        self.slider2:SetValue(0)
        self.slider3:SetValue(0)
        self.slider4:SetValue(0)
        self.slider5:SetValue(0)
    elseif self.curActiveValue > self.dailyvalue[1] and self.curActiveValue <= self.dailyvalue[2] then
        self.slider1:SetValue(1)
        self.slider2:SetValue((self.curActiveValue-self.dailyvalue[1])/(self.dailyvalue[2]-self.dailyvalue[1]))
        self.slider3:SetValue(0)
        self.slider4:SetValue(0)
        self.slider5:SetValue(0)
    elseif self.curActiveValue > self.dailyvalue[2] and self.curActiveValue <= self.dailyvalue[3] then
        self.slider1:SetValue(1)
        self.slider2:SetValue(1)
        self.slider3:SetValue((self.curActiveValue - self.dailyvalue[2])/(self.dailyvalue[3] - self.dailyvalue[2]))
        self.slider4:SetValue(0)
        self.slider5:SetValue(0)
    elseif self.curActiveValue > self.dailyvalue[3] and self.curActiveValue <= self.dailyvalue[4] then
        self.slider1:SetValue(1)
        self.slider2:SetValue(1)
        self.slider3:SetValue(1)
        self.slider4:SetValue((self.curActiveValue - self.dailyvalue[3])/(self.dailyvalue[4] - self.dailyvalue[3]))
        self.slider5:SetValue(0)
    elseif self.curActiveValue > self.dailyvalue[4] and self.curActiveValue <= self.dailyvalue[5] then
        self.slider1:SetValue(1)
        self.slider2:SetValue(1)
        self.slider3:SetValue(1)
        self.slider4:SetValue(1)
        self.slider5:SetValue((self.curActiveValue - self.dailyvalue[4])/(self.dailyvalue[5] - self.dailyvalue[4]))
    elseif self.curActiveValue > self.dailyvalue[5] then
        self.slider1:SetValue(1)
        self.slider2:SetValue(1)
        self.slider3:SetValue(1)
        self.slider4:SetValue(1)
        self.slider5:SetValue(1)
    end
end

--刷新box状态
function EveryDayTaskItem:RefreshBoxState()
    for k,v in ipairs(self.box) do
        local state = DataCenter.DailyTaskManager:GetBoxState(k,self.curActiveValue)
        v:RefreshState(state)
    end
    local state = DataCenter.DailyTaskManager:GetBoxState(BoxNum,self.curActiveValue)
    self.bubble:SetActive(state ~= TaskState.Received)
end

function EveryDayTaskItem:BoxCallBack(index,position,width)
    local x = position.x
    local isUp = false
    local y = position.y
    local list = DataCenter.DailyTaskManager:GetBoxRewardShow(self.box[index].param.count)
    local state = DataCenter.DailyTaskManager:GetBoxState(index,self.curActiveValue)
    local des
    if state == 2 then
        des = Localization:GetString("129065")
    else
        des = Localization:GetString("130065")
    end
    local offset = 70
    if list ~= nil and table.count(list) > 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip,des,nil,x,y,isUp,self.box[index].param.count,offset)
        return
    end
end

function EveryDayTaskItem:InitBox()
    for k,v in ipairs(self.box) do
        local param = {}
        param.callBack = function(index,position,width) self:BoxCallBack(index,position,width) end
        param.index = k
        param.state = DataCenter.DailyTaskManager:GetBoxState(k,self.curActiveValue)
        param.count = self.dailyvalue[k]
        v:ReInit(param)
    end
    local state = DataCenter.DailyTaskManager:GetBoxState(BoxNum,self.curActiveValue)
    self.bubble:SetActive(state ~= TaskState.Received)
end

-- 表现销毁
function EveryDayTaskItem:SetAllCellsDestroy()
    self.scroll_view:RemoveComponents(UIDailyCell)
    self.content:DestroyChildNode()
    self.listGO = {}
end

function EveryDayTaskItem:ShowCells()
    self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
    local tempCount = table.count(self.list)
    if tempCount > 0 then
        self.scroll_view:SetActive(true)
        self.no_task:SetActive(false)
        self.content:SetItemCount(tempCount)
    else
        self.scroll_view:SetActive(false)
        self.no_task:SetActive(true)
        self.no_task_text:SetLocalText(129092)
    end
end

function EveryDayTaskItem:RefreshPanel()
    if self.isInit then
        self:RefreshActive()
        self:InitBox()
        self:RefreshTime()
    end
end

function EveryDayTaskItem:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function EveryDayTaskItem:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

function EveryDayTaskItem:RefreshTime()
    local resTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if resTime == 0 then
        UIManager.Instance:DestroyWindow(UIWindowNames.UITaskMain)
        self:GetNewData()
    else
        self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
    end
end

function EveryDayTaskItem:ForceUpdate()
    self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
    if self.list ~= nil and not next(self.list) then
        self.scroll_view:SetActive(false)
        self.no_task:SetActive(true)
        self.no_task_text:SetLocalText(129092)
        return
    end
    self.content:LaterItemByIndex(self.deleteIndex, 0.25)
    --self:AddAnimatorTimer()
end

function EveryDayTaskItem:AddAnimatorTimer()
    if self.deleteCell~=nil then
        local animTime = self.deleteCell:PlayAnim("Eff_Ani_Taskmain_Out")
        self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.content:LaterItemByIndex(self.deleteIndex, 0.25)
        end, animTime)
    end
end

function EveryDayTaskItem:ClearAnimTimer()
    if self.animTimer ~= nil then
        self.animTimer:Stop()
        self.animTimer = nil
    end
end

function EveryDayTaskItem:DoQuestShowAnimation()
    for i, v in pairs(self.listGO) do
        self.listGO[i]:PlayAnim("Eff_Ani_Taskmain_Loop")
    end
    self.content:Remark(#self.list)
    self:DeleteMoveTimer()
end

function EveryDayTaskItem:DeleteMoveTimer()
    self.deleteIndex = 0
    self.isTween = false
end

function EveryDayTaskItem:IsTween()
    return self.isTween
end

--记录领取任务index
function EveryDayTaskItem:OnClickCallBack(index, gameObject)
    self.deleteIndex = index
    self.isTween = false
    self.deleteCell = self.listGO[gameObject]
end

function EveryDayTaskItem : OnClickGetAllRewardBtn()
    SFSNetwork.SendMessage(MsgDefines.DailyQuestGetAllReward)
end

function EveryDayTaskItem : OnDailyQuestGetAllTaskReward()
    self:RefreshPanel()
    self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
    self.content:Remark(#self.list)
end

function EveryDayTaskItem : RefreshGetAllReward(count)
    self.GetAllRewardBg:SetActive(count > 0)
end

return EveryDayTaskItem