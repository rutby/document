
local RightPart = BaseClass("RightPart", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local ActivityItem = require "UI.UIMainNew.Comp.UIMainRightPart.ActivityItem"
local UIMainPopupPackageBtn = require "UI.UIMainNew.Comp.UIMainRightPart.UIMainPopupPackageBtn"

local list_path = "List"
local activityBtn_path = "List/UIMainActivityBtn"
local packCenterBtn_path = "List/PackCenterBtn"
local packCenterRed_path = "List/PackCenterBtn/PackCenterRed"
local packCenterRedText_path = "List/PackCenterBtn/PackCenterRed/PackCenterRedText"
local packCenterName_path = "List/PackCenterBtn/PackCenterName"
local sevenDayLoginBtn_path = "List/SevenDayLoginBtn"
local sevenDayLoginRed_path = "List/SevenDayLoginBtn/Img_ActivityRed"
local sevenDayLoginName_path = "List/SevenDayLoginBtn/SevenDayLoginName"
local sevenDayTaskBtn_path = "List/SevenDayTaskBtn"
local sevenDayTaskRed_path = "List/SevenDayTaskBtn/sevenDayTaskRed"
local sevenDayName_path = "List/SevenDayTaskBtn/SevenDayTaskName"
local firstPayBtn_path = "List/FirstPayBtn"
local firstPayRed_path = "List/FirstPayBtn/firstPayRed"
local firstPayNew_path = "List/FirstPayBtn/firstPayNew"
local firstPayName_path = "List/FirstPayBtn/FirstPayName"
local five_star_btn_path = "List/FiveStarBtn"
local five_star_txt_path = "List/FiveStarBtn/FiveStarName"
local championBattleBtn_path = "List/ChampionBattleBtn"
local championBattleName_path = "List/ChampionBattleBtn/ChampionBattleName"
local championBattleRedDot_path = "List/ChampionBattleBtn/NewDot"
local allianceCompeteBtn_path = "List/AllianceCompeteBtn"
local allianceCompeteName_path = "List/AllianceCompeteBtn/AllianceCompeteName"
local allianceCompeteRedDot_path = "List/AllianceCompeteBtn/AllianceCompeteDot"
local alCompeteStart_path = "List/AllianceCompeteBtn/TimeBg"
local alCompeteStartTime_path = "List/AllianceCompeteBtn/TimeBg/alCompeteOpenT"
local welfareCenterBtn_path = "List/WelfareCenterBtn"
local welfareCenterName_path = "List/WelfareCenterBtn/WelfareCenterName"
local welfareCenterRedDot_path = "List/WelfareCenterBtn/Img_WelfareCenterRed"
local welfareCenterRedDotNum_path = "List/WelfareCenterBtn/Img_WelfareCenterRed/WelfareDotText"

function RightPart : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function RightPart : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function RightPart : OnEnable()
    base.OnEnable(self)
end

function RightPart : OnDisable()
    base.OnDisable(self)
end

function RightPart : ComponentDefine()
    self.listGo = self:AddComponent(UIBaseContainer, list_path)
    self.activityBtnItem = self:AddComponent(ActivityItem, activityBtn_path)
    self.packCenterBtn = self:AddComponent(UIButton, packCenterBtn_path)
    self.packCenterBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickPackCenter()
    end)
    self.packCenterRed = self:AddComponent(UIBaseContainer, packCenterRed_path)
    self.packCenterRedText = self:AddComponent(UITextMeshProUGUIEx, packCenterRedText_path)
    self.packCenterName = self:AddComponent(UITextMeshProUGUIEx, packCenterName_path)
    self.packCenterName:SetLocalText(320006)
    self.sevenDayLoginBtn = self:AddComponent(UIButton, sevenDayLoginBtn_path)
    self.sevenDayLoginBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_Activity)
        self:OnClickSevenDayLogin()
    end)
    self.sevenDayLoginRed = self:AddComponent(UIBaseContainer, sevenDayLoginRed_path)
    self.sevenDayLoginName = self:AddComponent(UITextMeshProUGUIEx, sevenDayLoginName_path)
    self.sevenDayLoginName:SetLocalText(302600)
    self.sevenDayTaskBtn = self:AddComponent(UIButton, sevenDayTaskBtn_path)
    self.sevenDayTaskBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_Activity)
        self:OnClickSevenDayTask()
    end)
    self.sevenDayTaskRed = self:AddComponent(UIBaseContainer, sevenDayTaskRed_path)
    self.sevenDayName = self:AddComponent(UITextMeshProUGUIEx, sevenDayName_path)
    self.sevenDayName:SetLocalText(371007)
    self.firstPayBtn = self:AddComponent(UIButton, firstPayBtn_path)
    self.firstPayBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickFirstPayBtn()
    end)
    self.firstPayRed = self:AddComponent(UIBaseContainer, firstPayRed_path)
    self.firstPayNew = self:AddComponent(UIBaseContainer, firstPayNew_path)
    self.firstPayName = self:AddComponent(UITextMeshProUGUIEx, firstPayName_path)
    self.firstPayName:SetLocalText(320550)
    self.five_star_btn = self:AddComponent(UIButton, five_star_btn_path)
    self.five_star_btn:SetOnClick(function()
        self:OnFiveStarClick()
    end)
    self.five_star_txt = self:AddComponent(UITextMeshProUGUIEx,five_star_txt_path)
    self.five_star_txt:SetLocalText(170460)
    self.championBattleBtn = self:AddComponent(UIButton,championBattleBtn_path)
    self.championBattleBtn:SetOnClick(function()
        self:OnClickChampionBattleBtn()
    end)
    self.championBattleName = self:AddComponent(UITextMeshProUGUIEx,championBattleName_path)
    --self.championBattleName:SetLocalText(" ")
    self.championBattleRedDot = self:AddComponent(UIBaseContainer,championBattleRedDot_path)

    self.allianceCompeteBtn = self:AddComponent(UIButton,allianceCompeteBtn_path)
    self.allianceCompeteBtn:SetOnClick(function()
        self:OnClickAllianceCompeteBtn()
    end)
    self.allianceCompeteName = self:AddComponent(UITextMeshProUGUIEx,allianceCompeteName_path)
    --self.allianceCompeteName:SetLocalText(370024)
    self.allianceCompeteRedDot = self:AddComponent(UIBaseContainer,allianceCompeteRedDot_path)
    self.alCompeteOpenTime = self:AddComponent(UIBaseContainer, alCompeteStart_path)
    self.alCompeteOpenTimeTxt = self:AddComponent(UITextMeshProUGUIEx, alCompeteStartTime_path)
    self.welfareCenterBtn = self:AddComponent(UIButton,welfareCenterBtn_path)
    self.welfareCenterBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_Activity)
        self:OnClickWelfareCenterBtn()
    end)
    self.welfareCenterName = self:AddComponent(UITextMeshProUGUIEx,welfareCenterName_path)
    self.welfareCenterName:SetLocalText(320006)
    self.Img_WelfareCenterRed = self:AddComponent(UIBaseContainer,welfareCenterRedDot_path)
    self.WelfareDotText = self:AddComponent(UITextMeshProUGUIEx,welfareCenterRedDotNum_path)
