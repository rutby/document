--[[
UIMainNewView
--]]

local UIMainNewView = BaseClass("UIMainNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMainCenter = require "UI.UIMainNew.Comp.UIMainCenter.UIMainCenter"
local BottomPart = require "UI.UIMainNew.Comp.UIMainBottomPart.BottomPart"
local LeftPart = require "UI.UIMainNew.Comp.UIMainLeftPart.LeftPart"
local RightPart = require "UI.UIMainNew.Comp.UIMainRightPart.RightPart"
local UIVitaMessage = require "UI.UIVita.Component.UIVitaMessage"
local UIMainStaminaItem = require "UI.UIMainNew.Comp.UIMainTopPart.UIMainStaminaItem"

local rightPart_path = "safeArea/RightPart"
local bottomPart_path = "safeArea/BottomPart"
local leftPart_path = "safeArea/LeftPart"
local top_bg_path = "safeArea/TopPart/bg"
local time_state_path = "safeArea/TopPart/bg/dayNight/stateIcon"
local time_text_path = "safeArea/TopPart/bg/dayNight/timeTxt"
local time_btn_path = "safeArea/TopPart/bg/dayNight"
local res_num_path = "safeArea/TopPart/bg/resCost/resNum"
local resident_bg_path = "safeArea/TopPart/bg/People"
local resident_text_path = "safeArea/TopPart/bg/People/PeopleNum"
local resident_red_path = "safeArea/TopPart/bg/People/PeopleNum/PeopleRed"
local gemsBtn_path = "safeArea/TopPart/bg/Gems"
local gems_num_path = "safeArea/TopPart/bg/Gems/GemNum"
local gems_add_icon_path = "safeArea/TopPart/bg/Gems/addicon"
local gift_btn_path = "safeArea/TopPart/bg/GiftPackage"
local gold_num_path = "safeArea/TopPart/bg/GiftPackage/goldNum"
local gold_red_dot_path = "safeArea/TopPart/bg/GiftPackage/PackRed"
local pack_red_path = "safeArea/TopPart/bg/GiftPackage/PackRed/PackRedText"
local resCostBtn_path = "safeArea/TopPart/bg/resCost"
local power_obj_path = "safeArea/TopPart/power"
local power_txt_path = "safeArea/TopPart/power/powerNum"
local player_obj_path = "safeArea/TopPart/PlayerObj"
local player_head_path = "safeArea/TopPart/PlayerObj/icon"
local head_frame_path = "safeArea/TopPart/PlayerObj/Foreground"
local vita_message_path = "safeArea/LeftPart/layout/UIVitaMessage"
local stamina_path = "safeArea/TopPart/stamina"
local centerPoint_path = "safeArea/CenterPoint"
local anim_path = "safeArea"
local warning_bg_path = "safeArea/warning_bg"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.rightPart = self:AddComponent(RightPart, rightPart_path)
    self.center = self:AddComponent(UIMainCenter, centerPoint_path)
    self.bottomPart = self:AddComponent(BottomPart, bottomPart_path)
    self.leftPart = self:AddComponent(LeftPart, leftPart_path)
    self.top_bg = self:AddComponent(UIBaseContainer,top_bg_path)
    self.top_bg:SetActive(true)
    self.time_text = self:AddComponent(UITextMeshProUGUI,time_text_path)
    self.time_state = self:AddComponent(UIImage,time_state_path)
    self.time_btn = self:AddComponent(UIButton, time_btn_path)
    self.time_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnTimeClick()
    end)
    
    
    self.resident_btn = self:AddComponent(UIButton, resident_bg_path)
    self.resident_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnResidentClick()
    end)
    self.resident_text = self:AddComponent(UITextMeshProUGUI, resident_text_path)
    self.resident_red_go = self:AddComponent(UIBaseContainer, resident_red_path)
    self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
    self.gift_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_GiftPack)
        self:OnClickGemsBtn()
    end)
    
    self.gold_num = self:AddComponent(UITextMeshProUGUI, gold_num_path)
    
    self.gold_red = self:AddComponent(UIBaseContainer,gold_red_dot_path)
    self.pack_red = self:AddComponent(UITextMeshProUGUIEx,pack_red_path)
    
    self.gemsBtn = self:AddComponent(UIButton, gemsBtn_path)
    self.gemsBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_GiftPack)
        self:OnClickGemsBtn()
    end)
    self.gems_num = self:AddComponent(UITextMeshProUGUI, gems_num_path)
    self.powerBtn = self:AddComponent(UIButton, power_obj_path)
    self.powerBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickPowerBtn()
    end)
    self.power_txt = self:AddComponent(UITextMeshProUGUI, power_txt_path)
    
    self.resCostBtn = self:AddComponent(UIButton, resCostBtn_path)
    self.resCostBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickResCostBtn()
    end)
    self.res_num = self:AddComponent(UITextMeshProUGUI, res_num_path)

    self.player_btn = self:AddComponent(UIButton, player_obj_path)
    self.player_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnPlayerClick()
    end)
    self.player_head = self:AddComponent(UIPlayerHead,player_head_path)
    self.playerHeadFgN = self:AddComponent(UIImage,head_frame_path)
    self.vita_message = self:AddComponent(UIVitaMessage, vita_message_path)
    self.stamina = self:AddComponent(UIMainStaminaItem,stamina_path)
    self.anim = self:AddComponent(UIAnimator, anim_path)
    self.gems_add_icon = self:AddComponent(UIBaseContainer, gems_add_icon_path)
    self.warning_bg = self:AddComponent(UIBaseContainer, warning_bg_path)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.isCreateMiniMap = false
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.TimerAction, self, false, false, false)
    self.timer:Start()
    self:TimerAction()
    self.curAnimState = UIMainAnimType.AllShow
    self.isCreateView = false
