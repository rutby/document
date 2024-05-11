--- Timeline一键跳过
--- Created by shimin.
--- DateTime: 2022/8/31 15:33

local UITimelineJumpView = BaseClass("UITimelineJumpView", UIBaseView)
local base = UIBaseView

local skip_btn_path = "SkipBtn"
local skip_btn_name_path = "SkipBtn/des_layout/des_text"

local PosType =
{
    First = Vector2.New(-32, -9.5),
    Second = Vector2.New(-32, -70)
}

--创建
function UITimelineJumpView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UITimelineJumpView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UITimelineJumpView:ComponentDefine()
    self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
    self.skip_btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.skip_btn_name = self:AddComponent(UITextMeshProUGUIEx, skip_btn_name_path)
end

function UITimelineJumpView:ComponentDestroy()
    self.skip_btn = nil
    self.skip_btn_name = nil
end

function UITimelineJumpView:DataDefine()
    self.param = {}
end

function UITimelineJumpView:DataDestroy()
    self.param = {}
end

function UITimelineJumpView:OnEnable()
    base.OnEnable(self)
end

function UITimelineJumpView:OnDisable()
    base.OnDisable(self)
end

function UITimelineJumpView:ReInit()
    self.param = self:GetUserData()
    self.skip_btn_name:SetLocalText(GameDialogDefine.SKIP)

    local posType = PosType.First
    local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if luaWindow ~= nil and luaWindow.View ~= nil then
        local animName = luaWindow.View:GetCurAnimName()
        if animName == UIMainAnimType.LeftRightBottomHide or animName == UIMainAnimType.AllShow or animName == UIMainAnimType.LeftRightBottomShow then
            local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.DiamondShop)
            if unlockBtnLockType == UnlockBtnLockType.Show then
                posType = PosType.Second
            end
        end
    end
    self.skip_btn:SetAnchoredPosition(posType)
end

function UITimelineJumpView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshTimelineJump, self.RefreshTimelineJumpSignal)
end

function UITimelineJumpView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshTimelineJump, self.RefreshTimelineJumpSignal)
end

function UITimelineJumpView:OnBtnClick()
    if self.param ~= nil then
        local gotoGuideId = self.param.gotoGuideId
        local timelineEnd = self.param.timelineEnd
        if gotoGuideId ~= nil then
            self.ctrl:CloseSelf()
            DataCenter.GuideManager:SetCurGuideId(gotoGuideId)
            if timelineEnd then
                EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
            end
            DataCenter.GuideManager:DoGuide()
        else
            if timelineEnd then
                EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
            end
        end
    end
end

function UITimelineJumpView:RefreshTimelineJumpSignal(param)
    self.param = param
end

return UITimelineJumpView