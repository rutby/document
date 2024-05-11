

local UITaskMainView = BaseClass("UITaskMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local ChapterTaskItem = require "UI.UITaskMain.Comp.ChapterTaskItem"
local MainTaskItem = require "UI.UITaskMain.Comp.MainTaskItem"
local EveryDayTaskItem = require "UI.UITaskMain.Comp.EveryDayTaskItem"
local UITaskChapterAdv = require "UI.UITaskMain.Comp.UITaskChapterAdv"

local toggle_path = "ToggleGroup/Toggle"
local titleText_path = "Rect/after_go/titleBg/titleText"
local CloseBtn_path = "Rect/after_go/CloseBtn"
local CloseBtn2_path = "Rect/after_go/RectChapterTask/CloseBtn2"
local panelCloseBtn_path = "UICommonPanel"
local chapterTaskItem_path = "Rect/after_go/RectChapterTask"
local mainTaskItem_path = "Rect/after_go/RectMainTask"
local everyDayTaskItem_path = "Rect/after_go/RectEveryDayTask"
local adv_go_path = "Rect/front_go/adv_go"
local title_bg_path = "Rect/after_go/titleBg"
local after_go_path = "Rect/after_go"
local front_go_path = "Rect/front_go"
local rect_go_path = "Rect/BG"
local this_path = ""

local toggleCount = 3

local AdvState =
{
    None = 0,--隐藏
    Pre = 1,--在最上层显示
}

local AnimName =
{
    In = "UITaskMain_movein1",--进入
    Out = "UITaskMain_moveout",--退出
    FlipIn = "Eff_Ani_zhangjie_In",--章节动画进入
}

local EffectTime = 1
local FlipPosition = Vector2.New(0, -15, 0)--翻转动画节点
local PrintTimeDelta = -1.0--打字提前一点
local CameraPhoneTime = 1.6--拍照片的声音

--创建
function UITaskMainView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UITaskMainView : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UITaskMainView : ComponentDefine()
    self.toggle1 = self:AddComponent(UIToggle,toggle_path..1)
    self.toggle2 = self:AddComponent(UIToggle,toggle_path..2)
    self.toggle3 = self:AddComponent(UIToggle,toggle_path..3)
    self.toggle1:SetIsOn(true)
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(1)
        end
    end)
    self.toggle2:SetIsOn(false)
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(2)
        end
    end)
    self.toggle3:SetIsOn(false)
    self.toggle3:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS(3)
        end
    end)
    self.toggleList = {}
    for i=1,toggleCount do
        local toggle = {}
        toggle.checkMark = self:AddComponent(UIImage, toggle_path..i.."/Background/Checkmark"..i)
        toggle.checkMark:SetActive(i == 1)
        toggle.text = self:AddComponent(UITextMeshProUGUIEx, toggle_path..i.."/text"..i)
        toggle.text:SetText(self:GetTitleTextByIndex(i))
        toggle.text:SetActive(i ~= 1)
        toggle.checkText = self:AddComponent(UITextMeshProUGUI, toggle_path..i.."/checkText"..i)
        toggle.checkText:SetText(self:GetTitleTextByIndex(i))
        toggle.checkText:SetActive(i == 1)
        toggle.redDot = self:AddComponent(UIBaseContainer, toggle_path..i.."/redDot"..i)
        toggle.redTxt = self:AddComponent(UITextMeshProUGUIEx, toggle_path..i.."/redDot"..i.."/redTxt"..i)
        table.insert(self.toggleList, toggle)
    end

    self.titleText = self:AddComponent(UITextMeshProUGUIEx, titleText_path)
    self.closeBtn = self:AddComponent(UIButton, CloseBtn_path)
    self.closeBtn2 = self:AddComponent(UIButton, CloseBtn2_path)
    self.closeBtn:SetOnClick(function()
        self.isClose = true
        self.ctrl:CloseSelf()
    end)
    self.closeBtn2:SetOnClick(function()
        self.isClose = true
        self.ctrl:CloseSelf()
    end)

    self.panelCloseBtn = self:AddComponent(UIButton, panelCloseBtn_path)
    self.panelCloseBtn:SetOnClick(function()
        self:OnCloseBtnClick()
    end)
    
    self.chapterTaskItem = self:AddComponent(ChapterTaskItem, chapterTaskItem_path)
    self.mainTaskItem = self:AddComponent(MainTaskItem, mainTaskItem_path)
    self.everyDayTaskItem = self:AddComponent(EveryDayTaskItem, everyDayTaskItem_path)
    self.adv_go = self:AddComponent(UITaskChapterAdv, adv_go_path)
    self.title_bg = self:AddComponent(UIBaseContainer, title_bg_path)
    self.front_go = self:AddComponent(UIBaseContainer, front_go_path)
    self.after_go = self:AddComponent(UIBaseContainer, after_go_path)
    self.flip_parent = self.after_go.transform.parent
    self.rect_img = self:AddComponent(UIImage, rect_go_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
end

function UITaskMainView : ComponentDestroy()
    self:ResetFlipParent()
end

function UITaskMainView : DataDefine()
    self.curTabType = -1
    self.playSound = false

    self.openToggle = tonumber(self:GetUserData())
    self.adv_state = AdvState.None
    self.showCloseEffect = false
    self.on_scene_load_callback = function()
        self:OnSceneLoadCallBack()
    end
    self.on_flip_finish_callback = function()
        self:OnFlipFinishCallBack()
    end
    self.enter_flip_anim_callback = function()
        self.adv_go:PlayPrint()
    end
    self.play_flip_camera_sound_callback = function()
        self:OnPlayFlipCameraSoundCallBack()
    end
    self.isClose = false
end

function UITaskMainView : DataDestroy()
    self.isClose = true
    DataCenter.WaitTimeManager:DeleteOneTimer(self.enter_flip_anim_callback)
    DataCenter.WaitTimeManager:DeleteOneTimer(self.play_flip_camera_sound_callback)
    self:CheckCloseDoEffect()
    self.curTabType = nil
    self.playSound = nil
end

function UITaskMainView : OnEnable()
    base.OnEnable(self)
    self:RefreshAll()
    self:DoEnterAnim()
end

function UITaskMainView : OnDisable()
    base.OnDisable(self)
end

function UITaskMainView : RefreshAll()
    self.chapterTaskItem:SetActive(false)
    self.mainTaskItem:SetActive(false)
    self.everyDayTaskItem:SetActive(false)
    
    local showChapterTask = DataCenter.ChapterTaskManager:CheckShowChapterTask()
    local showMainTask = DataCenter.TaskManager:CheckShowMainTask()
    local showEveryDayTask = DataCenter.DailyTaskManager:CheckShowEveryDayTask()
    self.toggle1:SetActive(showChapterTask)
    self.toggle2:SetActive(showMainTask)
    self.toggle3:SetActive(showEveryDayTask)
    if self.openToggle == 1 and showChapterTask then
        self:ToggleControlBorS(1)
        self.chapterTaskItem:SetActive(true)
        self.toggle1:SetIsOn(true)
        self.closeBtn:SetActive(false)
        self.closeBtn2:SetActive(true)
    elseif self.openToggle == 2 and showMainTask then
        self:ToggleControlBorS(2)
        self.mainTaskItem:SetActive(true)
        self.toggle2:SetIsOn(true)
        self.closeBtn:SetActive(true)
        self.closeBtn2:SetActive(false)
    else
        self:ToggleControlBorS(3)
        self.everyDayTaskItem:SetActive(true)
        self.toggle3:SetIsOn(true)
        self.closeBtn:SetActive(true)
        self.closeBtn2:SetActive(false)
    end
    -- 当只显示章节任务时不显示页签
    if showChapterTask and not showMainTask and not showEveryDayTask then
        self.toggle1:SetActive(false)
    end
    
    self:RefreshAllRedDot()
    self:GetEnterAdvState()
    self:RefreshAdv()
end

--页签切换
function UITaskMainView : ToggleControlBorS(index)
    if self.curTabType == index then
        return
    end

    if self.playSound then
        SoundUtil.PlayEffect("Effect_common_switch")
    else
        self.playSound = true
    end

    local title = self:GetTitleTextByIndex(index)
    self.titleText:SetText(title)
    
    self.curTabType = index
    for i=1,toggleCount do
        local toggle = self.toggleList[i]
        toggle.checkMark:SetActive(i == index)
        toggle.text:SetActive(i ~= index)
        toggle.checkText:SetActive(i == index)
    end

    if index == 1 then
        self.chapterTaskItem:ShowSelf()
    elseif index == 2 then
        self.mainTaskItem:ShowSelf()
    elseif index == 3 then
        self.everyDayTaskItem:ShowSelf()
    end

    self.closeBtn:SetActive(index ~= 1)
    self.closeBtn2:SetActive(index == 1)
    self.chapterTaskItem:SetActive(index == 1)
    self.mainTaskItem:SetActive(index == 2)
    self.everyDayTaskItem:SetActive(index == 3)
end

function UITaskMainView : GetTitleTextByIndex(index)
    if index == 1 then
        return Localization:GetString("430168")
    elseif index == 2 then
        return Localization:GetString("430169")
    elseif index == 3 then
        return Localization:GetString("170015")
    end
end

function UITaskMainView : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ChapterTask, self.OnChapterTask)
    self:AddUIListener(EventId.DailyQuestLs, self.RefreshEveryDayRedDot)
    self:AddUIListener(EventId.DailyQuestSuccess, self.RefreshEveryDayRedDot)
    self:AddUIListener(EventId.DailyQuestReward, self.RefreshEveryDayRedDot)
    self:AddUIListener(EventId.DailyQuestGetAllTaskReward, self.RefreshEveryDayRedDot)
    self:AddUIListener(EventId.MainTaskSuccess, self.RefreshMainRedDot)