end

function RightPart : ComponentDestroy()

end

function RightPart : DataDefine()
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
    
    -- 弹出礼包
    self.popupPackIdDict = {} -- Dict<packId, bool>
    self.popupPackageReqs = {}
    self.popupPackageBtns = {}
end

function RightPart : DataDestroy()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end

    -- 弹出礼包
    self.listGo:RemoveComponents(UIMainPopupPackageBtn)
    for _, req in pairs(self.popupPackageReqs) do
        self:GameObjectDestroy(req)
    end
    self.popupPackIdDict = {}
    self.popupPackageReqs = {}
    self.popupPackageBtns = {}
end

function RightPart : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshBtnInfoByActivityRed)
    self:AddUIListener(EventId.StaminaBallData, self.RefreshActivityBtn)
    self:AddUIListener(EventId.OnRefreshMigrateRedPot, self.RefreshActivityBtn)
    self:AddUIListener(EventId.ResourceUpdated, self.RefreshActivityBtn)
    self:AddUIListener(EventId.UpdateGold, self.RefreshActivityBtn)
    self:AddUIListener(EventId.ShowActBossOpen, self.RefreshActivityBtn)
    self:AddUIListener(EventId.ShowActBossClose, self.RefreshActivityBtn)
    self:AddUIListener(EventId.OnRefreshSevenLogin, self.RefreshSevenLoginBtn)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
    self:AddUIListener(EventId.SevenDayGetReward, self.RefreshSevenTaskBtn)
    self:AddUIListener(EventId.UpdateDayActInfo, self.RefreshSevenTaskBtn)
    self:AddUIListener(EventId.MainTaskSuccess, self.RefreshSevenTaskBtn)
    self:AddUIListener(EventId.OnPassDay, self.RefreshFirstPayBtn)
    self:AddUIListener(EventId.BuildLevelUp, self.RefreshFirstPayBtn)
    self:AddUIListener(EventId.FirstPayStatusChange, self.RefreshFirstPayBtn)
    self:AddUIListener(EventId.UpdateThemeActNoticeRewardInfo, self.RefreshFirstPayBtn)
    self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
    self:AddUIListener(EventId.RefreshWelfareRedDot, self.OnPackageInfoUpdated)
    self:AddUIListener(EventId.CheckFiveStar, self.CheckShowFiveStar)
    self:AddUIListener(EventId.ChampionBattleEntranceNotice, self.RefreshChampionBattle)
    self:AddUIListener(EventId.OnLeagueMatchStageChange, self.RefreshAllianceCompeteBtn)
