--- Created by shimin
--- DateTime: 2023/7/20 18:52
--- 英雄代币商店界面

local UIHeroMetalRedemptionShop = BaseClass("UIHeroMetalRedemptionShop", UIBaseContainer)
local base = UIBaseContainer
local UIHeroMetalRedemptionShopCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionShopCell"
local CommonGoodsShopItem = require "UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem"

local scroll_view_path = "CellList"
local des_text_path = "DescText"


function UIHeroMetalRedemptionShop:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionShop:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionShop:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionShop:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionShop:ComponentDefine()
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIHeroMetalRedemptionShop:ComponentDestroy()

end

function UIHeroMetalRedemptionShop:DataDefine()
    self.param = {}
    self.list = {}
    self.refreshCdTimerCallback = function()
        self:RefreshCdTimerCallback()
    end
    self.endTime = 0
end

function UIHeroMetalRedemptionShop:DataDestroy()
    self:DelRefreshCdTimer()
    self.param = {}
    self.list = {}
    self.endTime = 0
end

function UIHeroMetalRedemptionShop:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionShop:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionShop:ReInit(param)
    self.param = param
    self.endTime = 0
    self:Refresh()
end

function UIHeroMetalRedemptionShop:Refresh()
    if self.param.select then
        self:SetActive(true)
        self.endTime = DataCenter.CommonShopManager:GetRefreshTime(CommonShopType.HeroMetalRedemption)
        self:RefreshCdTimerCallback()
        self:ShowCells()
        self:AddRefreshCdTimer()
    else
        self:DelRefreshCdTimer()
        self:SetActive(false)
    end
end

function UIHeroMetalRedemptionShop:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIHeroMetalRedemptionShop:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(CommonGoodsShopItem)--清循环列表gameObject
end

function UIHeroMetalRedemptionShop:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(CommonGoodsShopItem, itemObj)
    item:SetItem(self.list[index])
    --item:ReInit(self.list[index])
end

function UIHeroMetalRedemptionShop:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, CommonGoodsShopItem)
end

function UIHeroMetalRedemptionShop:GetDataList()
    self.list = {}
    self.list = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HeroMetalRedemption)
end

function UIHeroMetalRedemptionShop:Select(tabType, select)
    if self.param.select ~= select then
        self.param.select = select
        self:Refresh()
    end
end

function UIHeroMetalRedemptionShop:AddRefreshCdTimer()
    if self.refreshCdTimer == nil then
        self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.refreshCdTimerCallback ,self, false, false, false)
    end
    self.refreshCdTimer:Start()
end

function UIHeroMetalRedemptionShop:RefreshCdTimerCallback()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = math.ceil(self.endTime - curTime)
    if remainTime > 0 then
        self.des_text:SetLocalText(GameDialogDefine.REFRESH_LEFT_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.des_text:SetText("")
        self:DelRefreshCdTimer()
        SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.HeroMetalRedemption)
    end
end

function UIHeroMetalRedemptionShop:DelRefreshCdTimer()
    if self.refreshCdTimer ~= nil then
        self.refreshCdTimer:Stop()
        self.refreshCdTimer = nil
    end
end

return UIHeroMetalRedemptionShop