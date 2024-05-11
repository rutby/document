---
--- Created by shimin.
--- DateTime: 2021/8/18 10:52
---
local GuideManager = BaseClass("GuideManager")
local Data = CS.GameEntry.Data
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local WaitLoadTime = 0.5
local WaitMessageLongTime = 5

--引导章节图状态
local GuideChapterSceneState =
{
    SetPre = 1,--设置在最上方的背景
    AnimQuest = 2,--做撕任务动画
    AnimChapter = 3,--做撕章节图动画
}  

local function __init(self)
    self.guideId = nil--正在进行的引导id  为nil表示没做过新手，设置新手开始id，为 -1表示引导结束
    self.template = nil --当前引导template
    self.hasDoneGuide = {}--已经做过的触发引导
    self.allTriggerGuide = {}--需要触发的引导 <触发类型,<任务id,引导id>>

    self.waitUIView = nil--需要等待的页面加载完成
    self.waitUIBtn = nil--需要等待的页面控件加载完成

    self.obj = nil
    self.objWorldPos = nil
    self.needParam = nil --判断引导完成需要的参数 建造代表建筑id

    
    self.waitingMessage = {}

    self.guideState = GuideCanDoType.Yes
    self.objPositionType = PositionType.Screen
    self.auto_next_timer_action = function(temp)
        self:AutoNextTimeCallBack()
    end
    self.wait_load_timer_action = function(temp)
        self:WaitLoadCallBack()
    end
    self.wait_time_timer_action = function(temp)
        self:WaitTimeCallBack()
    end
    self.wait_long_delay_timer_callback = function(temp)
        self:WaitLongDelayTimerCallBack()
    end

    self.guideEndCallBack = nil
    self.dubName = nil
    self.noGotoTime = false
    self:AddListener()
    self.isDebug = CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor
    self.effectSound = {}
    self.pveTrigger = {}
    self.specialTriggerGuide = {}
    self.successMarchFlag = SuccessMarchFlagType.No
    self.requestGm = nil
    self.waitTrigger = {}--等待回到主城/所有页面关闭后触发
    self.check_error_timer_callback = function()
        self:CheckErrorTimerCallBack()
    end

    self.movie_callback = function()
        self:MovieCallBack()
    end
    self.speech_talk_callback = function()
        self:SpeechTalkCallBack()
    end
    self.move_camera_callback = function()
        self:MoveCameraTimerCallBack()
    end
    self.noShowUIMain = GuideSetUIMainAnim.Show
    self.useGuideCameraConfig = false
    self.canShowRandomZombie = true--临时控制丧尸不显示
    self.saveWaitTrigger = {}
    self.guideTempFlag = {}--保存一些临时的数据
    self.guideCreateZombie = {}--引导生成的僵尸
end

local function __delete(self)
    -- 砍伐管理器
    self:DestroyGm()
    self:DeleteMoveCameraTimer()
    self:DeleteCheckErrorTimer()
    self:DeleteWaitLoadTimer()
    self:DeleteAutoNextTimer()
    self:DeleteWaitTimeTimer()
    self:DeleteWaitLongDelayTimer()
    self.guideId = nil
    self.template = nil
    self.hasDoneGuide = {}
    self.allTriggerGuide = {}
    self.auto_next_timer_action = nil
    self.waitUIView = nil
    self.waitUIBtn = nil
    self.obj = nil
    self.objPositionType = nil
    self.needParam = nil
    self.objWorldPos = nil
    self.guideState = nil
    self.waitingMessage = nil
    self.guideEndCallBack = nil
    self.dubName = nil
    self:RemoveListener()
    self.isDebug = nil
    self.noGotoTime = nil
    self.effectSound = nil
    self.pveTrigger = {}
    self.specialTriggerGuide = {}
    self.successMarchFlag = SuccessMarchFlagType.No
    self.waitTrigger = {}--等待回到主城/所有页面关闭后触发
end

local function Startup()
end

--服务器数据初始化
local function InitData(self,data)
    if self:InGuide() then
        --只要断线就重登
        CS.ApplicationLaunch.Instance:ReloadGame()
    else
        EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
        local guideRecord = data["guideRecord"]
        if guideRecord ~= nil then
            for k,v in pairs(guideRecord) do
                self.hasDoneGuide[k] = v
                self:ShowLog("shimin ------------------------- guideRecord ", k, "   ", v)
            end
        else
            self:ShowLog("shimin ++++++++++++++++++++++++ guideRecord == nil")
        end
        self:InitSaveWaitTrigger()
        self:ReInitTemplate()
        self:SetCurGuideId(self:GetSaveGuideId())
        EventManager:GetInstance():Broadcast(EventId.GuideInitFinish)
    end
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UILoadingExitSignal)--进入场景
    EventManager:GetInstance():AddListener(EventId.BuildPlace, self.BuildPlaceSignal)--放置建筑
    EventManager:GetInstance():AddListener(EventId.OpenUI, self.OpenUISignal)--打开UI
    EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)--队列完成
    EventManager:GetInstance():AddListener(EventId.Queue_Add, self.QueueAddSignal)--新获得队列
    EventManager:GetInstance():AddListener(EventId.OnClickWorld, self.OnClickWorldSignal)--点击世界
    EventManager:GetInstance():AddListener(EventId.OpenFogSuccess, self.OpenFogSuccessSignal)--解锁迷雾
    EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)--升级完成建筑
    EventManager:GetInstance():AddListener(EventId.ChapterTaskGetReward, self.ChapterTaskGetRewardSignal)--更新章节任务信息
    EventManager:GetInstance():AddListener(EventId.ShowAllGuideObject, self.ShowAllGuideObjectSignal)--显示所有Object
    EventManager:GetInstance():AddListener(EventId.CloseUI, self.CloseUISignal)--关闭UI
    EventManager:GetInstance():AddListener(EventId.ChapterTask, self.ChapterTaskSignal)--章节任务每个小任务成功领取奖励
    EventManager:GetInstance():AddListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessSignal)--成功加入联盟
    EventManager:GetInstance():AddListener(EventId.GuideWaitMessage, self.GuideWaitMessageSignal)--等待种鸵鸟消息
    EventManager:GetInstance():AddListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)--刷新主线任务
    EventManager:GetInstance():AddListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)--农田种植
    EventManager:GetInstance():AddListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)--点击
    EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.TrainingArmySignal)--
    EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceDataSignal)
    EventManager:GetInstance():AddListener(EventId.HospitalUpdate, self.HospitalUpdateSignal)--伤兵
    EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)--研究科技
    EventManager:GetInstance():AddListener(EventId.StartAttackMonsterWithoutMsgTip, self.StartAttackMonsterWithoutMsgTipSignal)--是否成功出征
    EventManager:GetInstance():AddListener(EventId.UpdateAlCanBeLeader, self.UpdateAlCanBeLeaderSignal)--是否能成为盟主
    EventManager:GetInstance():AddListener(EventId.GarbageCollectStart, self.GarbageCollectStartSignal)--咕噜行军到达
    if self.mergeExitBackCitySignal == nil then
        self.mergeExitBackCitySignal = function(param)
            self:MergeExitBackCitySignal(param)
        end
        EventManager:GetInstance():AddListener(EventId.MergeExitBackCity , self.mergeExitBackCitySignal)--退出合成
    end
    if self.buildUpgradeStartSignal == nil then
        self.buildUpgradeStartSignal = function(param)
            self:BuildUpgradeStartSignal(param)
        end
        EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart , self.buildUpgradeStartSignal)--建筑开始升级
    end
    if self.needRefreshGuideArrowSignal == nil then
        self.needRefreshGuideArrowSignal = function()
            self:NeedRefreshGuideArrowSignal()
        end
        EventManager:GetInstance():AddListener(EventId.NeedRefreshGuideArrow , self.needRefreshGuideArrowSignal)--重新
    end
    if self.pveLineUpInitEndSignal == nil then
        self.pveLineUpInitEndSignal = function()
            self:PveLineUpInitEndSignal()
        end
        EventManager:GetInstance():AddListener(EventId.PVE_Lineup_Init_End , self.pveLineUpInitEndSignal)--pve完全加载完
    end
    if self.pveLevelBeforeEnterSignal == nil then
        self.pveLevelBeforeEnterSignal = function()
            self:PveLevelBeforeEnterSignal()
        end
        EventManager:GetInstance():AddListener(EventId.PveLevelBeforeEnter , self.pveLevelBeforeEnterSignal)--进入pve
    end
    if self.onEnterWorldSignal == nil then
        self.onEnterWorldSignal = function()
            self:OnEnterWorldSignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterWorld , self.onEnterWorldSignal)--进入世界
    end
    if self.onEnterCitySignal == nil then
        self.onEnterCitySignal = function()
            self:OnEnterCitySignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterCity , self.onEnterCitySignal)--进入主城
    end
    if self.parkourBattleEnterCompleteSignal == nil then
        self.parkourBattleEnterCompleteSignal = function()
            self:ParkourBattleEnterCompleteSignal()
        end
        EventManager:GetInstance():AddListener(EventId.ParkourBattleEnterComplete , self.parkourBattleEnterCompleteSignal)--完全进入战斗
    end
    if self.detectInfoChangeSignal == nil then
        self.detectInfoChangeSignal = function()
            self:DetectInfoChangeSignal()
        end
        EventManager:GetInstance():AddListener(EventId.DetectInfoChange , self.detectInfoChangeSignal)--雷达事件更新
    end

end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UILoadingExitSignal)--进入场景
    EventManager:GetInstance():RemoveListener(EventId.BuildPlace, self.BuildPlaceSignal)--放置建筑
    EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.OpenUISignal)--打开UI
    EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)--队列完成
    EventManager:GetInstance():RemoveListener(EventId.Queue_Add, self.QueueAddSignal)--新获得队列
    EventManager:GetInstance():RemoveListener(EventId.OnClickWorld, self.OnClickWorldSignal)--点击世界
    EventManager:GetInstance():RemoveListener(EventId.OpenFogSuccess, self.OpenFogSuccessSignal)--解锁迷雾
    EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)--升级完成建筑
    EventManager:GetInstance():RemoveListener(EventId.ChapterTaskGetReward, self.ChapterTaskGetRewardSignal)--更新章节任务信息
    EventManager:GetInstance():RemoveListener(EventId.ShowAllGuideObject, self.ShowAllGuideObjectSignal)--显示所有Object
    EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.CloseUISignal)--关闭UI
    EventManager:GetInstance():RemoveListener(EventId.ChapterTask, self.ChapterTaskSignal)--章节任务每个小任务成功领取奖励
    EventManager:GetInstance():RemoveListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessSignal)--成功加入联盟
    EventManager:GetInstance():RemoveListener(EventId.GuideWaitMessage, self.GuideWaitMessageSignal)--等待种鸵鸟消息
    EventManager:GetInstance():RemoveListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)--刷新主线任务
    EventManager:GetInstance():RemoveListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)--农田种植
    EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)--点击
    EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.TrainingArmySignal)--
    EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceDataSignal)
    EventManager:GetInstance():RemoveListener(EventId.HospitalUpdate, self.HospitalUpdateSignal)--伤兵
    EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)--研究科技
    EventManager:GetInstance():RemoveListener(EventId.StartAttackMonsterWithoutMsgTip, self.StartAttackMonsterWithoutMsgTipSignal)--是否成功出征
    EventManager:GetInstance():RemoveListener(EventId.UpdateAlCanBeLeader, self.UpdateAlCanBeLeaderSignal)--是否能成为盟主
    EventManager:GetInstance():RemoveListener(EventId.GarbageCollectStart, self.GarbageCollectStartSignal)--咕噜行军到达
    if self.mergeExitBackCitySignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.MergeExitBackCity, self.mergeExitBackCitySignal)--退出合成
        self.mergeExitBackCitySignal = nil
    end
    if self.buildUpgradeStartSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.buildUpgradeStartSignal)--建筑开始升级
        self.buildUpgradeStartSignal = nil
    end
    if self.needRefreshGuideArrowSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.NeedRefreshGuideArrow, self.needRefreshGuideArrowSignal)--建筑开始升级
        self.needRefreshGuideArrowSignal = nil
    end
    if self.pveLineUpInitEndSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.PVE_Lineup_Init_End, self.pveLineUpInitEndSignal)--pve完全加载完
        self.pveLineUpInitEndSignal = nil
    end
    if self.pveLevelBeforeEnterSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.PveLevelBeforeEnter, self.pveLevelBeforeEnterSignal)--进入pve
        self.pveLevelBeforeEnterSignal = nil
    end
    if self.onEnterWorldSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.onEnterWorldSignal)--进入pve
        self.onEnterWorldSignal = nil
    end
    if self.onEnterCitySignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)--进入pve
        self.onEnterCitySignal = nil
    end
    if self.parkourBattleEnterCompleteSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.ParkourBattleEnterComplete, self.parkourBattleEnterCompleteSignal)--进入pve
        self.parkourBattleEnterCompleteSignal = nil
    end
    if self.detectInfoChangeSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.DetectInfoChange, self.detectInfoChangeSignal)--雷达事件更新
        self.detectInfoChangeSignal = nil
    end
end

--获取引导id
local function GetGuideId(self)
    return self.guideId
end

--设置引导id
local function SetCurGuideId(self,id)
    self:ShowLog("shimin +++++++++++++++++++++ SetCurGuideId ", id)
    self:DeleteMoveCameraTimer()
    self:DeleteCheckErrorTimer()
    self:DeleteWaitLoadTimer()
    self:DeleteAutoNextTimer()
    self:DeleteWaitTimeTimer()
    self:DeleteWaitLongDelayTimer()

    local lastGuideId = self.guideId
    local lastTemplate = self.template
    --保存上一条savedoneid
    if self.guideState == GuideCanDoType.Yes and lastTemplate ~= nil and lastTemplate.savedoneid ~= 0 then
        if not self:IsDoneThisGuide(lastTemplate.savedoneid) then
            self:SendSaveGuideMessage(self:GetDoneGuideEndId(lastTemplate.savedoneid),SaveGuideDoneValue)
            EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
        end
    end

    self.guideId = id
    self.waitUIView = nil
    self.waitUIBtn = nil
    self.obj = nil
    self.objWorldPos = nil
    self.objPositionType = PositionType.Screen
    self.needParam = {}
    if lastGuideId ~= nil then
        self:SendLogMessage(lastGuideId,StatTTType.Guide, id)
    end
    if lastTemplate ~= nil then
        if lastTemplate.gototime ~= "" and not self.noGotoTime then
            EventManager:GetInstance():Broadcast(EventId.GotoTime,lastTemplate.gototime)
        end
    end
    self.noGotoTime = false
    if id == GuideEndId then
        if CS.SceneManager.World ~= nil then
            if self.useGuideCameraConfig then
                self.useGuideCameraConfig = false
                if SceneUtils.GetIsInCity() then
                    DataCenter.CityCameraManager:UpdateCamera()--恢复正常限制
                end
            end
        end
        DataCenter.CityNpcManager:SetFollowNpc()
        if self.guideState == GuideCanDoType.Yes then
            self:SendSaveGuideMessage(SaveGuideId,tostring(id))
        end
        self:ShowLog("shimin +++++++++++++++++++++++ GuideEndId", GuideEndId)
        self.template = nil
        self.guideState = GuideCanDoType.Yes
        if self.guideEndCallBack ~= nil then
            self.guideEndCallBack()
            self.guideEndCallBack = nil
        end
        if self:InGuide() then
            EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
        else
            EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.Close)
        end

        EventManager:GetInstance():Broadcast(EventId.RefreshGuide)
        self:CheckStopDub()

        if DataCenter.BattleLevel:IsInBattleLevel() then
            DataCenter.BattleLevel:GuideEnd()
        end
        
        self:CheckDoSaveTrigger()
    else
        self.template = DataCenter.GuideTemplateManager:GetGuideTemplate(id)
        if self.template ~= nil then
            local canDo = true
            if self.template.tipswaittime[1] ~= nil and self.template.triggerType ~= 0 then
                if self:CanDoSaveTriggerType(id) then
                    self:RemoveSaveWaitTrigger(id)
                else
                    canDo = false
                    self:SaveWaitTrigger(id)
                    self:SetCurGuideId(GuideEndId)
                end
            end

            if canDo then
                self.guideState = self:GetCanDoGuideState(id)
                self:ShowLog("shimin +++++++++++++++++++ self.guideState", self.guideState)
                if self.guideState == GuideCanDoType.No then
                    if self.template.jumpid ~= 0 then
                        self:SetCurGuideId(self.template.jumpid)
                    else
                        self:SetCurGuideId(GuideEndId)
                    end
                else
                    if self.template.forcetype == GuideForceType.Soft and self.template.savedoneid ~= 0 then
                        if not self:IsDoneThisGuide(self.template.savedoneid) then
                            self:SendSaveGuideMessage(self:GetDoneGuideEndId(self.template.savedoneid),SaveGuideDoneValue)
                            EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
                        end
                    end
                    if self.template.returnstepid ~= 0 and self.template.returnstepid ~= self:GetSaveGuideId() then
                        --发送消息
                        self:SendSaveGuideMessage(SaveGuideId,tostring(self.template.returnstepid))
                    end
                    if self.template.type == GuideType.ClickButton and self.template.para1 ~= nil then
                        self.objPositionType = PositionType.Screen
                        local para = string.split_ss_array(self.template.para1,"/")
                        local paraCount = table.count(para)
                        if paraCount > 0 then
                            self.waitUIView = para[1]
                            local length = string.len(self.waitUIView)
                            self:ShowLog("shimin +++++++++++++++++++++++ self.waitUIView", self.waitUIView)
                            self.waitUIBtn = string.sub(self.template.para1,length + 2,string.len(self.template.para1))
                            self:ShowLog("shimin +++++++++++++++++++++++ self.waitUIBtn", self.waitUIBtn)
                        end
                    elseif self.template.type == GuideType.Bubble
                            or self.template.type == GuideType.GotoMoveBubble  or self.template.type == GuideType.ClickTimeLineBubble 
                            or self.template.type == GuideType.ClickLandZoneBubble or self.template.type == GuideType.ClickWoundedCompensateBubble then

                        self.objPositionType = PositionType.World
                    elseif (self.template.type == GuideType.OpenFog or self.template.type == GuideType.ClickBuild
                            or self.template.type == GuideType.QueueBuild or self.template.type == GuideType.ClickBuildFinishBox
                            or self.template.type == GuideType.ClickMonster
                            or self.template.type == GuideType.ClickGuideHdcBubble
                            or self.template.type == GuideType.ClickOpinionBox or self.template.type == GuideType.ClickLandLock)
                            and self.template.para1 ~= nil then
                        self.objPositionType = PositionType.World
                    elseif self.template.type == GuideType.ClickQuickBuildBtn then
                        self.objPositionType = PositionType.Screen
                    elseif self.template.type == GuideType.WaitTroopArrive then

                    elseif self.template.type == GuideType.ClickTime then
                        self.objPositionType = PositionType.World
                    elseif self.template.type == GuideType.ShowGuideTip then
                        if self.template.para2 ~= nil and self.template.para2 ~= "" then
                            local tempSpl = string.split_ss_array(self.template.para2,";")
                            if #tempSpl > 1 then
                                local btnType = tonumber(tempSpl[1])
                                if btnType == GuideType.ClickButton then
                                    self.objPositionType = PositionType.Screen
                                    local para = string.split_ss_array(tempSpl[2],"/")
                                    local paraCount = table.count(para)
                                    if paraCount > 0 then
                                        self.waitUIView = para[1]
                                    end
                                end
                            end
                        end
                    elseif self.template.type == GuideType.ClickRadarMonster then
                        self.objPositionType = PositionType.World
                    elseif self.template.type == GuideType.ClickCollectResource then
                        self.objPositionType = PositionType.World
                        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,tonumber(self.template.para1),0)
                    elseif self.template.type == GuideType.BlackHoleMask and self.template.para2 ~= nil and self.template.para2 ~= "" then
                        self.objPositionType = PositionType.Screen
                        local para = string.split_ss_array(self.template.para2, "/")
                        local paraCount = table.count(para)
                        if paraCount > 0 then
                            self.waitUIView = para[1]
                            local length = string.len(self.waitUIView)
                            self.waitUIBtn = string.sub(self.template.para2,length + 2,string.len(self.template.para2))
                        end
                    elseif self.template.type == GuideType.UIPathArrow and self.template.para2 ~= nil and self.template.para2 ~= "" then
                        self.objPositionType = PositionType.Screen
                        local para = string.split_ss_array(self.template.para2, "/")
                        local paraCount = table.count(para)
                        if paraCount > 0 then
                            self.waitUIView = para[1]
                            local length = string.len(self.waitUIView)
                            self.waitUIBtn = string.sub(self.template.para2,length + 2,string.len(self.template.para2))
                        end
                    end
                end

                if id == GuideStartId then
                    --清空所有引导信息
                    for k, v in pairs(self.hasDoneGuide) do
                        self:SendRemoveSaveGuide(k)
                    end
                    self:SendSaveGuideMessage(NoShowRandomZombie, SaveGuideDoneValue)
                    self:SendSaveGuideMessage(CanShowLand, SaveGuideDoneValue)
                    DataCenter.VitaManager:SendNewbieResident()
                    DataCenter.CityResidentManager:SetCanSpawnZombie(false)
                    local showCGType = ShowCGType.Show
                    local jumpPrologue = JumpPrologueType.NoJump
                    if self.template.type == GuideType.GuideStart then
                        if self.template.para1 ~= "" then
                            showCGType = tonumber(self.template.para1)
                        end
                        if self.template.para2 ~= "" then
                            jumpPrologue = tonumber(self.template.para2)
                        end
                    elseif self.template.type == GuideType.JumpPrologue then
                        jumpPrologue = JumpPrologueType.Jump
                    end

                    if showCGType == ShowCGType.Show then

                    else
                        if not AppStartupLoading:GetInstance():IsLoading() then
                            AppStartupLoading:GetInstance():CloseUILoading()
                        else
                            AppStartupLoading:GetInstance().isCanCloseLoading = true
                        end
                        DataCenter.GuideManager:DoGuide()
                    end

                    if jumpPrologue == JumpPrologueType.Jump then
                        if DataCenter.BuildManager.MainLv == 0 then
                            CS.BuildMainCityMessage.Instance:Send()
                        end
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain,{})
                    else
                        self:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
                        self:SendSaveGuideMessage(BeforePrologue,SaveGuideDoneValue)
                    end
                end
            end

            if self:InGuide() then
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
            else
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.Close)
            end
            --self:CheckStopDub()
            EventManager:GetInstance():Broadcast(EventId.RefreshGuide)
        end
    end
end

--获取上传的引导id
local function GetSaveGuideId(self)
    if self.hasDoneGuide ~= nil then
        local saveId = self.hasDoneGuide[SaveGuideId]
        if saveId ~= nil then
            return tonumber(saveId)
        end
    end
    if DataCenter.BuildManager.MainLv <= 1 and SceneUtils.GetIsInCity() then
        return GuideStartId
    end

    return GuideEndId
end

--保存已经触发过的引导
local function SendSaveGuideMessage(self,saveKey,saveValue)
    if self.hasDoneGuide[saveKey] ~= saveValue then
        self.hasDoneGuide[saveKey] = saveValue
        local param = {}
        param.saveKey = tostring(saveKey)
        param.saveValue = tostring(saveValue)
        SFSNetwork.SendMessage(MsgDefines.SaveGuide, param)
    end