end

function RightPart : OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshBtnInfoByActivityRed)
    self:RemoveUIListener(EventId.StaminaBallData, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.OnRefreshMigrateRedPot, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.ShowActBossOpen, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.ShowActBossClose, self.RefreshActivityBtn)
    self:RemoveUIListener(EventId.OnRefreshSevenLogin, self.RefreshSevenLoginBtn)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
    self:RemoveUIListener(EventId.SevenDayGetReward, self.RefreshSevenTaskBtn)
    self:RemoveUIListener(EventId.UpdateDayActInfo, self.RefreshSevenTaskBtn)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshSevenTaskBtn)
    self:RemoveUIListener(EventId.OnPassDay, self.RefreshFirstPayBtn)
    self:RemoveUIListener(EventId.BuildLevelUp, self.RefreshFirstPayBtn)
    self:RemoveUIListener(EventId.FirstPayStatusChange, self.RefreshFirstPayBtn)
    self:RemoveUIListener(EventId.UpdateThemeActNoticeRewardInfo, self.RefreshFirstPayBtn)
    self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
    self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.OnPackageInfoUpdated)
    self:RemoveUIListener(EventId.CheckFiveStar, self.CheckShowFiveStar)
    self:RemoveUIListener(EventId.ChampionBattleEntranceNotice, self.RefreshChampionBattle)
    self:RemoveUIListener(EventId.OnLeagueMatchStageChange, self.RefreshAllianceCompeteBtn)
end

function RightPart : TimerAction()
    for _, popupPackageBtn in pairs(self.popupPackageBtns) do
        popupPackageBtn:TimerAction()
    end
end

function RightPart:UpdateLod(lod)
    if SceneUtils.GetIsInWorld() then
        if lod>3 then
            self.listGo:SetActive(false)
        else
            self.listGo:SetActive(true)
        end
    else
        self.listGo:SetActive(true)
    end