end

local function DataDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnEnable(self)
    base.OnEnable(self)
    self:UpdateGold()
    self:ShowDayNight(true)
    self:OnRefreshPlayerIcon()
    self:Refresh()
    
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.OnVitaDataUpdate)
    self:AddUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
    self:AddUIListener(EventId.VitaDayNightChange, self.ShowDayNight)
    self:AddUIListener(EventId.VitaDayNightChangeAnimUI, self.ShowDayNightChange)
    self:AddUIListener(EventId.VitaChangeTime, self.OnChangeTime)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGold)
    self:AddUIListener(EventId.VitaDataUpdate, self.OnVitaDataUpdate)
    self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
    self:AddUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
    self:AddUIListener(EventId.OnEnterCity, self.OnEnterCity)
    self:AddUIListener(EventId.ShowUnlockBtn, self.ShowUnlockBtnSignal)
    self:AddUIListener(EventId.ChapterTask, self.RefreshTaskSignal)
    self:AddUIListener(EventId.MainTaskSuccess, self.RefreshTaskSignal)
    self:AddUIListener(EventId.DailyQuestLs, self.RefreshTaskSignal)
    self:AddUIListener(EventId.DailyQuestSuccess, self.RefreshTaskSignal)
    self:AddUIListener(EventId.DailyQuestReward, self.RefreshTaskSignal)
    self:AddUIListener(EventId.DailyQuestGetAllTaskReward, self.RefreshTaskSignal)
    self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.BuildDataSignal)
    self:AddUIListener(EventId.RefreshStorm, self.RefreshStormSignal)
    self:AddUIListener(EventId.CloseUI, self.CloseUISignal)
    self:AddUIListener(EventId.UIMAIN_VISIBLE, self.UiMainVisibleSignal)
    self:AddUIListener(EventId.StoryUpdateHangupTime, self.StoryUpdateHangupTimeSignal)
    self:AddUIListener(EventId.ShowStoryRewardBubble, self.StoryUpdateHangupTimeSignal)
    self:AddUIListener(EventId.MonthCardInfoUpdated, self.OnRefreshPlayerIcon)
    self:AddUIListener(EventId.PlayerPowerInfoUpdated, self.PlayerPowerInfoUpdatedSignal)
    
    self:AddUIListener(EventId.NoticeMainViewUpdateMarch, self.NoticeMainViewUpdateMarchSignal)
    self:AddUIListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    self:AddUIListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
    self:AddUIListener(EventId.UpdateAlertData,self.UpdateAlertDataSignal)
    self:AddUIListener(EventId.BlackKnightWarning, self.BlackKnightWarningSignal)
    self:AddUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
    self:AddUIListener(EventId.RefreshAlarm, self.RefreshAlarmSignal)
    self:AddUIListener(EventId.IgnoreTargetForMineMarch, self.IgnoreTargetForMineMarchSignal)
    self:AddUIListener(EventId.AllianceQuitOK, self.AllianceQuitOKSignal)
    self:AddUIListener(EventId.IgnoreAllianceMarch, self.HideAllianceWarningSignal)
    self:AddUIListener(EventId.RefreshCityBuildModel, self.RefreshCityBuildModelSignal)
    self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
    self:AddUIListener(EventId.RefreshWelfareRedDot, self.OnPackageInfoUpdated)
    
    self:AddUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedSignal)
    self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedSignal)
    self:AddUIListener(EventId.RefreshAlertUI, self.RefreshAllianceRedSignal)
    self:AddUIListener(EventId.AttackerInfoUpdate, self.RefreshAllianceRedSignal)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.OnVitaDataUpdate)
    self:RemoveUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
    self:RemoveUIListener(EventId.VitaDayNightChange, self.ShowDayNight)
    self:RemoveUIListener(EventId.VitaDayNightChangeAnimUI, self.ShowDayNightChange)
    self:RemoveUIListener(EventId.VitaChangeTime, self.OnChangeTime)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGold)
    self:RemoveUIListener(EventId.VitaDataUpdate, self.OnVitaDataUpdate)
    self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
    self:RemoveUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
    self:RemoveUIListener(EventId.OnEnterCity, self.OnEnterCity)
    self:RemoveUIListener(EventId.ShowUnlockBtn, self.ShowUnlockBtnSignal)
    self:RemoveUIListener(EventId.ChapterTask, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.DailyQuestSuccess, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.DailyQuestGetAllTaskReward, self.RefreshTaskSignal)
    self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.BuildDataSignal)
    self:RemoveUIListener(EventId.RefreshStorm, self.RefreshStormSignal)
    self:RemoveUIListener(EventId.CloseUI, self.CloseUISignal)
    self:RemoveUIListener(EventId.UIMAIN_VISIBLE, self.UiMainVisibleSignal)
    self:RemoveUIListener(EventId.StoryUpdateHangupTime, self.StoryUpdateHangupTimeSignal)
    self:RemoveUIListener(EventId.ShowStoryRewardBubble, self.StoryUpdateHangupTimeSignal)
    self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.OnRefreshPlayerIcon)
    self:RemoveUIListener(EventId.PlayerPowerInfoUpdated, self.PlayerPowerInfoUpdatedSignal)


    self:RemoveUIListener(EventId.NoticeMainViewUpdateMarch, self.NoticeMainViewUpdateMarchSignal)
    self:RemoveUIListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    self:RemoveUIListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
    self:RemoveUIListener(EventId.UpdateAlertData,self.UpdateAlertDataSignal)
    self:RemoveUIListener(EventId.BlackKnightWarning, self.BlackKnightWarningSignal)
    self:RemoveUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
    self:RemoveUIListener(EventId.RefreshAlarm, self.RefreshAlarmSignal)
    self:RemoveUIListener(EventId.IgnoreTargetForMineMarch, self.IgnoreTargetForMineMarchSignal)
    self:RemoveUIListener(EventId.AllianceQuitOK, self.AllianceQuitOKSignal)
    self:RemoveUIListener(EventId.IgnoreAllianceMarch, self.HideAllianceWarningSignal)
    self:RemoveUIListener(EventId.RefreshCityBuildModel, self.RefreshCityBuildModelSignal)
    self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
    self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.OnPackageInfoUpdated)
    self:RemoveUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedSignal)
    self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedSignal)
    self:RemoveUIListener(EventId.RefreshAlertUI, self.RefreshAllianceRedSignal)
    self:RemoveUIListener(EventId.AttackerInfoUpdate, self.RefreshAllianceRedSignal)
