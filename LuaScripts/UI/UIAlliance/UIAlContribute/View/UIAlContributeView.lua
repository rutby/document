---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---

local base = UIBaseView--Variable
local UIAlContributeView = BaseClass("UIAlContributeView", base)--Variable
local AlContributeBoxItem = require "UI.UIAlliance.UIAlContribute.Component.AlContributeBoxItem"
local AlContributeItem = require "UI.UIAlliance.UIAlContribute.Component.AlContributeItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"

local CONTRIBUTE_PACKAGE_ID = "9100"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local packageIcon_path = "ImgBg/package/packageImg"
local packageName_path = "ImgBg/package/packageName"
local packageDesc_path = "ImgBg/package/packageDesc"
local boughtTxt_path = "ImgBg/package/bought"
local buyBtn_path = "ImgBg/package/buyBtn"
local buyBtnTxt_path = "ImgBg/package/buyBtn/buyBtnTxt"
local score_path = "ImgBg/score/score/scoreNum"
local scoreTip_path = "ImgBg/score/score/weekScore"
local scrollRect_path = "ImgBg/ScrollView"
local content_path = "ImgBg/ScrollView/Content"
local remainTime_path = "ImgBg/package/bought/remainTime"
local packagePoint_path = "ImgBg/package/buyBtn/UIGiftPackagePoint"
local scoreScrollView_path = "ImgBg/score/ScoreScrollView"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitData()
end

local function OnDestroy(self)
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(320413)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.packageIconN = self:AddComponent(UIImage, packageIcon_path)
    self.packageNameN = self:AddComponent(UIText, packageName_path)
    self.packageDescN = self:AddComponent(UIText, packageDesc_path)
    self.boughtTxtN = self:AddComponent(UIText, boughtTxt_path)
    self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
    self.buyBtnN:SetOnClick(function()
        self:OnClickBuyBtn()
    end)
    self.buyBtnTxtN = self:AddComponent(UIText, buyBtnTxt_path)
    self.scoreN = self:AddComponent(UIText, score_path)
    self.scoreTipN = self:AddComponent(UIText, scoreTip_path)
    self.scoreTipN:SetLocalText(372754)
    self.remainTimeN = self:AddComponent(UIText, remainTime_path)
    self.listGO = {}
    self.scrollRectN = self:AddComponent(UIScrollRect, scrollRect_path)
    self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1,bindFunc2, bindFunc3)
    self.packagePointN = self:AddComponent(UIGiftPackagePoint, packagePoint_path)
    self.scoreScrollView = self:AddComponent(UIScrollView, scoreScrollView_path)
    self.scoreScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnScoreItemMoveIn(itemObj, index)
    end)
    self.scoreScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnScoreItemMoveOut(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.packageIconN = nil
    self.packageNameN = nil
    self.packageDescN = nil
    self.boughtTxtN = nil
    self.buyBtnN = nil
    self.buyBtnTxtN = nil
    self.scoreN = nil
    self.scoreTipN = nil
    self.remainTimeN = nil
    self.listGO = nil
    self.scrollRectN = nil
    self.contentN = nil
    self.packagePointN = nil
end

local function DataDefine(self)
    self.activityId = nil
    self.packageInfo = nil
    self.scoreItemInfoList = nil
end

local function DataDestroy(self)
    self.activityId = nil
    self.packageInfo = nil
    self.scoreItemInfoList = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnAlContributeBoxStatusChange, self.RefreshAll)
    self:AddUIListener(EventId.OnAlContributeEventInfoUpdate, self.RefreshAll)
    self:AddUIListener(EventId.OnExploitMonthCardInfoUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnAlContributeBoxStatusChange, self.RefreshAll)
    self:RemoveUIListener(EventId.OnAlContributeEventInfoUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.OnExploitMonthCardInfoUpdate, self.RefreshAll)
end


local function InitData(self)
    self.activityId = self:GetUserData()
    if not self.activityId then
        return
    end

    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if actInfo then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet,tostring(actInfo.activityId))
    end
    
    self:RefreshAll()
end

local function RefreshAll(self)
    if IsNull(self.gameObject) then
        return
    end
    
    if not self.activityId then
        return
    end
    
    self:RefreshPackage()
    self:RefreshRewards()
    self:RefreshContributeItems()
end

local function RefreshPackage(self)
    self.packageNameN:SetLocalText("372752")
    self.packageDescN:SetLocalText("372753")
    
    self.packageInfo = GiftPackManager.get(CONTRIBUTE_PACKAGE_ID)
    
    local monthCardInfo = self.ctrl:GetMonthCardInfo()
    if monthCardInfo then
        self.boughtTxtN:SetActive(true)
        self.boughtTxtN:SetLocalText(280124)
        self.buyBtnN:SetActive(false)
        self.remainTimeN:SetActive(true)
        self.endTime = monthCardInfo.endTime
        self:AddCountDownTimer()
    else
        self.boughtTxtN:SetActive(false)
        if self.packageInfo == nil then
            self.buyBtnN:SetActive(false)
        else
            self.buyBtnN:SetActive(true)
            local strPrice = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
            self.buyBtnTxtN:SetText(strPrice)
        end
    end

    self.packagePointN:RefreshPoint(self.packageInfo)
