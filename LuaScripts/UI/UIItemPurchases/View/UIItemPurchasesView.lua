--- Created by shimin.
--- DateTime: 2022/3/28 21:06
--- 购买道具界面
---

local UIItemPurchasesCell = require "UI.UIItemPurchases.Component.UIItemPurchasesCell"
local UIItemPurchases = BaseClass("UIItemPurchases",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local slider_go_path = "Bg/SliderGo"
local slider_path = "Bg/SliderGo/Common_bg1/Slider"
local slider_txt_path = "Bg/SliderGo/Common_bg1/Txt_Percent"
local slider_icon_bg_path = "Bg/SliderGo/Common_bg1/ItemBg"
local slider_icon_path = "Bg/SliderGo/Common_bg1/ItemBg/ItemIcon"
local slider_image_path = "Bg/SliderGo/Common_bg1/Slider/Fill Area/Fill"
local scroll_path = "Bg/ScrollView"
local bg_go_path = "Bg"
local packageCell_path = "Bg/AdvCell"
local packageNameTxt_path = "Bg/AdvCell/Common_bg1/NameText"
local packageImgB_path = "Bg/AdvCell/Common_bg1/packageIcon"
local resourceImgB_path = "Bg/AdvCell/Common_bg1/resourceIcon"
local packageDescTxt_path = "Bg/AdvCell/Common_bg1/DesTextBg/DesText"
local packageBuyBtn_path = "Bg/AdvCell/Common_bg1/BuyBtn"
local packageBuyBtnTxt_path = "Bg/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
local packageCloseBtn_path = "Bg/AdvCell/CloseBtnBg/PackageCloseBtn"
local packageJumpBtn_path = "Bg/AdvCell/Common_bg1/jumpBtn"
local point_path = "Bg/AdvCell/Common_bg1/BuyBtn/UIGiftPackagePoint"

local MaxFlyNum = 5

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.slider_icon_bg = self:AddComponent(UIImage, slider_icon_bg_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
    self.slider_txt = self:AddComponent(UIText, slider_txt_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_path)
    self.slider_go = self:AddComponent(UIBaseContainer, slider_go_path)
    self.slider_image = self:AddComponent(UIImage, slider_image_path)
    self.bg_go = self:AddComponent(UIBaseContainer, bg_go_path)
    
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.packageCell = self:AddComponent(UIBaseContainer, packageCell_path)
    self.packageNameTxt = self:AddComponent(UIText, packageNameTxt_path)
    self.packageImgB = self:AddComponent(UIImage, packageImgB_path)
    self.resourceImgB = self:AddComponent(UIImage,resourceImgB_path)
    self.packageDescTxt = self:AddComponent(UIText, packageDescTxt_path)
    self.packageBuyBtn = self:AddComponent(UIButton, packageBuyBtn_path)
    self.packageBuyBtn:SetOnClick(function()
        if self.packageInfo then
            self.ctrl:BuyGift(self.packageInfo)
        end
    end)
    self.packageBuyBtnTxt = self:AddComponent(UIText, packageBuyBtnTxt_path)
    self.packageCloseBtn = self:AddComponent(UIButton, packageCloseBtn_path)
    self.packageCloseBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.packageJumpBtn = self:AddComponent(UIButton, packageJumpBtn_path)
    self.packageJumpBtn:SetOnClick(function()
        self:OnClickJumpToPackBtn()
    end)
    self.point_rect = self:AddComponent(UIGiftPackagePoint,point_path)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.slider_icon_bg = nil
    self.close_btn = nil
    self.return_btn = nil
    self.slider = nil
    self.slider_icon = nil
    self.slider_txt = nil
    self.scroll_view = nil
    self.slider_go = nil
    self.slider_image = nil
    self.bg_go = nil
    self.point_rect = nil
end


local function DataDefine(self)
    self.param = nil
    self.cells = {}
    self.template = nil
    self.list = {}
end

local function DataDestroy(self)
    self.param = nil
    self.cells = nil
    self.template = nil
    self.list = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.param = self:GetUserData()
    self.list = {}
    if self.param ~= nil then
        self.slider_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.param.itemId))
        self.template = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        if self.template ~= nil then
            self.txt_title:SetText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
            self.slider_icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(self.template.color))
            if self.template.sales ~= nil and self.template.sales[1] ~= nil then
                for k, v in ipairs(self.template.sales) do
                    table.insert(self.list, {count = v[1],price = v[2]})
                end
            else
                if self.template.price > 0 then
                    table.insert(self.list,{count = 1,price = self.template.price})
                end
            end
        end
        if self.param.count == nil or self.param.count <= 0 then
            self.slider_go:SetActive(false)
        else
            self.slider_go:SetActive(true)
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.rectTransform)
    self:UpdateSlider()
    self:ShowCells()
    self:TryShowPackage()
end