end

local function OnEnterWorld(self)
    self.bottomPart:OnEnterWorld()
    self.leftPart:OnEnterWorld()
    self:RefreshVitaMessage()
end

local function OnEnterCity(self)
    self.bottomPart:OnEnterCity()
    self.leftPart:OnEnterCity()
    self:RefreshVitaMessage()
end

local function OnVitaDataUpdate(self)
    self:RefreshVita()
    self:RefreshVitaMessage()
end

local function UpdateLod(self,lod)
    self.bottomPart:UpdateLod(lod)
    self.leftPart:UpdateLod(lod)
    self.rightPart:UpdateLod(lod)
    if SceneUtils.GetIsInWorld() then
        if lod>3 then
            self.top_bg:SetActive(false)
            self.powerBtn:SetActive(false)
            self:TryShowMiniMap()
        else
            self:TryHideMiniMap()
            self.top_bg:SetActive(true)
            self:RefreshPower()
        end
    else
        self:TryHideMiniMap()
        self.top_bg:SetActive(true)
        self:RefreshPower()
    end
    
end

local function OnRefreshPlayerIcon(self)
    local uid = LuaEntry.Player:GetUid()
    local pic = LuaEntry.Player:GetPic()
    local picVer = LuaEntry.Player.picVer
    self.player_head:SetData(uid, pic, picVer)
    local fgImg = LuaEntry.Player:GetHeadBgImg()
    if not string.IsNullOrEmpty(fgImg) then
        self.playerHeadFgN:SetActive(true)
        self.playerHeadFgN:LoadSprite(fgImg)
    else
        self.playerHeadFgN:SetActive(false)
    end