end
function RightPart : RefreshAll()
    self:RefreshActivityBtn()
    self:RefreshSevenLoginBtn()
    self:RefreshSevenTaskBtn()
    self:RefreshFirstPayBtn()
    self:RefreshPopupPackageBtn()
    self:RefreshPackCenter()
    self:CheckShowFiveStar()
end

function RightPart : RefreshActivityBtn()
    self.activityBtnItem:RefreshAll()
end

function RightPart:RefreshBtnInfoByActivityRed()
    self:RefreshActivityBtn()
    self:RefreshChampionBattle()
    self:RefreshAllianceCompeteBtn()
    self:RefreshWelfareCenterBtn()
end

function RightPart : OnUpdateBuildData()
    self:RefreshSevenLoginBtn()
end

function RightPart : RefreshSevenLoginBtn()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.SevenLogin)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        local actId = DataCenter.ActSevenLoginData:CheckActLogin()
        if actId then
            local data = DataCenter.ActSevenLoginData:GetInfoByActId(actId)
            self.sevenDayLoginBtn:SetActive(true)
            self.sevenDayLoginRed:SetActive(false)
            if data and next(data) then
                local day = data:CheckToday()
                --今天是否还能领
                if day and day ~= 0 then
                    self.sevenDayLoginRed:SetActive(true)
                end
            end
        else
            self.sevenDayLoginBtn:SetActive(false)
        end
    else
        self.sevenDayLoginBtn:SetActive(false)
    end
end

function RightPart : RefreshSevenTaskBtn()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.SevenActivity)
    local canShow = true
    local sevenDayInfo = DataCenter.ActivityListDataManager:GetSevenDayList()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    canShow = sevenDayInfo.endTime and sevenDayInfo.endTime > curTime
    if unlockBtnLockType == UnlockBtnLockType.Show and canShow then
        self.sevenDayTaskBtn:SetActive(true)
        --红点
        -- 七日
        --if next(sevenDay) then
        --    sevenDay:CheckRedDot()
        --end
        --local count = DataCenter.ActivityListDataManager:GetDayActRedNum()
        sevenDayInfo:CheckRedDot()
        local showRed = false
        local redData = sevenDayInfo.taskRed
        for i = 1, #redData do
            for j = 1, #redData[i] do
                if redData[i][j] == 1 then
                    showRed = true
                    break
                end
            end
        end
        showRed = showRed or sevenDayInfo:GetBoxRewardRed() > 0
        self.sevenDayTaskRed:SetActive(showRed)
    else
        self.sevenDayTaskBtn:SetActive(false)
    end
end

function RightPart : RefreshFirstPayBtn()
    if DataCenter.PayManager:CheckIfFirstPayOpen() then
        self.firstPayBtn:SetActive(true)
        local firstPayStatus = DataCenter.PayManager:GetFirstPayStatus()
        self.firstPayRed:SetActive(firstPayStatus == 1)
    else
        self.firstPayBtn:SetActive(false)
    end
    self:RefreshChampionBattle()
    self:RefreshAllianceCompeteBtn()
    self:RefreshWelfareCenterBtn()
end

