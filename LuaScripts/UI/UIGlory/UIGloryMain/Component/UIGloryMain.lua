---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/27 20:10
---

local UIGloryMain = BaseClass("UIGloryMain", UIBaseContainer)
local base = UIBaseContainer
local UIGloryBtnList = require "UI.UIGlory.Component.UIGloryBtnList"
local UIGloryMainPreview = require "UI.UIGlory.UIGloryMain.Component.UIGloryMainPreview"
local UIGloryMainMenu = require "UI.UIGlory.UIGloryMain.Component.UIGloryMainMenu"
local UIGloryMainSettle = require "UI.UIGlory.UIGloryMain.Component.UIGloryMainSettle"
local UIMasteryEntrance = require "UI.UIMastery.Component.UIMasteryEntrance"
local UIWeekBuff = require "UI.UISeasonWeek.Component.UIWeekBuff"
local Localization = CS.GameEntry.Localization

local back_path = "SafeArea/Back"
local backBg_path = "Bg"
local time_path = "SafeArea/Time"
local info_path = "SafeArea/Time/Info"
local btn_list_path = "SafeArea/UIGloryBtnList"
local preview_path = "SafeArea/UIGloryMainPreview"
local menu_path = "SafeArea/UIGloryMainMenu"
local settle_path = "SafeArea/UIGloryMainSettle"
local mastery_entrance_path = "SafeArea/layout/UIMasteryEntrance"
local interstellar_path = "SafeArea/layout/UIInterstellar"
local stamina_ball_path = "SafeArea/layout/UIExperienceEntrance"
local stamina_red_dot_path = "SafeArea/layout/UIExperienceEntrance/RedDot"
local stamina_slider_path = "SafeArea/layout/UIExperienceEntrance/Slider"
local stamina_txt_path = "SafeArea/layout/UIExperienceEntrance/Name"
local interstellar_red_path = "SafeArea/layout/UIInterstellar/migrateRedPoint"
local interstellar_obj_path = "SafeArea/layout/UIInterstellar/GameObject"
local interstellar_time_path = "SafeArea/layout/UIInterstellar/Txt_InterstellarEndTime"
local interName_path = "SafeArea/layout/UIInterstellar/Txt_InterName"
local buff_path = "SafeArea/layout/UIWeekBuff"
local sFive_rect_path = "SafeArea/UIGlorySFive"
local president_btn_path = "SafeArea/prisident"
local president_txt_path = "SafeArea/prisident/prisidentText"
local enterCross_path = "SafeArea/UIGlorySFive/layout/Btn_EnterCross"
local enterCross_txt_path = "SafeArea/UIGlorySFive/layout/Btn_EnterCross/Txt_EnterCross"
local cross_time_path = "SafeArea/UIGlorySFive/layout/Txt_crossTime"
local sFiveTime_path = "SafeArea/UIGlorySFive/layout/Txt_SFiveTime"
local sFiveTime_btn_path = "SafeArea/UIGlorySFive/layout/Txt_SFiveTime/Btn_SFiveTime"
local sFiveTips_btn_path = "SafeArea/UIGlorySFive/layout/Btn_SFiveTips"

local ActParam = {UIMastery = 1}
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:CheckShowMigrateRed()
    self:CheckShowStamina()
    self:ReInit()

    local seasonEndState = DataCenter.RobotWarsManager:GetSeasonEndState()
    if seasonEndState and not self.isShowIntro then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
        if curTime < settleTime then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGlorySeasonEnd)
            self.isShowIntro = true
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
            Setting:SetString(LuaEntry.Player.uid .. "_".."SEASON_END"..seasonId,tostring(curTime))
        end
    end
end