end

local function RefreshRewards(self)
    local tempScore = self.ctrl:GetCurScore(self.activityId)
    self.scoreN:SetText(string.GetFormattedSeperatorNum(tempScore))
    self:RefreshScoreScroll()
end

local function RefreshContributeItems(self)
    self.contributeList = self.ctrl:GetContributeList(self.activityId)
    self.contentN:SetItemCount(#self.contributeList)
end

local function OnInitScroll(self,go,index)
    local item = self.scrollRectN:AddComponent(AlContributeItem, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    go.name = index + 1
    local cellItem = self.listGO[go]
    if not cellItem then
        return
    end
    local contribute = self.contributeList[index + 1]
    cellItem:SetItem(contribute)
end

local function OnDestroyScrollItem(self,go, index)
    
end

local function ClearItemCell(self)
    self.scrollRectN:RemoveComponents(AlContributeItem)
    self.contentN:DestroyChildNode()
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickBuyBtn(self)
    DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIAlContribute)
end


local function AddCountDownTimer(self)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if remainTime >= 0 then
        self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self:DelCountDownTimer()
        self.boughtTxtN:SetLocalText(390843)
        self.remainTimeN:SetActive(false)
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnScoreItemMoveIn(self, itemObj, index)
    if self.scoreItemInfoList and #self.scoreItemInfoList then
        itemObj.name = tostring(index)
        local item = self.scoreScrollView:AddComponent(AlContributeBoxItem, itemObj)
        item:SetItem(index, self.scoreItemInfoList[index])
    end
end

local function OnScoreItemMoveOut(self,itemObj, index)
    self.scoreScrollView:RemoveComponent(itemObj.name, AlContributeBoxItem)
end

local function ClearScoreScroll(self)
    self.scoreScrollView:ClearCells()
    self.scoreScrollView:RemoveComponents(AlContributeBoxItem)
end

local function RefreshScoreScroll(self)
    self:ClearScoreScroll()
    self.scoreItemInfoList = self.ctrl:GetScoreItemInfoList(self.activityId)
    if self.scoreItemInfoList and #self.scoreItemInfoList then
		local count = #self.scoreItemInfoList
        self.scoreScrollView:SetTotalCount(count)
        self.scoreScrollView:RefillCells()
        --todo
        for i, v in ipairs(self.scoreItemInfoList) do
            local info = self.scoreItemInfoList[i]
            if info.showBoxItem and info.state == 2 then
                self.scoreScrollView:ScrollToCell(i, 5000)
                break
            end
        end
    end
end

local function OnGetReward(self, index)
    self.scoreItemInfoList[index].state = 3
end

UIAlContributeView.OnCreate = OnCreate
UIAlContributeView.OnDestroy = OnDestroy
UIAlContributeView.OnAddListener = OnAddListener
UIAlContributeView.OnRemoveListener = OnRemoveListener
UIAlContributeView.ComponentDefine = ComponentDefine
UIAlContributeView.ComponentDestroy = ComponentDestroy
UIAlContributeView.DataDefine = DataDefine
UIAlContributeView.DataDestroy = DataDestroy

UIAlContributeView.InitData = InitData
UIAlContributeView.RefreshAll = RefreshAll
UIAlContributeView.RefreshPackage = RefreshPackage
UIAlContributeView.RefreshRewards = RefreshRewards
UIAlContributeView.RefreshContributeItems = RefreshContributeItems
UIAlContributeView.OnInitScroll = OnInitScroll
UIAlContributeView.OnUpdateScroll = OnUpdateScroll
UIAlContributeView.OnDestroyScrollItem = OnDestroyScrollItem
UIAlContributeView.ClearItemCell = ClearItemCell
UIAlContributeView.OnClickCloseBtn = OnClickCloseBtn
UIAlContributeView.OnClickBuyBtn = OnClickBuyBtn
UIAlContributeView.AddCountDownTimer = AddCountDownTimer
UIAlContributeView.RefreshRemainTime = RefreshRemainTime
UIAlContributeView.DelCountDownTimer = DelCountDownTimer
UIAlContributeView.OnScoreItemMoveIn = OnScoreItemMoveIn
UIAlContributeView.OnScoreItemMoveOut = OnScoreItemMoveOut
UIAlContributeView.ClearScoreScroll = ClearScoreScroll
UIAlContributeView.RefreshScoreScroll = RefreshScoreScroll
UIAlContributeView.OnGetReward = OnGetReward

return UIAlContributeView