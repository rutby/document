---
--- 黑骑士信息（点击遗迹城）
--- Created by shimin.
--- DateTime: 2023/3/7 22:25
---

local UIBlackKnightInfo = BaseClass("UIBlackKnightInfo", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local activity_detail_btn_path = "BtnGo/activity_detail_btn"
local activity_detail_btn_text_path = "BtnGo/activity_detail_btn/activity_detail_btn_text"
local my_warning_btn_path = "BtnGo/my_warning_btn"
local my_warning_btn_text_path = "BtnGo/my_warning_btn/my_warning_btn_text"
local state_des_text_path = "state_des_text"
local time_text_path = "time_text"
local ing_des_text_path = "ing_go/ing_des_text"
local turn_tips_path = "ing_go/turn_tips"
local turn_text_path = "ing_go/turn_text"
local ing_go_path = "ing_go"
local power_tips_path = "ing_go/power_tips"
local power_text_path = "ing_go/power_text"
local pos_text_path = "ing_go/pos_text"
local pos_btn_path = "ing_go/pos_text/pos_btn"

function UIBlackKnightInfo:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIBlackKnightInfo:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightInfo:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightInfo:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightInfo:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.activity_detail_btn = self:AddComponent(UIButton, activity_detail_btn_path)
    self.activity_detail_btn:SetOnClick(function()
        self:OnActivityBtnClick()
    end)
    self.activity_detail_btn_text = self:AddComponent(UITextMeshProUGUIEx, activity_detail_btn_text_path)
    self.my_warning_btn = self:AddComponent(UIButton, my_warning_btn_path)
    self.my_warning_btn:SetOnClick(function()
        self:OnMyWarningBtnClick()
    end)
    self.my_warning_btn_text = self:AddComponent(UITextMeshProUGUIEx, my_warning_btn_text_path)
    self.state_des_text = self:AddComponent(UITextMeshProUGUIEx, state_des_text_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
    self.ing_des_text = self:AddComponent(UITextMeshProUGUIEx, ing_des_text_path)
    self.turn_tips = self:AddComponent(UITextMeshProUGUIEx, turn_tips_path)
    self.turn_text = self:AddComponent(UITextMeshProUGUIEx, turn_text_path)
    self.ing_go = self:AddComponent(UIBaseContainer, ing_go_path)
    self.power_tips = self:AddComponent(UITextMeshProUGUIEx, power_tips_path)
    self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
    self.pos_text = self:AddComponent(UITextMeshProUGUIEx, pos_text_path)
    self.pos_btn = self:AddComponent(UIButton, pos_btn_path)
    self.pos_btn:SetOnClick(function()
        self:OnPosBtnClick()
    end)
end

function UIBlackKnightInfo:ComponentDestroy()
end

function UIBlackKnightInfo:DataDefine()
    self.timer = nil
    self.endTime = 0
    self.state = BlackKnightState.END
    self.time_callback = function()
        self:RefreshTime()
    end
end

function UIBlackKnightInfo:DataDestroy()
    self:DeleteTimer()
    self.endTime = 0
    self.state = BlackKnightState.END
    self.time_callback = nil
end

function UIBlackKnightInfo:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
end

function UIBlackKnightInfo:OnRemoveListener()
    self:RemoveUIListener(EventId.BlackKnightUpdate, self.BlackKnightUpdateSignal)
    base.OnRemoveListener(self)
end

function UIBlackKnightInfo:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT)
    self.my_warning_btn_text:SetLocalText(GameDialogDefine.MY_MILITARY_INFORMATION)
    self.turn_tips:SetLocalText(GameDialogDefine.BLACK_KNIGHT_TURN_WITH, "")
    self.power_tips:SetLocalText(GameDialogDefine.BLACK_KNIGHT_POWER_WITH, "")
    self:SendMsg()
    self:Refresh()
    self:AddTimer()
    self:RefreshTime()
end

function UIBlackKnightInfo:BlackKnightUpdateSignal()
    self:Refresh()
    self:RefreshTime()
end

function UIBlackKnightInfo:Refresh()
    local actBlackKnightData = DataCenter.ActBlackKnightManager:GetActInfo()
    self.state = DataCenter.ActBlackKnightManager:GetUIActState()
    if self.state == BlackKnightState.NoAlliance then
        self.activity_detail_btn_text:SetLocalText(GameDialogDefine.JOIN_ALLIANCE)
        self.my_warning_btn:SetActive(false)
        self.state_des_text:SetActive(true)
        self.state_des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_READY_DES)
        self.ing_go:SetActive(false)
        self.endTime = DataCenter.ActBlackKnightManager:GetWeekEndTime()
    elseif self.state == BlackKnightState.READY then
        self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
        self.my_warning_btn:SetActive(false)
        self.state_des_text:SetActive(true)
        self.state_des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_READY_DES)
        self.ing_go:SetActive(false)
        self.endTime = DataCenter.ActBlackKnightManager:GetWeekEndTime()
    elseif self.state == BlackKnightState.OPEN then
        self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
        self.my_warning_btn:SetActive(true)
        self.state_des_text:SetActive(false)
        self.ing_go:SetActive(true)
        self.ing_des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_ING_DES)
        if actBlackKnightData ~= nil then
            self.endTime = actBlackKnightData.nextRoundTime
            self.turn_text:SetText(actBlackKnightData.round)
            self.power_text:SetText(string.GetFormattedSeperatorNum(actBlackKnightData.power))
            local pos = SceneUtils.IndexToTilePos(actBlackKnightData.pointId, ForceChangeScene.World)
            self.pos_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_POINT_WITH, 
                    "<i>"..Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y).."</i>")
        else
            self.endTime = 0
        end
    elseif self.state == BlackKnightState.CLOSING or self.state == BlackKnightState.REWARD then
        self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
        self.my_warning_btn:SetActive(false)
        self.state_des_text:SetActive(true)
        self.state_des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_OVER_WITH)
        self.ing_go:SetActive(false)
        if actBlackKnightData ~= nil then
            self.endTime = actBlackKnightData.rewardTime
        else
            self.endTime = 0
        end
    elseif self.state == BlackKnightState.END or self.state == BlackKnightState.CLOSED then
        self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
        self.my_warning_btn:SetActive(false)
        self.state_des_text:SetActive(true)
        self.state_des_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_OVER_WITH)
        self.ing_go:SetActive(false)
        self.endTime = DataCenter.ActBlackKnightManager:GetWeekEndTime()
    end