local function OnDisable(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self:DeleteTimer()
    self:DeleteColdDownTimer()
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.back_bg = self:AddComponent(UIImage, backBg_path)
    self.back_btn = self:AddComponent(UIButton, back_path)
    self.back_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    --赛季结束时间
    self.time_text = self:AddComponent(UIText, time_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self.btn_list = self:AddComponent(UIGloryBtnList, btn_list_path)
    self.preview = self:AddComponent(UIGloryMainPreview, preview_path)
    self.menu = self:AddComponent(UIGloryMainMenu, menu_path)
    self.settle = self:AddComponent(UIGloryMainSettle, settle_path)
    self.mastery_entrance = self:AddComponent(UIMasteryEntrance, mastery_entrance_path)
    self._interstellar_btn = self:AddComponent(UIButton,interstellar_path)
    self._interstellar_btn:SetOnClick(function()
        self:OnInterClick()
    end)
    self.interstellar_obj = self:AddComponent(UIBaseContainer,interstellar_obj_path)
    self.interstellar_time = self:AddComponent(UIText,interstellar_time_path)
    self.interstellar_red = self:AddComponent(UIBaseContainer,interstellar_red_path)
    self._interName_txt = self:AddComponent(UIText,interName_path)

    self.slider = self:AddComponent(UISlider,stamina_slider_path)
    self.stamina_ball_btn = self:AddComponent(UIButton,stamina_ball_path)
    self.stamina_ball_btn:SetOnClick(function()
        self:OnStaminaClick()
    end)
    self.stamina_red_dot = self:AddComponent(UIBaseContainer,stamina_red_dot_path)
    self.stamina_txt = self:AddComponent(UIText,stamina_txt_path)
    self.stamina_txt:SetLocalText(376169)
    self.buff = self:AddComponent(UIWeekBuff, buff_path)

    --S5界面
    self._sFiveTitle_txt = self:AddComponent(UIText,"SafeArea/UIGlorySFive/Txt_SFiveTitle")
    self._sFiveDesc_txt = self:AddComponent(UIText,"SafeArea/UIGlorySFive/layout/Txt_SFiveDesc")
    self._sFive_rect = self:AddComponent(UIBaseContainer,sFive_rect_path)
    self._enterCross_btn = self:AddComponent(UIButton,enterCross_path)
    self._enterCross_btn:SetOnClick(function()
        self:OnClickEnterCross()
    end)
    self._enterCross_txt = self:AddComponent(UIText,enterCross_txt_path)
    self.cross_time = self:AddComponent(UIText,cross_time_path)
    self._sFiveTime_txt = self:AddComponent(UIText,sFiveTime_path)
    self._sFiveTime_btn = self:AddComponent(UIButton,sFiveTime_btn_path)
    self._sFiveTime_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoClick()
    end)
    self._sFiveTips_btn = self:AddComponent(UIButton,sFiveTips_btn_path)
    self._sFiveTips_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickSFiveTips()
    end)
    self.president_btn = self:AddComponent(UIButton, president_btn_path)
    self.president_btn:SetOnClick(function()
        self:OnPresidentClick()
    end)
    self.president_txt = self:AddComponent(UIText, president_txt_path)
    self.president_txt:SetLocalText(250005)
    self.president_btn:SetActive(false)
end

local function ComponentDestroy(self)
    self.back_btn = nil
    self.time_text = nil
    self.info_btn = nil
    self.btn_list = nil
    self.preview = nil
    self.menu = nil
    self.settle = nil
    self.mastery_entrance = nil
end

local function DataDefine(self)
    self.isShowIntro = false
    self.period = GloryPeriod.None
    self.switchTime = 0
    self.timer = nil
    self.timer_btn = nil
    self.timer_coldDown = nil
    self.crossLimitEndTime = 0
    self.timer_action = function(temp)
        self:RefreshTime(temp)
    end
    self.timer_actionEnd = function(temp)
        self:RefreshEndTime(temp)
    end
    self.timer_coldDownAction = function(temp)
        self:RefreshColdDownEndTime(temp)
    end
    self.timer_actionSFive = function(temp)
        self:RefreshSFiveTime(temp)
    end
end

