---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---

local base = UIBaseView--Variable
local UIAlMemberRecommendView = BaseClass("UIAlMemberRecommendView", base)--Variable
local UIAlMemberRecommendItem = require "UI.UIAlliance.UIAlMemberRecommend.Component.UIAlMemberRecommendItem"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local recommendTip_path = "ImgBg/TxtContect"
local svRecommends_path = "ImgBg/ScrollView"
local btnClose_path = "UICommonPopUpTitle/bg_mid/CloseBtn"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshAll()
end

local function OnDestroy(self)
    local param = {}
    param.recommendUserSize = 0
    DataCenter.AllianceMemberDataManager:UpdateAlMemberRecommendNum(param)
    
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(141087)
    self.recommendTipN = self:AddComponent(UIText, recommendTip_path)
    self.recommendTipN:SetLocalText(141088)
    self.svRecommendsN = self:AddComponent(UIScrollView, svRecommends_path)
    self.svRecommendsN:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.svRecommendsN:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.btnCloseN = self:AddComponent(UIButton, btnClose_path)
    self.btnCloseN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.AlLeaderCandidateUpdate, self.RefreshUI)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.AlLeaderCandidateUpdate, self.RefreshUI)
end


local function RefreshAll(self)
    self.recommendList = DataCenter.AllianceMemberDataManager:GetRecommendMemberList()
    if self.recommendList then
        self.svRecommendsN:SetTotalCount(#self.recommendList)
        self.svRecommendsN:RefillCells()
    end
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.svRecommendsN:AddComponent(UIAlMemberRecommendItem, itemObj)
    cellItem:SetItem(self.recommendList[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.svRecommendsN:RemoveComponent(itemObj.name, UIAlMemberRecommendItem)
end

local function ClearScroll(self)
    self.svRecommendsN:ClearCells()
    self.svRecommendsN:RemoveComponents(UIAlMemberRecommendItem)
end

UIAlMemberRecommendView.OnCreate = OnCreate
UIAlMemberRecommendView.OnDestroy = OnDestroy
UIAlMemberRecommendView.OnAddListener = OnAddListener
UIAlMemberRecommendView.OnRemoveListener = OnRemoveListener
UIAlMemberRecommendView.ComponentDefine = ComponentDefine
UIAlMemberRecommendView.ComponentDestroy = ComponentDestroy
UIAlMemberRecommendView.DataDefine = DataDefine
UIAlMemberRecommendView.DataDestroy = DataDestroy

UIAlMemberRecommendView.RefreshAll = RefreshAll
UIAlMemberRecommendView.OnItemMoveIn = OnItemMoveIn
UIAlMemberRecommendView.OnItemMoveOut = OnItemMoveOut
UIAlMemberRecommendView.ClearScroll = ClearScroll

return UIAlMemberRecommendView