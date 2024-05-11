---
--- 捐兵黑骑士
--- Created by shimin.
--- DateTime: 2023/3/7 22:25
---

local UIALVSDonateSoldierInfoView = BaseClass("UIALVSDonateSoldierInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local activity_detail_btn_path = "ImgBg/BtnGo/activity_detail_btn"
local activity_detail_btn_text_path = "ImgBg/BtnGo/activity_detail_btn/activity_detail_btn_text"
local my_warning_btn_path = "ImgBg/BtnGo/my_warning_btn"
local my_warning_btn_text_path = "ImgBg/BtnGo/my_warning_btn/my_warning_btn_text"
local state_des_text_path = "ImgBg/state_des_text"
local time_text_path = "ImgBg/time_text"
local ing_des_text_path = "ImgBg/ing_go/ing_des_text"
local turn_tips_path = "ImgBg/ing_go/turn_tips"
local turn_text_path = "ImgBg/ing_go/turn_text"
local ing_go_path = "ImgBg/ing_go"
local power_tips_path = "ImgBg/ing_go/power_tips"
local power_text_path = "ImgBg/ing_go/power_text"
local pos_text_path = "ImgBg/ing_go/pos_text"
local pos_btn_path = "ImgBg/ing_go/pos_text/pos_btn"

function UIALVSDonateSoldierInfoView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIALVSDonateSoldierInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIALVSDonateSoldierInfoView:OnEnable()
    base.OnEnable(self)
end

function UIALVSDonateSoldierInfoView:OnDisable()
    base.OnDisable(self)
end

function UIALVSDonateSoldierInfoView:ComponentDefine()
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
    self.activity_detail_btn_text = self:AddComponent(UIText, activity_detail_btn_text_path)
    self.my_warning_btn = self:AddComponent(UIButton, my_warning_btn_path)
    self.my_warning_btn:SetOnClick(function()
        self:OnMyWarningBtnClick()
    end)
    self.my_warning_btn_text = self:AddComponent(UIText, my_warning_btn_text_path)
    self.state_des_text = self:AddComponent(UIText, state_des_text_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.ing_des_text = self:AddComponent(UIText, ing_des_text_path)
    self.turn_tips = self:AddComponent(UIText, turn_tips_path)
    self.turn_text = self:AddComponent(UIText, turn_text_path)
    self.ing_go = self:AddComponent(UIBaseContainer, ing_go_path)
    self.power_tips = self:AddComponent(UIText, power_tips_path)
    self.power_text = self:AddComponent(UIText, power_text_path)
    self.pos_text = self:AddComponent(UIText, pos_text_path)
    self.pos_btn = self:AddComponent(UIButton, pos_btn_path)
    self.pos_btn:SetOnClick(function()
        self:OnPosBtnClick()
    end)
    self.isSending = false
end

function UIALVSDonateSoldierInfoView:ComponentDestroy()
end

function UIALVSDonateSoldierInfoView:DataDefine()
    self.timer = nil
    self.endTime = 0
    self.time_callback = function()
        self:RefreshTime()
    end
end

function UIALVSDonateSoldierInfoView:DataDestroy()
    self:DeleteTimer()
    self.endTime = 0
    self.time_callback = nil
end

function UIALVSDonateSoldierInfoView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UIDonateSoldierInfoDataUpdate, self.OnDataReturn)
end

function UIALVSDonateSoldierInfoView:OnRemoveListener()
    self:RemoveUIListener(EventId.UIDonateSoldierInfoDataUpdate, self.OnDataReturn)
    base.OnRemoveListener(self)
end

function UIALVSDonateSoldierInfoView:OnDataReturn()
    self:Refresh()
    self:AddTimer()
    self:RefreshTime()
    self.isSending = false
end

function UIALVSDonateSoldierInfoView:ReInit()
    self.title_text:SetLocalText(372775)
    self.my_warning_btn_text:SetLocalText(GameDialogDefine.MY_MILITARY_INFORMATION)
    self.turn_tips:SetLocalText(372807, "") --远征军轮次：
    self.power_tips:SetLocalText(372808, "") --远征军战力：

    local attackOpenTime = DataCenter.ActivityALVSDonateSoldierManager:GetExpeditionOpenTime()
    local nowTime = UITimeManager:GetInstance():GetServerTime()
    if nowTime > attackOpenTime then
        --到活动时间再发送请求
        self:SendMsg()
    else
        self.panel_state = AllianceDonateState.Waiting
        self:OnDataReturn()
    end
end

function UIALVSDonateSoldierInfoView:Refresh()
    local attackOpenTime = DataCenter.ActivityALVSDonateSoldierManager:GetExpeditionOpenTime()
    local nowTime = UITimeManager:GetInstance():GetServerTime()
    if nowTime < attackOpenTime then
        self.panel_state = AllianceDonateState.Waiting
        --未开启
        self:SetWaitingPanelState()
    else
        local battleData = DataCenter.ActivityALVSDonateSoldierManager:DonateSoldierInfoViewData()
        if battleData then
            if battleData.state == AllianceDonateState.Attaking then
                self.panel_state = battleData.state
                --正在进攻 显示下一波次
                self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
                self.my_warning_btn:SetActive(true)
                self.state_des_text:SetActive(false)
                self.ing_go:SetActive(true)
                self.ing_des_text:SetLocalText(372806) --敌方远征军正在进攻您的联盟！
                if battleData ~= nil then
                    self.endTime = battleData.nextRoundTime
                    self.turn_text:SetText(battleData.round)
                    self.power_text:SetText(string.GetFormattedSeperatorNum(battleData.power))
                    self.pos_text:SetLocalText(GameDialogDefine.BLACK_KNIGHT_POINT_WITH, 
                            "<i>"..Localization:GetString(GameDialogDefine.SHOW_POS, battleData.x, battleData.y).."</i>")
                else
                    self.endTime = 0
                end
            elseif battleData.state == AllianceDonateState.End or battleData.state == AllianceDonateState.Victory or  battleData.state == AllianceDonateState.Lose then
                --已结束
                self.panel_state = battleData.state
                self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
                self.my_warning_btn:SetActive(false)
                self.state_des_text:SetActive(true)
                self.state_des_text:SetLocalText(372810) --活动已结束，胜负结果将在活动界面展示。
                self.ing_go:SetActive(false)
                if battleData ~= nil then
                    self.endTime = battleData.finishTime
                else
                    self.endTime = DataCenter.ActivityALVSDonateSoldierManager:GetActivityEndTime()
                end
            else
                self:SetWaitingPanelState()
            end
        else
            self:SetWaitingPanelState()
        end
    end
end

function UIALVSDonateSoldierInfoView:SetWaitingPanelState()
    --数据有问题的容错
    self.panel_state = AllianceDonateState.Waiting
    self.activity_detail_btn_text:SetLocalText(GameDialogDefine.ACTIVITY_DETAIL)
    self.my_warning_btn:SetActive(false)
    self.state_des_text:SetActive(true)
    self.state_des_text:SetLocalText(372805) --敌方远征军即将来袭，守卫总部击退敌方远征军获得活动胜利！
    self.ing_go:SetActive(false)
    self.endTime = DataCenter.ActivityALVSDonateSoldierManager:GetExpeditionOpenTime()
end

function UIALVSDonateSoldierInfoView:SendMsg() 
    if self.isSending == false then
        self.isSending = true
        DataCenter.ActivityALVSDonateSoldierManager:OnSendGetDonateSoldierInfoMsg()
    end
end

function UIALVSDonateSoldierInfoView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    if leftTime < 0 then
        if self.panel_state == AllianceDonateState.Waiting 
        or self.panel_state == AllianceDonateState.Attaking then
            -- 如果到了阶段结束时间时间 发送请求更新状态
            self:SendMsg()
        end
        self.time_text:SetActive(false)
        --什么时候发消息刷新
    else
        self.time_text:SetActive(true)
        if self.panel_state == AllianceDonateState.Attaking then
            local time = math.modf(leftTime / 1000)
            self.time_text:SetLocalText(372809, time) --下波远征军来袭：{0}秒后
        else
            self.time_text:SetLocalText(GameDialogDefine.LEFT_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        end
    end
end

function UIALVSDonateSoldierInfoView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIALVSDonateSoldierInfoView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback ,self, false, false, false)
        self.timer:Start()
    end
end

function UIALVSDonateSoldierInfoView:OnActivityBtnClick()
    local actId = DataCenter.ActivityALVSDonateSoldierManager:GetDonateSoldierActivityId()
    if actId ~= nil then
        self.ctrl:CloseSelf()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, hideTop = true, UIMainAnim = UIMainAnimType.AllHide },
                tonumber(actId))
    end
end

function UIALVSDonateSoldierInfoView:OnMyWarningBtnClick()
    GoToUtil.GotoOpenView(UIWindowNames.UIAllianceWarPersonalList, NormalBlurPanelAnim)
end

function UIALVSDonateSoldierInfoView:OnPosBtnClick()
    local battleData = DataCenter.ActivityALVSDonateSoldierManager:DonateSoldierInfoViewData()
    if battleData ~= nil then
        self.ctrl:CloseSelf()
        local tileIdx = SceneUtils.TileXYToIndex(battleData.x, battleData.y, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(tileIdx,ForceChangeScene.World), CS.SceneManager.World.InitZoom
            ,LookAtFocusTime, nil, LuaEntry.Player:GetSelfServerId())
    end
end

return UIALVSDonateSoldierInfoView