--- 黑骑士奖励cell
--- Created by shimin.
--- DateTime: 2024/2/23 18:25
---
local UIBlackKnightRewardCell = BaseClass("UIBlackKnightRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local rank_img_path = "mainContent/rankImg"
local rank_text_path = "mainContent/rankNumTxt"
local reward_scroll_view_path = "mainContent/reward_scroll_view"
local rank_bg_path = "Common_supple"

local SelectColor =
{
    No = Color.New(0.9098039, 0.8784314, 0.8196079, 1),
    Select = Color.New(0.9411765, 0.8000001, 0.5294118, 1),
}

function UIBlackKnightRewardCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIBlackKnightRewardCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightRewardCell:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightRewardCell:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightRewardCell:ComponentDefine()
    self.rank_num_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.rank_bg = self:AddComponent(UIImage, rank_bg_path)
end

function UIBlackKnightRewardCell:ComponentDestroy()

end

function UIBlackKnightRewardCell:DataDefine()
    self.param = {}
    self.list = {}
end

function UIBlackKnightRewardCell:DataDestroy()
    self.param = {}
    self.list = {}
end

function UIBlackKnightRewardCell:OnAddListener()
    base.OnAddListener(self)
end

function UIBlackKnightRewardCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIBlackKnightRewardCell:ReInit(param)
    self.param = param
    local iconName, showName = CommonUtil.GetRankImgAndShowText(self.param.rank + 1)
    if iconName ~= nil then
        self.rank_img:SetActive(true)
        self.rank_num_text:SetActive(false)
        self.rank_img:LoadSprite(iconName)
    else
        self.rank_img:SetActive(false)
        self.rank_num_text:SetActive(true)
        self.rank_num_text:SetText(showName)
    end
    if self.param.select then
        self.rank_bg:SetColor(SelectColor.Select)
    else
        self.rank_bg:SetColor(SelectColor.No)
    end
    self:ShowCells()
end

function UIBlackKnightRewardCell:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIBlackKnightRewardCell:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIBlackKnightRewardCell:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItem, itemObj)
    item:ReInit(self.list[index])
end

function UIBlackKnightRewardCell:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIBlackKnightRewardCell:GetDataList()
    self.list = self.param.reward
end


return UIBlackKnightRewardCell