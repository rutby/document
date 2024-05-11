--- Created by shimin.
--- DateTime: 2024/3/7 17:29
--- 引导红色警告

local UIGuideRedScreenEffectView = BaseClass("UIGuideRedScreenEffectView", UIBaseView)
local base = UIBaseView

function UIGuideRedScreenEffectView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIGuideRedScreenEffectView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideRedScreenEffectView:ComponentDefine()
end

function UIGuideRedScreenEffectView:ComponentDestroy()
end

function UIGuideRedScreenEffectView:DataDefine()
end

function UIGuideRedScreenEffectView:DataDestroy()
end

function UIGuideRedScreenEffectView:OnEnable()
    base.OnEnable(self)
end

function UIGuideRedScreenEffectView:OnDisable()
    base.OnDisable(self)
end

function UIGuideRedScreenEffectView:OnAddListener()
    base.OnAddListener(self)
end

function UIGuideRedScreenEffectView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGuideRedScreenEffectView:ReInit()
  
end

return UIGuideRedScreenEffectView