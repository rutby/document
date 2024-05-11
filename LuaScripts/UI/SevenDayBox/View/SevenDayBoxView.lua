---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
--- 
local SevenDayBoxView = BaseClass("SevenDayBoxView", UIBaseView)
local base = UIBaseView
local SevenDayBoxItem = require "UI.SevenDayBox.Component.SevenDayBoxItem"
function SevenDayBoxView:OnCreate()
    base.OnCreate(self)
    
    self._title_txt = self:AddComponent(UITextMeshProUGUIEx,"UICommonPopUpTitle/bg_mid/titleText")
    self._title_txt:SetLocalText(321322)
    
    self._close_btn = self:AddComponent(UIButton,"UICommonPopUpTitle/bg_mid/CloseBtn")
    self._close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.panelClose = self:AddComponent(UIButton,"UICommonPopUpTitle/panel")
    self.panelClose:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self._tips_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/Txt_Tips")
    self._tips_txt:SetLocalText(321324)
    self._normalReward_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/Rect_Des/Txt_NormalReward")
    self._normalReward_txt:SetLocalText(321322)
    self._vipReward_txt = self:AddComponent(UITextMeshProUGUIEx,"ImgBg/Rect_Des/Txt_VipReward")
    self._vipReward_txt:SetLocalText(321323)
    
    self.scroll_view = self:AddComponent(UIScrollView, "ImgBg/ScrollView")
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
end

function SevenDayBoxView:OnDestroy()
    self:ClearScroll()
    base.OnDestroy(self)
end

function SevenDayBoxView:OnEnable()
    base.OnEnable(self)
    self:OnRefresh()
end

function SevenDayBoxView:OnDisable()
    base.OnDisable(self)
end

function SevenDayBoxView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.SevenDayGetReward, self.RefreshReward)
    self:AddUIListener(EventId.VipDataRefresh, self.Refresh)
end

function SevenDayBoxView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.SevenDayGetReward, self.RefreshReward)
    self:RemoveUIListener(EventId.VipDataRefresh, self.Refresh)
end


function SevenDayBoxView:OnRefresh()
    self.sevenDayInfo =  DataCenter.ActivityListDataManager:GetSevenDayList()
    self.rewardList = self.sevenDayInfo.scoreReward
    self.cellList = {}
    if #self.rewardList > 0 then
        self.scroll_view:SetTotalCount(#self.rewardList)
        self.scroll_view:RefillCells()
    end
end

function SevenDayBoxView:RefreshReward(index)
    self.sevenDayInfo = DataCenter.ActivityListDataManager:GetSevenDayList()
    self.rewardList = self.sevenDayInfo.scoreReward
    if self.cellList[index] then
        self.cellList[index]:ReInit(self.rewardList[index],self.sevenDayInfo.score,index)
    end
end

function SevenDayBoxView:Refresh()
    for i = 1, table.count(self.cellList) do
        self.cellList[i]:ReInit(self.rewardList[i],self.sevenDayInfo.score,i)
    end
end

function SevenDayBoxView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(SevenDayBoxItem, itemObj)
    cellItem:ReInit(self.rewardList[index],self.sevenDayInfo.score,index)
    self.cellList[index] = cellItem
end

function SevenDayBoxView:OnItemMoveOut( itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, SevenDayBoxItem)
    self.cellList[index] = nil
end

function SevenDayBoxView:ClearScroll()
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(SevenDayBoxItem)
end

return SevenDayBoxView