end

local function BuildDataSignal(self,data)
    self.bottomPart:BuildDataSignal(data)
    self.leftPart:BuildDataSignal(data)
end
local function ShowDayNight(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
    if dayNight == VitaDefines.DayNight.Day then
        self.time_state:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMain_icon_day")
    elseif dayNight == VitaDefines.DayNight.Night then
        self.time_state:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMain_icon_night")
    else
        self.time_state:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMain_icon_sleep")
    end
end

local function ShowDayNightChange(self)
    if not SceneUtils.GetIsInCity() then
        return
    end
    if self.isCreateView == false then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDayNightChange,{anim = true})
        self.isCreateView = true
        
    end
end

local function TryShowMiniMap(self)
    if self.isCreateMiniMap  == false then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainMiniMap)
        self.isCreateMiniMap  = true
    end

end
local function TryHideMiniMap(self)
    if self.isCreateMiniMap  == true and LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMiniMap)
        self.isCreateMiniMap  = false
    end

end

local function OnChangeTime(self)
    self:RefreshVitaTime()
end

local function TimerAction(self)
    self:RefreshVitaTime()
    self.vita_message:Refresh()
end

local function Refresh(self)
    self.bottomPart:RefreshAll()
    self.rightPart:RefreshAll()
    self.leftPart:RefreshAll()
    self:OnPackageInfoUpdated()
    self:RefreshVita()
    self:RefreshPower()
    self:RefreshGem()
    self:RefreshResCost()
    self:RefreshStamina()
    self:RefreshVitaMessage()
    self:ResetWarningSignal()
end

local function RefreshTaskSignal(self)
    self.bottomPart:RefreshTask()
    self.leftPart:RefreshTaskSignal()
end

local function RefreshPower(self)
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Power)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.powerBtn:SetActive(true)
        local playerPower = LuaEntry.Player.power
        self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(playerPower)))
    else
        self.powerBtn:SetActive(false)
    end
end
local function RefreshVita(self)
    local residentCount = DataCenter.VitaManager:GetResidentCount()
    local residentMaxCount = DataCenter.VitaManager:GetResidentMaxCount()
    local product = LuaEntry.Resource:GetCntByResType(ResourceType.Plank)
    self.res_num:SetText(string.GetFormattedStr(product))
    self.resident_text:SetText(string.format("%d/%d", residentCount, residentMaxCount))
    self.resident_red_go:SetActive(DataCenter.VitaManager:ShowResidentWorkRed())
    self:RefreshVitaTime()
