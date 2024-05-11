--- 出世界/联盟迁城遮罩
--- Created by shimin.
--- DateTime: 2022/7/18 16:12
---
local UIGuideLoadMaskView = BaseClass("UIGuideLoadMaskView",UIBaseView)
local base = UIBaseView

local down_text_path = "anim/down_text"
local bg_img_path = "anim/bg_img"
local black_bg_path = "anim/black_bg"
local anim_path = "anim"
local second_black_bg_path = "anim/second_black_bg"

local PosType =
{
    Top = 1,
    Middle = 2,
    Down = 3,
}
--默认位置
local DefaultPosY =
{
    [PosType.Top] = -120,
    [PosType.Middle] = 0,
    [PosType.Down] = 251,
}
--动画名称
local AnimName =
{
    Open = "UIGuideLoadMask_movein",
    Close = "UIGuideLoadMask_moveout",
}

--创建
function UIGuideLoadMaskView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIGuideLoadMaskView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIGuideLoadMaskView:ComponentDefine()
    self.sortComponent = {}
    self.down_text = self:AddComponent(UITextMeshProUGUIEx, down_text_path)
    self.bg_img = self:AddComponent(UIImage, bg_img_path)
    self.black_bg = self:AddComponent(UIImage, black_bg_path)
    self.btn = self:AddComponent(UIButton, black_bg_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.second_black_bg = self:AddComponent(UIImage, second_black_bg_path)
    table.insert(self.sortComponent, self.black_bg)
    table.insert(self.sortComponent, self.bg_img)
    table.insert(self.sortComponent, self.down_text)
    table.insert(self.sortComponent, self.second_black_bg)
    self.anim = self:AddComponent(UIAnimator, anim_path)
  
end

function UIGuideLoadMaskView:ComponentDestroy()
end


function UIGuideLoadMaskView:DataDefine()
    self.param = {}
    self.close_timer_callback = function() 
        self:OnCloseTimerCallBack()
    end
    self.effectId = nil
    self.print_finish_callback = function()
        self:OnPrintFinishCallBack()
    end
end

function UIGuideLoadMaskView:DataDestroy()
    self:StopSound()
    self:DeleteCloseTimer()
    self.param = {}
end

function UIGuideLoadMaskView:OnEnable()
    base.OnEnable(self)
end

function UIGuideLoadMaskView:OnDisable()
    base.OnDisable(self)
end

function UIGuideLoadMaskView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.CloseGuideLoadMask, self.CloseGuideLoadMaskSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideLoadMaskView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.CloseGuideLoadMask, self.CloseGuideLoadMaskSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideLoadMaskView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
    self.anim:SetSpeed(self.param.openSpeed or 1)
    self.anim:Play(AnimName.Open, 0, 0)
end

function UIGuideLoadMaskView:Refresh()
    if self.param.bgName ~= nil then
        self.bg_img:LoadSprite(self.param.bgName, DefaultAlphaIcon, function()
            self.bg_img:SetActive(true)
            self.bg_img:SetNativeSize()
        end)
    else
        self.bg_img:SetActive(false)
    end
    if self.param.des == nil or self.param.des == "" then
        self.down_text:SetActive(false)
    else
        self.down_text:SetActive(true)
        self.down_text:SetText(self.param.des)
        self.down_text:PlayPrint(self.print_finish_callback)
        if self.param.playPrintSound then
            self.effectId = SoundUtil.PlayLoopEffect(SoundAssets.Music_Effect_Chapter_Print)
        end
    end

    if self.param.bgAlpha ~= nil and self.param.bgAlpha > 0 then
        self.black_bg:SetAlpha(self.param.bgAlpha)
    else
        self.black_bg:SetAlpha(1)
    end
    if self.param.secondBgAlpha ~= nil and self.param.secondBgAlpha > 0 then
        self.second_black_bg:SetActive(true)
        self.second_black_bg:SetAlpha(self.param.secondBgAlpha)
    else
        self.second_black_bg:SetActive(false)
    end
    
    if self.param.posType == PosType.Top then
        self.down_text:SetAnchorMinXY(0.5, 1)
        self.down_text:SetAnchorMaxXY(0.5, 1)
    elseif self.param.posType == PosType.Middle then
        self.down_text:SetAnchorMinXY(0.5, 0.5)
        self.down_text:SetAnchorMaxXY(0.5, 0.5)
    else
        self.down_text:SetAnchorMinXY(0.5, 0)
        self.down_text:SetAnchorMaxXY(0.5, 0)
    end
    if self.param.posY ~= nil then
        self.down_text:SetAnchoredPositionXY(0, self.param.posY)
    else
        self.down_text:SetAnchoredPositionXY(0, DefaultPosY[self.param.posType] or DefaultPosY[PosType.Down])
    end
    self.down_text:SetAlignment(self.param.alignmentType or TextAlignmentType.Center)
    
    local newSort = {}
    if self.param.sortArr ~= nil then
        for k,v in ipairs(self.param.sortArr) do
            newSort[v] = self.sortComponent[k]
        end
    end
    for k,v in ipairs(newSort) do
        v.transform:SetAsLastSibling()
    end
end

function UIGuideLoadMaskView:OnBtnClick()
    if not self.down_text:AddSpeedPrint() then
        if self.param.showLoadMaskType == ShowLoadMaskType.ClickNext then
            local nextType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
            if nextType ~= GuideType.ShowLoadMask then
                self:DoClose()
            end
            if DataCenter.GuideManager:GetGuideType() == GuideType.ShowLoadMask then
                DataCenter.GuideManager:DoNext()
            end
        end
    end
end

function UIGuideLoadMaskView:DoClose()
    self:DeleteCloseTimer()
    local speed = self.param.closeSpeed or 1
    self.anim:SetSpeed(speed)
    local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Close)
    if ret then
        self:AddCloseTimer(time / speed)
    end
end

function UIGuideLoadMaskView:DeleteCloseTimer()
    if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end
end

function UIGuideLoadMaskView:AddCloseTimer(time)
    self:DeleteCloseTimer()
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, self.close_timer_callback, self, true, false, false)
    self.closeTimer:Start()
end

function UIGuideLoadMaskView:OnCloseTimerCallBack()
    self:DeleteCloseTimer()
    self.ctrl:CloseSelf()
end

function UIGuideLoadMaskView:CloseGuideLoadMaskSignal()
    self:DoClose()
end

function UIGuideLoadMaskView:RefreshGuideAnimSignal(param)
    self.param = param
    self:Refresh()
end

function UIGuideLoadMaskView:OnPrintFinishCallBack()
    self:StopSound()
end

function UIGuideLoadMaskView:StopSound()
    if self.effectId ~= nil then
        SoundUtil.StopSound(self.effectId)
        self.effectId = nil
    end
end

return UIGuideLoadMaskView