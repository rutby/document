--UIDigRewardView.lua

local UIDigRewardView = BaseClass("UIDigRewardView", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local rewardSv_path = "ImgBg/svRewards"
local rewardContent_path = "ImgBg/svRewards/Viewport/Content"

--local rewardSr_path = ""
--local rewardSrContent_path = ""

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:InitUI()
end

-- 销毁
local function OnDestroy(self)
   -- self:ClearItemCell()
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(372442)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.rewardSvN = self:AddComponent(UIScrollView, rewardSv_path)
    self.rewardSvN:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.rewardSvN:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    --self.rewardContentN = self:AddComponent(UIScrollView, rewardContent_path)
    --local bindFunc1 = BindCallback(self, self.OnInitScroll)
    --local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    --local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    --self.rewardContentN:Init(bindFunc1,bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.rewardSvN = nil
    self.rewardContentN = nil
end


local function DataDefine(self)
    self.listGO = {}
end

local function DataDestroy(self)
    self.listGO = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end


local function InitUI(self)
    self:ClearScroll()
    self.activityId, self.level = self:GetUserData()
    self.rewardsList = DataCenter.DigActivityManager:GetPreviewRewardsList(self.activityId, self.level)
    self.rewardSvN:SetTotalCount(#self.rewardsList)
    self.rewardSvN:RefillCells()
end

--local function OnInitScroll(self,go,index)
--    local item = self.rewardSvN:AddComponent(UICommonItem, go)
--    self.listGO[go] = item
--end
--
--local function OnUpdateScroll(self,go,index)
--    go.name = tostring(index)
--    local cellItem = self.listGO[go]
--    if not cellItem then
--        return
--    end
--    local luaIndex = index + 1
--    local tempReward = {}
--    tempReward.rewardType = RewardType.GOODS
--    tempReward.itemId = self.rewardsList[luaIndex].itemId
--    tempReward.count = self.rewardsList[luaIndex].count
--    cellItem:ReInit(tempReward)
--end

--local function OnDestroyScrollItem(self,go, index)
--
--end

local function OnItemMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.rewardSvN:AddComponent(UICommonItem, itemObj)
    local tempReward = {}
    tempReward.rewardType = RewardType.GOODS
    tempReward.itemId = self.rewardsList[index].itemId
    tempReward.count = self.rewardsList[index].count
    cellItem:ReInit(tempReward)
    self.listGO[index] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
    self.rewardSvN:RemoveComponent(itemObj.name, UICommonItem)
    self.listGO[index] = nil
end

local function ClearScroll(self)
    self.listGO = {}
    self.rewardSvN:ClearCells()
    self.rewardSvN:RemoveComponents(UICommonItem)
end

--local function ClearItemCell(self)
--    self.rewardSvN:RemoveComponents(UICommonItem)
--    self.rewardContentN:DestroyChildNode()
--end


local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UIDigRewardView.OnCreate = OnCreate
UIDigRewardView.OnDestroy = OnDestroy
UIDigRewardView.ComponentDefine = ComponentDefine
UIDigRewardView.ComponentDestroy = ComponentDestroy
UIDigRewardView.DataDefine = DataDefine
UIDigRewardView.DataDestroy = DataDestroy
UIDigRewardView.OnAddListener = OnAddListener
UIDigRewardView.OnRemoveListener = OnRemoveListener

UIDigRewardView.InitUI = InitUI
--UIDigRewardView.OnInitScroll = OnInitScroll
--UIDigRewardView.OnUpdateScroll = OnUpdateScroll
--UIDigRewardView.OnDestroyScrollItem = OnDestroyScrollItem
--UIDigRewardView.ClearItemCell = ClearItemCell
UIDigRewardView.OnClickCloseBtn = OnClickCloseBtn

UIDigRewardView.OnItemMoveIn = OnItemMoveIn
UIDigRewardView.OnItemMoveOut = OnItemMoveOut
UIDigRewardView.ClearScroll = ClearScroll

return UIDigRewardView