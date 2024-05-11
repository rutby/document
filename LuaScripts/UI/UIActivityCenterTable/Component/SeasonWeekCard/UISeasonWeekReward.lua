
local UISeasonWeekReward = BaseClass("UISeasonWeekReward", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

-- 创建
function UISeasonWeekReward : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UISeasonWeekReward : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UISeasonWeekReward : DataDefine()

end

function UISeasonWeekReward : DataDestroy()

end

function UISeasonWeekReward : ComponentDefine()
    self.item1 = self:AddComponent(UICommonItem, "UICommonItem")
end

function UISeasonWeekReward : ComponentDestroy()

end

function UISeasonWeekReward : ReInit(data)
    self.item1:ReInit(data)
end


return UISeasonWeekReward