end

local function RefreshVitaTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local vitaTime = VitaUtil.RealTimeToVita(curTime)
    self.time_text:SetText(VitaUtil.VitaTimeToStringHM(vitaTime))
end

local function RefreshVitaMessage(self)
    if SceneUtils.GetIsInCity() then
    --    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.PeopleCome)
    --    if unlockBtnLockType == UnlockBtnLockType.Show then
            self.vita_message:SetActive(true)
    --    else
    --        self.vita_message:SetActive(false)
    --    end
    else
        self.vita_message:SetActive(false)
    end
end

local function OnTimeClick(self)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UITimeRoundPanel)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVitaSegment)
end

local function OnResidentClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVitaResident, 1)
end

local function OnClickPowerBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoreInformation,{ anim = true ,isBlur = true},LuaEntry.Player.uid)
end

local function OnClickGemsBtn(self)
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.DiamondAdd)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        if self.redTagInfo then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = self.redTagInfo:getType() })
        elseif self.firstTagInfo then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = self.firstTagInfo:getType() })
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage)
        end
        
    end
end

local function OnClickResCostBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVitaProduction, {anim = true, isBlur = true})
end

local function UpdateGold(self)
    self.gems_num:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
    self.gold_num:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

local function OnPackageInfoUpdated(self)
    -- 红点
    local tagInfos = WelfareController.getShowTagInfos()
    table.sort(tagInfos, function(tagInfoA, tagInfoB)
        return tagInfoA:getOrder() < tagInfoB:getOrder()
    end)
    self.firstTagInfo = nil
    self.redTagInfo = nil
    local redNum = 0
    for _, t in pairs(tagInfos) do
        if t:getDailyType() ~= ActivityShowLocation.welfareCenter then
            if self.firstTagInfo == nil then
                self.firstTagInfo = t
            end
            redNum = redNum + t:getRedDotNum()
            if redNum > 0 and self.redTagInfo == nil then
                self.redTagInfo = t
            end
        end
    end
    if redNum > 0 then
        self.gold_red:SetActive(true)
        self.pack_red:SetText(redNum)
    else
        self.gold_red:SetActive(false)
    end
end

local function OnPlayerClick(self)
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerInfo,{ anim = true},LuaEntry.Player.uid)
end

local function RefreshCameraPoint(self)
    self.center:UpdateMilePointer(true)
end

function UIMainNewView:ShowUnlockBtnSignal(btnType)
    if btnType == UnlockBtnType.Bag or btnType == UnlockBtnType.Story
            or btnType == UnlockBtnType.Hero or btnType == UnlockBtnType.Shop or btnType == UnlockBtnType.Alliance
            or btnType == UnlockBtnType.Chat or btnType == UnlockBtnType.World or btnType == UnlockBtnType.Quest
            or btnType == UnlockBtnType.Mail then
        self.bottomPart:ShowUnlockBtnSignal(btnType)
    elseif btnType == UnlockBtnType.SevenLogin or btnType == UnlockBtnType.SevenActivity
            or btnType == UnlockBtnType.FirstPay or btnType == UnlockBtnType.Activity then
        self.rightPart:ShowUnlockBtnSignal(btnType)
    elseif btnType == UnlockBtnType.DiamondShop or btnType == UnlockBtnType.DiamondAdd then
        self:RefreshGem()
    elseif btnType == UnlockBtnType.Power then
        self:RefreshPower()
    elseif btnType == UnlockBtnType.Resource then
        self:RefreshResCost()
    elseif btnType == UnlockBtnType.Stamina then
        self:RefreshStamina()
    elseif btnType == UnlockBtnType.PeopleCome then
        self:RefreshVitaMessage()
    end
end

