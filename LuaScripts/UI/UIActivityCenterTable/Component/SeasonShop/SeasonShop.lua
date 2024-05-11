
local SeasonShop = BaseClass("SeasonShop", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require "UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem"

local activityTitle_path = "RectView/Top/title"
local activitySubTitle_path = "RectView/Top/subTitle"
local actRemainTime_path = "RectView/Top/remainTime"
local infoBtn_path = "RectView/Top/title/infoBtn"

local resIconImg1_path = "RectView/ResShow1/resIcon1"
local resNumTxt1_path = "RectView/ResShow1/resNum1"
local resIconImg2_path = "RectView/ResShow2/resIcon2"
local resNumTxt2_path = "RectView/ResShow2/resNum2"
local remainTimeTxt_path = "RectView/ImgBg/remainTimeRoot/remainTimeTxt"

local contentExpiring_path = "RectView/ImgBg/Scroll/Viewport/Content/RectExpiring/ContentExpiring"
local contentShopping_path = "RectView/ImgBg/Scroll/Viewport/Content/RectShopping/ContentShopping"
local expiringTxt_path = "RectView/ImgBg/Scroll/Viewport/Content/RectExpiring/expiringTxt"
local shoppingTxt_path = "RectView/ImgBg/Scroll/Viewport/Content/RectShopping/shoppingTxt"
local rectExpiring_path = "RectView/ImgBg/Scroll/Viewport/Content/RectExpiring"
local rectShopping_path = "RectView/ImgBg/Scroll/Viewport/Content/RectShopping"

local shopType = CommonShopType.SeasonShop     --10 赛季商店
local itemId1 = ResourceType.Oil    --黑曜石
local itemId2 = ResourceType.FLINT      --火晶石

function SeasonShop : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function SeasonShop : OnEnable()
    base.OnEnable(self)
end

function SeasonShop : OnDisable()
    self:DelRefreshCdTimer()
    self:DelCountDownTimer()
    base.OnDisable(self)
end

function SeasonShop : OnDestroy()
    self:DelRefreshCdTimer()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function SeasonShop  : DataDefine()
    self.itemGoList = {}
    self.goodsList = {}
    self.expiringList = {}
    self.shoppingList = {}
    self.modelExpiring = {}
    self.modelShopping = {}
    self.compExpiring = {}
    self.compShopping = {}
end

function SeasonShop : DataDestroy()
    self.itemGoList = nil
    self.goodsList = nil
    self.expiringList = nil
    self.shoppingList = nil
    self.modelExpiring = nil
    self.modelShopping = nil
    self.compExpiring = nil
    self.compShopping = nil
end

function SeasonShop : ComponentDefine()
    self.activityTitle = self:AddComponent(UIText, activityTitle_path)
    self.activitySubTitle = self:AddComponent(UIText, activitySubTitle_path)
    self.actRemainTimeTxt = self:AddComponent(UIText, actRemainTime_path)
    self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtn:SetOnClick(function()
        self:OnClickInfoBtn()
    end)

    self.resIconImg1 = self:AddComponent(UIImage, resIconImg1_path)
    self.resNumTxt1 = self:AddComponent(UIText, resNumTxt1_path)
    self.resIconImg2 = self:AddComponent(UIImage, resIconImg2_path)
    self.resNumTxt2 = self:AddComponent(UIText, resNumTxt2_path)
    
    self.remainTimeTxt = self:AddComponent(UIText, remainTimeTxt_path)
    
    self.contentExpiring = self:AddComponent(UIBaseContainer, contentExpiring_path)
    self.contentShopping = self:AddComponent(UIBaseContainer, contentShopping_path)
    self.expiringTxt = self:AddComponent(UIText, expiringTxt_path)
    self.expiringTxt:SetLocalText(372996)
    self.shoppingTxt = self:AddComponent(UIText, shoppingTxt_path)
    self.shoppingTxt:SetLocalText(372997)
    self.rectExpiring = self:AddComponent(UIBaseContainer, rectExpiring_path)
    self.rectShopping = self:AddComponent(UIBaseContainer, rectShopping_path)
end

function SeasonShop : ComponentDestroy()

end

function SeasonShop : SetData(activityId)
    self.activityId = activityId

    if not self.activityId then
        return
    end
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if not self.activityInfo then
        return
    end
    --标题
    self.activityTitle:SetLocalText(self.activityInfo.name)
    self.activitySubTitle:SetLocalText(self.activityInfo.desc_info)

    --剩余时间
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
    self.endTime = self.activityInfo.endTime
    self:AddCountDownTimer()

    local curDay = UITimeManager:GetInstance():GetWeekdayIndex(self.activityInfo.startTime)
    local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(curDay)
    self.refreshCdEndT = nextWeek
    self:AddRefreshCdTimer()
    self:SetRefreshCd()

    --SFSNetwork.SendMessage(MsgDefines.GetSeasonShopActParamInfo, self.activityId)
	SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, shopType, activityId)
end

function SeasonShop : RefreshRes()
    local tempCount1 = LuaEntry.Resource:GetCntByResType(itemId1)
    self.resNumTxt1:SetText(string.GetFormattedSeperatorNum(tempCount1))
    
    local tempCount2 = LuaEntry.Resource:GetCntByResType(itemId2)
    self.resNumTxt2:SetText(string.GetFormattedSeperatorNum(tempCount2))