function RightPart:RefreshWelfareCenterBtn()
    local k2 = LuaEntry.DataConfig:TryGetNum("gift_shop", "k2")
    if DataCenter.BuildManager.MainLv >= k2 then
        local welfareActivityData = DataCenter.ActivityListDataManager:GetWelfareActivity()
        self.welfareCenterBtn:SetActive(#welfareActivityData > 0)
        local redNum = DataCenter.ActivityListDataManager:GetWelfareCenterRedCount()
        self.Img_WelfareCenterRed:SetActive(redNum > 0)
        if redNum > 0 then
            self.WelfareDotText:SetText(redNum)
        else
            self.WelfareDotText:SetText("")
        end
    else
        self.welfareCenterBtn:SetActive(false)
        self.WelfareDotText:SetText("")
    end
end

function RightPart:RefreshChampionBattle()
    local mainBuildLV = DataCenter.BuildManager.MainLv
    local showLv = LuaEntry.DataConfig:TryGetNum("champ_battle", "k3")
    local openState = DataCenter.ActChampionBattleManager:GetEntranceOpenState()
    self.championBattleBtn:SetActive(openState and mainBuildLV >= showLv)
    self.championBattleRedDot:SetActive(DataCenter.ActChampionBattleManager:ShowRedPointKey())
end

function RightPart:RefreshAllianceCompeteBtn()
    local isShow = self:CheckIsAllianceCompeteOpen()
    self.allianceCompeteBtn:SetActive(isShow)
    if isShow then
        local alCompeteRedCount = DataCenter.AllianceCompeteDataManager:GetAlCompeteteTotalRedCount()
        local isSubmitting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
        if isSubmitting then --or (activityInfo ~= nil and activityInfo.finish ~= nil) then
            self.alCompeteOpenTime:SetActive(true)
            self.alCompeteOpenTimeTxt:SetLocalText(372118)

            local serverT = UITimeManager:GetInstance():GetServerTime()
            local strToday = UITimeManager:GetInstance():TimeStampToDayForLocal(serverT)
            local strKey = "AlCompeteResult_" .. LuaEntry.Player.uid .. "_" .. strToday
            local isFirstEnter = Setting:GetInt(strKey, 0)
            if (not isSubmitting) and isFirstEnter == 0 then
                alCompeteRedCount = alCompeteRedCount + 1
            end
        else

            self:TryShowAlCompeteNoticeTime()
        end

        if alCompeteRedCount > 0 then
            self.allianceCompeteRedDot:SetActive(true)
            --self.alCompeteRedNumN:SetText(alCompeteRedCount)
        else
            self.allianceCompeteRedDot:SetActive(false)
        end
    end
end

function RightPart:TryShowAlCompeteNoticeTime()
    self.alCompeteNoticeEndT = nil
    self.alCompeteOpenTime:SetActive(false)

    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not actInfo then
        return
    end
    if actInfo.preOpenTime then
        self.alCompeteNoticeEndT = actInfo.preOpenTime
        if not self.timer then
            self:AddAllianceCompeteTimer()
        end
    end
end

function RightPart:AddAllianceCompeteTimer()
    self.TimerAction = function()
        local isAlNoticeCD = self:RefreshAlCompeteNoticeRemainT()
        local needTimer = isAlNoticeCD
        if not needTimer then
            self:DelTimer()
        end
    end

    if self.allianceCompeteTimer == nil then
        self.allianceCompeteTimer = TimerManager:GetInstance():GetTimer(1, self.TimerAction , self, false,false,false)
    end
    self.allianceCompeteTimer:Start()
end

function RightPart:RefreshAlCompeteNoticeRemainT()
    if not self.alCompeteNoticeEndT then
        return false
    end

    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.alCompeteNoticeEndT - curTime
    if remainTime > 0 then
        self.alCompeteOpenTime:SetActive(true)
        self.alCompeteOpenTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
        return true
    else
        self.alCompeteNoticeEndT = nil
        self.alCompeteOpenTime:SetActive(false)
        return false
    end
end

function RightPart:DelTimer(self)
    if self.allianceCompeteTimer ~= nil then
        self.allianceCompeteTimer:Stop()
        self.allianceCompeteTimer = nil
    end
end

function RightPart:CheckIsAllianceCompeteOpen()
    local configOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_duel")
    if not configOpenState then
        return false
    end

    local mainLv = 0
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if activityInfo then
        mainLv = activityInfo.needMainCityLevel
    else
        local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
        if not actInfo then
            return false
        end
        local isOpen = DataCenter.LeagueMatchManager:CheckIsMatchOpen()
        if isOpen then
            local matchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
            local duelInfo = matchInfo and matchInfo.duelInfo
            if duelInfo then
                mainLv = LuaEntry.DataConfig:TryGetNum("alliance_legend2","k2")
            else
                local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
                if tempStage == LeagueMatchStage.Notice then
                    return true
                else
                    return false
                end
            end
        else
            return false
        end
    end
    local mainBuildLV = DataCenter.BuildManager.MainLv
    if mainLv > mainBuildLV then
        return false
    else
        return true
    end
end

function RightPart:OnClickWelfareCenterBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWelfareCenter, { anim = true, UIMainAnim = UIMainAnimType.AllHide,isBlur = true })
end

