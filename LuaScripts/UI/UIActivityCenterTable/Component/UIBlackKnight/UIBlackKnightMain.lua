---
--- 黑骑士活动主界面
--- Created by shimin.
--- DateTime: 2023/3/6 12:03
---

local UIBlackKnightMain = BaseClass("UIBlackKnightMain", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_text_path = "Panel/Txt_ActName"
local des_text_path = "Panel/Txt_ActDesc"
local left_time_text_path = "Panel/bottom_go/RestTime"
local go_btn_path = "Panel/bottom_go/GoBtn"
local go_btn_text_path = "Panel/bottom_go/GoBtn/GoBtnText"
local mail_btn_path = "Panel/bottom_go/mail_btn"
local mail_btn_name_text_path = "Panel/bottom_go/mail_btn/mail_btn_text"
local state_text_path = "Panel/bottom_go/state_text"
local reward_content_path = "Panel/bottom_go/RewardList"
local rank_btn_path = "Panel/RightBtnList/RanklistBtn"
local person_score_value_text_path = "Panel/bottom_go/pointBg/title_tips_IDup"
local person_score_name_text_path = "Panel/bottom_go/pointBg/content_main_IDup"
local alliance_score_value_text_path = "Panel/bottom_go/pointBg/title_tips_Alliance"
local alliance_score_name_text_path = "Panel/bottom_go/pointBg/content_main_Alliance"
local toggle_path = "Panel/bottom_go/redSwitchTxt/redSwitch"
local toggle_text_path = "Panel/bottom_go/redSwitchTxt"
local activity_state_text_path = "Panel/bottom_go/activity_state_text"
local rank_btn_name_text_path = "Panel/RightBtnList/RanklistBtn/RanklistBtnText"
local left_time_name_text_path = "Panel/bottom_go/left_time_name_text"
local reward_des_text_path = "Panel/bottom_go/rewardDes"
local rank_score_btn_path = "Panel/RightBtnList/RewardBtn"
local rank_score_btn_text_path = "Panel/RightBtnList/RewardBtn/RewardText"
local info_btn_path = "Panel/infoBtn"

function UIBlackKnightMain:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIBlackKnightMain:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightMain:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightMain:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightMain:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.left_time_text = self:AddComponent(UITextMeshProUGUIEx, left_time_text_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoBtnClick()
    end)
    self.go_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_btn_text_path)
    self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
    self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
    self.rank_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnScoreRankBtnClick()
    end)
    self.person_score_value_text = self:AddComponent(UITextMeshProUGUIEx, person_score_value_text_path)
    self.person_score_name_text = self:AddComponent(UITextMeshProUGUIEx, person_score_name_text_path)
    self.alliance_score_value_text = self:AddComponent(UITextMeshProUGUIEx, alliance_score_value_text_path)
    self.alliance_score_name_text = self:AddComponent(UITextMeshProUGUIEx, alliance_score_name_text_path)
    self.toggle_text = self:AddComponent(UITextMeshProUGUIEx, toggle_text_path)
    self.toggle = self:AddComponent(UIToggle, toggle_path)
    self.toggle:SetOnValueChanged(function(tf)
        self:ToggleControlBorS(tf)
    end)
    self.activity_state_text = self:AddComponent(UITextMeshProUGUIEx, activity_state_text_path)
    self.mail_btn = self:AddComponent(UIButton, mail_btn_path)
    self.mail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMailBtnClick()
    end)
    self.mail_btn_name_text = self:AddComponent(UITextMeshProUGUIEx, mail_btn_name_text_path)
    self.rank_btn_name_text = self:AddComponent(UITextMeshProUGUIEx, rank_btn_name_text_path)
    self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
    self.left_time_name_text = self:AddComponent(UITextMeshProUGUIEx, left_time_name_text_path)
    self.reward_des_text = self:AddComponent(UITextMeshProUGUIEx, reward_des_text_path)
    self.rank_score_btn = self:AddComponent(UIButton, rank_score_btn_path)
    self.rank_score_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRankBtnClick()
    end)
    self.rank_score_btn_text = self:AddComponent(UITextMeshProUGUIEx, rank_score_btn_text_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    
end

function UIBlackKnightMain:ComponentDestroy()
    
end

function UIBlackKnightMain:DataDefine()
    self.time_callback = function()
        self:RefreshTime()
    end
    self.isClickOpen = false
    self.endTime = 0
    self.ingEndTime = 0
    self.rewardEndTime = 0
    self.initReward = false
end

function UIBlackKnightMain:DataDestroy()
    self:DeleteTimer()
    self.time_callback = nil
    self.isClickOpen = false
    self.endTime = 0
    self.ingEndTime = 0
    self.rewardEndTime = 0
    self.initReward = false
end

function UIBlackKnightMain:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
end

function UIBlackKnightMain:OnRemoveListener()
    self:RemoveUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
    base.OnRemoveListener(self)
end

function UIBlackKnightMain:ReInit()
    DataCenter.ActBlackKnightManager:SendMonsterSiegeActivityInfo()
    self.endTime = DataCenter.ActBlackKnightManager:GetWeekEndTime()
    self.title_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT)
    self.des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_DES)
    self.toggle_text:SetLocalText(GameDialogDefine.CLOSE_BLACK_KNIGHT_WARNING)
    self.person_score_name_text:SetLocalText(GameDialogDefine.PERSONAL_SCORE_WITH, "")
    self.alliance_score_name_text:SetLocalText(GameDialogDefine.ALLIANCE_SCORE_WITH, "")
    self.mail_btn_name_text:SetLocalText(GameDialogDefine.BATTLE_MAIL)
    self.rank_btn_name_text:SetLocalText(GameDialogDefine.RANK_NAME)
    self.left_time_name_text:SetLocalText(GameDialogDefine.LEFT_TIME)
    self.reward_des_text:SetLocalText(GameDialogDefine.ACTIVITY_REWARD)
    self.rank_score_btn_text:SetLocalText(GameDialogDefine.REWARD)
    self:Refresh()
    
    if DataCenter.ActBlackKnightManager:IsShowWarning() then
        self.toggle:SetIsOn(false)
    else
        self.toggle:SetIsOn(true)
    end
    self:AddTimer()
    self:RefreshTime()
    self:ShowReward()
    DataCenter.ActBlackKnightManager:SetIsNew()