end

function SeasonShop : RefreshAll()
    self:RefreshRes()
    
    local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(shopType, self.activityId)
    self.expiringList = {}
    self.shoppingList = {}
    for k,v in ipairs(goodsList) do
        if(v.closeTime > 0) then
            local goodCloseTime = self.activityInfo.startTime + v.closeTime * 24 * 60 * 60 * 1000
            if(goodCloseTime <= self.refreshCdEndT) then
                table.insert(self.expiringList, v)
            end
        else
            table.insert(self.shoppingList, v)
        end

    end
    self:RefreshAllGoods()
end

function SeasonShop : RefreshAllGoods()
    --self:SetAllCellDestroy()
    self:RefreshItemReward(self.expiringList)
    self:RefreshShoppingGoods(self.shoppingList)
end

function SeasonShop : SetAllCellDestroy()
    self.contentExpiring:RemoveComponents(CommonGoodsShopItem)
    if self.modelExpiring ~= nil then
        for k,v in pairs(self.modelExpiring) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.contentShopping:RemoveComponents(CommonGoodsShopItem)
    if self.modelShopping ~= nil then
        for k,v in pairs(self.modelShopping) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

--道具奖励
function SeasonShop : RefreshItemReward(expiringList)
    if(expiringList == nil or #expiringList <= 0) then
        self.rectExpiring:SetActive(false)
    else
        self.rectExpiring:SetActive(true)
        for i = 1, #self.compExpiring do
            self.compExpiring[i]:SetActive(false)
        end
        for i = 1, table.count(expiringList) do
            if(i > #self.modelExpiring)then
                --没有已创建的go,创建一次
                self.modelExpiring[i] = self:GameObjectInstantiateAsync(UIAssets.SeasonShopItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.contentExpiring.transform)
                    go.transform:Set_localScale(1,1,1)
                    go.name = "expiringItem"..i
                    local cell = self.contentExpiring:AddComponent(CommonGoodsShopItem, go.name)
                    cell:SetItem(expiringList[i])
                    self.compExpiring[i] = cell
                    --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
                end)
            else
                self.compExpiring[i]:SetActive(true)
                self.compExpiring[i]:SetItem(expiringList[i])
            end
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentExpiring.rectTransform)
end

function SeasonShop : RefreshShoppingGoods(shoppingList)
    if(shoppingList == nil or #shoppingList <= 0) then
        self.rectShopping:SetActive(false)
    else
        self.rectShopping:SetActive(true)
        for i = 1, #self.compShopping do
            self.compShopping[i]:SetActive(false)
        end
        for i = 1, table.count(shoppingList) do
            if(i > #self.modelShopping)then
                --复制基础prefab，每次循环创建一次
                self.modelShopping[i] = self:GameObjectInstantiateAsync(UIAssets.SeasonShopItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.contentShopping.transform)
                    go.transform:Set_localScale(1,1,1)
                    go.name = "shoppingItem"..i
                    local cell = self.contentShopping:AddComponent(CommonGoodsShopItem, go.name)
                    cell:SetItem(shoppingList[i])
                    self.compShopping[i] = cell
                    --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
                end)
            else
                self.compShopping[i]:SetActive(true)
                self.compShopping[i]:SetItem(shoppingList[i])
            end
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentShopping.rectTransform)
end

function SeasonShop : AddCountDownTimer()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false, false, false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

function SeasonShop : RefreshRemainTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if remainTime >= 0 then
        self.actRemainTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.actRemainTimeTxt:SetText("")
    end
end

function SeasonShop : DelCountDownTimer()
    self.CountDownTimerAction = nil
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

function SeasonShop : AddRefreshCdTimer()
    self.RefreshCdTimerAction = function()
        self:SetRefreshCd()
    end

    if self.refreshCdTimer == nil then
        self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction , self, false,false,false)
    end
    self.refreshCdTimer:Start()
end

function SeasonShop : SetRefreshCd()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = math.ceil(self.refreshCdEndT - curTime)
    if remainTime > 0 then
        self.remainTimeTxt:SetText(Localization:GetString("104209", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
    else
        self.remainTimeTxt:SetText("")
        self:DelRefreshCdTimer()
        SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, shopType)
    end
end

function SeasonShop : DelRefreshCdTimer()
    if self.refreshCdTimer ~= nil then
        self.refreshCdTimer:Stop()
        self.refreshCdTimer = nil
    end
end

function SeasonShop : OnInitScroll(go,index)
    local item = self.scrollRect:AddComponent(CommonGoodsShopItem, go)
    self.itemGoList[go] = item
end

function SeasonShop : OnUpdateScroll(go,index)
    local conf = self.goodsList[index + 1]
    go.name = conf.id
    local cellItem = self.itemGoList[go]
    if not cellItem then
        return
    end
    cellItem:SetItem(conf)
end

function SeasonShop : OnDestroyScrollItem(go, index)

end

function SeasonShop : OnClickInfoBtn()
    UIUtil.ShowIntro(Localization:GetString(self.activityInfo.name), Localization:GetString("100239"),Localization:GetString(self.activityInfo.story))
end

function SeasonShop : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
    self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
    self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
end

function SeasonShop : OnRemoveListener()
    self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
    
    base.OnRemoveListener(self)
end

return SeasonShop