end

function UITaskMainView : OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ChapterTask, self.OnChapterTask)
    self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshEveryDayRedDot)
    self:RemoveUIListener(EventId.DailyQuestSuccess, self.RefreshEveryDayRedDot)
    self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshEveryDayRedDot)
    self:RemoveUIListener(EventId.DailyQuestGetAllTaskReward, self.RefreshEveryDayRedDot)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshMainRedDot)
end

function UITaskMainView : RefreshChapterRedDot()
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
    self.toggleList[1].redDot:SetActive(count > 0)
    self.toggleList[1].redTxt:SetText(count)
end

function UITaskMainView : RefreshMainRedDot()
    if not self.isClose then
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
        self.toggleList[2].redDot:SetActive(count > 0)
        self.toggleList[2].redTxt:SetText(count)
    end
end

function UITaskMainView : RefreshEveryDayRedDot()
    if not self.isClose then
        local count = 0
        local showEveryDayTask = DataCenter.DailyTaskManager:CheckShowEveryDayTask()
        if showEveryDayTask then
            count = DataCenter.DailyTaskManager:GetRedNum()
        end
        self.toggleList[3].redDot:SetActive(count > 0)
        self.toggleList[3].redTxt:SetText(count)
        self.everyDayTaskItem:RefreshGetAllReward(count)
    end
