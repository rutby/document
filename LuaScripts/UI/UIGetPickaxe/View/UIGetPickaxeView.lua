--UIGetPickaxeView.lua

local UIGetPickaxeView = BaseClass("UIGetPickaxeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_path = "Root/UICommonMidPopUpTitle/bg_mid/titleText"
local closeBtn_path = "Root/UICommonMidPopUpTitle/bg_mid/CloseBtn"
local bgBtn_path = "panel"
local actRoot_path = "Root/ImgBg/content/activity"
local actName_path = "Root/ImgBg/content/activity/offset/actName"
local actIcon_path = "Root/ImgBg/content/activity/offset/actIcon"
local actJumpBtn_path = "Root/ImgBg/content/activity/actJumpBtn"
local actJumpBtnTxt_path = "Root/ImgBg/content/activity/actJumpBtn/actJumpBtnTxt"
local goldRoot_path = "Root/ImgBg/content/gold"
local goldName_path = "Root/ImgBg/content/gold/offset/goldTitle"
local goldIcon_path = "Root/ImgBg/content/gold/offset/pickaxeIcon"
local goldBuyBtn_path = "Root/ImgBg/content/gold/goldBuyBtn"
local goldBuyBtnTxt_path = "Root/ImgBg/content/gold/goldBuyBtn/goldBtnTxt"
local goldBuyBtnPrice_path = "Root/ImgBg/content/gold/goldBuyBtn/goldPrice"
local goldBuyLimit_path = "Root/ImgBg/content/gold/offset/limit"
local packageRoot_path = "Root/ImgBg/content/package"
local packageName_path = "Root/ImgBg/content/package/offset/packageName"
local packageItems_path = "Root/ImgBg/content/package/offset/Rect_Gift/UICommonItem"
local packageBuyBtn_path = "Root/ImgBg/content/package/offset/buyPackageBtn"
local packageBtnPrice_path = "Root/ImgBg/content/package/offset/buyPackageBtn/packagePrice"
local packageGift_path = "Root/ImgBg/content/package/offset/buyPackageBtn/UIGiftPackagePoint"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(129253)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
    self.bgBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.actN = self:AddComponent(UIBaseContainer, actRoot_path)
    self.actNameN = self:AddComponent(UIText, actName_path)
    self.actNameN:SetLocalText(320416)
    self.actIconN = self:AddComponent(UIImage, actIcon_path)
    self.actJumpBtnN = self:AddComponent(UIButton, actJumpBtn_path)
    self.actJumpBtnN:SetOnClick(function()
        self:OnClickJumpToAct()
    end)
    self.actJumpBtnTxtN = self:AddComponent(UIText, actJumpBtnTxt_path)
    self.actJumpBtnTxtN:SetLocalText(110003)
    self.goldN = self:AddComponent(UIBaseContainer, goldRoot_path)
    self.goldNameN = self:AddComponent(UIText, goldName_path)
    self.goldNameN:SetLocalText(110027)
    self.goldIconN = self:AddComponent(UIImage, goldIcon_path)
    self.goldBuyBtnN = self:AddComponent(UIButton, goldBuyBtn_path)
    self.goldBuyBtnN:SetOnClick(function()
        self:OnClickBuyPickaxe()
    end)
    self.goldBuyBtnTxtN = self:AddComponent(UIText, goldBuyBtnTxt_path)
    self.goldBuyBtnTxtN:SetLocalText(110080)
    self.goldBtnPriceN = self:AddComponent(UIText, goldBuyBtnPrice_path)
    self.goldBuyLimitN = self:AddComponent(UIText, goldBuyLimit_path)
    self.packageN = self:AddComponent(UIBaseContainer, packageRoot_path)
    self.packageNameN = self:AddComponent(UIText, packageName_path)
    self.packageItemsTbN = {}
    for i = 1, 3 do
        local path = packageItems_path .. i
        local item = self:AddComponent(UICommonItem, path)
        table.insert(self.packageItemsTbN, item)
    end
    self.packageBuyBtnN = self:AddComponent(UIButton, packageBuyBtn_path)
    self.packageBuyBtnN:SetOnClick(function()
        self:OnClickBuyPackageBtn()
    end)
    self.packageBtnPriceN = self:AddComponent(UIText, packageBtnPrice_path)
    self.packageGiftN = self:AddComponent(UIGiftPackagePoint, packageGift_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.bgBtnN = nil
    self.actN = nil
    self.actNameN = nil
    self.actIconN = nil
    self.actJumpBtnN = nil
    self.actJumpBtnTxtN = nil
    self.goldN = nil
    self.goldNameN = nil
    self.goldIconN = nil
    self.goldBuyBtnN = nil
    self.goldBuyBtnTxtN = nil
    self.goldBtnPriceN = nil
    self.packageN = nil
    self.packageNameN = nil
    self.packageIconN = nil
    self.packageBuyBtnN = nil
    self.packageBuyBtnTxtN = nil
    self.packageBtnPriceN = nil
end


local function DataDefine(self)
    self.activityId = nil
end

local function DataDestroy(self)
    self.activityId = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

local function InitUI(self)
    self.activityId = self:GetUserData()
    
    self:RefreshAll()
end

local function RefreshAll(self)
    self:RefreshActGet()
    self:RefreshGoldGet()
    self:RefreshPackageGet()
end

local function RefreshActGet(self)
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if activityInfo then
        self.jumpToActId = tonumber(activityInfo.para1)
        local jumpActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.jumpToActId))
        if jumpActInfo then
            self.actN:SetActive(true)
        else
            self.actN:SetActive(false)
        end
    else
        self.actN:SetActive(false)
    end