local function DataDestroy(self)
    self.period = nil
    self.switchTime = nil
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self:DeleteSFiveTimer()
    self:DeleteColdDownTimer()
    self:DeleteTimer()
    self:DeleteEndTimer()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GloryGetWarData, self.OnGloryGetWarData)
    self:AddUIListener(EventId.GloryGetAct, self.OnGloryGetAct)
    self:AddUIListener(EventId.RefreshActivityRedDot, self.CheckShowMigrateRed)
    self:AddUIListener(EventId.GetMigrateList, self.CheckShowMigrateRed)
    self:AddUIListener(EventId.StaminaBallData,self.CheckShowStamina)
    self:AddUIListener(EventId.RefreshMigrateInfo,self.RefreshInterStelltar)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GloryGetWarData, self.OnGloryGetWarData)
    self:RemoveUIListener(EventId.GloryGetAct, self.OnGloryGetAct)
    self:RemoveUIListener(EventId.RefreshActivityRedDot, self.CheckShowMigrateRed)
    self:RemoveUIListener(EventId.GetMigrateList, self.CheckShowMigrateRed)
    self:RemoveUIListener(EventId.StaminaBallData,self.CheckShowStamina)
    self:RemoveUIListener(EventId.RefreshMigrateInfo,self.RefreshInterStelltar)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    DataCenter.GloryManager:SendGetWarData()
    local activityData = DataCenter.GloryManager:GetActivityData()
    if activityData then
        self.btn_list:SetGroupId(activityData.groupId)
    end
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local isFormal = true
    self.btn_list:SetSeasonId(seasonId,isFormal)
end

local function SetData(self, activityId, param,actParam)
    self.preview:SetData(activityId, param)
    self.crossLimitEndTime = 0
    if actParam and actParam == ActParam.UIMastery then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMastery, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
    end

    SFSNetwork.SendMessage(MsgDefines.SeasonBalanceViewOpen)
    SFSNetwork.SendMessage(MsgDefines.MigrateActivityInfo)
    if LuaEntry.Player.crossFightSrcServerId and (LuaEntry.Player.crossFightSrcServerId == -1 or LuaEntry.Player.crossFightSrcServerId == LuaEntry.Player.serverId) then
        self._enterCross_txt:SetLocalText(111053)
    else
        self._enterCross_txt:SetLocalText(111054)
    end
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    if seasonId ~= 5 then
        self.back_bg:LoadSprite("Assets/Main/TextureEx/UIGloryLeague/gloryleague_bg_large_s" .. seasonId)
        self:ReIntEndTime()
        self.president_btn:SetActive(false)
    else
        self.back_bg:LoadSprite("Assets/Main/TextureEx/UIGloryLeague/gloryleague_bg_advance_s5")
        self:ReIntSFiveTime()
        if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and DataCenter.GovernmentManager:IsSelfPresident() then
            self.president_btn:SetActive(true)
        else
            self.president_btn:SetActive(false)
        end
    end
end

local function Refresh(self)
    self.crossLimitEndTime = 0
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    if LuaEntry.Player:IsInAlliance() then
        self.period, self.switchTime = DataCenter.GloryManager:GetPeriod()
        self.btn_list:SetActive(true)
        self.preview:SetActive(false)
        if seasonId == 5 then
            self.buff:SetActive(true)
            self.buff:Refresh()
            self._sFive_rect:SetActive(true)
            self._enterCross_btn:SetActive(LuaEntry.Player:IsInAlliance())
            self.preview:SetActive(false)
            self.menu:SetActive(false)
            self.settle:SetActive(false)
            local str = GetTableData(TableName.APS_Season,seasonId, 'season_des')
            local dialog = string.split(str,"|")
            self._sFiveTitle_txt:SetLocalText(dialog[1])
            self._sFiveDesc_txt:SetLocalText(dialog[2])
            self:RefreshEdenBtn()
        else
            self.buff:SetActive(false)
            self._sFive_rect:SetActive(false)
            local useTimer = false
            if self.period == GloryPeriod.Unopened then
                self.menu:SetActive(true)
                self.settle:SetActive(false)
                --self.invasion_btn:SetActive(false)
            elseif self.period == GloryPeriod.Prepare or self.period == GloryPeriod.Start then
                self.menu:SetActive(true)
                self.settle:SetActive(false)
                --self.invasion_btn:SetActive(true)
                --self.period_text:SetActive(true)
                useTimer = true
            elseif self.period == GloryPeriod.Settle then
                self.menu:SetActive(false)
                self.settle:SetActive(true)
                --self.invasion_btn:SetActive(true)
                --self.period_text:SetActive(false)
            end

            if useTimer and self.timer == nil then
                self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
                self.timer:Start()
                self:TimerAction()
            elseif not useTimer and self.timer ~= nil then
                self.timer:Stop()
                self.timer = nil
            end
        end
    else
        self.buff:SetActive(false)
        self.menu:SetActive(false)
        self.settle:SetActive(false)
        self.preview:SetActive(true)
        local isFormal = true
        self.preview:SetSeasonId(isFormal)
        self._sFive_rect:SetActive(false)
        self.btn_list:SetActive(false)
    end
