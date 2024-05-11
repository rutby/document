--- Created by shimin
--- DateTime: 2023/9/26 17:25
--- 推翻胡蒂尔页面

local UIOverthrowHudierView = BaseClass("UIOverthrowHudierView", UIBaseView)
local base = UIBaseView

local panel_btn_path = "Panel"
local close_btn_path = "Root/CloseBtn"
local desc_text_path = "Root/desc_text"
local time_text_path = "Root/time_text"
local confirm_btn_path = "Root/confirm_btn"
local confirm_btn_text_path = "Root/confirm_btn/confirm_btn_text"

function UIOverthrowHudierView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIOverthrowHudierView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.desc_text = self:AddComponent(UIText, desc_text_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.confirm_btn_text = self:AddComponent(UIText, confirm_btn_text_path)
end

function UIOverthrowHudierView:ComponentDestroy()
end

function UIOverthrowHudierView:DataDefine()
    self.timer = nil
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
    self.endTime = 0
end

function UIOverthrowHudierView:DataDestroy()
    self.endTime = 0
    self:DeleteTimer()
end

function UIOverthrowHudierView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIOverthrowHudierView:OnEnable()
    base.OnEnable(self)
end

function UIOverthrowHudierView:OnDisable()
    base.OnDisable(self)
end

function UIOverthrowHudierView:OnAddListener()
    base.OnAddListener(self)
end

function UIOverthrowHudierView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIOverthrowHudierView:ReInit()
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local seasonName = GetTableData(TableName.APS_Season, seasonId, 'subTitle')
    if string.IsNullOrEmpty(seasonName) then
        self.desc_text:SetText("")
    else
        self.desc_text:SetLocalText(seasonName)
    end
    self.confirm_btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    local curStage, endTime = DataCenter.RobotWarsManager:GetCurStage()
    if curStage == SeasonStage.Preview then
        self.endTime = endTime
        self.time_text:SetActive(true)
        self:AddTimer()
        self:OnTimerCallBack()
    else
        self.endTime = 0
        self.time_text:SetActive(false)
        self:DeleteTimer()
    end
end

function UIOverthrowHudierView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_callback, self, false, false, false)
        self.timer:Start()
    end
end

function UIOverthrowHudierView:OnTimerCallBack()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if remainTime > 0 then
        self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.time_text:SetActive(false)
        self:DeleteTimer()
    end
end

function UIOverthrowHudierView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

return UIOverthrowHudierView