---
--- Created by Beef.
--- DateTime: 2024/4/2 19:07
---

local UICitySiegeStart = BaseClass("UICitySiegeStart", UIBaseView)
local base = UIBaseView
local Close_Time = 3

local title_text_path = "Anim/title_text"
local effect_go_path = "Anim/Eff_UI_Sangshilaixi_tishi"

function UICitySiegeStart:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UICitySiegeStart:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICitySiegeStart:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.effect_go = self:AddComponent(UIBaseContainer, effect_go_path)
end

function UICitySiegeStart:ComponentDestroy()
end

function UICitySiegeStart:DataDefine()
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Zombie_Coming)
end

function UICitySiegeStart:DataDestroy()
    self:DeleteAutoDoNextTimer()
    self.auto_to_do_next_timer_action = nil
end

function UICitySiegeStart:OnEnable()
    base.OnEnable(self)
    self:ReInit()
end

function UICitySiegeStart:OnDisable()
    base.OnDisable(self)
end

function UICitySiegeStart:OnAddListener()
    base.OnAddListener(self)
end

function UICitySiegeStart:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICitySiegeStart:ReInit()
    self.callback = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.ZOMBIE_WILL_COMING)
    self:AddScript()
    self:AddAutoDoNextTimer()
end

function UICitySiegeStart:AddAutoDoNextTimer()
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(Close_Time, self.auto_to_do_next_timer_action , self, true, false,false)
    self.autoDoNextTimer:Start()
end


function UICitySiegeStart:AutoDoNextTimerAction()
    self:DeleteAutoDoNextTimer()
    self:Close()
end

function UICitySiegeStart:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UICitySiegeStart:AddScript()
    if typeof(CS.RadialBlurHelper) == nil then
        local radial_blur_helper = self.effect_go.rectTransform:GetOrAddComponent(typeof(CS.RadialBlurHelper))
        if radial_blur_helper ~= nil then
            radial_blur_helper.ScreenX = 0.455
            radial_blur_helper.ScreenY = 0.5
            radial_blur_helper.loop = 6
            radial_blur_helper.blur = 1.85
            radial_blur_helper.downsample = 2
            radial_blur_helper.instensity = 0
        end
    end
end

function UICitySiegeStart:Close()
    if self.callback then
        self.callback()
    end
    self.ctrl:CloseSelf()
end

function UICitySiegeStart:OnKeyEscape()
    self:Close()
end

return UICitySiegeStart