end

local function RefreshGoldGet(self)
    local digTemplate = DataCenter.DigActivityManager:GetDigTemplate(self.activityId)
    local digInfo = DataCenter.DigActivityManager:GetDigInfo(self.activityId)
    if digInfo then
        self.goldN:SetActive(true)
        self.goldBtnPriceN:SetText(digTemplate.pickaxPrice)
        self.goldBuyLimitN:SetText(Localization:GetString(104208) .." ".. (digTemplate.pickaxBuyMax - digInfo.itemBoughtTimes))
        local canBuy = digInfo.itemBoughtTimes < digTemplate.pickaxBuyMax
        CS.UIGray.SetGray(self.goldBuyBtnN.transform, not canBuy, canBuy)
    else
        self.goldN:SetActive(false)
    end
end

local function RefreshPackageGet(self)
    self.packInfo = DataCenter.DigActivityManager:GetPickaxePackageInfo(self.activityId)
    if not self.packInfo then
        self.packageN:SetActive(false)
    else
        self.packageN:SetActive(true)
        local price = DataCenter.PayManager:GetDollarText(self.packInfo:getPrice(), self.packInfo:getProductID())
        self.packageNameN:SetLocalText(self.packInfo:getName())
        self.packageBtnPriceN:SetText(price)
        self.packageGiftN:RefreshPoint(self.packInfo)
        local showList = self:GetCellsList(self.packInfo)
        for i, v in ipairs(self.packageItemsTbN) do
            if i <= #showList then
                v:SetActive(true)
                v:ReInit(showList[i])
            else
                v:SetActive(false)
            end
        end
    end
end

--cpy from ResLackItem_BuyGiftNew
local function GetCellsList(self, packageInfo)
    local listParam = {}
    local info  = packageInfo

    -- 英雄
    local heroStr = info:getHeroesStr()
    if (not string.IsNullOrEmpty(heroStr)) then
        local arr = string.split(heroStr, ";")
        if (#arr == 2) then
            local param = {}-- UIGiftPackageCell.Param.New()
            param.rewardType = RewardType.HERO
            param.itemId = arr[1]
            param.count = arr[2]
            table.insert(listParam,param)
        end
    end

    -- 普通道具
    local str = info:getItemsStr()
    local _item_use = info:getItemUse()
    if _item_use ~= nil and _item_use ~= "" then
        str = _item_use .. "|" .. str
    end

    local arrMiddle = string.split(str,"|")
    if arrMiddle ~= nil and #arrMiddle > 0 then
        for k,v in ipairs(arrMiddle) do
            local arr = string.split(v,";")
            if arr[1] ~= "" then
                local param = {}-- UIGiftPackageCell.Param.New()
                param.rewardType = RewardType.GOODS
                param.itemId = arr[1]
                local numCount = tonumber(arr[2])
                param.count = string.GetFormattedSeperatorNum(numCount)
                table.insert(listParam,param)
            end
        end
    end

    local goldParam = {}
    local goldNum = tonumber(info:getDiamond())
    if goldNum > 0 then
        goldParam.rewardType = RewardType.GOLD
        goldParam.count = string.GetFormattedSeperatorNum(goldNum)
        goldParam.itemId = ResourceType.Gold
        table.insert(listParam, 2, goldParam)
    end

    local temp = info:GetDiscountTips()
    if temp then
        if temp[4] then
            local replace = temp[4]
            for i ,v in pairs(replace) do
                listParam[i] = v
            end
        end
    end

    return listParam
end


local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickJumpToAct(self)
    local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIActivityCenterTable)
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIActivityCenterTable) and  luaWindow ~= nil and luaWindow.View ~= nil then
        luaWindow.View:GotoActivityByExternal(self.jumpToActId)
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, self.jumpToActId)
    end
    self.ctrl:CloseSelf()
end

local function OnClickBuyPickaxe(self)
    DataCenter.DigActivityManager:TryBuyPickaxe(self.activityId)
    self.ctrl:CloseSelf()
end

local function OnClickBuyPackageBtn(self)
    DataCenter.PayManager:CallPayment(self.packInfo, UIWindowNames.UIGetPickaxe)
    self.ctrl:CloseSelf()
end

UIGetPickaxeView.OnCreate = OnCreate
UIGetPickaxeView.OnDestroy = OnDestroy
UIGetPickaxeView.ComponentDefine = ComponentDefine
UIGetPickaxeView.ComponentDestroy = ComponentDestroy
UIGetPickaxeView.DataDefine = DataDefine
UIGetPickaxeView.DataDestroy = DataDestroy
UIGetPickaxeView.OnAddListener = OnAddListener
UIGetPickaxeView.OnRemoveListener = OnRemoveListener


UIGetPickaxeView.InitUI = InitUI
UIGetPickaxeView.RefreshAll = RefreshAll
UIGetPickaxeView.RefreshActGet = RefreshActGet
UIGetPickaxeView.RefreshGoldGet = RefreshGoldGet
UIGetPickaxeView.RefreshPackageGet = RefreshPackageGet
UIGetPickaxeView.GetCellsList = GetCellsList
UIGetPickaxeView.OnClickCloseBtn = OnClickCloseBtn
UIGetPickaxeView.OnClickJumpToAct = OnClickJumpToAct
UIGetPickaxeView.OnClickBuyPickaxe = OnClickBuyPickaxe
UIGetPickaxeView.OnClickBuyPackageBtn = OnClickBuyPackageBtn

return UIGetPickaxeView