function UIMainNewView:GetSavePos(posType)
    if posType == UIMainSavePosType.VitaResident then
        return self.resident_btn.transform.position
    elseif posType == UIMainSavePosType.Goods or posType == UIMainSavePosType.Story
            or posType == UIMainSavePosType.Hero or posType == UIMainSavePosType.Shop or posType == UIMainSavePosType.Alliance
            or posType == UIMainSavePosType.Chat or posType == UIMainSavePosType.World 
            or posType == UIMainSavePosType.Quest or posType == UIMainSavePosType.Search or posType == UIMainSavePosType.LaDar then
        return self.bottomPart:GetSavePos(posType)
    elseif posType == UIMainSavePosType.Gold then
        return self.gemsBtn.transform.position
    elseif posType == UIMainSavePosType.SevenLogin or posType == UIMainSavePosType.SevenActivity 
            or posType == UIMainSavePosType.FirstPay or posType == UIMainSavePosType.Activity or posType == UIMainSavePosType.WelfareCenter then
        return self.rightPart:GetSavePos(posType)
    elseif posType == UIMainSavePosType.Power then
        return self.powerBtn.transform.position
    elseif posType == UIMainSavePosType.Resource then
        return self.resCostBtn.transform.position
    elseif posType == UIMainSavePosType.VitaMessage then
        return self.vita_message.transform.position
    elseif posType == UIMainSavePosType.Stamina then
        return self.stamina.transform.position
    end
end

function UIMainNewView:RefreshGem()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.DiamondShop)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.DiamondAdd)
        local k1 = LuaEntry.DataConfig:TryGetNum("gift_shop", "k1")
        if unlockBtnLockType == UnlockBtnLockType.Show and DataCenter.BuildManager.MainLv >= k1 then
            self.gift_btn:SetActive(true)
            self.gemsBtn:SetActive(false)
        else
            self.gemsBtn:SetActive(true)
            self.gift_btn:SetActive(false)
        end
    else
        self.gemsBtn:SetActive(false)
        self.gift_btn:SetActive(false)
    end
    self.gems_add_icon:SetActive(false)
end

function UIMainNewView:RefreshResCost()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Resource)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.resCostBtn:SetActive(true)
    else
        self.resCostBtn:SetActive(false)
    end
end

function UIMainNewView:RefreshStamina()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Stamina)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.stamina:SetActive(true)
    else
        self.stamina:SetActive(false)
    end
end

---march start
function UIMainNewView:SetTroopListShow(show)
    self.leftPart:SetTroopListShow(show)
end
function UIMainNewView:HideAllShowTip()
    self.leftPart:HideAllShowTip()
end
function UIMainNewView:ShowFormationArmyTip(x,y,dataInfo)
    self.leftPart:ShowFormationArmyTip(x,y,dataInfo)
end
function UIMainNewView:ShowFormationRallyTip(x,y,dataInfo)
    self.leftPart:ShowFormationRallyTip(x,y,dataInfo)
end
function UIMainNewView:OnSelectClick(uuid)
    self.leftPart:OnSelectClick(uuid)
end
function UIMainNewView:ShowFormationCreateTip(x,y,dataInfo)
    self.leftPart:ShowFormationCreateTip(x,y,dataInfo)
end
function UIMainNewView:OnAtkClick(uuid)
    self.leftPart:OnAtkClick(uuid)
end
function UIMainNewView:OnCreateClick(uuid)
    self.leftPart:OnCreateClick(uuid)
end
function UIMainNewView:OnEditClick(uuid,needAutoAdd)
    self.leftPart:OnEditClick(uuid,needAutoAdd)
end
function UIMainNewView:GetTimeInFormation(uuid)
    return self.leftPart:GetTimeInFormation(uuid)
end
function UIMainNewView:OnClickStartInvestigate(targetPointId)
    return self.leftPart:OnClickStartInvestigate(targetPointId)
end
function UIMainNewView:ResetScoutSelectTipPosition(posX,posY)
    return self.leftPart:ResetScoutSelectTipPosition(posX,posY)
end
function UIMainNewView:OnClickScoutTroopItem(formationIndex)
    return self.leftPart:OnClickScoutTroopItem(formationIndex)