end

function UIBlackKnightInfo:SendMsg()
    DataCenter.ActBlackKnightManager:SendMonsterSiegeActivityInfo()
end

function UIBlackKnightInfo:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    if leftTime < 0 then
        self.time_text:SetActive(false)
        --什么时候发消息刷新
    else
        self.time_text:SetActive(true)
        if self.state == BlackKnightState.NoAlliance or self.state == BlackKnightState.READY 
                or self.state == BlackKnightState.END or self.state == BlackKnightState.CLOSED  then
            self.time_text:SetLocalText(GameDialogDefine.LEFT_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        elseif self.state == BlackKnightState.OPEN then
            local time = math.modf(leftTime / 1000)
            self.time_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_NEXT_COMING_WITH, time)
        elseif self.state == BlackKnightState.CLOSING or self.state == BlackKnightState.REWARD then
            self.time_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_STATE_REWARD_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        end
    end
end

function UIBlackKnightInfo:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIBlackKnightInfo:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback ,self, false, false, false)
        self.timer:Start()
    end
end

function UIBlackKnightInfo:OnActivityBtnClick()
    if self.state == BlackKnightState.NoAlliance then
        GoToUtil.GotoOpenView(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
    else
        local actData = DataCenter.ActBlackKnightManager:GetActivity()
        if actData ~= nil then
            self.ctrl:CloseSelf()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, hideTop = true, UIMainAnim = UIMainAnimType.AllHide },
                    tonumber(actData.id))
        end
    end
end

function UIBlackKnightInfo:OnMyWarningBtnClick()
    GoToUtil.GotoOpenView(UIWindowNames.UIAllianceWarPersonalList, NormalBlurPanelAnim)
end

function UIBlackKnightInfo:OnPosBtnClick()
    local actBlackKnightData = DataCenter.ActBlackKnightManager:GetActInfo()
    if actBlackKnightData ~= nil then
        self.ctrl:CloseSelf()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(actBlackKnightData.pointId,ForceChangeScene.World), CS.SceneManager.World.InitZoom
            ,LookAtFocusTime, nil, LuaEntry.Player.serverId)
    end
end

return UIBlackKnightInfo