end

local function RefreshEdenBtn(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startTime = LuaEntry.Player:GetEdenCoolDownTime()
    local addTime = 0
    local configTime = LuaEntry.DataConfig:TryGetNum("eden_activity_config", "k1")
    if configTime~=nil then
        addTime = configTime*1000
    end
    local endTime = addTime+startTime
    if endTime>curTime then
        self.crossLimitEndTime = endTime
        CS.UIGray.SetGray(self._enterCross_btn.transform, true, false)
        self:AddColdDownTimer()
        self:RefreshColdDownEndTime()
    else
        CS.UIGray.SetGray(self._enterCross_btn.transform, false, true)
        self.cross_time:SetText("")
        self.crossLimitEndTime = 0
        self:DeleteColdDownTimer()
    end
end

local function RefreshColdDownEndTime(self)
    if self.crossLimitEndTime>0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.crossLimitEndTime-curTime
        if deltaTime>0 then
            local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
            self.cross_time:SetLocalText(120397, restTimeStr)
        else
            self.cross_time:SetText("")
            self:RefreshEdenBtn()
        end
    end
end

--{{{s5相关时间刷新
local function ReIntSFiveTime(self)
    self._sFiveTime_txt:SetActive(false)
    self._sFiveTips_btn:SetActive(false)
    local sFiveBtnState = false
    local activityInfo = DataCenter.RobotWarsManager:GetActivityInfo()
    if activityInfo then
        local settledRewardEndTime = activityInfo.WorldSeasonRewardEndTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
        local actData = {str = nil,endTime = 0}
        if settleTime > 0 and curTime < settleTime then --赛季即将结束
            actData.str = 111042
            actData.endTime = settleTime
            sFiveBtnState = false
        else
            --获取预告活动下赛季开启时间
            local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.GloryPreview)
            if dataList ~= nil and #dataList > 0 then
                local data = dataList[1]
                if data ~= nil and data.WorldSeasonStartTime and curTime < data.WorldSeasonStartTime and settledRewardEndTime and curTime > settledRewardEndTime then
                    actData.str = 110360
                    actData.endTime = data.WorldSeasonStartTime
                end
            end
            if settledRewardEndTime and curTime < settledRewardEndTime then
                sFiveBtnState = true
            end
        end
        if actData.endTime ~= 0 then
            self._sFiveTime_txt:SetActive(true)
            self:AddSFiveTimer(actData)
            self:RefreshSFiveTime(actData) 
        end
        if LuaEntry.Player.crossFightSrcServerId and (LuaEntry.Player.crossFightSrcServerId == -1 or LuaEntry.Player.crossFightSrcServerId == LuaEntry.Player.serverId) then
            --检查是否在原服并且时间
            self._sFiveTips_btn:SetActive(sFiveBtnState)
        end
    end
end

local function AddSFiveTimer(self,actData)
    if actData ~= nil then
        if self.timer_SFive == nil then
            self.timer_SFive = TimerManager:GetInstance():GetTimer(1, self.timer_actionSFive ,actData , false,false,false)
        end
        self.timer_SFive:Start()
    end
end

local function RefreshSFiveTime(self,actListData)
    if actListData then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < actListData.endTime  then
            self._sFiveTime_txt:SetText(Localization:GetString(actListData.str)..": "..UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
        else
            self._sFiveTime_txt:SetText("00:00:00")
            self:DeleteSFiveTimer()
            self:ReIntSFiveTime()
        end
    end
end

local function DeleteSFiveTimer(self)
    if self.timer_SFive ~= nil then
        self.timer_SFive:Stop()
        self.timer_SFive = nil
    end
end
--}}}


local function AddColdDownTimer(self)
    if self.timer_coldDown == nil then
        self.timer_coldDown = TimerManager:GetInstance():GetTimer(1, self.timer_coldDownAction ,self, false,false,false)
    end
    self.timer_coldDown:Start()
end

local function DeleteColdDownTimer(self)
    if self.timer_coldDown ~= nil then
        self.timer_coldDown:Stop()
        self.timer_coldDown = nil
    end
end
local function TimerAction(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.switchTime >= curTime then
        --local restTime = math.floor(self.switchTime - curTime)
        --local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
        --self.period_text:SetText(restTimeStr)
    else
        self.timer:Stop()
        self.timer = nil
        DataCenter.GloryManager:SendGetWarData()
    end
end

--{{{按钮时间检测
local function RefreshInterStelltar(self,message)
    self:DeleteTimer()
    local dialog = 250300
    local path = "UIemigrate_entry"
    if message.type and message.type ~= 0 then
        if message.type == 2 then
            dialog = 250406
            path = "UIemigrate_entry02"
        end
        self:RefreshTime(message)
        self:AddTimer(message)
    else
        self._interstellar_btn:SetActive(false)
    end
    self._interstellar_btn:LoadSprite(string.format(LoadPath.UIInterstellarMigration,path))
    self._interName_txt:SetLocalText(dialog)
end

local function AddTimer(self,actData)
    if actData ~= nil then
        if self.timer_btn == nil then
            self.timer_btn = TimerManager:GetInstance():GetTimer(1, self.timer_action ,actData , false,false,false)
        end
        self.timer_btn:Start()
    end
end

local function RefreshTime(self,actListData)
    if actListData then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if actListData.startTime < curTime and curTime < actListData.endTime  then
            self._interstellar_btn:SetActive(true)
            self.interstellar_obj:SetActive(true)
            self.interstellar_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
            self.actEnd = false
        else
            SFSNetwork.SendMessage(MsgDefines.MigrateActivityInfo)
            self._interstellar_btn:SetActive(false)
            self:DeleteTimer()
            self.actEnd = true
        end
    else
        self._interstellar_btn:SetActive(false)
        self:DeleteTimer()
        self.actEnd = true
    end
end

local function DeleteTimer(self)
    if self.timer_btn ~= nil then
        self.timer_btn:Stop()
        self.timer_btn = nil
    end
end
--}}}

--local function OnInvasionClick(self)
--    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryPeriod, self.period)
--end

--{{{赛季结束倒计时
local function ReIntEndTime(self)
    self:DeleteEndTimer()
    self.info_btn:SetActive(false)
    local activityInfo = DataCenter.RobotWarsManager:GetActivityInfo()
    if activityInfo then
        local endTime = 0
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local settleEndTime = activityInfo.settleEndTime
        local finishTime = activityInfo.WorldSeasonRewardEndTime
        local nextSeasonTime = activityInfo.WorldSeasonStartTime
        if settleEndTime > 0 and curTime < settleEndTime then
            endTime = settleEndTime
            self.info_btn:SetActive(true)
        elseif finishTime > 0 and curTime < finishTime then
            endTime = finishTime
        elseif finishTime > 0 and curTime > finishTime then
            endTime = nextSeasonTime
        end
        if endTime ~= 0 then
            self:AddEndTimer(endTime)
            self:RefreshEndTime(endTime)
        end
    end
end

local function AddEndTimer(self,endTime)
    if endTime ~= nil then
        if self.timer_end == nil then
            self.timer_end = TimerManager:GetInstance():GetTimer(1, self.timer_actionEnd ,endTime , false,false,false)
        end
        self.timer_end:Start()
    end
end

local function RefreshEndTime(self,endTime)
    if endTime then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < endTime  then
            self.time_text:SetActive(true)
            self.time_text:SetText(Localization:GetString("111042")..": "..UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
        else
            self.time_text:SetActive(false)
            self:DeleteEndTimer()
        end
    else
        self.time_text:SetActive(false)
        self:DeleteTimer()
    end
end

local function DeleteEndTimer(self)
    if self.timer_end ~= nil then
        self.timer_end:Stop()
        self.timer_end = nil
    end
end

local function OnInfoClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGlorySeasonEnd)
end

--}}}

local function OnInterClick(self)

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIInterstellarMigrationPreview)
end