end

--删除保存的key
function GuideManager:SendRemoveSaveGuide(saveKey)
    self:SendSaveGuideMessage(saveKey, "")
end

--发送做过的引导（只用于服务器输出日志）
local function SendLogMessage(self,id,statType,curId)
    local param = {}
    param.id = tostring(id)
    param.type = statType
    if curId == nil then
        curId = GuideEndId
    end
    param.curId = tostring(curId)
    SFSNetwork.SendMessage(MsgDefines.StatTT, param)
end

--是否在引导中
local function InGuide(self)
    return self.guideId ~= GuideEndId and self.template ~= nil
end

local function UILoadingExitSignal()
    DataCenter.GuideManager:CheckLoginGuide()
    --判断是否始于大本废弃状态
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil and mainBuild.state == BuildingStateType.FoldUp then
        DataCenter.GuideManager:SetCurGuideId(GuideEndId)
        DataCenter.GuideManager:DoGuide()
    else
        if DataCenter.GuideManager:InGuide() then
            DataCenter.GuideManager:DoGuide()
        else
            DataCenter.GuideManager:InitTriggerGuide()
        end
    end
    DataCenter.GuideManager:LoadGuideGm()
end

local function DoGuide(self)
    if self.template ~= nil then
        self:ShowLog("shimin ++++++++++++++++++++++++++++++ DoGuide", self.template.id)
        local loadResult = self:NeedWaitLoadComplete()
        if loadResult == GuideWaitLoadCompleteResult.Finish then
            self:DeleteWaitLongDelayTimer()
            self:DeleteWaitLoadTimer()
            --头像对话
            self:CheckTipsWaitTime()
            self:CheckNeedWaitTime()
        elseif loadResult == GuideWaitLoadCompleteResult.Wait then
            self:AddWaitLoadTimer()
            if self.waitLongDelayTimer == nil then
                local longTime = LuaEntry.DataConfig:TryGetNum("guide_overtime", "k1") / 1000
                if longTime > 0 then
                    self:AddWaitLongDelayTimer(longTime)
                end
            end
        elseif loadResult == GuideWaitLoadCompleteResult.NoNeedTimeWait then
            self:DeleteWaitLongDelayTimer()
            self:AddWaitLoadTimer()
        end
    end
end

local function BuildPlaceSignal(bUuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
        local param = {}
        param.buildId = buildData.itemId
        DataCenter.GuideManager:SetCompleteNeedParam(param)
        DataCenter.GuideManager:CheckGuideComplete()
        local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(param.buildId)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PlaceBuild, param.buildId .. ";" .. buildNum)
    end
end

local function CheckGuideComplete(self)
    if self.template ~= nil then
        if self.template.type == GuideType.ShowTalk then
            if self.needParam ~= nil and self.needParam.clickBtnObj ~= nil then
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickButton or self.template.type == GuideType.ClickQuickBuildBtn
                or self.template.type == GuideType.ClickRadarBubble  or self.template.type == GuideType.ClickUISpecialBtn then
            if self.obj == self.needParam.clickBtnObj then
                self:DoNext()
            end
        elseif self.template.type == GuideType.BuildPlace then
            if self.template.para1 ~= nil and self.needParam ~= nil then
                if tonumber(self.template.para1) == self.needParam.buildId then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.Bubble then
            if self.template.para2 ~= nil and self.needParam ~= nil then
                if BuildBubbleType[self.template.para2] == self.needParam.buildBubbleType then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.ClickBuildFinishBo or self.template.type == GuideType.ClickBuild then
            if self.template.para1 ~= nil and self.needParam ~= nil then
                if tonumber(self.template.para1) == self.needParam.buildId then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.ClickMonster then
            if self.template.para1 ~= nil and self.needParam ~= nil then
                local spl = string.split_ss_array(self.template.para1,",")
                if table.count(spl) > 1 then
                    local vec = {}
                    vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
                    vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
                    local pointId = SceneUtils.TilePosToIndex(vec)
                    if pointId == self.needParam.pointId then
                        self:DoNext()
                    end
                end
            end
        elseif self.template.type == GuideType.ClickTimeLineBubble or self.template.type == GuideType.ClickWoundedCompensateBubble  then
            if self.needParam ~= nil then
                if self.needParam.click then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.GotoMoveBubble then
            if self.needParam ~= nil then
                if self.needParam.click then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.OpenFog then
            if self.template.para1 ~= nil and self.needParam ~= nil then
                if Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1),tonumber(self.template.para2)) == self.needParam.pointId then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.WaitCloseUI then
            if self.needParam ~= nil then
                if self.needParam.uiName == self.template.para1 then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.ClickTime then
            if self.template.para2 ~= nil and self.needParam ~= nil then
                if tonumber(self.template.para2) == self.needParam.buildTimeType then
                    self:DoNext()
                end
            end
        elseif self.template.type == GuideType.ShowCommunicationTalk then
            if self.needParam ~= nil and self.needParam.clickBtnObj ~= nil then
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickCollectResource then
            if self.needParam ~= nil and (self.needParam.collectType == tonumber(self.template.para1) or self.needParam.point ~= nil) then
                self:DoNext()
            end
        elseif self.template.type == GuideType.WaitMarchFightEnd then
            if self.needParam ~= nil and self.needParam.waitMarchFightEnd then
                CS.SceneManager.World.marchUuid = 0
                DataCenter.WorldMarchDataManager:TrackMarch(0)
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickRadarMonster then
            if self.needParam ~= nil and self.needParam.monster then
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickGuideHdcBubble then
            if self.needParam ~= nil and self.needParam.guideHdc then
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickOpinionBox then
            if self.needParam ~= nil and self.needParam.clickOpinionBox then
                self:DoNext()
            end
        elseif self.template.type == GuideType.ClickLandLock or self.template.type == GuideType.ClickLandZoneBubble then
            if self.template.para1 ~= nil and self.needParam ~= nil then
                if tonumber(self.template.para1) == self.needParam.landId then
                    self:DoNext()
                end
            end
        end
    end
end

local function CheckOpenUITriggerGuide(self,uiName)
    if not self:InGuide() then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIPanel,uiName)
    end
end

--打开一个界面
local function OpenUISignal(uiName)
    DataCenter.GuideManager:CheckOpenUITriggerGuide(uiName)
    DataCenter.GuideManager:CheckDoSaveTrigger()
end

local function DeleteAutoNextTimer(self)
    if self.autoNextTimer ~= nil then
        self.autoNextTimer:Stop()
        self.autoNextTimer = nil
    end
end

local function AddAutoNextTimer(self,time)
    self:DeleteAutoNextTimer()
    if self.autoNextTimer == nil then
        self.autoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_next_timer_action , self, true,false,false)
        self.autoNextTimer:Start()
    end
end

local function AutoNextTimeCallBack(self)
    self:DeleteAutoNextTimer()
    if self.template ~= nil then
        self:DoNext()
    end
end

local function GetCurTemplate(self)
    return self.template
end

local function HasClick(self,obj)
    if self:InGuide() then
        self.needParam.clickBtnObj = obj
        self:CheckGuideComplete()
    end
end

--主UI加载完成才可以做
local function  NeedWaitLoadComplete(self)
    --大本0级升级不做引导
    local mainData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainData ~= nil and mainData.level == 0 and mainData.updateTime>0 then
        return GuideWaitLoadCompleteResult.Wait
    end

    if self.waitUIView ~= nil and self.waitUIView ~= "" then
        if not UIManager:GetInstance():IsWindowOpen(self.waitUIView) then
            return GuideWaitLoadCompleteResult.Wait
        end

        if not UIManager:GetInstance():IsPanelLoadingComplete(self.waitUIView) then
            return GuideWaitLoadCompleteResult.NoNeedTimeWait
        end
        if self.waitUIBtn ~= nil and self.waitUIBtn ~= "" then
            local trans = nil
            local luaWindow = UIManager:GetInstance():GetWindow(self.waitUIView)
            if luaWindow ~= nil and luaWindow.View ~= nil and luaWindow.View.transform ~= nil then
                trans = luaWindow.View.transform
            end
            if trans == nil then
                return GuideWaitLoadCompleteResult.Wait
            end
            self.obj = trans:Find(self.waitUIBtn)
            if self.obj == nil then
                return GuideWaitLoadCompleteResult.Wait
            end
        end
    elseif self.template.type == GuideType.ClickBuild and self.objWorldPos == nil then
        local buildId = tonumber(self.template.para1)
        local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if desTemplate ~= nil then
            self.objWorldPos = desTemplate:GetPosition()
        end
        if self.objWorldPos == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.QueueBuild and self.objWorldPos == nil then
        local queueType = tonumber(self.template.para1)
        local needPointId = nil
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
            local spl = string.split_ss_array(self.template.para2,",")
            if table.count(spl) > 1 then
                local vec = {}
                vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
                vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
                needPointId = SceneUtils.TilePosToIndex(vec)
            end
        end
        local list = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(queueType)
        if list ~= nil then
            for k ,v in pairs(list) do
                local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
                if buildData ~= nil then
                    if buildData.level > 0 then
                        if needPointId ~= nil then
                            if needPointId == buildData.pointId then
                                self.objWorldPos = buildData:GetCenterVec()
                                break
                            end
                        else
                            self.objWorldPos = buildData:GetCenterVec()
                            break
                        end
                    end
                end
            end
        end


        --if self.template.triggertype == GuideTriggerType.Queue then
        --    local list = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(queueType)
        --    if list ~= nil then
        --        for k ,v in pairs(list) do
        --            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
        --            if buildData ~= nil then
        --                if buildData.level > 0 then
        --                    self.objWorldPos = buildData:GetCenterVec()
        --                    break
        --                end
        --            end
        --        end
        --    end
        --elseif self.template.triggertype == GuideTriggerType.OwnQueue then
        --    local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
        --    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
        --    for k ,v in pairs(list) do
        --        if v.level > 0 then
        --            self.obj = CS.SceneManager.World:GetBuildingByPoint(v.pointId)
        --            break
        --        end
        --    end
        --end
        if self.objWorldPos == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.Bubble and self.obj == nil then
        local buildId = tonumber(self.template.para1)
        local bubbleType = BuildBubbleType[self.template.para2]
        self.obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(bubbleType,buildId)
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickMonster and self.obj == nil then
        local spl = string.split_ss_array(self.template.para1,",")
        if table.count(spl) > 1 then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
            local pointId = SceneUtils.TilePosToIndex(vec)
            local obj = CS.SceneManager.World:GetObjectByPointId(pointId)
            if obj ~= nil then
                cast(obj, typeof(CS.ModelManager.MonsterObject))
                self.obj = obj:GetObject()
            end
            if self.obj == nil then
                return GuideWaitLoadCompleteResult.Wait
            end

        end
    elseif self.template.type == GuideType.GotoMoveBubble and self.obj == nil then
        self.obj = DataCenter.GotoMoveBubbleManager:GetObject()
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickTimeLineBubble and self.obj == nil then
        local bubbleType = tonumber(self.template.para1)
        if bubbleType == GuideTimeLineBubbleType.OstrichEgg then
            self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowOstrichEgg)
        elseif bubbleType == GuideTimeLineBubbleType.Migrate then
            self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowMigrateScene)
        elseif bubbleType == GuideTimeLineBubbleType.Cow then
            self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowCowScene)
        end
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.OpenFog and self.objWorldPos == nil then
        local pointId = Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1),tonumber(self.template.para2))
        self.objWorldPos = SceneUtils.TileIndexToWorld(pointId)
    elseif self.template.type == GuideType.ClickQuickBuildBtn and self.obj == nil then

    elseif self.template.type == GuideType.ClickBuildFinishBox and self.objWorldPos == nil then
        local buildId = tonumber(self.template.para1)
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
        if list ~= nil then
            for k ,v in pairs(list) do
                if v:IsUpgradeFinish() then
                    self.objWorldPos = v:GetCenterVec()
                    GoToUtil.CloseAllWindows()
                    break
                end
            end
        end
        if self.objWorldPos == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickTime and self.obj == nil then
        local buildId = tonumber(self.template.para1)
        local timeType = tonumber(self.template.para2)
       
    elseif self.template.type == GuideType.ClickRadarBubble and self.obj == nil then
        local uiName = UIWindowNames.UIDetectEvent
        if not UIManager:GetInstance():IsWindowOpen(uiName) then
            return GuideWaitLoadCompleteResult.Wait
        end
        if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
            return GuideWaitLoadCompleteResult.NoNeedTimeWait
        end
        local luaWindow = UIManager:GetInstance():GetWindow(uiName)
        if luaWindow ~= nil and luaWindow.View ~= nil then
            if self.template.para3 ~= "" then
                self.obj = luaWindow.View:GetBubbleById(self.template.para3)
            else
                self.obj = luaWindow.View:GetGuideSpecialBubble(tonumber(self.template.para1),tonumber(self.template.para2))
            end
        end
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickUISpecialBtn and self.obj == nil then
        local btnType = tonumber(self.template.para1)
        if btnType == ClickUISpecialBtnType.UIFormationSelectHero then
            local uiName = UIWindowNames.UIFormationTableNew
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                self.obj = luaWindow.View:GetRemoveHeroGuideGameObj()
            end
        elseif btnType == ClickUISpecialBtnType.UIFormationDeleteHero then
            local uiName = UIWindowNames.UIFormationTableNew
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                self.obj = luaWindow.View:GetSecondRemoveHeroGuideGameObj()
            end
        elseif btnType == ClickUISpecialBtnType.UIFormationTableAddHero then
            local uiName = UIWindowNames.UIFormationTableNew
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                self.obj = luaWindow.View:GetAddHeroGuideGameObj()
            end
        elseif btnType == ClickUISpecialBtnType.UIPVESceneMinHeroRarity then
            local uiName = UIWindowNames.UIPVEScene
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local heroData = PveActorMgr:GetInstance():GetRarityMinHero()
                if heroData ~= nil then
                    local obj = luaWindow.View:GetHeroObjByHeroId(heroData.heroId)
                    if obj ~= nil then
                        self.obj = obj
                    end
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIPVESceneHeroId then
            local uiName = UIWindowNames.UIParkourFormation
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local heroId = tonumber(self.template.para2)
                local obj = luaWindow.View:GetHeroObjByHeroId(heroId)
                if obj ~= nil then
                    self.obj = obj
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIPVESceneHeroRarity then
            local uiName = UIWindowNames.UIPVEScene
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local heroRarity = tonumber(self.template.para2)
                local heroData = PveActorMgr:GetInstance():GetCanAddHeroByHeroRarity(heroRarity)
                if heroData ~= nil then
                    local obj = luaWindow.View:GetHeroObjByHeroId(heroData.heroId)
                    if obj ~= nil then
                        self.obj = obj
                    end
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIPVESceneMaxHeroRarity then
            local uiName = UIWindowNames.UIParkourFormation
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetMostRarityHeroNoInUse()
                if obj ~= nil then
                    self.obj = obj
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroListCanAdvanceHero then
            local uiName = UIWindowNames.UIHeroList
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetHeroCellAdvanceGuideBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIScience then
            local uiName = UIWindowNames.UIScience
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local scienceId = tonumber(self.template.para2)
                local obj = luaWindow.View:GetScienceGuideBtn(scienceId)
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIBuildUpgradeLackResource then
            local uiName = UIWindowNames.UIBuildUpgrade
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetGuideLackCellBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroAdvanceMainHero then
            local uiName = UIWindowNames.UIHeroAdvance
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetGuideCoreBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroAdvanceSubHero then
            local uiName = UIWindowNames.UIHeroAdvance
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetGuideDogFoodBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroListAdvanceHero then
            local uiName = UIWindowNames.UIHeroList
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetHeroCellMilitaryGuideBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroListHeroId then
            local uiName = UIWindowNames.UIHeroList
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local heroId = tonumber(self.template.para2)
                local obj = luaWindow.View:GetHeroItem(heroId)
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UIHeroListStarHero then
            local uiName = UIWindowNames.UIHeroList
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local obj = luaWindow.View:GetHeroCellStarGuideBtn()
                if obj ~= nil then
                    self.obj = obj.gameObject
                end
            end
        elseif btnType == ClickUISpecialBtnType.UITaskMainQuestBtn then
            local uiName = UIWindowNames.UITaskMain
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local taskId = self.template.para2
                self.obj = luaWindow.View:GetChapterBtnByTaskId(taskId)
            end
        elseif btnType == ClickUISpecialBtnType.UIFormationTableNewFreeSlot then
            local uiName = UIWindowNames.UIFormationTableNew
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                self.obj = luaWindow.View:GetAddFreeSlot()
            end
        elseif btnType == ClickUISpecialBtnType.UIFormationTableNewFreeHero then
            local uiName = UIWindowNames.UIFormationTableNew
            if not UIManager:GetInstance():IsWindowOpen(uiName) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                self.obj = luaWindow.View:GetAddFreeHero()
            end
        end

        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.WaitMarchFightEnd then
        local movePos = nil
        local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
        if allList ~= nil then
            for _, v in ipairs(allList) do
                if v.state == ArmyFormationState.March then
                    local buildId = MarchUtil.GetFormationBuildNameByIndex(v.index)
                    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
                    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
                        movePos = SceneUtils.TileIndexToWorld(buildList[1].pointId)
                        break
                    end
                end
            end
        end

        local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
        if #selfMarch == 0 then
            if movePos ~= nil then
                GoToUtil.GotoWorldPos(movePos)
            end
            return GuideWaitLoadCompleteResult.Wait
        else
            local troop = WorldTroopManager:GetInstance():GetTroop(selfMarch[1].uuid)
            if troop == nil  then
                GoToUtil.GotoWorldPos(selfMarch[1]:GetMarchCurPos())
                return GuideWaitLoadCompleteResult.Wait
            end
        end
    elseif self.template.type == GuideType.ClickRadarMonster and self.objWorldPos == nil then
        local info = nil
        if self.template.para1 ~= "" and self.template.para2 ~= "" then
            info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(tonumber(self.template.para1),tonumber(self.template.para2))
        elseif self.template.para3 ~= "" then
            info = DataCenter.RadarCenterDataManager:GetDetectEventInfoByEventId(self.template.para3)
        end
        local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(info.uuid)
        if marchInfo ~= nil then
            self.objWorldPos = SceneUtils.TileIndexToWorld(info.pointId)
        end
        if self.objWorldPos == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.WaitPanelOpen then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            if not UIManager:GetInstance():IsWindowOpen(self.template.para1) then
                return GuideWaitLoadCompleteResult.Wait
            end
            if not UIManager:GetInstance():IsPanelLoadingComplete(self.template.para1) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
        end
    elseif self.template.type == GuideType.AlliancePanelGuide then
        local uiName = UIWindowNames.UIAllianceMainTable
        if not UIManager:GetInstance():IsWindowOpen(uiName) then
            return GuideWaitLoadCompleteResult.Wait
        end
        if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
            return GuideWaitLoadCompleteResult.NoNeedTimeWait
        end
    elseif self.template.type == GuideType.WaitGolloesArrived then
        local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
        if worldMarch == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickLandZoneBubble and self.obj == nil then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local landId = tonumber(self.template.para1)
            local obj = DataCenter.LandManager:GetObject(LandObjectType.Zone, landId)
            if obj ~= nil then
                self.obj = obj:GetBubbleObj()
            end
            
            if self.obj == nil then
                return GuideWaitLoadCompleteResult.Wait
            end
        end
    elseif self.template.type == GuideType.ClickWoundedCompensateBubble and self.obj == nil then
        local bubble = DataCenter.WoundedCompensateManager:GetBubble()
        if bubble ~= nil then
            self.obj = bubble:GetGuideTrigger()
        end
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.ClickGuideHdcBubble and self.obj == nil then

    elseif self.template.type == GuideType.MoveCamera then
        if CS.SceneManager.World == nil or (not CS.SceneManager.World:IsBuildFinish()) then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.SetGuideQuestVisible then
        local uiName = UIWindowNames.UIMain
        if not UIManager:GetInstance():IsWindowOpen(uiName) then
            return GuideWaitLoadCompleteResult.Wait
        end
        if not UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
            return GuideWaitLoadCompleteResult.NoNeedTimeWait
        end
    elseif self.template.type == GuideType.ClickOpinionBox and self.obj == nil then
        self.obj = DataCenter.OpinionManager:GetGuideObj()
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    elseif self.template.type == GuideType.PlayMovie then
        local movieType = tonumber(self.template.para1)
        if movieType == GuidePlayMovieType.WorkEnterCity then
            if not DataCenter.CityResidentManager:CanDoGuide() then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            end
        end
    elseif self.template.type == GuideType.WaitBuildUpgradeFinish then
        local buildId = tonumber(self.template.para1)
        local level = tonumber(self.template.para2)
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, level) then
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil and (buildData:IsUpgrading() or buildData:IsUpgradeFinish()) then
                return GuideWaitLoadCompleteResult.NoNeedTimeWait
            else
                return GuideWaitLoadCompleteResult.Wait
            end
        end
    elseif self.template.type == GuideType.ClickLandLock and self.obj == nil then
        local landId = tonumber(self.template.para1)
        self.obj = DataCenter.LandManager:GetTriggerObject(LandObjectType.Block, landId)
        if self.obj == nil then
            return GuideWaitLoadCompleteResult.Wait
        end
    end
    return GuideWaitLoadCompleteResult.Finish
end

local function DeleteWaitLoadTimer(self)
    if self.waitLoadTimer ~= nil then
        self.waitLoadTimer:Stop()
        self.waitLoadTimer = nil
    end
end

local function AddWaitLoadTimer(self)
    self:DeleteWaitLoadTimer()
    if self.waitLoadTimer == nil then
        self.waitLoadTimer = TimerManager:GetInstance():GetTimer(WaitLoadTime, self.wait_load_timer_action , self, true,false,false)
        self.waitLoadTimer:Start()
    end
end

local function WaitLoadCallBack(self)
    self:DeleteWaitLoadTimer()
    self:DoGuide()
end

--获取引导类型
local function GetGuideType(self)
    if self:InGuide() then
        if self.template ~= nil then
            return self.template.type
        end
    end
    return 0
end

--保存验证完成的参数
local function SetCompleteNeedParam(self,param)
    self.needParam = param
end

--通过触发类型和触发参数获取引导id
local function GetGuideIdByTrigger(self,triggerType,TriggerPara)
    if triggerType ~= nil and TriggerPara ~= nil then
        if self.allTriggerGuide[triggerType] ~= nil then
            local guideId = self.allTriggerGuide[triggerType][TriggerPara]
            if guideId ~= nil and not self:IsDoneThisGuide(guideId) then
                if self:InGuide() then
                    local saveTrigger = GetTableData(DataCenter.GuideTemplateManager:GetTableName(), guideId, "tipswaittime", {})
                    if saveTrigger[1] ~= nil and saveTrigger[1] ~= "" then
                        self:SaveWaitTrigger(guideId)
                    end
                else
                    return guideId
                end
            end
        end
    end
end

--获取当前引导的配置参数
local function GetGuideTemplateParam(self,paramPara)
    if self.template ~= nil and paramPara ~= nil then
        return self.template[paramPara]
    end
end

--是否可以关闭界面
local function IsCanCloseUI(self,uiName)
    return true
end
--是否可以退出聚焦
local function IsCanQuitFocus(self)
    return true
end