function RightPart : OnClickSevenDayLogin()
    local actId = DataCenter.ActSevenLoginData:CheckActLogin()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISevenLogin, { anim = true, UIMainAnim = UIMainAnimType.AllHide,isBlur = true },actId)
    --GoToUtil.GoActWindow(tonumber(actId))
end

function RightPart : OnClickSevenDayTask()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISevenTask, { anim = true, UIMainAnim = UIMainAnimType.AllHide,isBlur = true })
    --GoToUtil.GoActWindow(tonumber(actId))
end

function RightPart : OnClickFirstPayBtn(self)
    if not DataCenter.PayManager:CheckIfFirstPayOpen() then
        UIUtil.ShowTipsId(320190)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA)
        return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, { anim = false, UIMainAnim = UIMainAnimType.AllHide,isBlur = true })
end

function RightPart:OnClickChampionBattleBtn()
    if DataCenter.ActChampionBattleManager:GetEntranceOpenState() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleMain)
    end
end

function RightPart:OnClickAllianceCompeteBtn()
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not actInfo then
        return
    end
    if actInfo.preOpenTime then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteNotice, { anim = true })
    else
        if DataCenter.LeagueMatchManager:CheckIsSubmitting() then
            UIUtil.ShowTipsId("372118")
            return
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteNew, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
    end
end

function RightPart:GetSavePos(posType)
    if posType == UIMainSavePosType.SevenLogin then
        return self.sevenDayLoginBtn.transform.position
    elseif posType == UIMainSavePosType.SevenActivity then
        return self.sevenDayTaskBtn.transform.position
    elseif posType == UIMainSavePosType.FirstPay then
        return self.firstPayBtn.transform.position
    elseif posType == UIMainSavePosType.Activity then
        return self.activityBtnItem.transform.position
    elseif posType == UIMainSavePosType.WelfareCenter then
        return self.welfareCenterBtn.transform.position
    end
end

function RightPart:ShowUnlockBtnSignal(btnType)
    if btnType == UnlockBtnType.SevenLogin then
        self:RefreshSevenLoginBtn()
    elseif btnType == UnlockBtnType.SevenActivity then
        self:RefreshSevenTaskBtn()
    elseif btnType == UnlockBtnType.FirstPay then
        self:RefreshFirstPayBtn()
    elseif btnType == UnlockBtnType.Activity then
        self:RefreshActivityBtn()
    end
end