local function OnGloryGetWarData(self)
    self:Refresh()
end

local function OnGloryGetAct(self)
    self:Refresh()
end

local function CheckShowMigrateRed(self)
    local  actListData = nil
    local show = false
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ActNoOne)
    if table.count(dataList) > 0 then
        actListData = dataList[1]
        if actListData then
            local lastEndTime = DataCenter.ActivityListDataManager:GetActivityVisitedEndTime(actListData.id)
            if actListData.endTime > lastEndTime then
                show = true
            end
        end
    end
    if show == false then
        show = DataCenter.MigrateDataManager:GetHasAccept()
    end
    self.interstellar_red:SetActive(show)
end

local function CheckShowStamina(self)
    local  actListData = nil
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.StaminaBall)
    if table.count(dataList) > 0 then
        actListData = dataList[1]
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if actListData~=nil and actListData.startTime < curTime and curTime < actListData.endTime  then
        self.stamina_ball_btn:SetActive(true)
        local show = false
        local redNum = DataCenter.StaminaBallManager:CheckShowRewardRed()
        if redNum>0 then
            show = true
        end
        self.stamina_red_dot:SetActive(show)
        local max = DataCenter.StaminaBallManager:GetMaxStamina()
        local cur = DataCenter.StaminaBallManager:GetOldStamina()
        local curNum = DataCenter.StaminaBallManager:GetExpByStamina(cur)
        local percent = math.min((curNum/math.max(max,1)),1)
        self.slider:SetValue(percent)
    else
        self.stamina_ball_btn:SetActive(false)
    end