--队列完成信号
local function QueueTimeEndSignal(queueType)
    if queueType ~= nil then
        local id = tostring(queueType)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Queue,id)
        if queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
            DataCenter.GuideManager:CheckWaitMessage()
        end
    end
end

--新获得队列信号
local function QueueAddSignal(queueType)
    if queueType ~= nil then
        local id = tostring(queueType)
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OwnQueue,id)
    end
end

local function InitTriggerGuide(self)
    self:CheckFirstJoinAllianceGuide()
    self:CheckTreatSoldierGuide()
    local season = SeasonUtil.GetSeason()
    if season ~= nil then
        self:CheckDoTriggerGuide(GuideTriggerType.SeasonLogin, tostring(season))
    end
end

--获取当前引导的配置参数
local function GetNextGuideTemplateParam(self,paramPara)
    if self.template ~= nil and paramPara ~= nil and self.template.nextid ~= GuideEndId then
        local nextTemplate = DataCenter.GuideTemplateManager:GetGuideTemplate(self.template.nextid)
        if nextTemplate ~= nil then
            return nextTemplate[paramPara]
        end
    end
end

local function OnClickWorldSignal(pointId)
    local point = tonumber(pointId)
    local param = {}
    param.pointId = point
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
end

local function OpenFogSuccessSignal(fogId)
    if fogId ~= nil then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenFog,tostring(fogId))
    end
end

local function BuildUpgradeFinishSignal(uuid)
    if uuid ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(uuid))
        if buildData ~= nil then
            local buildId = buildData.itemId
            local level = buildData.level
            local num = DataCenter.BuildManager:GetOwnNumByBuildIdAndLevel(buildId, level)
            local triggerType = buildId..",".. level .. ";" .. num
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.BuildUpgrade,triggerType)
        end
    end
end

local function GetDoneGuideEndId(self,guideId)
    return tostring(guideId).."end"
end

local function GetDoneGuideStartId(self,guideId)
    return tostring(guideId).."start"
end

local function IsDoneThisGuide(self,guideId)
    return self.hasDoneGuide[self:GetDoneGuideEndId(guideId)] == SaveGuideDoneValue
end

local function PlayMovieCompleteSignal(data)
    if DataCenter.GuideManager:InGuide() then
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil and template.type == GuideType.PlayMovie then
            GuideManager:DoNext()
        end
    end
end

local function CheckDoTriggerGuide(self,guideTriggerType,triggerPara)
    local triggerPara = self:GetSpecialTriggerPara(guideTriggerType,triggerPara)
    local guideId = self:GetGuideIdByTrigger(guideTriggerType,triggerPara)
    if guideId ~= nil then
        self:SetCurGuideId(guideId)
        self:DoGuide()
        self:RemoveOneWaitTrigger(guideTriggerType, triggerPara)
        return true
    end
    return false
end

local function SaveFinalGarbageRewardItemId(self,itemId)
    self:SendSaveGuideMessage(FinalGarbageRewardItemId,tostring(itemId))
end

local function GetFinalGarbageRewardItemId(self)
    return self:GetSaveGuideValue(FinalGarbageRewardItemId)
end

local function GetSaveGuideValue(self,keyName)
    return self.hasDoneGuide and self.hasDoneGuide[keyName]
end

local function ChapterTaskGetRewardSignal(chapterId)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ChapterQuestAfterReward,tostring(chapterId))
end

--剧情引导期间显示主UI
local function IsCanDoUIMainAnim(self)
    --播放timeline需要全部隐藏
    return self.noShowUIMain == GuideSetUIMainAnim.Show
end

local function SetNoShowUIMain(self,isNoShow)
    if self.noShowUIMain ~= isNoShow then
        if isNoShow == GuideSetUIMainAnim.Hide then
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
            self.noShowUIMain = isNoShow
        elseif isNoShow == GuideSetUIMainAnim.Show then
            self.noShowUIMain = isNoShow
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        elseif isNoShow == GuideSetUIMainAnim.StayTop then
            local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                luaWindow.View:PlayAnim(UIMainAnimType.LeftRightBottomHide)
            end
            self.noShowUIMain = isNoShow
        elseif isNoShow == GuideSetUIMainAnim.StayTopLeft then
            local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                luaWindow.View:PlayAnim(UIMainAnimType.OutStayTopLeft)
            end
            self.noShowUIMain = isNoShow
        end
    end
end

local function IsStartCanShowBuild(self)
    return not self.isNoShowBuild
end

local function SetCanShowBuild(self,isShow)
    self.isNoShowBuild = not isShow
end

local function ShowAllGuideObjectSignal()
    DataCenter.GuideManager:SetCanShowBuild(true)
end

--关闭一个界面
local function CloseUISignal(uiName)
    if DataCenter.GuideManager:GetGuideType() == GuideType.WaitCloseUI then
        local param = {}
        param.uiName = uiName
        DataCenter.GuideManager:SetCompleteNeedParam(param)
        DataCenter.GuideManager:CheckGuideComplete()
    end
    DataCenter.GuideManager:DoWaitTriggerAfterBack()
    if not UIManager:GetInstance():HasWindow() then
        DataCenter.GuideManager:CheckDoSaveTrigger()
    end
end

local function CheckNeedWaitTime(self)
    if self.template ~= nil and self.template.waittime > 0 then
        self:AddWaitTimeTimer(self.template.waittime / 1000)
    else
        self:WaitTimeCallBack()
    end
end

local function DeleteWaitTimeTimer(self)
    if self.waitTimeTimer ~= nil then
        self.waitTimeTimer:Stop()
        self.waitTimeTimer = nil
    end
end

local function AddWaitTimeTimer(self,time)
    self:DeleteWaitTimeTimer()
    if self.waitTimeTimer == nil then
        self.waitTimeTimer = TimerManager:GetInstance():GetTimer(time, self.wait_time_timer_action , self, true,false,false)
        self.waitTimeTimer:Start()
    end
end

local function WaitTimeCallBack(self)
    self:DeleteWaitTimeTimer()
    self:CallBackDoGuide()
end

local function ChapterTaskSignal()

end

local function MainTaskSuccessSignal()
    local list = DataCenter.TaskManager:GetCanReceivedList()
    if list ~= nil then
        for k,v in ipairs(list) do
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.TaskFinish,tostring(v))
        end
    end
end

local function CheckFirstJoinAllianceGuide(self)
    if not self:InGuide() then
        if LuaEntry.Player.isFirstJoin == FirstJoinAllianceType.Yes and LuaEntry.Player:IsInAlliance() then
            self:CheckDoTriggerGuide(GuideTriggerType.FirstJoinAlliance,FirstJoinAllianceValue)
        end
    end
end

local function AllianceApplySuccessSignal(self)
    DataCenter.GuideManager:CheckFirstJoinAllianceGuide()
end

local function IsStartId(self)
    return self.guideId == GuideStartId
end

--获取做引导的状态
local function GetCanDoGuideState(self,guideId)
    local curTemplate = DataCenter.GuideTemplateManager:GetGuideTemplate(guideId)
    if curTemplate ~= nil then
        local state = GuideCanDoType.Yes
        for k5,v5 in ipairs(curTemplate.jumptype) do
            if curTemplate.jumppara[k5] ~= nil then
                state = self:GetReachJumpState(v5,string.split_ss_array(curTemplate.jumppara[k5],";"))
            end
            if state ~= GuideCanDoType.Yes then
                return state
            end
        end
    end

    return GuideCanDoType.Yes
end

--内部函数，每个跳过条件是否满足
local function GetReachJumpState(self,jumpType,jumpPara)
    local jumpCount = jumpPara == nil and 0 or table.count(jumpPara)
    if jumpType == GuideJumpType.BuildPlace then
        if jumpCount > 0 then
            local buildId = tonumber(jumpPara[1])
            if jumpCount > 1 then
                local spl = string.split_ii_array(jumpPara[2],",")
                if table.count(spl) > 1 then
                    local vec = {}
                    vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
                    vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
                    local pointId = SceneUtils.TilePosToIndex(vec)
                    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId, false)
                    if buildData ~= nil and buildData.itemId == buildId then
                        return GuideCanDoType.No
                    end
                    local isCanPut = BuildingUtils.IsCanPutDownByBuild(buildId,pointId)
                    if isCanPut ~= BuildPutState.Ok then
                        return GuideCanDoType.No
                    end
                end
            end
            local buildState = DataCenter.BuildManager:GetBuildState(buildId)
            if buildState ~= BuildState.BUILD_LIST_STATE_OK then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.QueueBuild then
        local result = GuideCanDoType.No
        if jumpCount > 0 then
            local queueType = tonumber(jumpPara[1])
            local needPointId = nil
            if jumpCount > 1 then
                local spl = string.split_ii_array(jumpPara[2],",")
                if table.count(spl) > 1 then
                    local vec = {}
                    vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
                    vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
                    needPointId = SceneUtils.TilePosToIndex(vec)
                end
            end
            local list = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(queueType)
            if list ~= nil then
                for k ,v in pairs(list) do
                    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
                    if buildData ~= nil then
                        if buildData.level > 0 then
                            if needPointId ~= nil then
                                if needPointId == buildData.pointId then
                                    result = GuideCanDoType.Yes
                                    break
                                end
                            else
                                result = GuideCanDoType.Yes
                                break
                            end
                        end
                    end
                end
            end
        end
        return result
    elseif jumpType == GuideJumpType.WaitMessageFinish then
        if jumpCount > 0 then
            local waitType = tonumber(jumpPara[1])
            if self.waitingMessage[waitType] then
                return GuideCanDoType.Yes
            else
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.ClickTime then
        if jumpCount > 1 then
            local buildId = tonumber(jumpPara[1])
            local timeType = tonumber(jumpPara[2])
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            if list ~= nil then
                if timeType == BuildTimeType.BuildTime_pasture then
                    for k,v in pairs(list) do
                        local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(v.uuid)
                        if queueList == nil or table.count(queueList) == 0 then
                            return GuideCanDoType.No
                        end
                        for k1,v1 in pairs(queueList) do
                            if v1:GetQueueState() == NewQueueState.Work then
                                return GuideCanDoType.Yes
                            end
                        end
                    end
                elseif timeType == BuildTimeType.BuildTime_Upgrading then
                    local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
                    for k,v in pairs(list) do
                        if v.updateTime > curTime and v.level >= 0 then
                            return GuideCanDoType.Yes
                        end
                    end
                elseif timeType == BuildTimeType.BuildTime_CarSoldier or timeType == BuildTimeType.BuildTime_FootSoldier
                        or timeType == BuildTimeType.BuildTime_BowSoldier or timeType == BuildTimeType.BuildTime_Trap then
                    local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId))
                    if queue ~= nil then
                        local state = queue:GetQueueState()
                        if state == NewQueueState.Work then
                            return GuideCanDoType.Yes
                        end
                    end
                end
            end
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.ClickBuild then
        if jumpCount > 0 then
            local buildId = tonumber(jumpPara[1])
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            if list ~= nil then
                local needPointId = nil
                if jumpCount > 1 then
                    local spl = string.split_ii_array(jumpPara[2],",")
                    if table.count(spl) > 1 then
                        local vec = {}
                        vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
                        vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
                        needPointId = SceneUtils.TilePosToIndex(vec)
                    end
                end
                local result = GuideCanDoType.No
                for k ,v in pairs(list) do
                    if needPointId == nil or needPointId == v.pointId then
                        result = GuideCanDoType.Yes
                    end
                end
                return result
            end
        end
    elseif jumpType == GuideJumpType.WaitCloseUI then
        if jumpCount > 0 then
            if not UIManager:GetInstance():IsWindowOpen(jumpPara[1]) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.BuildLevel then
        if jumpCount > 0 then
            local spl = string.split_ii_array(jumpPara[1],",")
            if table.count(spl) > 1 then
                local level = DataCenter.BuildManager:GetMaxBuildingLevel(CommonUtil.GetBuildBaseType(spl[1]))
                if level <= CommonUtil.GetBuildLv(spl[2]) and level >= CommonUtil.GetBuildLv(spl[1]) then
                    return GuideCanDoType.Yes
                else
                    return GuideCanDoType.No
                end
            end
        end
    elseif jumpType == GuideJumpType.QueueState then
        if jumpCount > 1 then
            local queueType = tonumber(jumpPara[1])
            local queueState = tonumber(jumpPara[2])
            local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
            if queue ~= nil then
                local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queue.funcUuid)
                if buildData ~= nil then
                    local state = queue:GetQueueState()
                    if state == queueState and buildData.state == BuildingStateType.Normal then
                        return GuideCanDoType.Yes
                    end
                end
            end
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.AllianceMember then
        local member = DataCenter.AllianceMemberDataManager:GetNearMember()
        if member == nil then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.DoneGuide then
        if jumpCount > 0 then
            for k,v in ipairs(jumpPara) do
                if not self:IsDoneThisGuide(tonumber(v)) then
                    return GuideCanDoType.Yes
                end
            end
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.CityPointType then
        if jumpCount > 1 then
            local cityType = tonumber(jumpPara[2])
            local spl = string.split_ss_array(jumpPara[1],",")
            if table.count(spl) > 1 then
                local vec = {}
                vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
                vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
                local pointId = SceneUtils.TilePosToIndex(vec)
                local type = DataCenter.CityPointManager:GetPointType(pointId)
                if type ~= cityType then
                    return GuideCanDoType.No
                end
            end
        end
    elseif jumpType == GuideJumpType.HasBuild then
        if jumpCount > 0 then
            local buildId = tonumber(jumpPara[1])
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            if list ~= nil then
                local needPointId = nil
                if jumpCount > 1 then
                    local spl = string.split_ii_array(jumpPara[2],",")
                    if table.count(spl) > 1 then
                        local vec = {}
                        vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
                        vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
                        needPointId = SceneUtils.TilePosToIndex(vec)
                    end
                end
                local result = GuideCanDoType.No
                for k ,v in pairs(list) do
                    if needPointId == nil or needPointId == v.pointId then
                        result = GuideCanDoType.Yes
                    end
                end
                return result
            end
        end
    elseif jumpType == GuideJumpType.RadarEvent then
        if jumpCount > 0 then
            local info = DataCenter.RadarCenterDataManager:GetDetectEventInfoByEventId(tonumber(jumpPara[1]))
            if info == nil or info.state == DetectEventState.DETECT_EVENT_STATE_REWARDED then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.AllianceLeader then
        if (not LuaEntry.Player:IsInAlliance()) or (not DataCenter.AllianceBaseDataManager:IsSelfLeader()) then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.TreatSoldier then
        if not DataCenter.HospitalManager:IsHaveInjuredSolider() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.BuildState then
        if jumpCount > 1 then
            local buildId = tonumber(jumpPara[1])
            local guideBuildState = tonumber(jumpPara[2])
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData == nil then
                return GuideCanDoType.No
            end
            if guideBuildState == GuideBuildState.Normal then
                if buildData.state == BuildingStateType.Normal and not buildData:IsUpgrading()
                        and not buildData:IsUpgradeFinish() and not buildData:IsInFix() then
                    return GuideCanDoType.Yes
                end
            elseif guideBuildState == GuideBuildState.Box then
                if buildData:IsUpgradeFinish() and not buildData:IsInFix() then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.PveHasUseBattleHero then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        if isInBattle then
            if jumpCount > 0 then
                local pveHasUseBattleHeroType = tonumber(jumpPara[1])
                if pveHasUseBattleHeroType == PveHasUseBattleHeroType.Any then
                    --两个页面满足其一即可
                    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVEScene) then
                        if PveActorMgr:GetInstance():GetCanAddHero() then
                            return GuideCanDoType.Yes
                        end
                    else
                        if DataCenter.BattleLevel:GetCanAddHero() then
                            return GuideCanDoType.Yes
                        end
                    end
                elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroId then
                    if jumpCount > 1 then
                        local heroId = tonumber(jumpPara[2])
                        if heroId ~= 0 then
                            if PveActorMgr:GetInstance():GetCanAddHeroByHeroId(heroId) then
                                return GuideCanDoType.Yes
                            end
                        end
                    end
                elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroQuality then
                    if jumpCount > 1 then
                        local heroRarity = tonumber(jumpPara[2])
                        if heroRarity ~= nil then
                            if PveActorMgr:GetInstance():GetCanAddHeroByHeroRarity(heroRarity) ~= nil then
                                return GuideCanDoType.Yes
                            end
                        end
                    end
                elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroIdWithoutMax then
                    if jumpCount > 1 then
                        local heroId = tonumber(jumpPara[2])
                        if heroId ~= 0 then
                            if PveActorMgr:GetInstance():IsHeroExistByHeroId(heroId) then
                                return GuideCanDoType.Yes
                            end
                        end
                    end
                elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroQualityWithoutMax then
                    if jumpCount > 1 then
                        local heroRarity = tonumber(jumpPara[2])
                        if heroRarity ~= nil then
                            if PveActorMgr:GetInstance():IsHeroExistByHeroRarity(heroRarity) ~= nil then
                                return GuideCanDoType.Yes
                            end
                        end
                    end
                elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroMaxQualityWithoutMax then
                    if PveActorMgr:GetInstance():IsExistMoreRarityHero() then
                        return GuideCanDoType.Yes
                    end
                end
            end

        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.PveBattleMinHeroRarity then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        if isInBattle then
            if jumpCount > 0 then
                local heroRarity = tonumber(jumpPara[1])
                local heroData = PveActorMgr:GetInstance():GetRarityMinHero()
                if heroData ~= nil and heroData.rarity >= heroRarity then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.HasCanAdvanceHero then
        if not DataCenter.HeroDataManager:HasBeyondHero() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HasOutRangeLevelHero then
        if jumpCount > 0 then
            local maxLevel = tonumber(jumpPara[1])
            local curLevel = DataCenter.HeroDataManager:GetHighestHeroLevel()
            if curLevel > maxLevel then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.HaveAlliance then
        if jumpCount > 0 then
            local state = tonumber(jumpPara[1])
            local have = LuaEntry.Player:IsInAlliance()
            if have and state == HaveAllianceType.No then
                return GuideCanDoType.No
            elseif not have and state == HaveAllianceType.Yes then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.IsFormationUnset then
        if jumpCount > 0 then
            local index = tonumber(jumpPara[1])
            if DataCenter.ArmyFormationDataManager:IsFormationUnsetByIndex(index) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.IsSuccessMarch then
        if self.successMarchFlag == SuccessMarchFlagType.No then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HaveMonsterReward then
        local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
        if list ~= nil or table.count(list) > 0 then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            for k,v in ipairs(list) do
                if curTime <= v.expireTime then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.GetMonsterRewardBagFull then
        local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
        if list ~= nil or table.count(list) > 0 then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            for k,v in ipairs(list) do
                if curTime <= v.expireTime then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.Bubble then
        if jumpCount > 1 then
            local buildId = tonumber(jumpPara[1])
            local bubbleType = BuildBubbleType[jumpPara[2]]
            if DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(bubbleType,buildId) == nil then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.AttackLevelMonster then
        if jumpCount > 0 then
            local level = tonumber(jumpPara[1])
            if DataCenter.MonsterManager:GetCurCanAttackMaxLevel() < level then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.FinishChapter then
        if jumpCount > 0 then
            local needChapterId = tonumber(jumpPara[1])
            if DataCenter.ChapterTaskManager:IsCompleteAllChapter() == false then
                local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
                if chapterId ~= nil and chapterId <= needChapterId then
                    return GuideCanDoType.No
                end
            end
        end
    elseif jumpType == GuideJumpType.HaveLeaderInAlliance then
        if (not LuaEntry.Player:IsInAlliance()) or (DataCenter.AllianceBaseDataManager:CheckIfCanPayAsLeader()) then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.OwnResourceNum then
        if jumpCount > 1 then
            local num = LuaEntry.Resource:GetCntByResType(tonumber(jumpPara[1]))
            if num < tonumber(jumpPara[2]) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.PveTaskNotUnCompleteState then
        if jumpCount > 1 then
            local taskId = jumpPara[2]
            local pveTaskList = DataCenter.TaskManager:GetPVETaskById(tonumber(jumpPara[1]))
            if pveTaskList ~= nil then
                for k,v in pairs(pveTaskList) do
                    if v.id == taskId and v.state == TaskState.NoComplete then
                        return GuideCanDoType.Yes
                    end
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.HaveUpgradeHero then
        if jumpCount > 0 then
            if not HeroAdvanceController:GetInstance():HasHeroCanAdvance(tonumber(jumpPara[1])) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.HistoryUpgradeHero then
        if HeroAdvanceController:GetInstance():HasHeroAdvanced() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.BuildBubble then
        if jumpCount > 1 then
            local buildId = tonumber(jumpPara[1])
            local bubbleType = BuildBubbleType[jumpPara[2]]
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            for k,v in ipairs(list) do
                local param = DataCenter.BuildBubbleManager:GetBuildNeedShowBuildBubble(v.uuid)
                if param ~= nil and param.buildBubbleType == bubbleType then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.SceneType then
        if jumpCount > 0 then
            local sceneType = tonumber(jumpPara[1])
            if sceneType == GuideSceneType.City then
                if not SceneUtils.GetIsInCity() then
                    return GuideCanDoType.No
                end
            elseif sceneType == GuideSceneType.World then
                if not SceneUtils.GetIsInWorld() then
                    return GuideCanDoType.No
                end
            elseif sceneType == GuideSceneType.Pve then
                if not DataCenter.BattleLevel:IsInBattleLevel() then
                    return GuideCanDoType.No
                end
            end
        end
    elseif jumpType == GuideJumpType.HasStarUpHero then
        if DataCenter.HeroDataManager:hasStarUpHero() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HasCanStarUpHero then
        if not DataCenter.HeroDataManager:hasCanStarUpHero() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.PveBattleResult then
        if jumpCount > 0 then
            local result = tonumber(jumpPara[1])
            if DataCenter.BattleLevel:IsInBattleLevel() and PveActorMgr:GetInstance():GetBattleResult() == result then
                return GuideCanDoType.Yes
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.OwnItemNum then
        if jumpCount > 1 then
            local itemId = tonumber(jumpPara[1])
            local num = DataCenter.ItemData:GetItemCount(itemId)
            if num < tonumber(jumpPara[2]) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.ShowQuestId then
        if jumpCount > 0 then
            local taskId = jumpPara[1]
            if not DataCenter.ChapterTaskCellManager:CheckIdIsShow(taskId) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.WorldCollectPoint then
        local resourceType = 0
        local itemId = 0
        if jumpCount > 1 then
            itemId = tonumber(jumpPara[2])
        end
        if jumpCount > 0 then
            resourceType = tonumber(jumpPara[1])
        end
        local state = MarchUtil.GetResourcePointUnlockStateByType(resourceType, itemId)
        if state == 0 then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.UIPVEPowerLack then
        if jumpCount > 0 then
            local needType = tonumber(jumpPara[1])
            if not UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEPowerLack) then
                return GuideCanDoType.No
            end
            local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEPowerLack)
            if luaWindow == nil or luaWindow.View == nil or not luaWindow.View:HasTip(needType) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.HasAlliance then
        if not LuaEntry.Player:IsInAlliance() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.AllianceOwnCity then
        if jumpCount > 0 then
            local needCount = tonumber(jumpPara[1])
            local ownCount = DataCenter.WorldAllianceCityDataManager:GetAlCityCount()
            if needCount <= ownCount then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.HasAllianceCenter then
        if DataCenter.AllianceMineManager:CheckIfHasAllianceCenter() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.IsR4OrR5 then
        if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.OwnDesertCount then
        if jumpCount > 0 then
            local needCount = tonumber(jumpPara[1])
            local ownCount = DataCenter.DesertDataManager:GetSelfSeverDesert()
            if needCount <= ownCount then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.Season then
        if jumpCount > 0 then
            local season = SeasonUtil.GetSeason()
            local spl = string.split_ii_array(jumpPara[1],",")
            if spl[2] ~= nil and season ~= nil then
                if spl[1] <= season and season <= spl[2] then
                    return GuideCanDoType.Yes
                end
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.InPveLevelId then
        if jumpCount > 0 then
            local levelId = tonumber(jumpPara[1])
            local curId = DataCenter.BattleLevel.levelId
            if levelId ~= curId then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.Activity then
        if jumpCount > 0 then
            local actId = jumpPara[1]
            if not DataCenter.ActivityListDataManager:IsActivityOpen(actId) then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.FirstPay then
        local k1 = LuaEntry.DataConfig:TryGetNum("first_pay", "k3")
        if DataCenter.BuildManager.MainLv < k1 then
            return GuideCanDoType.No
        else
            local firstPayStatus = DataCenter.PayManager:GetFirstPayStatus()
            if firstPayStatus ~= 0 then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.StoryReward then
        local mapId = tonumber(jumpPara[1])
        local stage = tonumber(jumpPara[2])
        local mapData = DataCenter.StoryManager:GetMapData(mapId)
        if mapData ~= nil then
            local info = mapData.stageInfoList[stage]
            if info ~= nil and info.state == StoryStageRewardState.Normal and mapData.finishLevel >= info.needLevel then
                return GuideCanDoType.Yes
            end
        end
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.IsNewDailyActivity then
        if not DataCenter.DailyActivityManager:CheckSwitchNew() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.IsOpenBooster then
        local data = DataCenter.VitaManager:GetData()
        if data == nil or data.furnaceState ~= VitaDefines.FurnaceState.OpenWithBooster then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.IsFinishMeal then
        if DataCenter.CityResidentMovieManager.cookFinishFlag then
            -- 已经做完饭
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.IsFurnitureLevel then
        local buildId = tonumber(jumpPara[1])
        local furnitureId = tonumber(jumpPara[2])
        local index = tonumber(jumpPara[3])
        local level = tonumber(jumpPara[4])
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil then
            if level == 0 then
                return GuideCanDoType.No
            end
        else
            local furnitureData = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(buildData.uuid, furnitureId, index)
            if furnitureData == nil then
                if level == 0 then
                    return GuideCanDoType.No
                end
            else
                if level == furnitureData.lv then
                    return GuideCanDoType.No
                end
            end
        end
    elseif jumpType == GuideJumpType.BuildWorkerNum then
        local buildId = tonumber(jumpPara[1])
        local workNum = tonumber(jumpPara[2])
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil then
            if workNum == 0 then
                return GuideCanDoType.No
            end
        else
            local count = 0
            local furnitureInfoList = DataCenter.FurnitureManager:GetFurnitureListByBUuid(buildData.uuid)
            for _, furnitureInfo in ipairs(furnitureInfoList) do
                local furnitureResidentDataList = DataCenter.VitaManager:GetResidentDataListByFurnitureUuid(furnitureInfo.uuid)
                count = count + #furnitureResidentDataList
            end
            if count == workNum then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.BetweenPveLevel then
        local startId = tonumber(jumpPara[1])
        local endId = tonumber(jumpPara[2])
        local cur = DataCenter.LandManager:GetCurrentOrder(LandObjectType.Zone)
        if cur >= startId and cur <= endId then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.NoFinishLandOrder then
        local landOrder = tonumber(jumpPara[1])
        if not DataCenter.LandManager:IsBlockUnlocked(landOrder) then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.FinishParkour then
        local id = tonumber(jumpPara[1])
        if not DataCenter.LandManager:IsBlockUnlocked(id) then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.IsResidentCome then
        local state = tonumber(jumpPara[1])
        if state == ResidentComeJumpType.Bubble then
            local hudItem = DataCenter.CityHudManager:GetHudItemByType(CityHudType.ReadyQueue)
            if hudItem == nil then
                return GuideCanDoType.No
            end
        elseif state == ResidentComeJumpType.People then
            if not DataCenter.CityResidentManager:IsResidentQueueCome() then
                return GuideCanDoType.No
            end
        end
    elseif jumpType == GuideJumpType.HaveAnyPanel then
        if UIManager:GetInstance():HasWindow() then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.UIFormationTableNewViewNoAddHero then
        local uiName = UIWindowNames.UIFormationTableNew
        if UIManager:GetInstance():IsPanelLoadingComplete(uiName) then
            local luaWindow = UIManager:GetInstance():GetWindow(uiName)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                if luaWindow.View:CanAddHero() then
                    return GuideCanDoType.Yes
                end
            end
        end
        
        return GuideCanDoType.No
    elseif jumpType == GuideJumpType.QuestHasReward then
        local taskId = jumpPara[1]
        local task = DataCenter.TaskManager:FindTaskInfo(taskId)
        if task == nil then
            local taskInfo = DataCenter.ChapterTaskManager:FindTaskInfo(taskId)
            if taskInfo == nil or taskInfo.state == TaskState.Received then
                return GuideCanDoType.No
            end
        elseif task ~= nil and task.state == TaskState.Received then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HeroLevel then
        local heroId = tonumber(jumpPara[1])
        local level = tonumber(jumpPara[2])
        local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
        if heroData ~= nil and heroData.level >= level then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.LandBlockState then
        local landId = tonumber(jumpPara[1])
        local needState = jumpPara[2]
        local state = DataCenter.LandManager:GetState(LandObjectType.Block, landId)
        if state ~= needState then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.ClickPay then
        if self:GetFlag(GuideTempFlagType.ClickPay) ~= nil then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HeroCurLevelMax then
        local heroId = tonumber(jumpPara[1])
        local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
        if heroData ~= nil then
            local maxLevel = HeroUtils.GetHeroCurrentMaxLevel(heroData.heroId, heroData.quality, heroData:GetCurMilitaryRankId())
            if heroData.level >= maxLevel then
                return GuideCanDoType.No
            end
        else
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.OwnHero then
        local heroId = tonumber(jumpPara[1])
        local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
        if heroData == nil then
            return GuideCanDoType.No
        end
    elseif jumpType == GuideJumpType.HaveUpLevelHero then
        local heroDataList = DataCenter.HeroDataManager:GetMasterHeroList()
        for k, v in pairs(heroDataList) do
            local maxLevel = HeroUtils.GetHeroCurrentMaxLevel(v.heroId, v.quality, v:GetCurMilitaryRankId())
            if v.level < maxLevel then
                return GuideCanDoType.Yes
            end
        end
        return GuideCanDoType.No
    end

    return GuideCanDoType.Yes
