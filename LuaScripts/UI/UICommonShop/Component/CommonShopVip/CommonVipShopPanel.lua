---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/19 17:20
---


local base = UIBaseContainer--Variable
local CommonVipShopPanel = BaseClass("CommonVipShopPanel", base)--Variable
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require "UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem"

local content_path = "Anim/ScrollView/Content"
local anim_path = "Anim"
local refreshTip_path = "Anim/Top/refreshTip"
local refreshCd_path = "Anim/Top/refreshCd"
local vipTip_path = "Anim/Top/vipLevel"
local vipBtn_path = "Anim/Top/infoBtn"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelRefreshCdTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.contentN = nil
    self.animN = self:AddComponent(UIAnimator, anim_path)
    self.refreshTipN = self:AddComponent(UITextMeshProUGUIEx, refreshTip_path)
    self.refreshCdN = self:AddComponent(UITextMeshProUGUIEx, refreshCd_path)
    self.vipTipN = self:AddComponent(UITextMeshProUGUIEx, vipTip_path)
    self.vipBtnN = self:AddComponent(UIButton, vipBtn_path)
    self.vipBtnN:SetOnClick(function()
        self:OnClickVipBtn()
    end)
end

local function ComponentDestroy(self)
    self:ClearItemCell()
    self.animN = nil
    self.refreshTipN = nil
    self.refreshCdN = nil
    self.vipTipN = nil
    self.vipBtnN = nil
end

local function DataDefine(self)
    self.curShowType = nil
    self.goodsList = {}
    self.goodsItemsList = {}
    self.model = {}
    self.listGO = {}
    self.next_timer_callback = function()
        self:NextFrameTimeCallback()
    end
end

local function DataDestroy(self)
    self:DeleteNextFrameTimer()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
    self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
    self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
    base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType)
    self.curShowType = shopType
    self.refreshTipN:SetLocalText(GameDialogDefine.NEXT_REFRESH_TIME)
    self:RefreshAll()
end

local function RefreshAll(self, shopType)
    if shopType and shopType ~= self.curShowType then
        return
    end
    
    local vipInfo = DataCenter.VIPManager:GetVipData()
    self.vipTipN:SetLocalText("104211", vipInfo.level)

    local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
    self.refreshCdEndT = nextWeek
    self:AddRefreshCdTimer()
    self:SetRefreshCd()
    self:ShowCells()
end

local function OnInitScroll(self,go,index)
    local item = self:AddComponent(CommonGoodsShopItem, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    local conf = self.goodsList[index + 1]
    go.name = conf.id
    local cellItem = self.listGO[go]
    if not cellItem then
        return
    end
    cellItem:SetItem(self.goodsList[index + 1])
end

local function OnDestroyScrollItem(self,go, index)

end

local function ClearItemCell(self)
    if self.contentN ~= nil then
        self:RemoveComponents(CommonGoodsShopItem)
        self.contentN:DestroyChildNode()
    end
end

local function AddRefreshCdTimer(self)
    self.RefreshCdTimerAction = function()
        self:SetRefreshCd()
    end

    if self.refreshCdTimer == nil then
        self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction , self, false,false,false)
    end
    self.refreshCdTimer:Start()
end

local function SetRefreshCd(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = math.ceil(self.refreshCdEndT - curTime)
    if remainTime > 0 then
        self.refreshCdN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.refreshCdN:SetText("")
        self:DelRefreshCdTimer()
        SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, self.curShowType)
    end
end

local function DelRefreshCdTimer(self)
    if self.refreshCdTimer ~= nil then
        self.refreshCdTimer:Stop()
        self.refreshCdTimer = nil
    end
end

local function OnClickVipBtn(self)
    local k3 = LuaEntry.DataConfig:TryGetNum("vip_aps", "k3")
    if k3 <= DataCenter.BuildManager.MainLv then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip,{ anim = true, hideTop = true})
    else
        UIUtil.ShowTips(Localization:GetString("320269",k3))
    end
end

function CommonVipShopPanel:ShowCells()
    if self.contentN == nil then
        self:AddNextFrameTimer()
    else
        self:RefreshCells()
    end
end

function CommonVipShopPanel:RefreshCells()
    self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
    self.contentN:SetItemCount(#self.goodsList)
end

function CommonVipShopPanel:AddNextFrameTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(NextFrameTime, self.next_timer_callback,self, true, false, false)
    end
    self.timer:Start()
end

function CommonVipShopPanel:DeleteNextFrameTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function CommonVipShopPanel:NextFrameTimeCallback()
    self:DeleteNextFrameTimer()
    self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
    self:RefreshCells()
end


CommonVipShopPanel.OnCreate = OnCreate
CommonVipShopPanel.OnDestroy = OnDestroy
CommonVipShopPanel.OnAddListener = OnAddListener
CommonVipShopPanel.OnRemoveListener = OnRemoveListener
CommonVipShopPanel.ComponentDefine = ComponentDefine
CommonVipShopPanel.ComponentDestroy = ComponentDestroy
CommonVipShopPanel.DataDefine = DataDefine
CommonVipShopPanel.DataDestroy = DataDestroy

CommonVipShopPanel.ShowPanel = ShowPanel
CommonVipShopPanel.RefreshAll = RefreshAll
CommonVipShopPanel.OnInitScroll = OnInitScroll
CommonVipShopPanel.OnUpdateScroll = OnUpdateScroll
CommonVipShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonVipShopPanel.ClearItemCell = ClearItemCell
CommonVipShopPanel.OnClickVipBtn = OnClickVipBtn
CommonVipShopPanel.AddRefreshCdTimer = AddRefreshCdTimer
CommonVipShopPanel.SetRefreshCd = SetRefreshCd
CommonVipShopPanel.DelRefreshCdTimer = DelRefreshCdTimer

return CommonVipShopPanel