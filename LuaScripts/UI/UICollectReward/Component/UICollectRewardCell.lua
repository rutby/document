
local UICollectRewardCell = BaseClass("UICollectRewardCell", UIBaseContainer)
local base = UIBaseContainer
local CollectResItem = require "UI.UICollectReward.Component.CollectResItem"

-- 创建
function UICollectRewardCell : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UICollectRewardCell : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICollectRewardCell : DataDefine()

end

function UICollectRewardCell : DataDestroy()

end

function UICollectRewardCell : ComponentDefine()
    self.item1 = self:AddComponent(CollectResItem, "UICommonItem")
end

function UICollectRewardCell : ComponentDestroy()

end

function UICollectRewardCell : ReInit(data)
    self.item1:ReInit(data)
end


return UICollectRewardCell