end

local function IsCanClick(self,curIndex)
    if self:InGuide() then
        if self.template ~= nil then
            if self.template.type == GuideType.OpenFog then
                if Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1),tonumber(self.template.para2)) ~= curIndex then
                    return false
                end
            end
        end
    end
    return true
end

local function GuideWaitMessageSignal()
    DataCenter.GuideManager:CheckWaitMessage()
end

local function CheckWaitMessage(self)
    if self:InGuide() then
        if self.template ~= nil and self.template.type == GuideType.WaitMessageFinish then
            if self.template.para1 ~= nil and self.template.para1 ~= "" then
                local guideId = self.template.returnstepid
                local waitType = tonumber(self.template.para1)
                if false then
                    -- deleted
                else
                    guideId = self.template.nextid
                end

                if not self.waitingMessage[waitType] then
                    self:SetCurGuideId(guideId)
                    self:DoGuide()
                end
            end
        end
    end
end

local function DoNext(self)
    if self.template ~= nil then
        self:SetCurGuideId(self.template.nextid)
        self:DoGuide()
    end
end

local function LoadGuideGm(self)
    if self.requestGm == nil then
        self.requestGm = ResourceManager:InstantiateAsync(UIAssets.GuideGM)
        self.requestGm:completed('+', function()
            if self.requestGm.isError then
                return
            end
            self.requestGm.gameObject:SetActive(true)
            self.requestGm.gameObject.transform:SetAsFirstSibling()
        end)
    end
end

local function DestroyGm(self)
    if self.requestGm ~= nil then
        self.requestGm:Destroy()
        self.requestGm = nil
    end
end

--设置等待的消息
local function SetWaitingMessage(self,waitType,value)
    self.waitingMessage[waitType] = value
end

local function SaveRecommendShow(self,value)
    self:SendSaveGuideMessage(SaveGuideRecommendShow,value)
end

local function GetRecommendShow(self)
    return self:GetSaveGuideValue(SaveGuideRecommendShow)
end

local function BuildResourcesStartSignal()
    if CS.SceneManager:IsInCity() then
        local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
        if buildIdList == nil or table.count(buildIdList) == 0 then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.NoFreeQueue,tostring(NewQueueType.Field))
        end
    end
end

local function OnWorldInputPointDownSignal(pointId)
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.ShowTroopTalk then
        DataCenter.GuideManager:DoNext()
    end
end

local function SetGuideEndCallBack(self,callBack)
    if self:InGuide() then
        self.guideEndCallBack = callBack
    else
        callBack()
    end
end

--检测主城迁世界加入联盟引导
local function CheckMoveToWorldGuide(self)
    if LuaEntry.Player:IsInAlliance() then
        self:CheckDoTriggerGuide(GuideTriggerType.MoveToWorldJoinAlliance,MoveToWorldJoinAllianceType.Join)
    else
        self:CheckDoTriggerGuide(GuideTriggerType.MoveToWorldJoinAlliance,MoveToWorldJoinAllianceType.No)
    end
end

local function CheckNoInput(self)
    local template = self:GetCurTemplate()
    if template ~= nil and template.forcetype == GuideForceType.Force then
        local guideType = template.type
        if guideType == GuideType.WaitCloseUI then
            if SceneUtils.GetIsInPve() then
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.Close)
            else
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoScene)
            end
        elseif guideType == GuideType.WaitMessageFinish then
            local waitType = tonumber(template.para1)
            if waitType == WaitMessageFinishType.UITaskMainAnimBg then
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoScene)
            else
                EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
            end
        elseif guideType == GuideType.ClickBuild or guideType == GuideType.QueueBuild or guideType == GuideType.Bubble
                or guideType == GuideType.GotoMoveBubble
                or guideType == GuideType.OpenFog or guideType == GuideType.ClickBuildFinishBox or guideType == GuideType.ClickTime
                or guideType == GuideType.ClickMonster
                or guideType == GuideType.ClickTimeLineBubble
                or guideType == GuideType.ClickCollectResource
                or guideType == GuideType.CollectUISpecialGuide
                or guideType == GuideType.PveShowBattleSpeedBtn or guideType == GuideType.PveShowBattleFinishBtn
                or guideType == GuideType.PveShowBattlePowerLight or guideType == GuideType.PveShowBattleBloodLight 
                or guideType == GuideType.ClickRadarMonster
                or guideType == GuideType.PveShowStaminaLight or guideType == GuideType.ClickLandZoneBubble 
                or guideType == GuideType.ClickWoundedCompensateBubble 
                or guideType == GuideType.ClickGuideHdcBubble
                or guideType == GuideType.ClickOpinionBox or guideType == GuideType.ClickLandLock then
            EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.Close)
        elseif guideType == GuideType.ClickButton or guideType == GuideType.UnlockBtn
                or guideType == GuideType.ClickQuickBuildBtn or guideType == GuideType.ClickRadarBubble
                or guideType == GuideType.ClickUISpecialBtn  or guideType == GuideType.WaitQuestionEnd or guideType == GuideType.ShowFakeHero
                or guideType == GuideType.AlliancePanelGuide then
            EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoScene)
        else
            EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
        end
    else
        EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.Close)
    end
end


local function CheckStopDub(self)
    local template = self:GetCurTemplate()
    if self.dubName ~= nil and (template == nil or template.dub == nil or template.dub == "") then
        self:StopDub()
    end
end

local function CheckPlayDub(self)
    local template = self:GetCurTemplate()
    if template ~= nil and template.dub ~= nil and template.dub ~= "" and template.dub ~= self.dubName then
        self:PlayDub(template.dub)
    end
end

local function StopDub(self)
    if self.dubName ~= nil then
        SoundUtil.StopDubSound()
        self.dubName = nil
    end
end

local function PlayDub(self,name)
    SoundUtil.StopDubSound()
    self.dubName = name
    SoundUtil.PlayDub(name)
end

local function CheckCanDragGuide(self,inputTilePos,para1)
    local splist = string.split_ss_array(para1,",")
    if #splist>1 then
        local tilePos = {}
        local mainPos = BuildingUtils.GetMainPos()
        tilePos.x = mainPos.x + tonumber(splist[1])
        tilePos.y = mainPos.y + tonumber(splist[2])
        local inputTile = {}
        inputTile.x = inputTilePos.x
        inputTile.y = inputTilePos.y
        local list = BuildingUtils.GetAllNeighborsPos(tilePos,2)
        if list~=nil and list[tilePos]~=nil and tilePos.x == inputTile.x and tilePos.y == inputTile.y then
            return true
        end
    end
end


local function CheckTipsWaitTime(self)
    self:TipsWaitTimeCallBack()
end


local function TipsWaitTimeCallBack(self)
    if self.template.tipspic ~= nil and self.template.tipspic ~= "" then
        local param = {}
        param.modelName = self.template.tipspic
        if self.template.tipsdialog ~= nil and self.template.tipsdialog ~= "" then
            param.dialog = Localization:GetString(self.template.tipsdialog)
        end
        if self.template.tipsdirection ~= nil and self.template.tipsdirection ~= "" then
            param.modelPosition = tonumber(self.template.tipsdirection)
        end
        param.isGuide = true
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk,{ anim = true,playEffect  = false}, param)
        else
            EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, param)
        end
    end
end

