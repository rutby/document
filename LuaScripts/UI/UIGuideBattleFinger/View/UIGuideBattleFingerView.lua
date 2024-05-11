--- Created by shimin
--- DateTime: 2024/03/28 20:07
--- 战斗开始引导手左右滑动提示

local UIPreviewStormView = BaseClass("UIPreviewStormView", UIBaseView)
local base = UIBaseView

local des_text_path = "Anim/des_text"

function UIPreviewStormView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIPreviewStormView:ComponentDefine()
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function UIPreviewStormView:ComponentDestroy()
end

function UIPreviewStormView:DataDefine()
end

function UIPreviewStormView:DataDestroy()
end

function UIPreviewStormView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPreviewStormView:OnEnable()
    base.OnEnable(self)
end

function UIPreviewStormView:OnDisable()
    base.OnDisable(self)
end

function UIPreviewStormView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.PveGuideStartDrag, self.PveGuideStartDragSignal)
end

function UIPreviewStormView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.PveGuideStartDrag, self.PveGuideStartDragSignal)
end

function UIPreviewStormView:ReInit()
    self.des_text:SetLocalText(GameDialogDefine.HOLD_AND_DRAG)
end

function UIPreviewStormView:PveGuideStartDragSignal(param)
    DataCenter.LWBattleManager:SetGamePause(false)
    DataCenter.LWBattleManager:OnFingerDown(param.pos)
    self.ctrl:CloseSelf()
end


return UIPreviewStormView