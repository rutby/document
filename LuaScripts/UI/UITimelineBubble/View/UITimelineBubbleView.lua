--- Created by shimin.
--- DateTime: 2024/1/24 17:38
--- timeline气泡界面

local UITimelineBubbleView = BaseClass("UITimelineBubbleView", UIBaseView)
local base = UIBaseView
local UIBubbleBuildCell = require "UI.UIBubble.Component.UIBubbleBuildCell"

local bubble_cell_path = "root/UIBubbleBuildCell"

--创建
function UITimelineBubbleView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UITimelineBubbleView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UITimelineBubbleView:ComponentDefine()
    self.bubble_cell = self:AddComponent(UIBubbleBuildCell, bubble_cell_path)
end

function UITimelineBubbleView:ComponentDestroy()
end

function UITimelineBubbleView:DataDefine()
end

function UITimelineBubbleView:DataDestroy()
 
end

function UITimelineBubbleView:OnEnable()
    base.OnEnable(self)
end

function UITimelineBubbleView:OnDisable()
    base.OnDisable(self)
end

function UITimelineBubbleView:OnAddListener()
    base.OnAddListener(self)
end


function UITimelineBubbleView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UITimelineBubbleView:ReInit()
    self.param = self:GetUserData()
    self.bubble_cell:ReInit(self.param)
end

return UITimelineBubbleView