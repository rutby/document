---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/10 15:50
---


local UIPresidentAuthorityMain = BaseClass("UIPresidentAuthorityMain", UIBaseView)
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local title_path = "offset/title"
local desc_path = "offset/desc"
local time_path = "offset/timeText/timeCD"

local btn_path = "offset/btn"
local btn_text_path = "offset/btn/btnText"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    DataCenter.PresidentMineRefreshManager:SetIsNew()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


local function OnAddListener(self)
    base.OnAddListener(self)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

--控件的定义
local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)

    self.desc = self:AddComponent(UIText, desc_path)
    self.timeText = self:AddComponent(UIText, time_path)

    self.btn = self:AddComponent(UIButton, btn_path)
    self.btnText = self:AddComponent(UIText, btn_text_path)
    self.btnText:SetLocalText(305040)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn()
    end)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end
end

--控件的销毁
local function ComponentDestroy(self)
    self:DelCountDownTimer()
end

--变量的定义
local function DataDefine(self)

end

--变量的销毁
local function DataDestroy(self)

end


local function SetData(self, activityId)
    self.activityId = activityId
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if self.activityInfo == nil then
        return
    end
    
    self:RefreshView()
end

local function RefreshView(self)
    self.titleN:SetText(Localization:GetString(self.activityInfo.name))
    self.desc:SetText(Localization:GetString(self.activityInfo.desc_info))
    self:AddCountDownTimer()
end

local function OnClickBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPresidentAuthority, {anim = true})
end

local function AddCountDownTimer(self)
    self:DelCountDownTimer()
    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

local function RefreshRemainTime(self)
    if self.activityInfo == nil then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityInfo.endTime - curTime
    if remainTime >= 0 then
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.timeText:SetText("")
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

UIPresidentAuthorityMain.OnCreate = OnCreate
UIPresidentAuthorityMain.OnDestroy = OnDestroy
UIPresidentAuthorityMain.OnAddListener = OnAddListener
UIPresidentAuthorityMain.OnRemoveListener = OnRemoveListener
UIPresidentAuthorityMain.ComponentDefine = ComponentDefine
UIPresidentAuthorityMain.ComponentDestroy = ComponentDestroy
UIPresidentAuthorityMain.DataDefine = DataDefine
UIPresidentAuthorityMain.DataDestroy = DataDestroy
UIPresidentAuthorityMain.OnEnable = OnEnable
UIPresidentAuthorityMain.OnDisable = OnDisable
UIPresidentAuthorityMain.RefreshView = RefreshView
UIPresidentAuthorityMain.SetData = SetData
UIPresidentAuthorityMain.OnClickBtn = OnClickBtn
UIPresidentAuthorityMain.AddCountDownTimer = AddCountDownTimer
UIPresidentAuthorityMain.RefreshRemainTime = RefreshRemainTime
UIPresidentAuthorityMain.DelCountDownTimer = DelCountDownTimer

return UIPresidentAuthorityMain