end
function UIMainNewView:GetScoutTroopUnlockLv(formationIndex)
    return self.leftPart:GetScoutTroopUnlockLv(formationIndex)
end
function UIMainNewView:RefreshStormSignal()
    self.leftPart:RefreshStormSignal()
end


function UIMainNewView:PlayAnim(animName)
    if DataCenter.GuideManager:IsCanDoUIMainAnim() then
        animName = self:CheckDoAnimName(animName)
        if animName ~= nil then
            self.curAnimState = animName
            self.anim:Play(animName,0,0)
        end
    end
end


function UIMainNewView:CheckDoAnimName(animName)
    if animName == UIMainAnimType.AllShow then
        if self.curAnimState == UIMainAnimType.AllHide then
            return animName
        end
    elseif animName == UIMainAnimType.LeftRightBottomShow then
        if self.curAnimState == UIMainAnimType.LeftRightBottomHide then
            return animName
        end
    elseif animName == UIMainAnimType.AllHide then
        if self.curAnimState ~= UIMainAnimType.AllHide then
            return animName
        end
    elseif animName == UIMainAnimType.LeftRightBottomHide then
        if self.curAnimState ~= UIMainAnimType.LeftRightBottomHide then
            return animName
        end
    elseif animName == UIMainAnimType.OutStayTopLeft then
        return animName
    elseif animName == UIMainAnimType.ChangeAllShow then
        if self.curAnimState == UIMainAnimType.AllHide then
            return UIMainAnimType.AllShow
        elseif self.curAnimState == UIMainAnimType.LeftRightBottomHide then
            return UIMainAnimType.LeftRightBottomShow
        else
            return UIMainAnimType.AllShow
        end
    end

    return nil
end

function UIMainNewView:CloseUISignal(viewName)
    self.leftPart:CloseUISignal()
    if viewName == UIWindowNames.UIDayNightChange then
        self.isCreateView = false
    end
end

function UIMainNewView:UiMainVisibleSignal(isVisible)
    if isVisible then
        self:PlayAnim(UIMainAnimType.ChangeAllShow)
    else
        self:PlayAnim(UIMainAnimType.AllHide)
    end
end

function UIMainNewView:StoryUpdateHangupTimeSignal()
    self.bottomPart:StoryUpdateHangupTimeSignal()
end

function UIMainNewView:PlayerPowerInfoUpdatedSignal()
    self:RefreshPower()
end


function UIMainNewView:ResetWarningSignal()
    local warningType = nil
    local canUnlock,lock_tips = SceneUtils.CheckIsWorldUnlock()
    if canUnlock ==false then
        self:ShowWarning(nil)
        return
        
    end
    local radarAlarmList = DataCenter.RadarAlarmDataManager:GetAllMarches()
    local isHide = false		--是否屏蔽
    if DataCenter.AllianceHelpVirtualMarchManager:HasVirtualMarch() then
        warningType = WarningType.Assistance
    elseif radarAlarmList and table.count(radarAlarmList) > 0 then
        isHide = true		--是否屏蔽
        local knightShow = DataCenter.ActBlackKnightManager:IsShowWarning()
        for _, v in pairs(radarAlarmList) do
            if v.allianceUid ~= LuaEntry.Player:GetAllianceUid() then
                if v.server ~= nil  then
                    warningType = WarningType.Attack
                    isHide = false
                else
                    if v:GetMarchType() == NewMarchType.MONSTER_SIEGE then
                        if knightShow then
                            isHide = false
                        end
                    elseif not DataCenter.RadarAlarmDataManager:IsCancel(v.uuid) then
                        isHide = false
                    end
                  
                    local temp = DataCenter.RadarAlarmDataManager:GetWarningType(v)
                    if warningType == nil then
                        warningType = temp
                    end
                    if warningType == WarningType.Scout then
                        warningType = temp
                    elseif warningType == WarningType.Assistance then
                        if temp == WarningType.Attack then
                            warningType = temp
                        end
                    end
                end
            end
            if warningType == WarningType.Attack and (not isHide) then
                break
            end
        end
    end
    
    --判断联盟集结
    if warningType == nil then
        local warCount = DataCenter.AllianceWarDataManager:GetAllianceWarCount()
        warCount = warCount + DataCenter.AllianceAlertDataManager:GetAlertNum()
        if warCount > 0 then
            warningType = WarningType.AllianceAttack
            isHide = true
        end
    end
    self:ShowWarning(warningType, isHide)
