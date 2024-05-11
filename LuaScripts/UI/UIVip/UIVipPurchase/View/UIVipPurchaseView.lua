---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local CellPointGood = require "UI.UIVip.UIVipPurchase.Component.CellPointGood"
local UIVipPurchaseView = BaseClass("UIVipPurchaseView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIVipPurchaseView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIVipPurchaseView:ComponentDefine()
    
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx,"UICommonPopUpTitle/bg_mid/titleText")
    
    self._close_btn = self:AddComponent(UIButton,"UICommonPopUpTitle/bg_mid/CloseBtn")
    self._close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
    self._more_btn = self:AddComponent(UIBaseContainer,"MoreBtn")
    self._more_btn:SetActive(false)

    self._progress_slider = self:AddComponent(UISlider,"Bg/SliderGo/Slider")
    self._percent_txt = self:AddComponent(UITextMeshProUGUIEx,"Bg/SliderGo/Slider/slider_text")
            
    self._level_txt = self:AddComponent(UITextMeshProUGUIEx,"Bg/SliderGo/Txt_Level")
    
    self.scroll_view = self:AddComponent(UIScrollView,"Bg/ScrollView")
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    --self.jump_txt_ = self:AddComponent(UITextMeshProUGUIEx,jump_txt_path)
    --self.jump_txt_:SetLocalText(300645) 
end

function UIVipPurchaseView:DataDefine()
    self.vipInfo = {}
    self.viptemplate = {}
    self.listGo = {}
    self.curIndex = 0
end

function UIVipPurchaseView:OnDestroy()
    self.title_txt = nil
    self._close_btn = nil
    self._progress_slider = nil
    self._percent_txt = nil
    self._level_txt = nil
    self:ClearScroll()
    self.scroll_view = nil
    self._more_btn = nil
    self.curIndex = nil
    self.listGo = nil
    base.OnDestroy(self)
end

function UIVipPurchaseView:OnEnable()
    base.OnEnable(self)
end

function UIVipPurchaseView:OnDisable()
    base.OnDisable(self)
end

function UIVipPurchaseView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.VipDataRefresh, self.Refresh)
end

function UIVipPurchaseView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.VipDataRefresh,self.Refresh)
end

function UIVipPurchaseView:Refresh(vipWindowType)
    self.ctrl:ShowOpenLvUp(vipWindowType)
    self.vipInfo = DataCenter.VIPManager:GetVipData()
    self:SetValue()
    --使用道具存在时更新使用道具
    if self.curIndex ~= 0 then
        self.listGo[self.curIndex]:UpdateNum(self.list[self.curIndex])
    end
end

function UIVipPurchaseView:ReInit()
    self.title_txt:SetLocalText(320266) 
    self.vipInfo = DataCenter.VIPManager:GetVipData()
    self:SetValue()
    self:RefreshData()
end

function UIVipPurchaseView:SetValue()
    local nextVipInfo = DataCenter.VIPManager:GetNextVipData()
    self._percent_txt:SetText(string.GetFormattedSeperatorNum(self.vipInfo.score).."/"..string.GetFormattedSeperatorNum(nextVipInfo.point))
    self._progress_slider:SetValue(self.vipInfo.score / nextVipInfo.point)
    self._level_txt:SetText(self.vipInfo.level)
end

function UIVipPurchaseView:RefreshData()
    self:ClearScroll()
    self.list = DataCenter.VIPManager:GetPointGoodList()
    if self.list~=nil then
        self.scroll_view:SetTotalCount(#self.list)
        self.scroll_view:RefillCells()
    end
end

function UIVipPurchaseView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(CellPointGood, itemObj)
    local callBack = function(tempIndex) self:OnClickCallBack(tempIndex) end
    self.listGo[index] = cellItem
    cellItem:RefreshData(self.list[index],callBack,index)
end

function UIVipPurchaseView:OnClickCallBack(index)
    self.curIndex = index
end

function UIVipPurchaseView:OnItemMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, CellPointGood)
end

function UIVipPurchaseView:ClearScroll()
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(CellPointGood)
end

return UIVipPurchaseView