end

function UITaskMainView : RefreshAllRedDot()
    self:RefreshChapterRedDot()
    self:RefreshMainRedDot()
    self:RefreshEveryDayRedDot()
end

function UITaskMainView : GetChapterBtnByTaskId(id)
    return self.chapterTaskItem:GetChapterBtnByTaskId(id)
end

function UITaskMainView : GetIsTween()
    return self.everyDayTaskItem:IsTween()
end

function UITaskMainView : OnChapterTask()
    if not self.isClose then
        if self.adv_state == AdvState.None then
            local showChapterTask = DataCenter.ChapterTaskManager:CheckShowChapterTask()
            local showMainTask = DataCenter.TaskManager:CheckShowMainTask()
            local showEveryDayTask = DataCenter.DailyTaskManager:CheckShowEveryDayTask()
            -- 当只显示章节任务时不显示页签
            if showChapterTask and not showMainTask and not showEveryDayTask then
                self.toggle1:SetActive(false)
            else
                self.toggle1:SetActive(true)
            end
            if showChapterTask and self.curTabType == 1 then
                self.chapterTaskItem:SetActive(true)
                self.chapterTaskItem:OnChapterTask()
            else
                self.chapterTaskItem:SetActive(false)
            end
            if not showChapterTask and self.curTabType == 1 then
                self:ToggleControlBorS(2)
            elseif showChapterTask then
                self:RefreshChapterRedDot()
            end

        end
    end
end

function UITaskMainView:RefreshAdv()
    if self.adv_state == AdvState.None then
        self.front_go:SetActive(false)
        self.after_go:SetActive(true)
        self.rect_img:LoadSprite("Assets/Main/TextureEx/UITaskMain/task_bg_di04.png")
        self.anim:Play(AnimName.In, 0, 0)
    elseif self.adv_state == AdvState.Pre then
        self.front_go:SetActive(true)
        self.after_go:SetActive(false)
        self.rect_img:LoadSprite("Assets/Main/TextureEx/UITaskMain/task_bg_di03.png")
        self.anim:Play(AnimName.FlipIn, 0, 0)
    else
        self.front_go:SetActive(false)
        self.after_go:SetActive(true)
        self.rect_img:LoadSprite("Assets/Main/TextureEx/UITaskMain/task_bg_di04.png")
        self.anim:Play(AnimName.In, 0, 0)
    end