end

function UIMainNewView:ShowWarning(warningType, isHide)
    if warningType == nil or isHide then
        self.warning_bg:SetActive(false)
    elseif warningType == WarningType.Attack then
        self.warning_bg:SetActive(true)
    elseif warningType == WarningType.Scout then
        self.warning_bg:SetActive(false)
    elseif warningType == WarningType.Assistance then
        self.warning_bg:SetActive(false)
    else
        self.warning_bg:SetActive(true)
    end
    
    self.bottomPart:RefreshWarning(warningType)
end

function UIMainNewView:NoticeMainViewUpdateMarchSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:OnEnterCrossServer()
    self:ResetWarningSignal()
end

function UIMainNewView:OnQuitCrossServer()
    self:ResetWarningSignal()
end

function UIMainNewView:UpdateAlertDataSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:BlackKnightWarningSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:BlackKnightUpdateSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:RefreshAlarmSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:IgnoreTargetForMineMarchSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:AllianceQuitOKSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:HideAllianceWarningSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:RefreshCityBuildModelSignal()
    self.bottomPart:RefreshCityBuildModelSignal()
end

function UIMainNewView:RefreshAllianceRedSignal()
    self:ResetWarningSignal()
end

function UIMainNewView:GetCurAnimName()
    return self.curAnimState
end

---march end

UIMainNewView.OnCreate = OnCreate
UIMainNewView.OnDestroy = OnDestroy
UIMainNewView.ComponentDefine = ComponentDefine
UIMainNewView.ComponentDestroy = ComponentDestroy
UIMainNewView.DataDefine = DataDefine
UIMainNewView.DataDestroy = DataDestroy
UIMainNewView.OnEnable = OnEnable
UIMainNewView.OnDisable = OnDisable

UIMainNewView.TimerAction = TimerAction
UIMainNewView.Refresh = Refresh
UIMainNewView.RefreshVita = RefreshVita
UIMainNewView.RefreshVitaTime = RefreshVitaTime
UIMainNewView.RefreshVitaMessage = RefreshVitaMessage

UIMainNewView.OnTimeClick = OnTimeClick
UIMainNewView.OnResidentClick = OnResidentClick
UIMainNewView.ShowDayNight =ShowDayNight
UIMainNewView.ShowDayNightChange = ShowDayNightChange
UIMainNewView.OnAddListener = OnAddListener
UIMainNewView.OnRemoveListener = OnRemoveListener
UIMainNewView.OnChangeTime = OnChangeTime
UIMainNewView.OnClickGemsBtn = OnClickGemsBtn
UIMainNewView.OnClickResCostBtn = OnClickResCostBtn
UIMainNewView.UpdateGold = UpdateGold
UIMainNewView.RefreshPower = RefreshPower
UIMainNewView.OnClickPowerBtn = OnClickPowerBtn
UIMainNewView.OnPlayerClick =OnPlayerClick
UIMainNewView.RefreshCameraPoint = RefreshCameraPoint
UIMainNewView.OnEnterWorld= OnEnterWorld
UIMainNewView.OnEnterCity = OnEnterCity
UIMainNewView.OnVitaDataUpdate = OnVitaDataUpdate
UIMainNewView.RefreshTaskSignal = RefreshTaskSignal
UIMainNewView.UpdateLod = UpdateLod
UIMainNewView.BuildDataSignal = BuildDataSignal
UIMainNewView.OnRefreshPlayerIcon =OnRefreshPlayerIcon
UIMainNewView.TryShowMiniMap = TryShowMiniMap
UIMainNewView.TryHideMiniMap = TryHideMiniMap
UIMainNewView.OnPackageInfoUpdated =OnPackageInfoUpdated
return UIMainNewView