function GuideManager:GetRealAniName(buildname, aniname)
    if (buildname ~= "WasteLand_MainBuilding") then
        return ""
    end

    local function IsContain(name)
        if (self.m_tmpList == nil) then
            return false
        end
        for _, v in pairs(self.m_tmpList) do
            if (v == name) then
                return true
            end
        end
        return false
    end

    if (aniname == "lv1_show" or aniname == "lv2_show" or aniname == "lv3_show" or aniname == "lv4_show" or aniname == "lv5_show") then
        self.m_tmpList = {}
    end
    if (self.m_tmpList == nil) then
        self.m_tmpList = {}
    end
    self.m_tmpList[#self.m_tmpList+1] = aniname
    if (aniname == "lv1_car1_show") then
        if (IsContain("lv1_car2_show")) then
            return "lv1_car2_show"
        else
            return "lv1_car1_show"
        end
    elseif aniname == "lv3_storehouse1_show" then
        if (IsContain("lv3_storehouse2_show")) then
            return "lv3_storehouse2_show"
        else
            return "lv3_storehouse1_show"
        end
    elseif aniname == "lv4_storehouse1_lv2_show" then
        if (IsContain("lv4_storehouse2_lv2_show")) then
            return "lv4_storehouse2_lv2_show"
        else
            return "lv4_storehouse1_lv2_show"
        end
    elseif (aniname == "lv1_car2_show") then
        if (IsContain("lv1_car1_show")) then
            return aniname
        else
            return "lv1_car2_show_only"
        end
    elseif (aniname == "lv3_storehouse2_show") then
        if (IsContain("lv3_storehouse1_show")) then
            return aniname
        else
            return "lv3_storehouse2_show_only"
        end
    elseif (aniname == "lv4_storehouse2_lv2_show") then
        if (IsContain("lv4_storehouse1_lv2_show")) then
            return aniname
        else
            return "lv4_storehouse2_lv2_show_only"
        end
    else
        return ""
    end
end

local function CallBackDoGuide(self)
    self:CheckNoInput()
    self:CheckPlayDub()
    if self.template == nil then
        return
    end

    if self.template.type == GuideType.GuideStart then
        local jumpPrologue = JumpPrologueType.NoJump
        if self.template.para2 ~= "" then
            jumpPrologue = tonumber(self.template.para2)
        end

        if jumpPrologue == JumpPrologueType.Jump then
            CommonUtil.PlayGameBgMusic()
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowTalk then
        local param = {}
        if self.template.para1 ~= "" then
            param.time = tonumber(self.template.para1) / 1000
        end
        if self.template.para2 ~= "" then
            local spl = string.split_ss_array(self.template.para2, ",")
            local spl2 = string.split_ss_array(spl[1], ";")
            local spl2Count = #spl2
            if spl2Count > 1 then
                local list = {}
                for i = 2, spl2Count, 1 do
                    local dialogType = tonumber(spl2[i])
                    if dialogType == GuideTalkDialogType.AllianceName then
                        local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
                        if allianceData ~= nil then
                            table.insert(list, allianceData.allianceName)
                        end
                    end
                end
                param.dialog = Localization:GetString(spl2[1], table.unpack(list))
            else
                param.dialog = Localization:GetString(spl[1])
            end
            param.modelName = spl[2]
            param.name = Localization:GetString(spl[3]) 
            param.modelPosition = tonumber(spl[4])
            if spl[5] ~= nil and spl[5] ~= "" then
                local spl5 = string.split_ss_array(spl[5], ";")
                param.spineName = spl5[1]
                param.spineAnimName = spl5[2]
                param.spineFlipX = tonumber(spl5[3])
                param.spineScale = tonumber(spl5[4]) or 1
            end
        end
        
        if self.template.para3 ~= "" then
            local spl = string.split_ss_array(self.template.para3, "|")
            if spl[1] ~= "" then
                param.bg = string.format(LoadPath.UIGuideEx, spl[1])
            end
            if spl[2] ~= nil then
                param.bgAlpha = tonumber(spl[2])
            end
        end

        if self.template.para4 ~= "" then
            param.emojiParam = self.template.para4
        end
     
        --打开对话
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTalk) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTalk,{ anim = true, UIMainAnim = UIMainAnimType.AllHide, playEffect = false}, param)
        else
            EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
        end
    elseif self:IsGuideArrowType() then
        --点击按钮强弱都打开箭头面板
        local param = {}
        param.guideType = self.template.type
        param.obj = self.obj
        param.objPositionType = self.objPositionType
        param.objWorldPos = self.objWorldPos
        param.forceType = self.template.forcetype
        param.arrowType = self.template.arrowtype or GuideArrowStyle.Finger
        param.showCircleType = self.template.showcircletype
        param.arrowDirection = self.template.arrowdirection
        param.animSpeed = self.template.para5 == "" and 1 or tonumber(self.template.para5)
        param.useGuide = true
        if self.template.type == GuideType.ClickBuild then
            param.isBuild = true
            param.buildId = tonumber(self.template.para1)
        else
            param.isBuild = false
        end
        if self.template.para4 ~= "" then
            param.des = Localization:GetString(self.template.para4)
        end
        if self.template.type == GuideType.ClickQuickBuildBtn then
            param.noAddClick = true
        end
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            local spl = string.split_ff_array(self.template.para3, ",")
            if #spl >= 2 then
                param.fingerOffset = Vector3.New(spl[1], spl[2], 0)
            end
        end
        param.moveCamera = self.template.type == GuideType.ClickBuildFinishBox
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideArrow) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideArrow,{ anim = false, playEffect = false}, param)
        else
            EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
        end
    elseif self.template.type == GuideType.PlayMovie then
        --播放剧情
        --通用逻辑 
        if self.template.para5 ~= nil and self.template.para5 ~= "" then
            local param = {}
            param.gotoGuideId = tonumber(self.template.para5)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump,{anim = false, playEffect = false}, param)
        end
        if self.template.para1 ~= nil then
            local movieType = tonumber(self.template.para1)
            if movieType == GuidePlayMovieType.MoveToWorld then
                if LuaEntry.Player:GetMainWorldPos() < 0 then
                    GoToUtil.CloseAllWindows()
                    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.TrainSpeedFree then
                EventManager:GetInstance():Broadcast(EventId.GuideChangeFreeSpeedBtn)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.StartStormScene then
                --开启暴风雪
                if DataCenter.StormManager:GetStormState() == StormState.No then
                    DataCenter.StormManager:SendStartNewbieStorm()
                else
                    self:SendSaveGuideMessage(WaitStartNextStorm, SaveGuideDoneValue)
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.WorkEnterCity then
                --小人进村
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.Begin, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.FireAndZombieOut then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ZombieEscape)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResetGuideControlWork then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ReleaseResident)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.SawyerWork then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.SawyerWork, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ChefWork then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ChefWork, self.movie_callback, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentEat then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ResidentEat, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.UnlockTaskBtn then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_Unclock)
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnlockBtnPanel, {anim = true}, UnlockBtnType.Quest)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentHide then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ResidentHide)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ZombieCome then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ZombieCome, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.HeroAttack then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.HeroAttack, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.UnlockStatsBtn then
                if self.template.para2 == "" then
                    EventManager:GetInstance():Broadcast(EventId.RefreshUIMainBtn, UIMainBtnType.StaticBtn)
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentCome then
                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ResidentCome, self.movie_callback)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ShowRandomZombie then
                self:SendRemoveSaveGuide(NoShowRandomZombie)
                DataCenter.CityResidentManager:SetCanSpawnZombie(true)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.UnlockLandScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.UnlockLandScene
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.BaseLightRangeScene then
                DataCenter.BuildManager:CheckShowFogUnlock(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.BellScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.BellScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.SecondNightScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.SecondNightScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.HuntLodgeScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.HuntLodgeScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ShowSecondNightZombieScene then
                DataCenter.CityResidentMovieManager:ClearAttackWaitZombie()
                local zombieUuid = DataCenter.CityResidentManager:GetNextZombieUuid()
                local zombieParam = {}
                zombieParam.prefabPath = "Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_Movie.prefab"
                DataCenter.CityResidentManager:AddData(zombieUuid, CityResidentDefines.Type.Zombie, zombieParam, function()
                    -- 僵尸移动
                    local zombieData = DataCenter.CityResidentManager:GetData(zombieUuid)
                    zombieData:SetGuideControl(true)
                    zombieData:SetSpeed(DataCenter.CityResidentManager:GetZombieWalkSpeed())
                    zombieData:PlayAnim(CityResidentDefines.AnimName.Walk1)
                    zombieData:SetPos(Vector3.New(98.136,0,100.381))
                    zombieData:GoToPosDirectly(Vector3.New(99.018,0,100.395))
                    zombieData.zombieStamina = 1
                    local callback = function()
                        if zombieData ~= nil then
                            zombieData.onFinish = nil
                            if not zombieData:IsDead() then
                                zombieData:PlayAnim(CityResidentDefines.AnimName.Idle)
                                zombieData:WaitForFinish(1.667)
                                zombieData.onFinish = function()
                                    if zombieData ~= nil then
                                        zombieData.onFinish = nil
                                        if not zombieData:IsDead() then
                                            zombieData:PlayAnim(CityResidentDefines.AnimName.Attack1)
                                            zombieData:WaitForFinish(1.5)
                                            zombieData.onFinish = zombieData.loopCallBack
                                        end
                                    end
                                end
                            end
                        end
                    end
                    zombieData.loopCallBack = callback
                    zombieData.onFinish = zombieData.loopCallBack
                    DataCenter.CityResidentMovieManager:AddOneAttackWaitZombie(zombieData)
                end)
                
                self:DoNext()
            elseif movieType == GuidePlayMovieType.BurnResidentScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.BurnResidentScene
                param.state = tonumber(self.template.para2)
                param.id = tonumber(self.template.para3)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentEnterCityScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.ResidentEnterCityScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentComeScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.ResidentComeScene
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.TollScene then
                DataCenter.BellManager:Toll(tonumber(self.template.para2))
                self:DoNext()
            elseif movieType == GuidePlayMovieType.BaseBuildLightRangeScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.BaseBuildLightRangeScene
                local scale = tonumber(self.template.para2)
                param.startScale = Vector3.New(scale, scale, scale)
                scale = tonumber(self.template.para3)
                param.endScale = Vector3.New(scale, scale, scale)
                DataCenter.EffectSceneManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.UIResidentDeadScene then
                local param = {}
                param.buildId = tonumber(self.template.para2)
                self:AddOneTempFlag(GuideTempFlagType.VitaDead, param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ChapterBgScene then
                local state = tonumber(self.template.para2)
                if state == GuideChapterSceneState.SetPre then
                    local param = {}
                    param.chapterId = tonumber(self.template.para3)
                    self:AddOneTempFlag(GuideTempFlagType.ChapterBg, param)
                elseif state == GuideChapterSceneState.AnimQuest then
                    DataCenter.TaskFlipManager:PlayEffect(tonumber(self.template.para3))
                end
                if self.template.para4 ~= "" then
                    self:AddOneTempFlag(GuideTempFlagType.ChapterPlayFlip, {})
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ResidentScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.ResidentScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.SecondNightBScene then
                local param = {}
                param.sceneType = GuideAnimObjectType.SecondNightBScene
                param.state = tonumber(self.template.para2)
                DataCenter.GuideCityAnimManager:LoadOneScene(param)
                self:DoNext()
            elseif movieType == GuidePlayMovieType.PausePve then
                local visible = tonumber(self.template.para2)
                if visible == GuideSetNormalVisible.Show then
                    DataCenter.LWBattleManager:SetGamePause(false)
                elseif visible == GuideSetNormalVisible.Hide then
                    DataCenter.LWBattleManager:SetGamePause(true)
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.ControlWallAnim then
                local visible = tonumber(self.template.para2)
                if visible == GuideSetNormalVisible.Show then
                    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
                    if buildData ~= nil then
                        local pointId = buildData.pointId
                        local build = CS.SceneManager.World:GetObjectByPointId(pointId)
                        if build ~= nil then
                            build:SetIsVisible(true)
                        end
                    end
                    --显示城墙并做动画
                    DataCenter.CityWallManager:SetVisible(true)
                    DataCenter.CityWallManager:DoExpand(0, 0, tonumber(self.template.para3))
                elseif visible == GuideSetNormalVisible.Hide then
                    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
                    if buildData ~= nil then
                        local pointId = buildData.pointId
                        local build = CS.SceneManager.World:GetObjectByPointId(pointId)
                        if build ~= nil then
                            build:SetIsVisible(false)
                        end
                    end
                    DataCenter.CityWallManager:SetVisible(false)
                end
                self:DoNext()
            elseif movieType == GuidePlayMovieType.SetLandBlockCallBoss then
                local visible = tonumber(self.template.para2)
                if visible == GuideSetNormalVisible.Show then
                    DataCenter.CitySiegeManager:SetCanCallBoss(true)
                elseif visible == GuideSetNormalVisible.Hide then
                    DataCenter.CitySiegeManager:SetCanCallBoss(false)
                end
                self:DoNext()
            end
        end
    elseif self.template.type == GuideType.WaitMovieComplete then
       
    elseif self.template.type == GuideType.WaitMessageFinish then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local waitType = tonumber(self.template.para1)
            if self.waitingMessage[waitType] then
                --计时5秒，还没回来就跳过
                if waitType ~= WaitMessageFinishType.UIMainChapterTaskRefresh and waitType ~= WaitMessageFinishType.UIDetectEvent 
                        and waitType ~= WaitMessageFinishType.PveEnter and waitType ~= WaitMessageFinishType.LandBlockOne
                        and waitType ~= WaitMessageFinishType.ResidentLoad and waitType ~= WaitMessageFinishType.BackWorldSceneFinish
                        and waitType ~= WaitMessageFinishType.ParkourBattleEnter and waitType ~= WaitMessageFinishType.UITaskMainAnimBg
                then
                    self:AddWaitLongDelayTimer(WaitMessageLongTime)
                end
            else
                if waitType == WaitMessageFinishType.BackCitySceneFinish then
                    if SceneUtils.GetIsInCity() then
                        self:DoNext()
                    end
                elseif waitType == WaitMessageFinishType.BackWorldSceneFinish then
                    if SceneUtils.GetIsInWorld() then
                        self:DoNext()
                    end
                else
                    self:DoNext()
                end
            end
        end
    elseif self.template.type == GuideType.ShowBlackUI then
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIShowBlack) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowBlack,{anim = true, playEffect = false})
        else
            EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
        end
    elseif self.template.type == GuideType.MoveCamera then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        if isInBattle then
            DataCenter.BattleLevel:SetFollowNpc()
        else
            DataCenter.CityNpcManager:SetFollowNpc()
        end
        local pos = nil
        local stage = 0
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local moveType= tonumber(self.template.para1)
            if moveType == GuideMoveCameraType.Point then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local spl = string.split_ff_array(self.template.para2,",")
                    if table.count(spl) > 1 then
                        local vec = {}
                        if isInBattle then
                            vec.x = spl[1]
                            vec.y = spl[2]
                        else
                            vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
                            vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
                        end
                        pos = SceneUtils.TileToWorld(vec)
                    end
                end
            elseif moveType == GuideMoveCameraType.Build then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(tonumber(self.template.para2))
                    if desTemplate ~= nil then
                        pos = desTemplate:GetPosition()
                    end
                end
            elseif moveType == GuideMoveCameraType.AllianceChief then
                if LuaEntry.Player:IsInAlliance() then
                    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
                    if baseData ~= nil and baseData.leaderUid and not baseData:CheckIfIsVirtualLeader() then
                        local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
                        if leaderData ~= nil and leaderData.pointId ~= 0 then
                            pos = SceneUtils.TileIndexToWorld(leaderData.pointId)
                        end
                    end
                end
                if pos == nil or (pos.x == 0 and pos.y == 0 and pos.z == 0) then
                    local temp  = self:GetSaveGuideValue(AllianceBornPoint)
                    if temp ~= nil then
                        pos = SceneUtils.TileIndexToWorld(tonumber(temp))
                    end
                end
            elseif moveType == GuideMoveCameraType.AllianceMember then
                if LuaEntry.Player:IsInAlliance() then
                    local member = DataCenter.AllianceMemberDataManager:GetNearMember()
                    if member ~= nil then
                        pos = SceneUtils.TileIndexToWorld(member.pointId)
                    end
                end
                if pos == nil or (pos.x == 0 and pos.y == 0 and pos.z == 0) then
                    local temp  = self:GetSaveGuideValue(AllianceBornPoint)
                    if temp ~= nil then
                        pos = SceneUtils.TileIndexToWorld(tonumber(temp))
                    end
                end
            elseif moveType == GuideMoveCameraType.NewbieSpaceMan then --重新follow小人
                --如果在pve中，镜头跟随pve小人
                if isInBattle then
                    pos = DataCenter.BattleLevel:GetPosition()
                end
            elseif moveType == GuideMoveCameraType.Npc then
                if isInBattle then
                    pos = DataCenter.BattleLevel:GetNpcPositionByName(self.template.para2)
                else
                    pos = DataCenter.CityNpcManager:GetNpcPositionByName(self.template.para2)
                end
            elseif moveType == GuideMoveCameraType.FollowNpc then
                if isInBattle then
                    DataCenter.BattleLevel:SetFollowNpc(self.template.para2)
                else
                    DataCenter.CityNpcManager:SetFollowNpc(self.template.para2)
                end
            elseif moveType == GuideMoveCameraType.CollectResource then
                SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,tonumber(self.template.para2),0)
            elseif moveType == GuideMoveCameraType.Garbage then
                local list = CS.SceneManager.World:GetGarbagePoint()
                if list ~= nil and list.Count > 0 then
                    for i = 0, list.Count - 1, 1 do
                        local pointId = list[i]
                        local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
                        if obj ~= nil then
                            pos = SceneUtils.TileIndexToWorld(pointId)
                            break
                        end
                    end
                end
            elseif moveType == GuideMoveCameraType.MonsterReward then
                local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
                if list ~= nil or table.count(list) > 0 then
                    local curTime = UITimeManager:GetInstance():GetServerTime()
                    for k,v in ipairs(list) do
                        if curTime <= v.expireTime then
                            pos = SceneUtils.TileIndexToWorld(v.pointId)
                            break
                        end
                    end
                end
            elseif moveType == GuideMoveCameraType.RadarMonster then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local spl = string.split_ii_array(self.template.para2,";")
                    if table.count(spl) > 1 then
                        local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(spl[1],spl[2])
                        if info ~= nil then
                            pos = SceneUtils.TileIndexToWorld(info.pointId)
                        end
                    end
                end
            elseif moveType == GuideMoveCameraType.WorldCity then
                pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos())
            elseif moveType == GuideMoveCameraType.SeasonCity then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local level = tonumber(self.template.para2)
                    pos = DataCenter.AllianceCityTemplateManager:GetNearCityPosByLevel(level)
                end
            elseif moveType == GuideMoveCameraType.SeasonDesert then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local spl = string.split_ii_array(self.template.para2, ";")
                    local desertType = spl[1]
                    if desertType == GuideMoveSeasonDesertType.OwnLevel then
                        local level = spl[2]
                        local data = DataCenter.DesertDataManager:GetDesertByLevel(level)
                        if data ~= nil then
                            pos = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.World)
                        end
                    elseif desertType == GuideMoveSeasonDesertType.Block then
                        pos = DataCenter.DesertDataManager:GetBlockDesertWorldPos()
                    elseif desertType == GuideMoveSeasonDesertType.AllianceBlock then
                        --找当前视口的赛季城
                        if CS.SceneManager.World ~= nil then
                            local worldPos = CS.SceneManager.World.CurTarget
                            local zoneId = CS.SceneManager.World:GetZoneIdByPosId(SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World) - 1)
                            local template = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId)
                            if template ~= nil then
                                local rangeList = BuildingUtils.GetBuildRoundPos(template.pos, template.size)
                                if rangeList ~= nil then
                                    for k,v in ipairs(rangeList) do
                                        local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(SceneUtils.TilePosToIndex(v, ForceChangeScene.World))
                                        if worldTileInfo ~= nil then
                                            local pointData = worldTileInfo:GetPointInfo()
                                            if pointData == nil then
                                                local desertInfo = worldTileInfo:GetWorldDesertInfo()
                                                if desertInfo~=nil then
                                                    local playerType = desertInfo:GetPlayerType()
                                                    if playerType == CS.PlayerType.PlayerNone then
                                                        pos = SceneUtils.TileToWorld(v, ForceChangeScene.World)
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elseif desertType == GuideMoveSeasonDesertType.Any then
                        local list = DataCenter.DesertDataManager:GetAllMyDesert()
                        if list ~= nil then
                            for k,v in pairs(list) do
                                pos = SceneUtils.TileIndexToWorld(v.pointId, ForceChangeScene.World)
                                break
                            end
                        end
                    end
                end
            elseif moveType == GuideMoveCameraType.RadarEvent then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local eventId = self.template.para2
                    local info = DataCenter.RadarCenterDataManager:GetDetectEventInfoByEventId(eventId)
                    if info ~= nil then
                        pos = SceneUtils.TileIndexToWorld(info.pointId)
                    end
                end
            elseif moveType == GuideMoveCameraType.LandPeople then
                local obj = DataCenter.LandManager:GetCurrentObject(LandObjectType.Block)
                if obj ~= nil then
                    pos = obj.transform.position
                end
            elseif moveType == GuideMoveCameraType.Land then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    pos = DataCenter.LandManager:GetObjectPos(LandObjectType.Block, tonumber(self.template.para2))
                end
            elseif moveType == GuideMoveCameraType.Position then
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    local str = string.split_ff_array(self.template.para2, ",")
                    pos = Vector3.New(str[1], str[2], str[3])
                end
            end
        end

        local time = LookAtFocusTime
        if self.template.para4 ~= nil and self.template.para4 ~= "" then
            time = tonumber(self.template.para4) / 1000
        end
        if isInBattle then
            local zoom = DataCenter.BattleLevel:GetCameraZoom()
            if self.template.para3 ~= nil and self.template.para3 ~= ""  then
                zoom = tonumber(self.template.para3)
                DataCenter.BattleLevel:SetGuideMaxHeight(zoom)
            end
            local nowPos = DataCenter.BattleLevel:GetCameraTarget()
            if zoom ~= nil then
                if pos == nil or (pos.x == nowPos.x and pos.z == nowPos.z)  then
                    DataCenter.BattleLevel:AutoZoom(zoom, time)
                else
                    DataCenter.BattleLevel:AutoLookat(pos, zoom, time)
                end
            end
        else
            if CS.SceneManager.World ~= nil then
                if not self.useGuideCameraConfig then
                    self.useGuideCameraConfig = true
                    CS.SceneManager.World:SetRangeValue(32, 32, 60, 69)
                end
                local zoom = CS.SceneManager.World.Zoom
                if self.template.para3 ~= nil and self.template.para3 ~= ""  then
                    zoom = tonumber(self.template.para3)
                    --记录开荒的相机高度 重登后恢复
                    if zoom < CS.SceneManager.World:GetCameraMinHeight() then
                        CS.SceneManager.World:SetCameraMinHeight(zoom)
                    elseif zoom > CS.SceneManager.World:GetCameraMaxHeight() then
                        CS.SceneManager.World:SetCameraMaxHeight(zoom)
                        CS.SceneManager.World:SetZoomParams(6, zoom, zoom * CameraZoomCotY, CameraSensitivity)
                    end
                end
                if self.template.para6 ~= nil and self.template.para6 ~= "" then
                    DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(pos, 
                            Quaternion.Euler(tonumber(self.template.para6), TimelineCameraRotationY, 0), time)
                else
                    local nowPos = CS.SceneManager.World.CurTarget
                    if pos == nil or (pos.x == nowPos.x and pos.z == nowPos.z)  then
                        CS.SceneManager.World:AutoZoom(zoom, time)
                    else
                        GoToUtil.GotoCityPos(pos, zoom, time)
                    end
                end
            end
        end
        local nextType = tonumber(self.template.para5)
        if nextType == GuideMoveCameraNextType.Next then
            self:DoNext()
        else
            self:AddMoveCameraTimer(time + GuideMovieCameraTimeDelta)
        end
    elseif self.template.type == GuideType.CloseAllUI then
        GoToUtil.CloseAllWindows()
        if not DataCenter.BattleLevel:IsInBattleLevel() then
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        end
        self:DoNext()
    elseif self.template.type == GuideType.UnlockBtn then
        local nextType = self.template.para2 == "" and GuideUnlockBtnNextType.WaitAnim or tonumber(self.template.para2)
        if nextType == GuideUnlockBtnNextType.WaitAnim then
            DataCenter.UnlockBtnManager:StartUnlockBtn(tonumber(self.template.para1))
        elseif nextType == GuideUnlockBtnNextType.Fly then
            DataCenter.UnlockBtnManager:StartFlyOnlyUnlockBtn(tonumber(self.template.para1))
        else
            self:DoNext()
            DataCenter.UnlockBtnManager:CheckAllUnlockBtn()
        end
    elseif self.template.type == GuideType.ShowTroopTalk then
    elseif self.template.type == GuideType.ShowGuideTip then
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTip) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTip,{ anim = true, playEffect = false})
        else
            EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
        end
    elseif self.template.type == GuideType.PlayEffectSound then
        if self.template.para1 ~= "" then
            local id = SoundUtil.PlayEffect(self.template.para1)
            self.effectSound[self.template.para1] = id
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowChapterAnim then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local list = string.split_ss_array(self.template.para1,";")
            if table.count(list) > 3 then
                local param = {}
                param.chapterId = tonumber(list[1])
                param.bgName = list[2]
                param.titleDes = Localization:GetString(list[3])
                param.des = Localization:GetString(list[4])
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    param.autoDoNext = tonumber(self.template.para2) / 1000
                end
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIChapterSwitch,{ anim = true, playEffect = false},tonumber(list[1]))
            end
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.StopAllEffectSound then
        self:StopAllEffectSound()
        self:DoNext()
    elseif self.template.type == GuideType.PrologueShowNpc then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        local nextType = GuideNpcDoNextType.Auto
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            nextType = tonumber(self.template.para3)
        end
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local posArr = {}
            local spl1 = string.split_ss_array(self.template.para1,";")
            for k,v in ipairs(spl1) do
                local spl2 = string.split_ff_array(v, ",")
                if table.count(spl2) > 1 then
                    local vec = {}
                    if isInBattle then
                        vec.x = spl2[1]
                        vec.y = spl2[2]
                    else
                        vec.x = DataCenter.BuildManager.main_city_pos.x + spl2[1]
                        vec.y = DataCenter.BuildManager.main_city_pos.y + spl2[2]
                    end
                    table.insert(posArr,vec)
                end
            end
            if isInBattle then
                local param = {}
                param.modelName = self.template.para2
                param.posArr = posArr
                param.animName = self.template.para4
                param.angle = tonumber(self.template.para5)
                param.nextType = nextType
                DataCenter.BattleLevel:AddOneNpc(param)
            else
                local moveType = NpcMoveType.Normal
                if self.template.para6 ~= nil and self.template.para6 ~= "" then
                    moveType = tonumber(self.template.para6)
                end
                DataCenter.CityNpcManager:AddOneNpc(self.template.para2,posArr, self.template.para4, tonumber(self.template.para5), nextType, nil, moveType)
            end
        end
        if nextType == GuideNpcDoNextType.Auto or nextType == GuideNpcDoNextType.WaitWalkDelete then
            self:DoNext()
        end
    elseif self.template.type == GuideType.PrologueHideNpc then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        if isInBattle then
            DataCenter.BattleLevel:RemoveOneNpc(self.template.para2)
        else
            DataCenter.CityNpcManager:RemoveOneNpc(self.template.para2)
        end
        self:DoNext()
    elseif self.template.type == GuideType.PrologueShowSetManPosition then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        if isInBattle then
            if self.template.para1 ~= nil and self.template.para1 ~= "" then
                local posArr = {}
                local spl1 = string.split_ss_array(self.template.para1,";")
                for k,v in ipairs(spl1) do
                    local spl2 = string.split_ff_array(v,",")
                    if table.count(spl2) > 1 then
                        table.insert(posArr, SceneUtils.TileToWorld({x = spl2[1], y = spl2[2]}))
                    end
                end
                local player = DataCenter.BattleLevel:GetPlayer()
                if player ~= nil and #posArr > 0 then
                    player:MoveTo(posArr)
                end
            end
            if self.template.para2 ~= nil and self.template.para2 ~= "" then
                local spl1 = string.split_ff_array(self.template.para2,",")
                if table.count(spl1) > 1 then
                    local vec = {}
                    vec.x = spl1[1]
                    vec.y = spl1[2]
                    local player = DataCenter.BattleLevel:GetPlayer()
                    if player ~= nil then
                        player:TurnToPos(SceneUtils.TileToWorld(vec))
                    end
                end
            end
        end
        local nextType = GuideNpcDoNextType.Auto
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            nextType = tonumber(self.template.para3)
        end
        if nextType == GuideNpcDoNextType.Auto then
            self:DoNext()
        end
    elseif self.template.type == GuideType.ShowUIWindow then
        local windowName = self.template.para4
        if (not UIManager:GetInstance():IsWindowOpen(windowName)) then
            UIManager:GetInstance():OpenWindow(windowName)
        end
        self:DoNext()
    elseif self.template.type == GuideType.WaitTime then
        self:DoNext()
    elseif self.template.type == GuideType.PVEFinishOneTrigger then
        if DataCenter.BattleLevel:IsInBattleLevel() then
            DataCenter.BattleLevel:DoTrigger(DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(self.template.para1)),true)
        end
        if self.template.type == GuideType.PVEFinishOneTrigger then
            self:DoNext()
        end
    elseif self.template.type == GuideType.PveShowYellowArrow then
        local spl = string.split_ii_array(self.template.para1,",")
        if table.count(spl) > 1 then
            if DataCenter.BattleLevel:IsInBattleLevel() then
                local vec = {}
                vec.x = spl[1]
                vec.y = spl[2]
                local height = nil
                local vec3 = SceneUtils.TileToWorld(vec)
                if self.template.para3 ~= nil and self.template.para3 ~= "" then
                    local spl2 = string.split_ff_array(self.template.para3, ",")
                    if table.count(spl2) >= 3 then
                        vec3 = Vector3.New(spl2[1], spl2[2], spl2[3])
                    end
                end
                if self.template.para2 ~= nil and self.template.para2 ~= "" then
                    height = tonumber(self.template.para2)
                    vec3.y = height
                end

                DataCenter.BattleLevel:AddOneArrow(SceneUtils.TileToWorld(vec), height, vec3)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowUIBlackChangeMask then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackChangeMask,{ anim = false, playEffect = false})
    elseif self.template.type == GuideType.PveShowBattleBloodLight then
        if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
            local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                luaWindow.View:ShowGrayMask(self.template.para1)
            end
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.WaitMarchFightEnd then
        --找到自己正在行军的编队
        local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
        if #selfMarch > 0 then
            local march = selfMarch[1]
            local marchUuid = march.uuid
            DataCenter.WorldMarchDataManager:TrackMarch(marchUuid)
        end
    elseif self.template.type == GuideType.OpenSelectQuestionPanel then
        GoToUtil.CloseAllWindows()
        DataCenter.AllianceLeaderManager:TryOpenRoleSelect()
        self:DoNext()
    elseif self.template.type == GuideType.NoNpcTalk then
        local param = {}
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            param.autoNextTime = tonumber(self.template.para1) / 1000
        end
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
            param.des = Localization:GetString(self.template.para2)
        end
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            param.canClickTime = tonumber(self.template.para3) / 1000
        end
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideNoNpcTalk) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideNoNpcTalk,{ anim = true, playEffect = false}, param)
        end
    elseif self.template.type == GuideType.ShowFakeHero then
        --显示假的英雄UI
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local heroId = tonumber(self.template.para1)
            local isShowAfterReward = true
            if self.template.para3 ~= "" then
                isShowAfterReward = false
            end
            if isShowAfterReward then
                local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
                local fakeParam = {}
                fakeParam.type = RewardType.HERO
                fakeParam.value = {heroId = heroId,rewardAdd = 1,uuid = heroUuid}
                if fakeParam ~= nil then
                    DataCenter.HeroEntrustManager:AddShowReward({reward = {fakeParam}})
                end
            end
            local param = {}
            param.heroId = heroId
            if self.template.para2 ~= nil and self.template.para2 ~= "" then
                param.canClickTime = tonumber(self.template.para2) / 1000
            end
            --UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowFakeNewHero,{ anim = false }, param)
        end
    elseif self.template.type == GuideType.SetAttackSpecialStateFlag then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            EventManager:GetInstance():Broadcast(EventId.AttackSpecialStateFlag, tonumber(self.template.para1))
        end
        self:DoNext()
    elseif self.template.type == GuideType.WaitPanelOpen then
        self:DoNext()
    elseif self.template.type == GuideType.SetBubbleShow then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local showType = tonumber(self.template.para1)
            if showType == BubbleShowType.Show then
                DataCenter.BuildBubbleManager:ShowBubbleNode()
            elseif showType == BubbleShowType.Hide then
                DataCenter.BuildBubbleManager:HideBubbleNode()
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.AlliancePanelGuide then
        if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIAllianceMainTable) then
            local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMainTable)
            if luaWindow ~= nil and luaWindow.View ~= nil then
                local showParam = {}
                if self.template.para1 ~= nil and self.template.para1 ~= "" then
                    local spl = string.split_ss_array(self.template.para1, "|")
                    for k,v in ipairs(spl) do
                        local spl1 = string.split_ss_array(v, ",")
                        local count = table.count(spl1)
                        local temp = {}
                        if count >= 1 then
                            temp.btnType = tonumber(spl1[1])
                            table.insert(showParam, temp)
                        end
                        if count >= 4 then
                            temp.dialog = spl1[2]
                            temp.modelName = spl1[3]
                            temp.modelPosition = tonumber(spl1[4])
                        end
                    end
                end
                luaWindow.View:DoSpecialGuide(showParam)
            end
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.DoQuestJump then
        local questId
        if self.template.para1 ~= nil then
            questId = tonumber(self.template.para1)
        end
        self:DoNext()
        if questId ~= nil then
            GoToUtil.GoToByQuestId(LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), questId))
        end
    elseif self.template.type == GuideType.CheckBecomeAllianceLeader then
        DataCenter.AllianceLeaderManager:SendCheckCanBeLeader()
    elseif self.template.type == GuideType.ShowLoadMask then
        local doNext = true
        if self.template.para1 ~= nil then
            local showLoadMaskType = tonumber(self.template.para1)
            if showLoadMaskType == ShowLoadMaskType.Show or showLoadMaskType == ShowLoadMaskType.ClickNext then
                local list = string.split_ss_array(self.template.para2,";")
                local param = {}
                local temp = list[1]
                if temp ~= nil and temp ~= "" then
                    param.bgAlpha = tonumber(temp)
                end
                temp = list[2]
                if temp ~= nil and temp ~= "" then
                    param.bgName = temp
                end
                temp = list[3]
                if temp ~= nil and temp ~= "" then
                    local spl = string.split_ss_array(temp, ",")
                    param.des = Localization:GetString(spl[1])
                    if spl[2] ~= nil and spl[2] ~= "" then
                        param.playPrintSound = true
                    end
                end

                temp = list[4]
                if temp ~= nil and temp ~= "" then
                    param.secondBgAlpha = tonumber(temp)
                end
                if self.template.para3 ~= "" then
                    param.sortArr = string.split_ii_array(self.template.para3, ";")
                else
                    param.sortArr = {1,2,3,4}
                end
               
                if self.template.para4 ~= "" then
                    local str = string.split_ff_array(self.template.para4, ";")
                    param.posType = str[1]
                    param.posY = str[2]
                    param.alignmentType = str[3] or TextAlignmentType.Center
                end

                if self.template.para5 ~= "" then
                    local str = string.split_ff_array(self.template.para5, ";")
                    param.openSpeed = str[1]
                    param.closeSpeed = str[2]
                end
                param.showLoadMaskType = showLoadMaskType
                if showLoadMaskType == ShowLoadMaskType.ClickNext then
                    doNext = false
                end

                if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadMask) then
                    EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideLoadMask, NormalPanelAnim, param)
                end
            elseif showLoadMaskType == ShowLoadMaskType.Hide then
                EventManager:GetInstance():Broadcast(EventId.CloseGuideLoadMask)
            end
        end
        if doNext then
            self:DoNext()
        end
    elseif self.template.type == GuideType.ChangeBgm then
        if self.template.para2 ~= "" then
            self:SendSaveGuideMessage(GuideBgmName, self.template.para1)
            CommonUtil.PlayGameBgMusic()
        else
            CommonUtil.PlayGameBgMusic(self.template.para1)
        end
       
        self:DoNext()
    elseif self.template.type == GuideType.PVESetTriggerVisible then
        if self.template.para1 ~= nil then
            local visible = tonumber(self.template.para1) == PveTriggerVisibleType.Show
            local list = string.split_ii_array(self.template.para2,",")
            for k,v in ipairs(list) do
                DataCenter.BattleLevel:SetOneTriggerVisible(v, visible)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.ChangeBgmVolume then
        if CS.GameEntry.Sound.ChangeVolume ~= nil then
            CS.GameEntry.Sound:ChangeVolume("Music", tonumber(self.template.para1),tonumber(self.template.para2))
        end
        self:DoNext()
    elseif self.template.type == GuideType.WaitGolloesArrived then
        local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
        if worldMarch then
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
            DataCenter.WorldMarchDataManager:TrackMarch(worldMarch.uuid)
        end
    elseif self.template.type == GuideType.SetRadarMonsterVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
        elseif visible == GuideSetNormalVisible.Hide then
            EventManager:GetInstance():Broadcast(EventId.HideWorldMarchByType, NewMarchType.EXPLORE)
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetCityPeopleAndCarVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
        elseif visible == GuideSetNormalVisible.Hide then
            EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
        end
        self:DoNext()
    elseif self.template.type == GuideType.PveSkillVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.BattleLevel:SetHideSkill(false)
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.BattleLevel:SetHideSkill(true)
        end
        EventManager:GetInstance():Broadcast(EventId.SetPveSkillVisible)
        self:DoNext()
    elseif self.template.type == GuideType.SetPveStaminaNpcVisible then
        self:DoNext()
    elseif self.template.type == GuideType.FullPveSkill then
        if self.template.para1 ~= "" then
            DataCenter.BattleLevel:ChangeSkillNum(tonumber(self.template.para1))
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetPveBuyBuffShopEffectActive then
        EventManager:GetInstance():Broadcast(EventId.SetPveBuyBuffSShopEffectVisible, self.template.para1)
        self:DoNext()
    elseif self.template.type == GuideType.SetPveStopRefreshStamina then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderShow
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderHide
        end
        EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
        self:DoNext()
    elseif self.template.type == GuideType.SetPveNoClickStamina then
        EventManager:GetInstance():Broadcast(EventId.SetPveNoClickStamina, self.template.para1)
        self:DoNext()
    elseif self.template.type == GuideType.OpenHeadTalkPanel then
        if self.template.para2 ~= nil then
            local param = {}
            local list = string.split_ss_array(self.template.para2, "|")
            for k, v in ipairs(list) do
                local spl = string.split_ss_array(v, ";")
                local count = #spl
                if count >= 4 then
                    local per = {}
                    table.insert(param, per)
                    per.dialog = Localization:GetString(spl[1])
                    per.modelName = spl[2]
                    per.modelPosition = spl[3]
                    per.time = tonumber(spl[4]) / 1000
                end
            end
            if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeadTalk) then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadTalk,{ anim = true, playEffect  = false}, param)
            else
                EventManager:GetInstance():Broadcast(EventId.RefreshUIHeadTalk, param)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.CloseHeadTalkPanel then
        EventManager:GetInstance():Broadcast(EventId.CloseUIGuideHeadTalk)
        self:DoNext()
    elseif self.template.type == GuideType.SetPveBagGuide then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = GuideMaskTypeSignalType.UIPveMainResourceShow
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = GuideMaskTypeSignalType.UIPveMainResourceHide
        end
        EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
        self:DoNext()
    elseif self.template.type == GuideType.HeroAdvanceGuide then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            local param = {}
            param.eventType = HeroAdvanceGuideSignalType.Enter
            param.quality = tonumber(self.template.para1)
            EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetHeroAdvanceGuideHeroVisible then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = HeroAdvanceGuideSignalType.ShowMainHeroBlack
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = HeroAdvanceGuideSignalType.HideMainHeroBlack
        end
        EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
        self:DoNext()
    elseif self.template.type == GuideType.SetHeroAdvanceGuideSubHeroVisible then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = HeroAdvanceGuideSignalType.ShowSubHeroBlack
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = HeroAdvanceGuideSignalType.HideSubHeroBlack
        end
        EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
        self:DoNext()
    elseif self.template.type == GuideType.ShakeCamera then
        if DataCenter.BattleLevel ~= nil then
            local paramSpls = string.split(self.template.para1, "|")
            local param = {}
            param.duration = tonumber(paramSpls[1]) or 0.5
            param.strength = tonumber(paramSpls[2]) or 1
            param.vibrato = tonumber(paramSpls[3]) or 20
            DataCenter.BattleLevel:ShakeCameraWithParam(param)
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetAllVisible then
        local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
        local visible = tonumber(self.template.para1)
        if visible == GuideSetUIMainAnim.Show then
            if isInBattle then

            else
                self:SetNoShowUIMain(GuideSetUIMainAnim.Show)
                DataCenter.BuildBubbleManager:ShowBubbleNode()
                DataCenter.WoundedCompensateManager:AddWoundedBubble()
            end
        elseif visible == GuideSetUIMainAnim.Hide then
            if isInBattle then

            else
                self:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
                DataCenter.BuildBubbleManager:HideBubbleNode()
                DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
            end
        elseif visible == GuideSetUIMainAnim.StayTop then
            if isInBattle then

            else
                self:SetNoShowUIMain(GuideSetUIMainAnim.StayTop)
                DataCenter.BuildBubbleManager:HideBubbleNode()
                DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
            end
        elseif visible == GuideSetUIMainAnim.StayTopLeft then
            if isInBattle then

            else
                self:SetNoShowUIMain(GuideSetUIMainAnim.StayTopLeft)
                DataCenter.BuildBubbleManager:HideBubbleNode()
                DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetWoundedBubbleVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.WoundedCompensateManager:AddWoundedBubble()
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetGuideQuestVisible then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            EventManager:GetInstance():Broadcast(EventId.GuidControlQuest, tonumber(self.template.para1))
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowCurtain then
        local param = {}
        param.title = Localization:GetString(self.template.para1)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVECurtain, { anim = false }, param)
        self:DoNext()
    elseif self.template.type == GuideType.NetUnConnect then
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
            CS.ApplicationLaunch.Instance:ReloadGame()
        else
            AppStartupLoading:GetInstance():ReConnect()
        end
        self:DoNext()
    elseif self.template.type == GuideType.BackBuildCollectTime then
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_CONDOMINIUM)
        if buildData ~= nil then
            SFSNetwork.SendMessage(MsgDefines.BackBuildingCollectTime, { uuid = buildData.uuid })
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.SetHeroAdvanceMaskVisible then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = HeroAdvanceGuideSignalType.ShowHeroStarUpBlack
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = HeroAdvanceGuideSignalType.HideHeroStarUpBlack
        end
        EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
        self:DoNext()
    elseif self.template.type == GuideType.SetPveOutBagGuide then
        local param = {}
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            param.eventType = GuideMaskTypeSignalType.UIPveMainBagShow
        elseif visible == GuideSetNormalVisible.Hide then
            param.eventType = GuideMaskTypeSignalType.UIPveMainBagHide
        end
        EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
        self:DoNext()
    elseif self.template.type == GuideType.OpenPanel then
        local panelType = tonumber(self.template.para1)
        if panelType == GuideOpenPanelType.Common then
            local panelName = self.template.para2
            if not UIManager:GetInstance():IsWindowOpen(panelName) then
                UIManager:GetInstance():OpenWindow(panelName)
            end
        elseif panelType == GuideOpenPanelType.Activity then
            local actId = self.template.para2
            --不关界面
            if DataCenter.ActivityListDataManager:IsActivityOpen(actId) then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, actId)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
            end
        elseif panelType == GuideOpenPanelType.FirstPay then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, { anim = false, UIMainAnim = UIMainAnimType.AllHide,isBlur = true })
        elseif panelType == GuideOpenPanelType.GetNewItem then
            local itemId = tonumber(self.template.para2)
            local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
            if template ~= nil then
                local icon = string.format(LoadPath.ItemPath, template.icon_big)
                UIUtil.ShowUnlockWindow(Localization:GetString(template.name), icon, Localization:GetString(template.description), UnlockWindowType.Item)
            end
        elseif panelType == GuideOpenPanelType.DailyActivity then
            local actType = tonumber(self.template.para2)
            DataCenter.DailyActivityManager:OpenDailyActivityView(actType)
        elseif panelType == GuideOpenPanelType.ClickBuild then
            local buildId = tonumber(self.template.para2)
            GoToUtil.GotoCityByBuildId(buildId)
        elseif panelType == GuideOpenPanelType.Bubble then
            local param = {}
            param.callBack = function()
                UIManager.Instance:DestroyWindow(UIWindowNames.UITimelineBubble)
            end
            if self.template.para2 ~= "" then
                local str = string.split_ff_array(self.template.para2, ",")
                param.worldPos = Vector3.New(str[1], str[2], str[3])
            end
            if self.template.para3 ~= "" then
                local str = string.split_ss_array(self.template.para3, ";")
                local str1 = string.split_ss_array(str[1], ",")
                param.bgName = string.format(LoadPath.UIBuildBubble, str1[1])
                if str1[2] ~= nil then
                    local scale = tonumber(tonumber(str1[2]))
                    param.bgScale = Vector3.New(scale, scale, scale)
                else
                    param.bgScale = BuildBubbleBgScale
                end
                if str[2] ~= nil then
                    param.iconScale = ResetScale
                    param.iconName = string.format(LoadPath.UIBuildBubble, str[2])
                end
            end
            
            UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineBubble, {}, param)
        end
        self:DoNext()
    elseif self.template.type == GuideType.UIScrollToSomeWhere then
        EventManager:GetInstance():Broadcast(EventId.UIScrollToSomeWhere, self.template.para1)
        self:DoNext()
    elseif self.template.type == GuideType.ShowJumpBtn then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            local param = {}
            if self.template.para2 ~= "" then
                param.gotoGuideId = tonumber(self.template.para2)
            end
            if self.template.para3 ~= "" then
                param.timelineEnd = true
            end
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITimelineJump) then
                EventManager:GetInstance():Broadcast(EventId.RefreshTimelineJump, param)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump,{anim = false, playEffect = false}, param)
            end
        elseif visible == GuideSetNormalVisible.Hide then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump,{anim = false, playEffect = false})
        end
        self:DoNext()
    elseif self.template.type == GuideType.BlackHoleMask then
        local canNext = true
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            local param = {}
            param.obj = self.obj
            if self.template.para3 ~= "" then
                --显示文字提示
                local str = string.split_ii_array(self.template.para3, ";")
                param.dialogDirection = str[1]
                param.dialog = str[2]
            end

            if self.template.para4 ~= "" then
                --显示文字提示
                param.canClick = true
                canNext = false
            end
            
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBlackHoleMask) then
                EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackHoleMask,{anim = false, playEffect = false}, param)
            end
        elseif visible == GuideSetNormalVisible.Hide then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false})
        end
        if canNext then
            self:DoNext()
        end
    elseif self.template.type == GuideType.UIPathArrow then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            local param = {}
            param.obj = self.obj
            param.extraPosition = Vector3.New(0,0,0)
            if self.template.para3 ~= nil and self.template.para3 ~= "" then
                local spl = string.split_ff_array(self.template.para3, ",")
                if #spl == 2 then
                    param.extraPosition.x = spl[1]
                    param.extraPosition.y = spl[2]
                end
            end
            param.rotation = Vector3.New(0,0,180)
            if self.template.para4 ~= nil and self.template.para4 ~= "" then
                param.rotation.z = tonumber(self.template.para4)
            end
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPathArrow) then
                EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIPathArrow,{anim = false, playEffect = false}, param)
            end
        elseif visible == GuideSetNormalVisible.Hide then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false})
        end
        self:DoNext()
    elseif self.template.type == GuideType.BuildCanDoAnim then
        local eventId = 0
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            eventId = EventId.SetBuildCanDoAnim
        elseif visible == GuideSetNormalVisible.Hide then
            eventId = EventId.SetBuildNoDoAnim
        end

        local buildId = 0
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
            buildId = tonumber(self.template.para2)
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            if list ~= nil and table.count(list) > 0 then
                for k,v in ipairs(list) do
                    EventManager:GetInstance():Broadcast(eventId, v.uuid)
                end
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowNewHero then
        local heroId = tonumber(self.template.para1) or 0
        local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
        if heroUuid ~= 0 then
            DataCenter.HeroDataManager:AddNewHeroTag(heroUuid)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
        end
        self:DoNext()
    elseif self.template.type == GuideType.SetWorldArrowVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            WorldArrowManager:GetInstance():SetGuidState(true)
        elseif visible == GuideSetNormalVisible.Hide then
            WorldArrowManager:GetInstance():SetGuidState(false)
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowWorldArrow then
        self:DoNext()
    elseif self.template.type == GuideType.ShowGuideDetectEventMonster then
        --显示世界胡迪尔雷打怪
        DataCenter.GuideDetectEventManager:SendGetGuideDetectEventInfo()
        self:DoNext()
    elseif self.template.type == GuideType.JumpPrologue then
        CommonUtil.PlayGameBgMusic()
        self:DoNext()
    elseif self.template.type == GuideType.ControlTimelinePause then
        EventManager:GetInstance():Broadcast(EventId.ControlTimelinePause, tonumber(self.template.para1))
        self:DoNext()
    elseif self.template.type == GuideType.OpenSeasonIntro then
        local showType = tonumber(self.template.para1)
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideEdenWarTips) then
            EventManager:GetInstance():Broadcast(EventId.UIGuideEdenWarTipsUpdate, showType)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideEdenWarTips,{anim = true, playEffect = false}, showType)
        end
        self:DoNext()
    elseif self.template.type == GuideType.ControlUISeasonIntro then
        local showType = tonumber(self.template.para1)
        EventManager:GetInstance():Broadcast(EventId.ControlSeasonIntro, showType)
        self:DoNext()
    elseif self.template.type == GuideType.WaitCloseUI then
        self:AddCheckErrorTimer()
    elseif self.template.type == GuideType.NewbieResident then
        DataCenter.VitaManager:SendNewbieResident()
        self:DoNext()
    elseif self.template.type == GuideType.ShowTopDes then
        local param = {}
        param.des = Localization:GetString(self.template.para1)
        if self.template.para2 == "" then
            param.time = GuideTopTipAutoCloseTime
        else
            param.time = tonumber(self.template.para2)
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideShowTopTip, { anim = true, playEffect = false}, param)
        self:DoNext()
    elseif self.template.type == GuideType.ShowSpeechTalk then
        local param = {}
        param.callback = self.speech_talk_callback
        param.list = {}
        if self.template.para1 ~= "" then
            local spl = string.split_ss_array(self.template.para1, "|")
            for k,v in ipairs(spl) do
                local spl1 = string.split_ss_array(v, ";")
                local talkParam = {}
                talkParam.icon = spl1[1]
                talkParam.name = Localization:GetString(spl1[2])
                talkParam.des = Localization:GetString(spl1[3])
                talkParam.showType = tonumber(spl1[4])
                talkParam.dub = spl1[5] or ""
                table.insert(param.list, talkParam)
            end
        end
      
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideSpeechTalk, { anim = true, playEffect = false, UIMainAnim = UIMainAnimType.AllHide}, param)
    elseif self.template.type == GuideType.ChangeDayTime then
        if self.template.para1 ~= "" then
            DataCenter.VitaManager:SendChangeTime(tonumber(self.template.para1))
        end
        if self.template.para2 ~= "" then
            local stopType = tonumber(self.template.para2)
            if stopType == ChangeDayTimeStopType.Stop then
                DataCenter.VitaManager:SetStopTime(true)
            elseif stopType == ChangeDayTimeStopType.Resume then
                DataCenter.VitaManager:SetStopTime(false)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.WaitBuildUpgradeFinish then
        self:DoNext()
    elseif self.template.type == GuideType.ShowOneCreateEffect then
        local rotation = nil
        if self.template.para2 ~= "" then
            rotation = tonumber(self.template.para2)
        end
        DataCenter.BuildCanCreateManager:ShowOneCreateEffect(tonumber(self.template.para1), rotation)
        self:DoNext()
    elseif self.template.type == GuideType.ShowLand then
        Logger.Log("CanShowLand true")
        DataCenter.GuideManager:SendRemoveSaveGuide(CanShowLand)
        DataCenter.LandManager:RefreshFunctionState()
        DataCenter.LandManager:SetShowBlockEffect(false) -- 隐藏地块特效
        DataCenter.LandManager:RefreshAllObjects()-- 重刷地块Model
        self:DoNext()
    elseif self.template.type == GuideType.PeopleMove then
        local id = tonumber(self.template.para1)
        local pos = nil
        local bUuid = nil
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
            local spl2 = string.split_ff_array(self.template.para2, ",")
            pos = Vector3.New(spl2[1], spl2[2], spl2[3])
            local buildId = tonumber(spl2[4]) or 0
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData then
                bUuid = buildData.uuid
            end
        end
        local nextType = GuideNpcDoNextType.Auto
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            nextType = tonumber(self.template.para3)
        end
        local speed = 0
        if self.template.para4 ~= nil and self.template.para4 ~= "" then
            speed = tonumber(self.template.para4) or 0
        end
        local data = DataCenter.CityResidentManager:GetDataById(CityResidentDefines.Type.Resident, id)
        if data ~= nil then
            data:SetGuideControl(true)
            data:ShowTool("")
            local angle = nil
            if self.template.para6 ~= nil and self.template.para6 ~= "" then
                angle = tonumber(self.template.para6)
            end
            if speed > 0 then
                -- 指定动作
                data:PlayAnim(CityResidentDefines.AnimName.Run)
                data:SetSpeed(speed)
                data:SetAutoAnim(false)
                if bUuid then
                    data:GoToBuildingPos(bUuid, pos, true)
                else
                    data:GoToCityPos(pos)
                end
                if self.template.para5 ~= nil and self.template.para5 ~= "" then
                    local zoom = CS.SceneManager.World.Zoom
                    data.onUpdate = function()
                        CS.SceneManager.World:AutoLookat(data:GetPos(), zoom, 0.1)
                    end
                end
              
                data.onFinish = function()
                    data.onFinish = nil
                    data.onUpdate = nil
                    if angle ~= nil then
                        data:SetRot(Quaternion.Euler(0, angle, 0))
                    end
                    data:PlayAnim(CityResidentDefines.AnimName.Idle)
                    if nextType == GuideNpcDoNextType.WaitWalk then
                        self:DoNext()
                    end
                end
            else
				data:Idle()
                if bUuid ~= nil then
                    data.atBUuid = bUuid
                else
                    data.atBUuid = 0
                end
                if pos ~= nil then
                    data:SetPos(pos)
                end
                if angle ~= nil then
                    data:SetRot(Quaternion.Euler(0, angle, 0))
                end
                data:PlayAnim(CityResidentDefines.AnimName.Idle)
                if nextType == GuideNpcDoNextType.WaitWalk then
                    self:DoNext()
                end
            end
            if nextType == GuideNpcDoNextType.Auto then
                self:DoNext()
            end
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.HeroMove then
        --如果英雄没有上阵就先上阵在下阵
        local id = tonumber(self.template.para1)
        local pos = nil
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
            local spl2 = string.split_ff_array(self.template.para2, ",")
            pos = Vector3.New(spl2[1], spl2[2], spl2[3])
        end
        local nextType = GuideNpcDoNextType.Auto
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
            nextType = tonumber(self.template.para3)
        end
        local speed = 0
        if self.template.para4 ~= nil and self.template.para4 ~= "" then
            speed = tonumber(self.template.para4) or 0
        end

        local callback = function()
            local data = DataCenter.CityResidentManager:GetDataByIndex(CityResidentDefines.Type.Hero, id)
            if data ~= nil then
                data:SetGuideControl(true)
                local angle = nil
                if self.template.para6 ~= nil and self.template.para6 ~= "" then
                    angle = tonumber(self.template.para6)
                end
                if speed > 0 then
                    -- 指定动作
                    data:PlayAnim(CityResidentDefines.AnimName.Run)
                    data:SetSpeed(speed)
                    data:SetAutoAnim(false)
                    data:GoToCityPos(pos)
                    if self.template.para5 ~= nil and self.template.para5 ~= "" then
                        local zoom = CS.SceneManager.World.Zoom
                        data.onUpdate = function()
                            CS.SceneManager.World:AutoLookat(data:GetPos(), zoom, 0.1)
                        end
                    end
                    data.onFinish = function()
                        data.onFinish = nil
                        data.onUpdate = nil
                        if angle ~= nil then
                            data:SetRot(Quaternion.Euler(0, angle, 0))
                        end
                        data:PlayAnim(CityResidentDefines.AnimName.Idle)
                        if nextType == GuideNpcDoNextType.WaitWalk then
                            self:DoNext()
                        end
                    end
                else
                    data:Idle()
                    data.atBUuid = 0
                    if pos ~= nil then
                        data:SetPos(pos)
                    end
                    if angle ~= nil then
                        data:SetRot(Quaternion.Euler(0, angle, 0))
                    end
                    data:PlayAnim(CityResidentDefines.AnimName.Idle)
                    if nextType == GuideNpcDoNextType.WaitWalk then
                        self:DoNext()
                    end
                end
                if nextType == GuideNpcDoNextType.Auto then
                    self:DoNext()
                end
            else
                self:DoNext()
            end
        end
        
        if DataCenter.CityResidentManager:GetDataByIndex(CityResidentDefines.Type.Hero, id) == nil then
            DataCenter.CityResidentManager:SetHeroOn(CityResidentDefines.HeroConfig[id].uuid, true, callback)
        else
            callback()
        end
        
    elseif self.template.type == GuideType.PeopleAnim then
        local id = tonumber(self.template.para1)
        local data = DataCenter.CityResidentManager:GetDataById(CityResidentDefines.Type.Resident, id)
        if data ~= nil then
            if self.template.para2 ~= nil and self.template.para2 ~= "" then
                -- 指定动作
                data:SetGuideControl(true)
                data:PlayAnim(self.template.para2)
            end

            if self.template.para3 ~= nil and self.template.para3 ~= "" then
                --local spl = string.split_ss_array(self.template.para3, ";")
                --DataCenter.CityResidentManager:ResidentEmo(data.uuid, tonumber(spl[1]), tonumber(spl[2]) or GuideMaxTime)
            end

            if self.template.para4 ~= nil and self.template.para4 ~= "" then
                local spl = string.split_ss_array(self.template.para4, ";")
                DataCenter.CityResidentManager:ResidentSpeak(data.uuid, Localization:GetString(spl[1]), tonumber(spl[2]) or GuideMaxTime)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.PeopleDead then
        local uuidArr = {}
        local idList = string.split_ii_array(self.template.para1, ";")
        for k,v in ipairs(idList) do
            local residentData = DataCenter.VitaManager:GetResidentDataById(v)
            if residentData ~= nil then
                table.insert(uuidArr, residentData.uuid)
            end
        end
        if uuidArr[1] ~= nil then
            local param = {}
            param.uuidArr = uuidArr
            SFSNetwork.SendMessage(MsgDefines.NewbieResidentDead, param)
        end
        self:DoNext()
    elseif self.template.type == GuideType.GuideEnterPve then
        local param = {}
        param.pveId = tonumber(self.template.para1)
        param.pveEntrance = PveEntrance.Guide
        PveUtil.EnterPve(param)
        DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.ParkourBattleEnter, true)
        self:DoNext()
    elseif self.template.type == GuideType.ControlResidentPause then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.CityResidentManager:ResumeAll()
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.CityResidentManager:PauseAll()
        end
        EventManager:GetInstance():Broadcast(EventId.ControlTimelinePause, visible)
        self:DoNext()
    elseif self.template.type == GuideType.ShowResidentEmoji then
        local obj, uuid = self:GetGuideObjAndUuid(self.template.para1)
        local time = tonumber(self.template.para3) or GuideMaxTime
        if time == 0 then
            --删除
            DataCenter.CityHudManager:Destroy(uuid, CityHudType.AnimEmoji)
        else
            if SceneUtils.GetIsInCity() and obj ~= nil and obj.transform ~= nil then
                local spl3 = string.split_ss_array(self.template.para2, "|")
                local emojiType = tonumber(spl3[1])
                table.remove(spl3, 1)
                local emojiPara = spl3

                local hudParam = {}
                hudParam.uuid = uuid
                hudParam.GetPos = function()
                    if obj ~= nil and obj.transform ~= nil then
                        return obj.transform.position
                    else
                        DataCenter.CityHudManager:Destroy(uuid, CityHudType.AnimEmoji)
                        return Vector3.New(0, 0, 0)
                    end
                end
                hudParam.type = CityHudType.AnimEmoji
                hudParam.emojiType = emojiType
                hudParam.emojiPara = emojiPara
                hudParam.worldOffset = Vector3.New(0, ResidentModelEmojiHeight, 0)
                hudParam.duration = time / 1000
                hudParam.updateEveryFrame = true
                hudParam.layer = CityHudLayer.Speak
                hudParam.location = CityHudLocation.UI
                hudParam.effectId = self.template.para4
                DataCenter.CityHudManager:Create(hudParam)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.ShowTalkBubble then
        local obj, uuid = self:GetGuideObjAndUuid(self.template.para1)
        local time = tonumber(self.template.para3) or GuideMaxTime 
        if time == 0 then
            --删除
            DataCenter.CityHudManager:Destroy(uuid, CityHudType.Speak)
        else
            if SceneUtils.GetIsInCity() and obj ~= nil and obj.transform ~= nil then
                local hudParam = {}
                hudParam.uuid = uuid
                hudParam.GetPos = function()
                    if obj ~= nil and obj.transform ~= nil then
                        return obj.transform.position
                    else
                        DataCenter.CityHudManager:Destroy(uuid, CityHudType.Speak)
                        return Vector3.New(0, 0, 0)
                    end
                end
                hudParam.type = CityHudType.Speak
                hudParam.text = Localization:GetString(self.template.para2)
                hudParam.worldOffset = Vector3.New(0, ResidentModelEmojiHeight, 0)
                hudParam.duration = time / 1000
                hudParam.updateEveryFrame = true
                hudParam.layer = CityHudLayer.Speak
                hudParam.location = CityHudLocation.UI
                hudParam.dubId = tonumber(self.template.para4)
                DataCenter.CityHudManager:Create(hudParam)
            end
        end
        self:DoNext()
    elseif self.template.type == GuideType.ControlLightRange then
        local lightType = tonumber(self.template.para1)
        if lightType == GuideControlLightType.Change then
            --控制灯光亮度
            EventManager:GetInstance():Broadcast(EventId.ForceSetPointLightRangeValueForGuide, self.template.para2)
        elseif lightType == GuideControlLightType.Reset then
            --恢复灯光亮度
            EventManager:GetInstance():Broadcast(EventId.ForceResetPointLightRangeValue)
        elseif lightType == GuideControlLightType.ChangeCur then
            --控制灯光范围
            EventManager:GetInstance():Broadcast(EventId.ForceSetLight1Value, self.template.para2)
        elseif lightType == GuideControlLightType.ResetCur then
            --控制灯光范围
            local k7 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k7")
            EventManager:GetInstance():Broadcast(EventId.ForceSetLight1Value, tostring(k7))
        end
        self:DoNext()
    elseif self.template.type == GuideType.ControlComeResident then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.CityResidentManager:SetReadyQueueComeSwitch(true) -- 小人
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.CityResidentManager:SetReadyQueueComeSwitch(false) -- 小人
        end

        visible = tonumber(self.template.para2)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.CityResidentManager:SetReadyQueueHudSwitch(true) -- 气泡
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.CityResidentManager:SetReadyQueueHudSwitch(false) -- 气泡
        end
       
        self:DoNext()
    elseif self.template.type == GuideType.AddZombie then
        local spl = string.split_ss_array(self.template.para1, "|")
        local pos = {}
        for k,v in ipairs(spl) do
            local spl1 = string.split_ff_array(v, ",")
            if spl1[3] ~= nil then
                table.insert(pos, Vector3.New(spl1[1], spl1[2], spl1[3]))
            end
        end
        local para3 = self.template.para3

        local zombieUuid = DataCenter.CityResidentManager:GetNextZombieUuid()
        table.insert(self.guideCreateZombie, zombieUuid)
        local zombieParam = {}
        zombieParam.prefabPath = string.format(LoadPath.ZombiePath, self.template.para2)
        DataCenter.CityResidentManager:AddData(zombieUuid, CityResidentDefines.Type.Zombie, zombieParam, function()
            -- 僵尸移动
            local zombieData = DataCenter.CityResidentManager:GetData(zombieUuid)
            zombieData:SetGuideControl(true)
            zombieData:SetSpeed(DataCenter.CityResidentManager:GetZombieWalkSpeed())
            zombieData:PlayAnim(CityResidentDefines.AnimName.Walk1)
            zombieData:SetPos(pos[1])
            zombieData.zombieStamina = 1
            if pos[2] ~= nil then
                zombieData:GoToPosDirectly(pos[2])
            end
            zombieData.onFinish = function()
                zombieData.onFinish = nil
                if not zombieData:IsDead() then
                    zombieData:SetGuideControl(false)
                end
            end
            if para3 ~= "" then
                local spl2 = string.split_ss_array(para3, ";")
                if spl2[1] ~= nil then
                    DataCenter.WaitTimeManager:AddOneWait(tonumber(spl2[1]) / 1000, function()
                        local spl3 = string.split_ss_array(spl2[2], "|")
                        local emojiType = tonumber(spl3[1])
                        table.remove(spl3, 1)
                        local emojiPara = spl3

                        local hudParam = {}
                        hudParam.uuid = zombieUuid
                        hudParam.GetPos = function() return zombieData:GetPos() end
                        hudParam.type = CityHudType.AnimEmoji
                        hudParam.emojiType = emojiType
                        hudParam.emojiPara = emojiPara
                        hudParam.worldOffset = Vector3.New(0, ResidentModelEmojiHeight, 0)
                        hudParam.duration = spl2[3] / 1000
                        hudParam.updateEveryFrame = true
                        hudParam.layer = CityHudLayer.Speak
                        hudParam.location = CityHudLocation.UI
                        DataCenter.CityHudManager:Create(hudParam)
                    end)
                end
            end
        end)

        self:DoNext()
    elseif self.template.type == GuideType.ShowGuideEffect then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideRedScreenEffect,{})
        elseif visible == GuideSetNormalVisible.Hide then
            UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideRedScreenEffect)
        end

        visible = tonumber(self.template.para2)
        if visible == GuideSetNormalVisible.Show then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideWindScreenEffect,{})
        elseif visible == GuideSetNormalVisible.Hide then
            EventManager:GetInstance():Broadcast(EventId.CloseGuideWindEffect)
        end

        self:DoNext()
    elseif self.template.type == GuideType.WaitRadarTaskFinish then
        --没有配置雷达任务，或者已完成走下一步
        local eventId = self.template.para1
        local info = DataCenter.RadarCenterDataManager:GetDetectEventInfoByEventId(eventId)
        if info ~= nil and info.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
            --一直等待
        else
            self:DoNext()
        end
    elseif self.template.type == GuideType.RemoveZombie then
        if self.guideCreateZombie[1] ~= nil then
            for k,v in ipairs(self.guideCreateZombie) do
                DataCenter.CityResidentManager:RemoveData(v)
            end
            self.guideCreateZombie = {}
        end 
        self:DoNext()
    elseif self.template.type == GuideType.ControlNewAddBuildVisible then
        local visible = tonumber(self.template.para1)
        if visible == GuideSetNormalVisible.Show then
            DataCenter.BuildCityBuildManager:SetBuildNoShow(true)
        elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.BuildCityBuildManager:SetBuildNoShow(false)
        end
        self:DoNext()
    elseif self.template.type == GuideType.OpenWithBooster then
        local furnaceState = tonumber(self.template.para1)
        if furnaceState == VitaDefines.FurnaceState.OpenWithBooster then
            DataCenter.VitaManager:SendSetFurnaceState(furnaceState)
        else
            DataCenter.VitaManager:SendSetFurnaceState(VitaDefines.FurnaceState.Open)
        end
        self:DoNext()
    elseif self.template.type == GuideType.ChangeSafeArea then
        local radius = tonumber(self.template.para1)
        self:AddOneTempFlag(GuideTempFlagType.ChangeSafeArea, radius)
        DataCenter.BuildEffectManager:SetOneBuildEffectScale(BuildingTypes.FUN_BUILD_MAIN,radius)
        self:DoNext()
    end