local function UpdateSlider(self)
    if self.param.count ~= nil and self.param.count > 0 then
        local own =  0
        local item = DataCenter.ItemData:GetItemById(self.param.itemId)
        if item ~= nil then
            own = item.count
        end
        local percent = own / self.param.count
        if percent >= 1 then
            self.slider_image:LoadSprite(SliderMaxImage)
        else
            self.slider_image:LoadSprite(SliderNormalImage)
        end
        self.slider:SetValue(percent)
        self.slider_txt:SetText(string.GetFormattedSeperatorNum(own) .."/"..string.GetFormattedSeperatorNum(self.param.count))
    end
end

local function ShowCells(self)
    self:ClearScroll()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIItemPurchasesCell, itemObj)
    local param = {}
    param.count = self.list[index].count
    param.price = self.list[index].price
    param.template = self.template
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
    param.index = index
    param.callBack = function(tempIndex,pos) self:CellsCallBack(tempIndex,pos) end
    cellItem:ReInit(param)
    self.cells[index] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIItemPurchasesCell)
end

local function ClearScroll(self)
    self.cells = {}
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIItemPurchasesCell)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemSignal)
    self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function CellsCallBack(self,index,pos)
    if LuaEntry.Player.gold >= self.list[index].price then
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog,Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING,
                string.GetFormattedSeperatorNum(self.list[index].price),Localization:GetString(GameDialogDefine.DIAMOND),
                DataCenter.ItemTemplateManager:GetName(self.param.itemId)),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            self:ConfirmBuy(self.list[index].count, pos)
        end)
    else
        GoToUtil.GotoPayTips()
    end
end

local function ConfirmBuy(self,count,pos)
    SFSNetwork.SendMessage(MsgDefines.UIShopBuy, { itemId = tostring(self.param.itemId),num = count })
    local showCount = count > MaxFlyNum and MaxFlyNum or count
    local flyEndPos = UIUtil.GetFlyTargetPosByRewardType(RewardType.GOODS)
    if flyEndPos == nil then
        flyEndPos = Vector3.New(0,0,0)
    end
    UIUtil.DoFly(RewardType.GOODS, showCount, DataCenter.ItemTemplateManager:GetIconPath(self.param.itemId),
            pos, flyEndPos)
end

local function RefreshGold(self)
    local gold = LuaEntry.Player.gold
    for k,v in pairs(self.cells) do
        v:RefreshColor(gold)
    end
end

local function RefreshItemSignal(self)
    self:UpdateSlider()
end

local function OnBuyPackageSucc(self)
    self:ShowCells()
    self:TryShowPackage()
end

local function TryShowPackage(self)
    self.packageInfo = self.ctrl:GetQuickPackageInfo(self.param.itemId)
    if self.packageInfo then
        self.packageCell:SetActive(true)
        self.packageNameTxt:SetLocalText(self.packageInfo:getName())
        local packageIcon = self.packageInfo:getPopupImageB()
        if packageIcon == "" then
            self.packageImgB:SetActive(true)
            self.resourceImgB:SetActive(false)
        else
            local iconPath = string.format("Assets/Main/Sprites/Resource/UIResource_Banner_band_%s.png", packageIcon)
            self.resourceImgB:LoadSprite(iconPath)
            self.packageImgB:SetActive(false)
            self.resourceImgB:SetActive(true)
        end
        self.packageDescTxt:SetText(self.packageInfo:getDescText())
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.packageBuyBtnTxt:SetText(price)

        --积分
        self.point_rect:RefreshPoint(self.packageInfo)
    else
        self.packageCell:SetActive(false)
    end
end

local function OnClickJumpToPackBtn(self)
    if self.packageInfo then
        GoToUtil.GotoGiftPackView(self.packageInfo)
    end
end

UIItemPurchases.OnCreate= OnCreate
UIItemPurchases.OnDestroy = OnDestroy
UIItemPurchases.OnEnable = OnEnable
UIItemPurchases.OnDisable = OnDisable
UIItemPurchases.OnItemMoveIn = OnItemMoveIn
UIItemPurchases.OnItemMoveOut = OnItemMoveOut
UIItemPurchases.ClearScroll = ClearScroll
UIItemPurchases.OnAddListener = OnAddListener
UIItemPurchases.OnRemoveListener = OnRemoveListener
UIItemPurchases.UpdateSlider =UpdateSlider
UIItemPurchases.ComponentDefine = ComponentDefine
UIItemPurchases.ComponentDestroy = ComponentDestroy
UIItemPurchases.DataDefine = DataDefine
UIItemPurchases.DataDestroy = DataDestroy
UIItemPurchases.ReInit = ReInit
UIItemPurchases.ShowCells = ShowCells
UIItemPurchases.CellsCallBack = CellsCallBack
UIItemPurchases.ConfirmBuy = ConfirmBuy
UIItemPurchases.RefreshGold = RefreshGold
UIItemPurchases.RefreshItemSignal = RefreshItemSignal
UIItemPurchases.OnBuyPackageSucc = OnBuyPackageSucc
UIItemPurchases.TryShowPackage = TryShowPackage
UIItemPurchases.OnClickJumpToPackBtn = OnClickJumpToPackBtn
return UIItemPurchases