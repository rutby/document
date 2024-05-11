--- Created by shimin.
--- DateTime: 2023/12/26 16:59
--- UIMain暴风雪倒计时

local UIMainStormTime = BaseClass("UIMainStormTime", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local storm_long_go_path = "storm_long_go"
local storm_name_text_path = "storm_long_go/storm_name_text"
local storm_long_time_text_path = "storm_long_go/storm_long_time_text"
local storm_short_go_path = "storm_short_go"
local storm_short_time_text_path = "storm_short_go/storm_short_time_text"
local reward_go_path = "storm_short_go/reward_go"
local reward_box_anim_path = "storm_short_go/reward_go/reward_box"

local AnimName =
{
    LongToShort = "Eff_Ani_UIMainNew_Sangshilaixi_1",
    Short = "Eff_Ani_UIMainNew_Sangshilaixi_1_Loop",
    ShortToLong = "Eff_Ani_UIMainNew_Sangshilaixi_2",
    Long = "Eff_Ani_UIMainNew_Sangshilaixi_2_Loop",
}

local BoxAnimName = "CanReceive"

function UIMainStormTime:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIMainStormTime:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
function UIMainStormTime:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.storm_long_go = self:AddComponent(UIBaseContainer, storm_long_go_path)
    self.storm_name_text = self:AddComponent(UITextMeshProUGUIEx, storm_name_text_path)
    self.storm_long_time_text = self:AddComponent(UITextMeshProUGUIEx, storm_long_time_text_path)
    self.storm_short_go = self:AddComponent(UIImage, storm_short_go_path)
    self.storm_short_time_text = self:AddComponent(UITextMeshProUGUIEx, storm_short_time_text_path)
    self.reward_go = self:AddComponent(UIBaseContainer, reward_go_path)
    self.reward_box_anim = self:AddComponent(UIAnimator, reward_box_anim_path)
    self.reward_box = self:AddComponent(UIImage, reward_box_anim_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
end

--控件的销毁
function UIMainStormTime:ComponentDestroy()
end

function UIMainStormTime:DataDefine()
    self.left_timer_callback = function()
        self:OnLeftTimerCallBack()
    end
    self.short_timer_callback = function()
        self:OnShortTimerCallBack()
    end
    self.desTest = nil
    self.state = UIStormPanelType.Short
    self.anim_timer_callback =  function()
        self:OnAnimTimerCallBack()
    end
    self.stormState = StormState.No
end

function UIMainStormTime:DataDestroy()
    self:RemoveShortTimer()
    self:RemoveAnimTimer()
    self.desTest = nil
    self:RemoveLeftTimer()
    self.state = UIStormPanelType.Short
    self.stormState = StormState.No
end

function UIMainStormTime:ReInit()
    self:Refresh()
end

function UIMainStormTime:OnEnable()
    base.OnEnable(self)
    self:RefreshAnim()
end

function UIMainStormTime:OnDisable()
    base.OnDisable(self)
end

function UIMainStormTime:OnBtnClick()
    local state = DataCenter.StormManager:GetRewardState()
    if state == StormRewardState.CanGet or state == StormRewardState.Got then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPreviewStorm2, NormalBlurPanelAnim)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPreviewStorm, NormalBlurPanelAnim)
    end
end

function UIMainStormTime:Refresh()
    self.stormState = DataCenter.StormManager:GetStormState()
    if (not SceneUtils.GetIsInCity()) or self.stormState == StormState.No then
        self.btn:SetActive(false)
    else
        self.btn:SetActive(true)
        self.state = DataCenter.StormManager.panelType
        self:RefreshAnim()
        self:RefreshRedDot()
        self:RefreshTime()
    end
end