end


function UIBlackKnightMain:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.endTime then
        self.left_time_text:SetActive(false)
    else
        self.left_time_text:SetActive(true)
        self.left_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
    end
    if self.ingEndTime > 0 then
        local ingLeftTime = self.ingEndTime - curTime
        if ingLeftTime >= 0 then
            self.activity_state_text:SetLocalText(GameDialogDefine.LEFT_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(self.ingEndTime - curTime))
        else
            self:Refresh()
        end
    end
    if self.rewardEndTime > 0 then
        local ingLeftTime = self.rewardEndTime - curTime
        if ingLeftTime >= 0 then
            self.activity_state_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_REWARD_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(ingLeftTime))
        else
            self:Refresh()
        end
    end
end

function UIBlackKnightMain:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIBlackKnightMain:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback ,self, false, false, false)
        self.timer:Start()
    end
end

function UIBlackKnightMain:OnGoBtnClick()
    local state = DataCenter.ActBlackKnightManager:GetUIActState()
    if state == BlackKnightState.NoAlliance then
        GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
    elseif state == BlackKnightState.READY then
        if not self.isClickOpen then
            UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.BLACK_KNIGHT_OPEN_TIPS), 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM,function()
            end, function()
                self.isClickOpen = true
                DataCenter.ActBlackKnightManager:SendMonsterSiegeStart()
                self.view.ctrl:CloseSelf()
            end)
        end
    end
end

function UIBlackKnightMain:OnRankBtnClick()
    --打开排行榜
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackKnightReward, NormalBlurPanelAnim)
end

function UIBlackKnightMain:OnMailBtnClick()
    --打开邮件
    GoToUtil.GotoOpenView(UIWindowNames.UIMailNew, MailInternalGroup.MAIL_IN_report)
end

function UIBlackKnightMain:BlackKnightUpdateSignal()
    self:Refresh()
    self:RefreshTime()
end