end

local function OnStaminaClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStaminaBall)
end

local function OnClickEnterCross(self)
    local dataInfo = DataCenter.RobotWarsManager:GetActivityInfo()
    if dataInfo ==nil then
        return
    end
    if CommonUtil.CheckIsLessThanTargetVersion("1.250.521") then
        UIUtil.ShowVersionMessage()
        return
    end
    local isAllFree = DataCenter.ArmyFormationDataManager:IsAllFormationFree()
    if isAllFree == false then
        UIUtil.ShowTipsId(250317)
        return
    end
    if LuaEntry.Player:IsInAlliance()==false then
        UIUtil.ShowTipsId(371059)
        return
    end
    if LuaEntry.Player:IsInCrossFight()==false then
        if dataInfo.edenMatch and dataInfo.edenMatch.targetServer and dataInfo.edenMatch.targetServer ~= 0 then
            local targetServer = dataInfo.edenMatch.targetServer
            local leftTime = 0
            --local defenceData = DataCenter.DefenceWallDataManager:GetDefenceWallData()
            --if defenceData~=nil then
            --    local protectEndTime = defenceData.protectEndTime
            --    leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
            --end
            if leftTime > 0 then
                UIUtil.ShowMessage(Localization:GetString("111096"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                    SFSNetwork.SendMessage(MsgDefines.MoveCrossServer,targetServer,0, 2)
                    EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Open)
                end)
            else
                UIUtil.ShowMessage(Localization:GetString("111086"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                    SFSNetwork.SendMessage(MsgDefines.MoveCrossServer,targetServer,0, 2)
                    EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Open)
                end)
            end
        else
            UIUtil.ShowTipsId(111167)
            return
        end
    else
        local leftTime = 0
        --local defenceData = DataCenter.DefenceWallDataManager:GetDefenceWallData()
        --if defenceData~=nil then
        --    local protectEndTime = defenceData.protectEndTime
        --    leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
        --end
        if leftTime > 0 then
            UIUtil.ShowMessage(Localization:GetString("111097"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                SFSNetwork.SendMessage(MsgDefines.MoveCrossServer,LuaEntry.Player.crossFightSrcServerId,0, 2)
                EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Open)
            end)
        else
            UIUtil.ShowMessage(Localization:GetString("111085"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                SFSNetwork.SendMessage(MsgDefines.MoveCrossServer,LuaEntry.Player.crossFightSrcServerId,0, 2)
                EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Open)
            end)
        end
    end