end

local function ShowGuideHand(self)

end

local function RemoveGuideHand(self)

end

local function LookBackToCharacter(self)

end

local function ShowLog(self,...)
    if self.isDebug then
        Logger.Log(...)
    end
end

local function DoJump(self)
    if self.template ~= nil and self.template.jumpid ~= 0 then
        self:SetCurGuideId(self.template.jumpid)
        self:DoGuide()
    end
end

local function IsDragGuide(self)
    return false
end

local function SetNoGotoTime(self,isGo)
    self.noGotoTime = isGo
end

local function TrainingArmySignal(bUuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
        local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildData.itemId)
        if queueType ~= NewQueueType.Default then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.NoFreeQueue, tostring(queueType))
        end
    end
end

local function ClickMuchStop(self)
    if true then
        return
    end
    local guideType = self:GetGuideType()
    if guideType ~= GuideType.PlayMovie and guideType ~= GuideType.WaitMovieComplete
            and guideType ~= GuideType.ShowTalk and guideType ~= GuideType.ShowBlackUI and guideType ~= GuideType.MoveCamera
            and guideType ~= GuideType.ShowChapterAnim and guideType ~= GuideType.ClickTimeLineBubble
            and guideType ~= GuideType.Wastelan_ResetManState and guideType ~= GuideType.ClickLandZoneBubble
            and guideType ~= GuideType.PrologueShowNpc then
        local id = self.guideId
        self:DoMuchStopJumpGuide()
        local guideName = StatTTType.JumpGuideId..id
        if self:GetSaveGuideValue(guideName) ~= SaveGuideDoneValue then
            self:SendSaveGuideMessage(guideName,SaveGuideDoneValue)
            self:SendLogMessage(tostring(id) ,StatTTType.JumpGuideId)
        end
        DataCenter.GuideManager:SetCurGuideId(GuideEndId)
        DataCenter.GuideManager:DoGuide()
    end
