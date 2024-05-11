---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/23 15:32
---

local UIScratchOffRecordPageView = BaseClass("UIScratchOffRecordPageView", UIBaseView)
local base = UIBaseView
local ScratchOffRecordItem = require "UI.UIScratchOffRecordPage.Comp.ScratchOffRecordItem"

local titleTxt_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local playerNameTxt_path = "Root/RankDes/rankNameTxt"
local lotteryTxt_path = "Root/RankDes/rankScoreTxt"
local luckyTxt_path = "Root/RankDes/rankRewardTxt"
local noRecordTxt_path = "Root/noRecordTxt"

local scrollView_Path = "Root/ScrollView"

function UIScratchOffRecordPageView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIScratchOffRecordPageView : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIScratchOffRecordPageView : OnEnable()
    base.OnEnable(self)
    self.activityId = tonumber(self:GetUserData())
    SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameRewardRecord, self.activityId)
end

function UIScratchOffRecordPageView : DataDefine()
    self.itemInfoList = {}
end

function UIScratchOffRecordPageView : DataDestroy()
    self.itemInfoList = nil
end

function UIScratchOffRecordPageView : ComponentDefine()
    self.titleTxt = self:AddComponent(UIText, titleTxt_path)
    self.titleTxt:SetLocalText(372925)
    self.playerNameTxt = self:AddComponent(UIText, playerNameTxt_path)
    self.playerNameTxt:SetLocalText(302129)
    self.lotteryTxt = self:AddComponent(UIText, lotteryTxt_path)
    self.lotteryTxt:SetLocalText(372976)
    self.luckyTxt = self:AddComponent(UIText, luckyTxt_path)
    self.luckyTxt:SetLocalText(372927)
    self.noRecordTxt = self:AddComponent(UIText, noRecordTxt_path)
    self.noRecordTxt:SetLocalText(302233)
    
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
    self.ScrollView = self:AddComponent(UIScrollView, scrollView_Path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)
end

function UIScratchOffRecordPageView : ComponentDestroy()
    
end

function UIScratchOffRecordPageView : OnRankItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.ScrollView:AddComponent(ScratchOffRecordItem, itemObj)
    item:SetData(self.itemInfoList[index])
end

function UIScratchOffRecordPageView : OnRankItemMoveOut(itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, ScratchOffRecordItem)
end

function UIScratchOffRecordPageView : RefreshView()
    self.itemInfoList = self.ctrl:GetItemInfoList(self.activityId)
    
    if self.itemInfoList and #self.itemInfoList > 0 then
        self.ScrollView:SetTotalCount(#self.itemInfoList)
        self.ScrollView:RefillCells()
        self.ScrollView:ScrollToCell(1)
		self.noRecordTxt:SetActive(false)
	else
		self.noRecordTxt:SetActive(true)
    end
end

function UIScratchOffRecordPageView : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ScratchOffGameRewardRecordInfoUpdate, self.RefreshView)
end

function UIScratchOffRecordPageView : OnRemoveListener()
    self:RemoveUIListener(EventId.ScratchOffGameRewardRecordInfoUpdate, self.RefreshView)
    base.OnRemoveListener(self)
end

return UIScratchOffRecordPageView