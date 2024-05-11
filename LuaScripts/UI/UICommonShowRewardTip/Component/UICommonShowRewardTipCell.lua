--- Created by shimin
--- DateTime: 2023/8/29 19:12
--- 点击未领取奖励箱子弹出道具列表界面cell

local UICommonShowRewardTipRewardCell = BaseClass("UICommonShowRewardTipRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local item_cell_path = "UICommonItem"
local name_text_path = "name_text"
local num_text_path = "num_text"

function UICommonShowRewardTipRewardCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UICommonShowRewardTipRewardCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonShowRewardTipRewardCell:OnEnable()
    base.OnEnable(self)
end

function UICommonShowRewardTipRewardCell:OnDisable()
    base.OnDisable(self)
end

function UICommonShowRewardTipRewardCell:ComponentDefine()
    self.item_cell = self:AddComponent(UICommonItem, item_cell_path)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.num_text = self:AddComponent(UIText, num_text_path)
    
end

function UICommonShowRewardTipRewardCell:ComponentDestroy()
end

function UICommonShowRewardTipRewardCell:DataDefine()
    self.param = {}
end

function UICommonShowRewardTipRewardCell:DataDestroy()
    self.param = {}
end

function UICommonShowRewardTipRewardCell:OnAddListener()
    base.OnAddListener(self)
end

function UICommonShowRewardTipRewardCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonShowRewardTipRewardCell:ReInit(param)
    self.param = param
    self.item_cell:ReInit(param)
    self.name_text:SetText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
    self.num_text:SetText("x" .. string.GetFormattedSeperatorNum(self.param.count))
end

return UICommonShowRewardTipRewardCell