function RightPart:CreatePopupPackageBtn(packId)
    self:DestroyPopupPackageBtn(packId)
    self.popupPackageReqs[packId] = self:GameObjectInstantiateAsync(UIAssets.UIMainPopupPackageBtn, function(req)
        local name = "UIMainPopupPackageBtn_" .. packId
        local go = req.gameObject
        go.transform:SetParent(self.listGo.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        go.name = name
        local popupPackageBtn = self.listGo:AddComponent(UIMainPopupPackageBtn, name)
        popupPackageBtn:SetData(packId)
        self.popupPackageBtns[packId] = popupPackageBtn
    end)
end

function RightPart:DestroyPopupPackageBtn(packId)
    local req = self.popupPackageReqs[packId]
    if req then
        local name = "UIMainPopupPackageBtn_" .. packId
        self.listGo:RemoveComponent(name, UIMainPopupPackageBtn)
        self:GameObjectDestroy(req)
    end
    self.popupPackIdDict[packId] = nil
    self.popupPackageReqs[packId] = nil
    self.popupPackageBtns[packId] = nil
end

function RightPart:RefreshPopupPackageBtn()
    -- self.popupPackIdDict[packId] 标记为 true 的创建或保留，标记为 false 的销毁
    local curRechargeDict = {}
    for packId, _ in pairs(self.popupPackIdDict) do
        self.popupPackIdDict[packId] = false
    end
    local curPopupPacks = GiftPackageData.GetAllAvailablePopupPackages()
    for _, pack in ipairs(curPopupPacks) do
        local packId = pack:getID()
        local rechargeLine = pack:getRechargeLineData()
        local rechargeId = rechargeLine.id
        if curRechargeDict[rechargeId] == nil then
            -- 同 rechargeId 只展示一个
            if self.popupPackIdDict[packId] == nil then
                self:CreatePopupPackageBtn(packId)
            end
            self.popupPackIdDict[packId] = true
            curRechargeDict[rechargeId] = true
        end
    end
    for packId, _ in pairs(self.popupPackIdDict) do
        if self.popupPackIdDict[packId] == false then
            self:DestroyPopupPackageBtn(packId)
        end
    end
end

function RightPart:OnClickPopupPackage()
    if self.popupPack then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPopupPackage, { anim = true, isBlur = true }, self.popupPack)
    end
end

function RightPart:RefreshPackCenter()
    if true then
        --不要了 先隐藏
        self.packCenterBtn:SetActive(false)
        return false
    end
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.DiamondAdd)
    if unlockBtnLockType ~= UnlockBtnLockType.Show then
        self.packCenterBtn:SetActive(false)
        return
    end
    
    self.packCenterBtn:SetActive(true)
    
    -- 红点
    local tagInfos = WelfareController.getShowTagInfos()
    table.sort(tagInfos, function(tagInfoA, tagInfoB)
        return tagInfoA:getOrder() < tagInfoB:getOrder()
    end)
    self.firstTagInfo = tagInfos[1]
    self.redTagInfo = nil
    local redNum = 0
    for _, t in pairs(tagInfos) do
        redNum = redNum + t:getRedDotNum()
        if redNum > 0 and self.redTagInfo == nil then
            self.redTagInfo = t
        end
    end
    if redNum > 0 then
        self.packCenterRed:SetActive(true)
        self.packCenterRedText:SetText(redNum)
    else
        self.packCenterRed:SetActive(false)
    end
end

function RightPart:OnClickPackCenter()
    if self.redTagInfo then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = self.redTagInfo:getType() })
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = self.firstTagInfo:getType() })
    end
end

function RightPart:OnPackageInfoUpdated()
    self:RefreshPopupPackageBtn()
    self:RefreshPackCenter()
end

function RightPart:CheckShowFiveStar()
    local show = Setting:GetPrivateInt("APS_FiveStar", 0)
    local isOpen = LuaEntry.DataConfig:CheckSwitch("five_star_evaluation")
    local hideNum = Setting:GetPrivateInt("APS_FiveStar_Close", 0)
    local hasTask = false
    local task = DataCenter.TaskManager:FindTaskInfo(FiveStarTaskId)
    if task~=nil then
        hasTask = true
    end
    local k2 = LuaEntry.DataConfig:TryGetNum("binding_guide", "k2")
    local k3 = LuaEntry.DataConfig:TryGetNum("binding_guide", "k3")
    if isOpen ==true and hasTask == true and show<=0 and hideNum<=1 and DataCenter.BuildManager.MainLv >= k2 and DataCenter.BuildManager.MainLv <= k3 then
        self.five_star_btn:SetActive(true)
    else
        self.five_star_btn:SetActive(false)
    end
end
function RightPart:OnFiveStarClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFiveStarGet,{anim = true,isBlur = true})
end
return RightPart