end

local function SendLogToNet(self, guideName, recordType)
    if self:GetSaveGuideValue(guideName) ~= SaveGuideDoneValue then
        self:SendSaveGuideMessage(guideName, SaveGuideDoneValue)
        self:SendLogMessage(guideName, recordType)
        self:ShowLog("shimin ------------------------- SendLogToNet  " .. guideName)
    end
end

local function UpdateScienceDataSignal(scienceId)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Science,tostring(scienceId))
end

--当点击15下后，停止引导，期间没有做完的特殊类型要处理
local function DoMuchStopJumpGuide(self)
    if not WorldArrowManager:GetInstance():GetGuidState() then
        WorldArrowManager:GetInstance():SetGuidState(true)
    end

    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if chapterId ~= nil and chapterId <= GuideJumpUnlockBtnChapterId then
        for k,v in ipairs(GuideJumpUnlockBtnType) do
            local template = DataCenter.UnlockBtnTemplateManager:GetUnlockBtnTemplate(v)
            if template ~= nil then
                for k1,v1 in ipairs(template.unlock_noviceboot) do
                    if not self:IsDoneThisGuide(v1) then
                        self:SendSaveGuideMessage(self:GetDoneGuideEndId(v1),SaveGuideDoneValue)
                        EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
                        EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, v)
                    end
                end
            end
        end
    else
        local guideId = self.guideId
        local template = nil
        while(guideId ~= GuideEndId) do
            template = DataCenter.GuideTemplateManager:GetGuideTemplate(guideId)
            if template == nil then
                guideId = GuideEndId
            else
                if template.type == GuideType.UnlockBtn then
                    if not self:IsDoneThisGuide(template.savedoneid) then
                        self:SendSaveGuideMessage(self:GetDoneGuideEndId(template.savedoneid),SaveGuideDoneValue)
                        EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
                    end
                    local unlockType = tonumber(template.para1)
                    EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, unlockType)
                elseif template.type == GuideType.SetAllVisible then
                    self:SetNoShowUIMain(GuideSetUIMainAnim.Show)
                    DataCenter.BuildBubbleManager:ShowBubbleNode()
                    DataCenter.WoundedCompensateManager:AddWoundedBubble()
                end
                guideId = template.nextid
            end
        end
    end
end

local function StopAllEffectSound(self)
    if self.effectSound ~= nil then
        for k,v in pairs(self.effectSound) do
            CS.GameEntry.Sound:StopSound(v)
        end
        self.effectSound = {}
    end
end

local function RefreshObject(self)
    self.obj = nil
    self.objWorldPos = nil
    self:DoGuide()
end


--是否可以放置建筑
local function IsSendBuildPlace(self)
    return DataCenter.GuideManager:GetSaveGuideValue(SaveNoSendPlaceBuild) ~= SaveGuideDoneValue
end

--是否在序章
local function IsShowPrologue(self)
    return DataCenter.BuildManager:IsInNewUserWorld()
end

local function HospitalUpdateSignal()
    DataCenter.GuideManager:CheckTreatSoldierGuide()
end

local function CheckTreatSoldierGuide(self)
    if DataCenter.HospitalManager:IsHaveInjuredSolider() then
        self:CheckDoTriggerGuide(GuideTriggerType.TreatSoldier,SaveGuideDoneValue)
    end
end

--设置小弟数量
local function SaveSpaceManExtraNum(self,num)
    self:SendSaveGuideMessage(SpaceManExtraNum,tostring(num))
end

--获取有几个小弟
local function GetSpaceManExtraNum(self)
    local num = self:GetSaveGuideValue(SpaceManExtraNum)
    if num ~= nil and num ~= "" then
        return tonumber(num)
    end
    return 0
end

--获取pve中需要材料到达配置数目触发的引导
local function GetPveTriggerGuide(self,pveId)
    return self.pveTrigger[pveId]
end

--初始化需要保存特殊处理的trigger
local function InitSpecialTrigger(self)
    --同一关卡内触发
    self.pveTrigger = {}
    self.specialTriggerGuide = {}
    local triggerType = GuideTriggerType.PveOwnRes
    local list = self.allTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in pairs(list) do
            local spl = string.split_ss_array(k,"|")
            if table.count(spl) > 1 then
                local pveId = tonumber(spl[1])
                if self.pveTrigger[pveId] == nil then
                    self.pveTrigger[pveId] = {}
                end
                local param = {}
                param.triggerType = triggerType
                param.triggerPara = k
                param.needRes = {}
                local spl2 = string.split_ss_array(spl[2], ";")
                for k1,v1 in ipairs(spl2) do
                    local spl3 = string.split_ii_array(v1, ",")
                    local spl3Count = table.count(spl3)
                    if spl3Count > 1 then
                        local need = {}
                        need.resType = spl3[1]
                        need.count = spl3[2]
                        table.insert(param.needRes,need)
                    end
                end
                table.insert(self.pveTrigger[pveId], param)
            end
        end
    end

    --所有关卡内触发
    triggerType = GuideTriggerType.PveEnterBattle
    list = self.allTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in pairs(list) do
            if self.specialTriggerGuide[triggerType] == nil then
                self.specialTriggerGuide[triggerType] = {}
            end
            local param = {}
            param.triggerType = triggerType
            param.triggerPara = k
            param.triggers = string.split_ss_array(k, ";")
            table.insert(self.specialTriggerGuide[triggerType], param)
        end
    end

    triggerType = GuideTriggerType.FinishBattleLevel
    list = self.allTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in pairs(list) do
            if self.specialTriggerGuide[triggerType] == nil then
                self.specialTriggerGuide[triggerType] = {}
            end
            local param = {}
            param.triggerType = triggerType
            param.triggerPara = k
            param.triggers = {}
            local spl = string.split_ss_array(k, ";")
            for k1,v1 in ipairs(spl) do
                local spl1 = string.split_ii_array(v1, ",")
                local spl1Count = table.count(spl1)
                if spl1Count > 1 and spl1[1] <= spl1[2]  then
                    for i = spl1[1], spl1[2] , 1 do
                        table.insert(param.triggers, i)
                    end
                elseif spl1Count == 1 then
                    table.insert(param.triggers, spl1[1])
                end
            end
            table.insert(self.specialTriggerGuide[triggerType], param)
        end
    end

    --序章背东西达到数量触发
    triggerType = GuideTriggerType.PrologueOwnNum
    list = self.allTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in pairs(list) do
            if self.specialTriggerGuide[triggerType] == nil then
                self.specialTriggerGuide[triggerType] = {}
            end
            local param = {}
            param.triggerType = triggerType
            param.triggerPara = k
            param.needRes = {}
            local spl2 = string.split_ss_array(k, ";")
            for k1,v1 in ipairs(spl2) do
                local spl3 = string.split_ii_array(v1, ",")
                local spl3Count = table.count(spl3)
                if spl3Count > 1 then
                    local need = {}
                    need.resType = spl3[1]
                    need.count = spl3[2]
                    table.insert(param.needRes,need)
                end
            end
            table.insert(self.specialTriggerGuide[triggerType], param)
        end
    end
end

local function GetSpecialTriggerPara(self,triggerType,triggerPara)
    local list = self.specialTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in ipairs(list) do
            if triggerType == GuideTriggerType.PveEnterBattle then
                for k1,v1 in ipairs(v.triggers) do
                    if v1 == triggerPara then
                        return v.triggerPara
                    end
                end
            elseif triggerType == GuideTriggerType.FinishBattleLevel then
                local numTriggerPara = tonumber(triggerPara)
                for k1,v1 in ipairs(v.triggers) do
                    if v1 == numTriggerPara then
                        return v.triggerPara
                    end
                end
            end
        end
    end

    return triggerPara
end

local function OnScienceQueueResearchSignal(bUuid)
    --DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.StartScience, tostring(scienceType + curLevel))
end

--是否能显示奖励
local function IsCanShowReward(self)
    if self:InGuide() and self.template.type ~= GuideType.ShowFakeHero and self.template.type ~= GuideType.WaitQuestionEnd and
            self.template.type ~= GuideType.WaitCloseUI and self.template.type ~= GuideType.WaitMessageFinish then
        return false
    end
    return true
end
--设置是否成功出征标志
local function SetSuccessMarchFlag(self,flag)
    self.successMarchFlag = flag
end

local function StartAttackMonsterWithoutMsgTipSignal(flag)
    DataCenter.GuideManager:SetSuccessMarchFlag(tonumber(flag))
end

--是否显示雷达气泡
local function IsShowRadarBubble(self)
    return DataCenter.GuideManager:GetSaveGuideValue(GuideNoShowRadarBubble) ~= SaveGuideDoneValue