function UIMainStormTime:RefreshTime()
    if self.stormState == StormState.Alert then
        local endTime = DataCenter.StormManager.stormStartTime
        local left = endTime - UITimeManager:GetInstance():GetServerTime()
        if left >= 0 then
            if self.state == UIStormPanelType.Short then
                self.storm_short_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(left))
            else
                self:SetDesText(GameDialogDefine.ZOMBIE_WILL_COMING)
                self.storm_long_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(left))
            end
            if DataCenter.StormManager:GetRewardState() == StormRewardState.No then
                self:AddLeftTimer()
            else
                self.storm_short_time_text:SetText("")
                self:RemoveLeftTimer()
            end
        end
    elseif self.stormState == StormState.Start then
        local endTime = DataCenter.StormManager.stormEndTime
        local left = endTime - UITimeManager:GetInstance():GetServerTime()
        if left >= 0 then
            if self.state == UIStormPanelType.Short then
                self.storm_short_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(left))
            else
                self:SetDesText(GameDialogDefine.ZOMBIE_WILL_COMING)
                self.storm_long_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(left))
            end
            if DataCenter.StormManager:GetRewardState() == StormRewardState.No then
                self:AddLeftTimer()
            else
                self.storm_short_time_text:SetText("")
                self:RemoveLeftTimer()
            end
        else
            self.storm_short_time_text:SetText("")
            self:RemoveLeftTimer()
        end
    else
        self:RemoveLeftTimer()
    end
end

function UIMainStormTime:AddLeftTimer()
    if self.leftTime == nil then
        self.leftTime = TimerManager:GetInstance():GetTimer(1, self.left_timer_callback, self, false, false, false)
        self.leftTime:Start()
    end
end

function UIMainStormTime:RemoveLeftTimer()
    if self.leftTime ~= nil then
        self.leftTime:Stop()
        self.leftTime = nil
    end
end

function UIMainStormTime:OnLeftTimerCallBack()
    self:RefreshTime()
end

function UIMainStormTime:SetDesText(des)
    if self.state == UIStormPanelType.Long then
        if self.desTest ~= des then
            self.desTest = des
            self.storm_name_text:SetLocalText(self.desTest)
        end
    end
end

function UIMainStormTime:CloseUISignal()
    if self.stormState ~= StormState.No and  self.state == UIStormPanelType.Long then
        --加一个1秒延时
        if not UIManager:GetInstance():HasWindow() then
            self:AddShortTimer()
        end
    end
end

function UIMainStormTime:AddShortTimer()
    if self.shortTime == nil then
        self.shortTime = TimerManager:GetInstance():GetTimer(1, self.short_timer_callback, self, true, false, false)
        self.shortTime:Start()
    end
end

function UIMainStormTime:RemoveShortTimer()
    if self.shortTime ~= nil then
        self.shortTime:Stop()
        self.shortTime = nil
    end
end

function UIMainStormTime:OnShortTimerCallBack()
    self:RemoveShortTimer()
    if not UIManager:GetInstance():HasWindow() then
        self:DoLongChangeShort()
    end
end

function UIMainStormTime:DoLongChangeShort()
    DataCenter.StormManager.panelType = UIStormPanelType.Short
    self:RefreshTime()
    --self:Refresh()
    local ret, time = self.anim:PlayAnimationReturnTime(AnimName.LongToShort)
    if ret then
        self:AddAnimTimer(time)
    end
end

function UIMainStormTime:AddAnimTimer(time)
    if self.animTime == nil then
        self.animTime = TimerManager:GetInstance():GetTimer(time, self.anim_timer_callback, self, true, false, false)
        self.animTime:Start()
    end
end

function UIMainStormTime:RemoveAnimTimer()
    if self.animTime ~= nil then
        self.animTime:Stop()
        self.animTime = nil
    end
end

function UIMainStormTime:OnAnimTimerCallBack()
    self:RemoveAnimTimer()
    self:Refresh()
end

function UIMainStormTime:RefreshRedDot()
    if self.stormState ~= StormState.No then
        if DataCenter.StormManager:GetRewardState() == StormRewardState.CanGet then
            self.reward_go:SetActive(true)
            self.reward_box_anim:Play(BoxAnimName, 0, 0)
            self.storm_short_go:LoadSprite(string.format(LoadPath.UIMain, "zombiecome_xiao2"), nil ,function()
                self.storm_short_go:SetNativeSize()
            end)
            self.reward_box:LoadSprite(string.format(LoadPath.UIPersonalArms, "UIactivities_img2_box3"))
        else
            self.storm_short_go:LoadSprite(string.format(LoadPath.UIMain, "zombiecome_xiao"), nil ,function()
                self.storm_short_go:SetNativeSize()
            end)
            self.reward_go:SetActive(false)
        end
    end
end
function UIMainStormTime:RefreshAnim()
    if self.stormState ~= StormState.No then
        if self.state == UIStormPanelType.Short then
            self.anim:Play(AnimName.Short, 0, 0)
        else
            self.anim:Play(AnimName.Long, 0, 0)
        end
    end
end


return UIMainStormTime