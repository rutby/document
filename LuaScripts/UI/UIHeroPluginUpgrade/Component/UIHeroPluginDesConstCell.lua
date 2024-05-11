--- Created by shimin
--- DateTime: 2023/7/26 10:27
--- 英雄插件属性界面Const cell

local UIHeroPluginDesConstCell = BaseClass("UIHeroPluginDesConstCell", UIBaseContainer)
local base = UIBaseContainer

local show_text_path = "show_text"
local show_value_path = "show_text/Text_lv18"
local this_path = ""

function UIHeroPluginDesConstCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginDesConstCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginDesConstCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginDesConstCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginDesConstCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_value = self:AddComponent(UIText, show_value_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
end

function UIHeroPluginDesConstCell:ComponentDestroy()
end

function UIHeroPluginDesConstCell:DataDefine()
    self.param = {}
    self.delay_timer_callback = function()
        self:DelayTimerCallback()
    end
end

function UIHeroPluginDesConstCell:DataDestroy()
    self:RemoveDelayTimer()
    self.param = {}
end

function UIHeroPluginDesConstCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginDesConstCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginDesConstCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginDesConstCell:Refresh()
    self:RemoveDelayTimer()
    if self.param.visible then
        self:SetActive(true)
        if self.param.data ~= nil then
            self.show_text:SetText(self.param.data.showName)
            self.show_value:SetText(self.param.data.showValue)
            if self.param.data.delayTime ~= nil and self.param.data.delayTime ~= 0 then
                self:PlayAnim(HeroPluginUpgradeAnimName.Hide)
                self:AddDelayTimer(self.param.data.delayTime)
            end
        end
    else
        self:SetActive(false)
    end
end

function UIHeroPluginDesConstCell:PlayAnim(nameAnim)
    if self.anim ~= nil then
        self.anim:Play(nameAnim, 0, 0)
    end
end

function UIHeroPluginDesConstCell:AddDelayTimer(time)
    if self.delayTimer == nil then
        self.delayTimer = TimerManager:GetInstance():GetTimer(time, self.delay_timer_callback, self, true, false, false)
    end
    self.delayTimer:Start()
end

function UIHeroPluginDesConstCell:DelayTimerCallback()
    self:RemoveDelayTimer()
    self:PlayAnim(HeroPluginUpgradeAnimName.Show)
    if self.param ~= nil and  self.param.data ~= nil then
        DataCenter.HeroPluginManager:PlayShowSound(self.param.data.quality)
    end
end

function UIHeroPluginDesConstCell:RemoveDelayTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

return UIHeroPluginDesConstCell