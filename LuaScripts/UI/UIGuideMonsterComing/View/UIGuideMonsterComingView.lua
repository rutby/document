--- Created by shimin.
--- DateTime: 2024/2/28 18:25
--  引导丧尸来袭页面

local UIGuideMonsterComingView = BaseClass("UIGuideMonsterComingView", UIBaseView)
local base = UIBaseView
local Close_Time = 5

local title_text_path = "Anim/title_text"
local effect_go_path = "Anim/Eff_UI_Sangshilaixi_tishi"

function UIGuideMonsterComingView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit(self:GetUserData())
end

-- 销毁
function UIGuideMonsterComingView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideMonsterComingView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.effect_go = self:AddComponent(UIBaseContainer, effect_go_path)
end

function UIGuideMonsterComingView:ComponentDestroy()
end

function UIGuideMonsterComingView:DataDefine()
    self.param = {}
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Zombie_Coming)
end

function UIGuideMonsterComingView:DataDestroy()
    self.param = {}
    self:DeleteAutoDoNextTimer()
    self.auto_to_do_next_timer_action = nil
end

function UIGuideMonsterComingView:OnEnable()
    base.OnEnable(self)
end

function UIGuideMonsterComingView:OnDisable()
    base.OnDisable(self)
end

function UIGuideMonsterComingView:OnAddListener()
    base.OnAddListener(self)
end

function UIGuideMonsterComingView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGuideMonsterComingView:ReInit(param)
    self.param = param
    self.title_text:SetLocalText(GameDialogDefine.ZOMBIE_WILL_COMING)
    self:AddScript()
    self:AddAutoDoNextTimer()
end

function UIGuideMonsterComingView:AddAutoDoNextTimer()
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(Close_Time, self.auto_to_do_next_timer_action , self, true, false,false)
    self.autoDoNextTimer:Start()
end


function UIGuideMonsterComingView:AutoDoNextTimerAction()
    self:DeleteAutoDoNextTimer()
    self.ctrl:CloseSelf()
end

function UIGuideMonsterComingView:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UIGuideMonsterComingView:AddScript()
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

return UIGuideMonsterComingView