end

local function OnClickSFiveTips(self)
    local param = {}
    param.type = "desc"
    param.desc = Localization:GetString("111198")
    param.alignObject = self._sFiveTips_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, { anim = true }, param)
end

local function OnPresidentClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMain)
end
UIGloryMain.OnCreate = OnCreate
UIGloryMain.OnDestroy = OnDestroy
UIGloryMain.OnEnable = OnEnable
UIGloryMain.OnDisable = OnDisable
UIGloryMain.ComponentDefine = ComponentDefine
UIGloryMain.ComponentDestroy = ComponentDestroy
UIGloryMain.DataDefine = DataDefine
UIGloryMain.DataDestroy = DataDestroy
UIGloryMain.OnAddListener = OnAddListener
UIGloryMain.OnRemoveListener = OnRemoveListener

UIGloryMain.ReInit = ReInit
UIGloryMain.SetData = SetData
UIGloryMain.Refresh = Refresh
UIGloryMain.TimerAction = TimerAction

--UIGloryMain.OnInvasionClick = OnInvasionClick
UIGloryMain.OnInfoClick = OnInfoClick
UIGloryMain.OnInterClick = OnInterClick

UIGloryMain.OnGloryGetWarData = OnGloryGetWarData
UIGloryMain.OnGloryGetAct = OnGloryGetAct

UIGloryMain.RefreshInterStelltar = RefreshInterStelltar
UIGloryMain.AddTimer = AddTimer
UIGloryMain.RefreshTime = RefreshTime
UIGloryMain.DeleteTimer = DeleteTimer
UIGloryMain.CheckShowMigrateRed =CheckShowMigrateRed

UIGloryMain.ReIntEndTime = ReIntEndTime
UIGloryMain.AddEndTimer = AddEndTimer
UIGloryMain.RefreshEndTime = RefreshEndTime
UIGloryMain.DeleteEndTimer = DeleteEndTimer
UIGloryMain.CheckShowStamina = CheckShowStamina
UIGloryMain.OnStaminaClick =OnStaminaClick
UIGloryMain.OnClickEnterCross = OnClickEnterCross
UIGloryMain.RefreshColdDownEndTime = RefreshColdDownEndTime
UIGloryMain.RefreshEdenBtn = RefreshEdenBtn
UIGloryMain.AddColdDownTimer = AddColdDownTimer
UIGloryMain.DeleteColdDownTimer = DeleteColdDownTimer
UIGloryMain.ReIntSFiveTime = ReIntSFiveTime
UIGloryMain.AddSFiveTimer = AddSFiveTimer
UIGloryMain.RefreshSFiveTime = RefreshSFiveTime
UIGloryMain.DeleteSFiveTimer = DeleteSFiveTimer
UIGloryMain.OnClickSFiveTips = OnClickSFiveTips
UIGloryMain.OnPresidentClick =OnPresidentClick
return UIGloryMain