end

--是否显示世界垃圾点
local function IsShowWorldCollectPoint(self)
    return self:GetSaveGuideValue(GuideNoShowCollectPoint) ~= SaveGuideDoneValue
end

--是否是引导手指点击类型
local function IsGuideArrowType(self)
    return self.template ~= nil and (self.template.type == GuideType.ClickButton or self.template.type == GuideType.ClickBuild or self.template.type == GuideType.QueueBuild
            or self.template.type == GuideType.Bubble or self.template.type == GuideType.GotoMoveBubble
            or self.template.type == GuideType.OpenFog or self.template.type == GuideType.ClickBuildFinishBox
            or self.template.type == GuideType.ClickTime or self.template.type == GuideType.ClickQuickBuildBtn or self.template.type == GuideType.ClickMonster
            or self.template.type == GuideType.ClickTimeLineBubble
            or self.template.type == GuideType.ClickRadarBubble
            or self.template.type == GuideType.ClickUISpecialBtn
            or self.template.type == GuideType.ClickCollectResource
            or self.template.type == GuideType.ClickRadarMonster
            or self.template.type == GuideType.ClickLandZoneBubble or self.template.type == GuideType.ClickWoundedCompensateBubble
            or self.template.type == GuideType.ClickGuideHdcBubble
            or self.template.type == GuideType.ClickOpinionBox or self.template.type == GuideType.ClickLandLock)
end

--登录判断
local function CheckLoginGuide(self)
    --登录触发
    local triggerType = GuideTriggerType.Login
    local list = self.allTriggerGuide[triggerType]
    if list ~= nil then
        for k,v in pairs(list) do
            if not self:IsDoneThisGuide(v) then
                local template = DataCenter.GuideTemplateManager:GetGuideTemplate(v)
                if template ~= nil then
                    --判断跳过条件 满足就保存
                    local state = self:GetCanDoGuideState(v)
                    if state == GuideCanDoType.Yes then
                        self:SendSaveGuideMessage(self:GetDoneGuideEndId(v), SaveGuideDoneValue)
                        EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
                    end
                end
            end
        end
    end
end

local function UpdateAlCanBeLeaderSignal()
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil then
        if template.type == GuideType.CheckBecomeAllianceLeader then
            if DataCenter.AllianceLeaderManager:CheckCanBeLeader() then
                DataCenter.GuideManager:SetCurGuideId(tonumber(template.para1))
                DataCenter.GuideManager:DoGuide()
            else
                DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
                DataCenter.GuideManager:DoGuide()
            end
        end
    end
end

local function GetGuideBgmName(self)
    return self:GetSaveGuideValue(GuideBgmName)
end

local function GarbageCollectStartSignal(marchUuid)
    if DataCenter.GuideManager:GetGuideType() == GuideType.WaitGolloesArrived then
        local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
        if worldMarch and worldMarch.targetUuid == marchUuid then
            CS.SceneManager.World.marchUuid = 0
            DataCenter.WorldMarchDataManager:TrackMarch(0)
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
            DataCenter.GuideManager:DoNext()
        end
    end
end

--如果当前在pve或者打开界面要等到回到主城且界面关闭后才能触发
local function CheckNeedWaitTriggerGuide(self, triggerType, triggerParam)
    if self:InGuide() or DataCenter.BattleLevel:IsInBattleLevel() or UIManager:GetInstance():HasWindow() or not SceneUtils.GetIsInCity() then
        self:AddOneWaitTrigger(triggerType, triggerParam)
    else
        DataCenter.GuideManager:CheckDoTriggerGuide(triggerType, triggerParam)
    end
end

local function AddOneWaitTrigger(self, triggerType, triggerParam)
    for k,v in ipairs(self.waitTrigger) do
        if v.triggerType == triggerType and v.triggerParam == triggerParam then
            return
        end
    end
    local param = {}
    param.triggerType = triggerType
    param.triggerParam = triggerParam
    table.insert(self.waitTrigger, param)
end

local function RemoveOneWaitTrigger(self, triggerType, triggerParam)
    for k,v in ipairs(self.waitTrigger) do
        if v.triggerType == triggerType and v.triggerParam == triggerParam then
            table.remove(self.waitTrigger, k)
            return
        end
    end
end

local function DoWaitTriggerAfterBack(self)
    for k,v in ipairs(self.waitTrigger) do
        self:CheckNeedWaitTriggerGuide(v.triggerType,v.triggerParam)
    end
end

--获取序章需要材料到达配置数目触发的引导
function GuideManager:GetPrologueOwnNumTriggerGuide()
    return self.specialTriggerGuide[GuideTriggerType.PrologueOwnNum]
end

function GuideManager:DeleteWaitLongDelayTimer()
    if self.waitLongDelayTimer ~= nil then
        self.waitLongDelayTimer:Stop()
        self.waitLongDelayTimer = nil
    end
end

function GuideManager:AddWaitLongDelayTimer(time)
    self:DeleteWaitLongDelayTimer()
    if self.waitLongDelayTimer == nil then
        self.waitLongDelayTimer = TimerManager:GetInstance():GetTimer(time, self.wait_long_delay_timer_callback , self, true,false,false)
        self.waitLongDelayTimer:Start()
    end
end

function GuideManager:WaitLongDelayTimerCallBack()
    self:DeleteWaitLongDelayTimer()
    --直接结束引导
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadMask) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadMask)
    end
    self:SetCurGuideId(GuideEndId)
    self:DoGuide()
end

function GuideManager:ReInitTemplate()
    self.allTriggerGuide = {}
    DataCenter.GuideTemplateManager:InitAllTemplate(self.allTriggerGuide)
    self:InitSpecialTrigger()
end

--造桥关卡通关
function GuideManager:MergeExitBackCitySignal(param)
    if param ~= nil then
        if param.exitType == MergeExitType.FinishOrder and param.guideTriggerParam ~= nil then
            self:CheckDoTriggerGuide(GuideTriggerType.MergeExitFinishOrder, param.guideTriggerParam)
        end
    end
end

--是否是合成新引导
function GuideManager:IsMergeNewGuide()
    return LuaEntry.DataConfig:CheckSwitch("merge_new_guide")
end
function GuideManager:DeleteCheckErrorTimer()
    if self.check_error_timer ~= nil then
        self.check_error_timer:Stop()
        self.check_error_timer = nil
    end
end

--针对发生报错后，引导卡死的情况，有些引导类型可以1秒判断一次，防止卡死（例如等待页面关闭引导，页面本身不存在，已经关闭了）
function GuideManager:AddCheckErrorTimer()
    if self.check_error_timer == nil then
        self.check_error_timer = TimerManager:GetInstance():GetTimer(1, self.check_error_timer_callback, self, false, false, false)
        self.check_error_timer:Start()
    end
end

function GuideManager:CheckErrorTimerCallBack()
    local guideType = self:GetGuideType()
    if guideType == GuideType.WaitCloseUI then
        if not UIManager:GetInstance():IsWindowOpen(self.template.para1) then
            self:DeleteCheckErrorTimer()
            self:DoNext()
        end
    end
end

--造兵是否可以免费加速
function GuideManager:IsTrainFreeSpeed()
    return DataCenter.GuideManager:GetSaveGuideValue(TrainFreeSpeed) == SaveGuideDoneValue
end

--造桥关卡通关
function GuideManager:BuildUpgradeStartSignal(uuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        self:CheckDoTriggerGuide(GuideTriggerType.BuildUpgradeStart, tostring(buildData.itemId + buildData.level))
    end
end

--造兵是否可以免费加速
function GuideManager:MovieCallBack()
    local guideType = self:GetGuideType()
    if guideType == GuideType.WaitMovieComplete then
        self:DoNext()
    end
end

--造兵是否可以免费加速
function GuideManager:SpeechTalkCallBack()
    local guideType = self:GetGuideType()
    if guideType == GuideType.ShowSpeechTalk then
        self:DoNext()
    end
end

--是否可以显示随机僵尸
function GuideManager:CanShowRandomZombie()
    return self.canShowRandomZombie and DataCenter.GuideManager:GetSaveGuideValue(NoShowRandomZombie) ~= SaveGuideDoneValue
end

function GuideManager:SetShowRandomZombie(value)
    self.canShowRandomZombie = value
end

function GuideManager:AddMoveCameraTimer(time)
    self:DeleteMoveCameraTimer()
    self.moveCameraTimer = TimerManager:GetInstance():DelayInvoke(self.move_camera_callback, time + GuideMovieCameraTimeDelta)
end

function GuideManager:MoveCameraTimerCallBack()
    self:DeleteMoveCameraTimer()
    if self.template ~= nil and self.template.type == GuideType.MoveCamera then
        self:DoNext()
    end
end

function GuideManager:DeleteMoveCameraTimer()
    if self.moveCameraTimer ~= nil then
        self.moveCameraTimer:Stop()
        self.moveCameraTimer = nil
    end
end

--是否免费租赁队列
function GuideManager:IsFreeLeaseBuildQueue()
    if self:GetSaveGuideValue(FreeLeaseSecondBuildQueue) == SaveGuideDoneValue then
        return false
    end
    local count = DataCenter.BuildQueueManager:GetOwnBuildQueueCount()
    if count == 1 then
        return true
    end
    
    return false
end

function GuideManager:NeedRefreshGuideArrowSignal()
    if self:IsGuideArrowType() then
        --object改变 需要重新获取
        self.obj = nil
        self:DoGuide()
    end
end

function GuideManager:PveLineUpInitEndSignal()
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PveEnter, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    self:CheckDoTriggerGuide(GuideTriggerType.EnterPve, tostring(DataCenter.BattleLevel:GetLevelId()))
end

function GuideManager:PveLevelBeforeEnterSignal()
    self:ParkourBattleBeforeEnterSignal()
end

function GuideManager:ParkourBattleEnterCompleteSignal()
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.ParkourBattleEnter, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    self:CheckDoTriggerGuide(GuideTriggerType.ParkourBattleEnter, tostring(DataCenter.LWBattleManager:GetPveId()))
end

function GuideManager:ParkourBattleBeforeEnterSignal()
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.ParkourBattleEnter, true)
end

--是否使用引导参数
function GuideManager:IsUseGuideCameraConfig()
    return self.useGuideCameraConfig
end

--是否可以显示地块
function GuideManager:CanShowLand()
    return DataCenter.GuideManager:GetSaveGuideValue(CanShowLand) ~= SaveGuideDoneValue
end

function GuideManager:InitSaveWaitTrigger()
    local str = self:GetSaveGuideValue(SaveWaitTrigger)
    if str ~= nil and str ~= "" then
        self.saveWaitTrigger = string.split_ii_array(str, ";")
    else
        self.saveWaitTrigger = {}
    end
end

function GuideManager:SaveWaitTrigger(guideId)
    table.insert(self.saveWaitTrigger, guideId)
    self:SendSaveWaitTrigger()
end

function GuideManager:RemoveSaveWaitTrigger(guideId)
    for i = #self.saveWaitTrigger, 1, -1 do
        if self.saveWaitTrigger[i] == guideId then
            table.remove(self.saveWaitTrigger, i)
        end
    end
    self:SendSaveWaitTrigger()
end

function GuideManager:SendSaveWaitTrigger()
    local result = ""
    for k,v in ipairs(self.saveWaitTrigger) do
        if result == "" then
            result = tostring(v)
        else
            result = result .. ";" .. v
        end
    end
    self:SendSaveGuideMessage(SaveWaitTrigger, result)
end

--是否满足做触发引导的条件
function GuideManager:CanDoSaveTriggerType(guideId)
    local saveTrigger = GetTableData(DataCenter.GuideTemplateManager:GetTableName(), guideId, "tipswaittime", {})
    if saveTrigger[1] ~= nil then
        if saveTrigger[1] == GuideTriggerSaveType.InCity then
            if SceneUtils.GetIsInCity() and (not UIManager:GetInstance():HasWindow()) then
                return true
            end
        elseif saveTrigger[1] == GuideTriggerSaveType.InWorld then
            if SceneUtils.GetIsInWorld() and (not UIManager:GetInstance():HasWindow()) then
                return true
            end
        elseif saveTrigger[1] == GuideTriggerSaveType.UI then
            if UIManager:GetInstance():IsWindowOpen(saveTrigger[2]) then
                return true
            end
        end
    end
    return false
end

function GuideManager:CheckDoSaveTrigger()
    if self.saveWaitTrigger[1] ~= nil and not self:InGuide() then
        for k, v in ipairs(self.saveWaitTrigger) do
            if not self:IsDoneThisGuide(v) then
                if self:CanDoSaveTriggerType(v) then
                    self:SetCurGuideId(v)
                    self:DoGuide()
                    break
                end
            end
        end
    end
end

function GuideManager:OnEnterWorldSignal()
    self:CheckDoSaveTrigger()
end
function GuideManager:OnEnterCitySignal()
    self:CheckDoSaveTrigger()
end

function GuideManager:GetGuideObjAndUuid(str)
    local obj = nil
    local uuid = ""
    local spl = string.split_ss_array(str, "|")
    local objType = tonumber(spl[1])
    if objType == GuideResidentObjType.Resident then
        local id = tonumber(spl[2])
        local data = DataCenter.CityResidentManager:GetDataById(CityResidentDefines.Type.Resident, id)
        if data ~= nil then
            obj = data.obj
        end
        uuid = "GuideResidentObjType" .. objType .. id
    elseif objType == GuideResidentObjType.Timeline then
        local spl2 = string.split_ii_array(spl[2], ";")
        obj = DataCenter.GuideCityAnimManager:GetGuideTalkObject(spl2[1], spl2[2])
        uuid = "GuideResidentObjType" .. objType .. spl2[1] .. spl2[2]
    elseif objType == GuideResidentObjType.Hero then
        local id = tonumber(spl[2])
        local data = DataCenter.CityResidentManager:GetDataByIndex(CityResidentDefines.Type.Hero, id)
        if data ~= nil then
            obj = data.obj
        end
        uuid = "GuideResidentObjType" .. objType .. id
    end
    return obj, uuid
end

function GuideManager:AddOneTempFlag(flagType, param)
    self.guideTempFlag[flagType] = (param or {})
end

function GuideManager:RemoveOneTempFlag(flagType)
    self.guideTempFlag[flagType] = nil
end

function GuideManager:GetFlag(flagType)
    return self.guideTempFlag[flagType]
end

function GuideManager:DetectInfoChangeSignal()
    if self:InGuide() and self.template.type == GuideType.WaitRadarTaskFinish then
        --没有配置雷达任务，或者已完成走下一步
        local eventId = self.template.para1
        local info = DataCenter.RadarCenterDataManager:GetDetectEventInfoByEventId(eventId)
        if info ~= nil and (info.state == DetectEventState.DETECT_EVENT_STATE_FINISHED or info.state == DetectEventState.DETECT_EVENT_STATE_REWARDED) then
            self:DoNext()
        end
    end
end

GuideManager.__init = __init
GuideManager.__delete = __delete
GuideManager.Startup = Startup
GuideManager.InitData = InitData
GuideManager.GetSaveGuideId = GetSaveGuideId
GuideManager.SendSaveGuideMessage = SendSaveGuideMessage
GuideManager.SetCurGuideId = SetCurGuideId
GuideManager.SendLogMessage = SendLogMessage
GuideManager.InGuide = InGuide
GuideManager.GetGuideId = GetGuideId
GuideManager.AddListener = AddListener
GuideManager.RemoveListener = RemoveListener
GuideManager.DoGuide = DoGuide
GuideManager.UILoadingExitSignal = UILoadingExitSignal
GuideManager.BuildPlaceSignal = BuildPlaceSignal
GuideManager.CheckGuideComplete = CheckGuideComplete
GuideManager.CheckOpenUITriggerGuide = CheckOpenUITriggerGuide
GuideManager.OpenUISignal = OpenUISignal
GuideManager.DeleteAutoNextTimer = DeleteAutoNextTimer
GuideManager.AddAutoNextTimer = AddAutoNextTimer
GuideManager.AutoNextTimeCallBack = AutoNextTimeCallBack
GuideManager.GetCurTemplate = GetCurTemplate
GuideManager.HasClick = HasClick
GuideManager.NeedWaitLoadComplete = NeedWaitLoadComplete
GuideManager.DeleteWaitLoadTimer = DeleteWaitLoadTimer
GuideManager.AddWaitLoadTimer = AddWaitLoadTimer
GuideManager.WaitLoadCallBack = WaitLoadCallBack
GuideManager.GetGuideType = GetGuideType
GuideManager.SetCompleteNeedParam = SetCompleteNeedParam
GuideManager.GetGuideIdByTrigger = GetGuideIdByTrigger
GuideManager.GetGuideTemplateParam = GetGuideTemplateParam
GuideManager.QueueTimeEndSignal = QueueTimeEndSignal
GuideManager.QueueAddSignal = QueueAddSignal
GuideManager.InitTriggerGuide = InitTriggerGuide
GuideManager.GetNextGuideTemplateParam = GetNextGuideTemplateParam
GuideManager.OnClickWorldSignal = OnClickWorldSignal
GuideManager.OpenFogSuccessSignal = OpenFogSuccessSignal
GuideManager.BuildUpgradeFinishSignal = BuildUpgradeFinishSignal
GuideManager.GetDoneGuideEndId = GetDoneGuideEndId
GuideManager.IsDoneThisGuide = IsDoneThisGuide
GuideManager.PlayMovieCompleteSignal = PlayMovieCompleteSignal
GuideManager.CheckDoTriggerGuide = CheckDoTriggerGuide
GuideManager.SaveFinalGarbageRewardItemId = SaveFinalGarbageRewardItemId
GuideManager.GetFinalGarbageRewardItemId = GetFinalGarbageRewardItemId
GuideManager.GetSaveGuideValue = GetSaveGuideValue
GuideManager.IsCanCloseUI = IsCanCloseUI
GuideManager.IsCanQuitFocus = IsCanQuitFocus
GuideManager.ChapterTaskGetRewardSignal = ChapterTaskGetRewardSignal
GuideManager.IsCanDoUIMainAnim = IsCanDoUIMainAnim
GuideManager.SetNoShowUIMain = SetNoShowUIMain
GuideManager.SetCanShowBuild = SetCanShowBuild
GuideManager.IsStartCanShowBuild = IsStartCanShowBuild
GuideManager.ShowAllGuideObjectSignal = ShowAllGuideObjectSignal
GuideManager.CloseUISignal = CloseUISignal
GuideManager.CheckNeedWaitTime = CheckNeedWaitTime
GuideManager.DeleteWaitTimeTimer = DeleteWaitTimeTimer
GuideManager.AddWaitTimeTimer = AddWaitTimeTimer
GuideManager.WaitTimeCallBack = WaitTimeCallBack
GuideManager.ChapterTaskSignal = ChapterTaskSignal
GuideManager.GetDoneGuideStartId = GetDoneGuideStartId
GuideManager.CheckFirstJoinAllianceGuide = CheckFirstJoinAllianceGuide
GuideManager.AllianceApplySuccessSignal = AllianceApplySuccessSignal
GuideManager.IsStartId = IsStartId
GuideManager.GetCanDoGuideState = GetCanDoGuideState
GuideManager.IsCanClick = IsCanClick
GuideManager.GuideWaitMessageSignal = GuideWaitMessageSignal
GuideManager.CheckWaitMessage = CheckWaitMessage
GuideManager.MainTaskSuccessSignal = MainTaskSuccessSignal
GuideManager.DoNext = DoNext
GuideManager.LoadGuideGm = LoadGuideGm
GuideManager.DestroyGm = DestroyGm
GuideManager.SetWaitingMessage = SetWaitingMessage
GuideManager.SaveRecommendShow = SaveRecommendShow
GuideManager.GetRecommendShow = GetRecommendShow
GuideManager.BuildResourcesStartSignal = BuildResourcesStartSignal
GuideManager.OnWorldInputPointDownSignal = OnWorldInputPointDownSignal
GuideManager.SetGuideEndCallBack = SetGuideEndCallBack
GuideManager.CheckMoveToWorldGuide = CheckMoveToWorldGuide
GuideManager.CheckNoInput = CheckNoInput
GuideManager.CheckStopDub = CheckStopDub
GuideManager.CheckPlayDub = CheckPlayDub
GuideManager.StopDub = StopDub
GuideManager.PlayDub = PlayDub
GuideManager.CheckCanDragGuide =CheckCanDragGuide
GuideManager.CheckTipsWaitTime =CheckTipsWaitTime
GuideManager.TipsWaitTimeCallBack =TipsWaitTimeCallBack
GuideManager.CallBackDoGuide =CallBackDoGuide
GuideManager.ShowLog =ShowLog
GuideManager.DoJump =DoJump
GuideManager.IsDragGuide =IsDragGuide
GuideManager.SetNoGotoTime =SetNoGotoTime
GuideManager.TrainingArmySignal =TrainingArmySignal
GuideManager.ClickMuchStop =ClickMuchStop
GuideManager.UpdateScienceDataSignal =UpdateScienceDataSignal
GuideManager.GetReachJumpState =GetReachJumpState
GuideManager.DoMuchStopJumpGuide =DoMuchStopJumpGuide
GuideManager.StopAllEffectSound =StopAllEffectSound
GuideManager.RefreshObject =RefreshObject
GuideManager.IsSendBuildPlace =IsSendBuildPlace
GuideManager.IsShowPrologue =IsShowPrologue

GuideManager.ShowGuideHand = ShowGuideHand
GuideManager.RemoveGuideHand = RemoveGuideHand
GuideManager.LookBackToCharacter = LookBackToCharacter
GuideManager.HospitalUpdateSignal = HospitalUpdateSignal
GuideManager.CheckTreatSoldierGuide = CheckTreatSoldierGuide
GuideManager.GetSpaceManExtraNum = GetSpaceManExtraNum
GuideManager.SaveSpaceManExtraNum = SaveSpaceManExtraNum
GuideManager.InitSpecialTrigger = InitSpecialTrigger
GuideManager.GetPveTriggerGuide = GetPveTriggerGuide
GuideManager.GetSpecialTriggerPara = GetSpecialTriggerPara
GuideManager.OnScienceQueueResearchSignal = OnScienceQueueResearchSignal
GuideManager.IsCanShowReward = IsCanShowReward
GuideManager.StartAttackMonsterWithoutMsgTipSignal = StartAttackMonsterWithoutMsgTipSignal
GuideManager.SetSuccessMarchFlag = SetSuccessMarchFlag
GuideManager.IsShowRadarBubble = IsShowRadarBubble
GuideManager.IsShowWorldCollectPoint = IsShowWorldCollectPoint
GuideManager.IsGuideArrowType = IsGuideArrowType
GuideManager.CheckLoginGuide = CheckLoginGuide
GuideManager.UpdateAlCanBeLeaderSignal = UpdateAlCanBeLeaderSignal
GuideManager.GetGuideBgmName = GetGuideBgmName
GuideManager.GarbageCollectStartSignal = GarbageCollectStartSignal
GuideManager.SendLogToNet = SendLogToNet
GuideManager.CheckNeedWaitTriggerGuide = CheckNeedWaitTriggerGuide
GuideManager.AddOneWaitTrigger = AddOneWaitTrigger
GuideManager.RemoveOneWaitTrigger = RemoveOneWaitTrigger
GuideManager.DoWaitTriggerAfterBack = DoWaitTriggerAfterBack
return GuideManager