function UIBlackKnightMain:ToggleControlBorS(isSelect)
    if isSelect then
        --关闭预警
        DataCenter.ActBlackKnightManager:CloseWarning()
    else
        --取消关闭预警
        DataCenter.ActBlackKnightManager:OpenWarning()
    end
end

function UIBlackKnightMain:Refresh()
    self.isClickOpen = false
    local actBlackKnightData = DataCenter.ActBlackKnightManager:GetActInfo()
    if actBlackKnightData ~= nil then
        self.ingEndTime = actBlackKnightData.siegeET
        self.person_score_value_text:SetText(string.GetFormattedSeperatorNum(actBlackKnightData.userKill))
        self.alliance_score_value_text:SetText(string.GetFormattedSeperatorNum(actBlackKnightData.allKill))
    else
        self.ingEndTime = 0
    end
    self.rewardEndTime = 0
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    local state = DataCenter.ActBlackKnightManager:GetUIActState()
    if state == BlackKnightState.NoAlliance then
        self.activity_state_text:SetActive(false)
        self.go_btn:SetActive(true)
        self.go_btn_text:SetLocalText(GameDialogDefine.JOIN_ALLIANCE)
        self.state_text:SetActive(false)
        self.toggle_text:SetActive(false)
        self.mail_btn:SetActive(false)
    elseif state == BlackKnightState.READY then
        if isR4orR5 then
            self.go_btn:SetActive(true)
            self.state_text:SetActive(false)
            self.activity_state_text:SetActive(false)
            self.go_btn_text:SetLocalText(GameDialogDefine.OPEN_ACTIVITY)
        else
            self.go_btn:SetActive(false)
            self.state_text:SetActive(true)
            self.activity_state_text:SetActive(false)
            self.state_text:SetLocalText(GameDialogDefine.ALLIANCE_NO_START_ACTIVITY)
        end
        self.toggle_text:SetActive(true)
        self.mail_btn:SetActive(false)
    elseif state == BlackKnightState.OPEN then
        self.activity_state_text:SetActive(true)
        self.go_btn:SetActive(false)
        self.state_text:SetActive(true)
        self.state_text:SetLocalText(GameDialogDefine.ACTIVITY_ING)
        self.toggle_text:SetActive(true)
        self.mail_btn:SetActive(false)
    elseif state == BlackKnightState.CLOSING or state == BlackKnightState.REWARD or state == BlackKnightState.CLOSED then
        if actBlackKnightData ~= nil then
            self.rewardEndTime = actBlackKnightData.rewardTime
        else
            self.rewardEndTime = 0
        end
        self.activity_state_text:SetActive(true)
        self.state_text:SetActive(true)
        self.state_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_OVER)
        self.go_btn:SetActive(false)
        self.toggle_text:SetActive(true)
        self.mail_btn:SetActive(true)
    elseif state == BlackKnightState.END then
        self.activity_state_text:SetActive(false)
        self.state_text:SetActive(true)
        self.state_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_OVER)
        self.go_btn:SetActive(false)
        self.toggle_text:SetActive(true)
        self.mail_btn:SetActive(true)
    end
end

function UIBlackKnightMain:ShowReward()
    if not self.initReward then
        self.initReward = true
        local actData = DataCenter.ActBlackKnightManager:GetActivity()
        if actData ~= nil then
            local rewardList = string.split_ii_array(actData.reward_goods, "|")
            for k,v in ipairs(rewardList) do
                local param = {}
                param.rewardType = RewardType.GOODS
                param.itemId = v
                self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.reward_content.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.reward_content:AddComponent(UICommonItem, nameStr)
                    cell:ReInit(param)
                end)
            end
        end
    end
end

function UIBlackKnightMain:OnScoreRankBtnClick()
    --打开积分排行榜
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackKnightScoreRank, NormalBlurPanelAnim)
end

function UIBlackKnightMain:OnInfoBtnClick()
    UIUtil.ShowIntro(Localization:GetString(GameDialogDefine.BLACK_KNIGHT),
            Localization:GetString(GameDialogDefine.ACTIVITY_RULE), Localization:GetString(GameDialogDefine.BLACK_KNIGHT_TIPS))
end



return UIBlackKnightMain