end

--撕掉章节图
function UITaskMainView:PlayAnimChapterImg()
    if self.adv_state == AdvState.Pre then
        self.adv_state = AdvState.None

        if DataCenter.GuideManager:GetFlag(GuideTempFlagType.ChapterPlayFlip) ~= nil then
            self.adv_go:DoFlipAnim(self.on_scene_load_callback, self.on_flip_finish_callback, self.front_go, self.after_go)
        else
            self:OnFlipFinishCallBack()
        end
    end
end

--撕掉任务
function UITaskMainView:OnClickChapterRewardCallBack()
    DataCenter.TaskFlipManager:OnClickChapterReward()
    self.isClose = true
    self.ctrl:CloseSelf()
end

function UITaskMainView:CheckCloseDoEffect()
    if self.showCloseEffect then
        --显示光效
        local srcPos = CS.SceneManager.World:WorldToScreenPoint(CS.SceneManager.World.CurTarget)
        local destPos = DataCenter.UnlockBtnManager:GetUnlockBtnPosition(UnlockBtnType.Quest)
        DataCenter.FurnitureEffectManager:ShowOneFurnitureTrailEffect(srcPos, destPos, EffectTime, function()
            DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UITaskMainAnimBg, nil)
            EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
        end)
    end
end

function UITaskMainView:GetEnterAdvState()
    local guideParam = DataCenter.GuideManager:GetFlag(GuideTempFlagType.ChapterBg)
    if guideParam ~= nil then
        self.adv_state = AdvState.Pre
        local chapterId = guideParam.chapterId
        self.adv_go:ReInit({chapterId = chapterId})
        DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UITaskMainAnimBg, true)
        DataCenter.GuideManager:RemoveOneTempFlag(GuideTempFlagType.ChapterBg)
    end
end

function UITaskMainView:OnCloseBtnClick()
    if self.adv_state == AdvState.Pre then
        self.adv_go:OnBtnClick()
    elseif self.adv_state == AdvState.None then
        if not DataCenter.GuideManager:InGuide() then
            self.isClose = true
            self.ctrl.CloseSelf()
        end
    end
end

function UITaskMainView:ResetFlipParent()
    self.after_go.transform:SetParent(self.flip_parent)
    self.after_go.transform:SetAsLastSibling()
    self.after_go:SetLocalScale(ResetScale)
    self.after_go.transform:Set_anchoredPosition3D(FlipPosition.x, FlipPosition.y, FlipPosition.z)

    self.rect_img:SetEnable(true)
    self.front_go.transform:SetParent(self.flip_parent)
    self.front_go.transform:SetAsLastSibling()
    self.front_go:SetLocalScale(ResetScale)
    self.front_go.transform:Set_anchoredPosition3D(ResetPosition.x, ResetPosition.y, ResetPosition.z)
end

function UITaskMainView:OnSceneLoadCallBack()
    self.front_go:SetActive(true)
    self.after_go:SetActive(true)
    self.rect_img:SetEnable(false)
end

function UITaskMainView:OnFlipFinishCallBack()
    self:ResetFlipParent()
    self.adv_go:DestroyScene()
    self:RefreshAdv()
    DataCenter.GuideManager:RemoveOneTempFlag(GuideTempFlagType.ChapterPlayFlip)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UITaskMainAnimBg, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

function UITaskMainView:DoEnterAnim()
    if self.adv_state == AdvState.Pre then
        local ret, time = self.anim:GetAnimationReturnTime(AnimName.FlipIn)
        if ret then
            DataCenter.WaitTimeManager:AddOneWait(time + PrintTimeDelta, self.enter_flip_anim_callback)
            DataCenter.WaitTimeManager:AddOneWait(CameraPhoneTime, self.play_flip_camera_sound_callback)
        end
    else
        self.anim:Play(AnimName.In, 0, 0)
    end
end

function UITaskMainView:OnPlayFlipCameraSoundCallBack()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Chapter_Flip_Camera)
end

return UITaskMainView