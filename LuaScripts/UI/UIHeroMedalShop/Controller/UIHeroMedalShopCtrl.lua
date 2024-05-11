local UIHeroMedalShopCtrl = BaseClass("UIHeroMedalShopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroMedalShop)
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetPanelData(self)
    local dataList = {}

    local allShopData = DataCenter.HeroMedalShopDataManager:GetMedalShopArr()
    for _,v in ipairs(allShopData) do
        local titleName = v.name
        local startTime = v.startTime
        local endTime = v.endTime
        local medalShopId = v.medalShopId
        -- 添加一个标题
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime > endTime then
            -- 已经结束 不要添加标题 直接continue
            goto continue
        end

        local hasStarted = false;

        if curTime > startTime then
            -- 还没开始 添加标题
            hasStarted = true
        end

        table.insert(dataList, {type = 0
                                            , titleName = titleName
                                            , startTime = startTime
                                            , endTime = endTime
                                            , medalShopId = medalShopId
                                            , hasStarted = hasStarted})
        if hasStarted then
            -- 每个小标题下的商品列表
            local itemArr = v.itemArr
            local count = 0
            local itemsTab = {}
            for _, v2 in ipairs(itemArr) do
                if count == 0 then
                    itemsTab = {type = 1
                                , medalShopId = medalShopId
                                , endTime = endTime}
                    table.insert(dataList, itemsTab)
                end
                table.insert(itemsTab, v2)
                count = count + 1
                if count == 3 then
                    count = 0
                end
            end
        end
        ::continue::
    end

    return dataList
end

local function GetDailyReward(self)
    if DataCenter.HeroMedalShopDataManager:GetStorageFullConfirmFlag() then
        DataCenter.HeroMedalShopDataManager:GetDailyReward();
    else
        local addNum = self:GetDailyRewardItemNum()
        if self:CheckStorageIsFull(addNum) then
            -- 仓库满了
            UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("320829"), 2, "", "", function()
                DataCenter.HeroMedalShopDataManager:GetDailyReward();
            end, nil)
        else
            DataCenter.HeroMedalShopDataManager:GetDailyReward();
        end
    end
end

local function GetCurrItemNum(self)
    local itemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
    local good = DataCenter.ItemData:GetItemById(itemId)
    local num = good and good.count or 0
    return num
end

local function GetItemMaxNum(self)
    local itemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
    local item = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if item ~= nil then
        return item.max_stock
    end
    return 0
end

local function GetQuickPackageInfo(self)
    local itemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
    local str = "6;".. itemId
    local packageTb = GiftPackageData.getShowTypeGiftPackList("6",str)
    if packageTb and #packageTb > 0 then
        return packageTb[1]
    end
end

local function BuyGift(self,info)
    if DataCenter.HeroMedalShopDataManager:GetStorageFullConfirmFlag() then
        self:ConfirmBuyGift(info)
    else
        local addNum = self:GetPackageRewardItemNum(info)

        if self:CheckStorageIsFull(addNum) then
            -- 仓库满了
            UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("320829"), 2, "", "", function()
                self:ConfirmBuyGift(info)
            end, nil)
            -- function(needSellConfirm)
            --     -- 为啥选中才是false
            --     local notShowAgain = needSellConfirm == false
            --     DataCenter.HeroMedalShopDataManager:SetStorageFullConfirmFlag(notShowAgain)
            -- end
        else
            self:ConfirmBuyGift(info)
        end
    end
end

local function ConfirmBuyGift(self, info)
    DataCenter.PayManager:CallPayment(info, UIWindowNames.UIItemPurchases)
end

-- 检测是否已经满库存
local function CheckStorageIsFull(self, addNum)
    local maxValue = self:GetItemMaxNum()
    local currValue = self:GetCurrItemNum();
    if currValue + addNum > maxValue then
        return true
    end

    return false
end

local function GetDailyRewardItemNum(self)
    local num = 0
    local dailyReward = DataCenter.HeroMedalShopDataManager:DailyReward()
    for _, v in pairs(dailyReward) do
        local itemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
        if toInt(v.value.id) == itemId then
            num = num + v.value.num
        end
    end
    return num
end

local function GetPackageRewardItemNum(self, package)
    local num = 0
    if package == nil then
        return num
    end

    local itemstr = package._serverData.item
    local item_vec = string.split(itemstr, "|")
    local medalItemId = DataCenter.HeroMedalShopDataManager:GetHeroMedalItemId()
    for _,item_split_str in ipairs(item_vec) do
        local item_split_vec = string.split(item_split_str, ";")
        if #item_split_vec == 2 then
            local itemid = toInt(item_split_vec[1])
            local item_num = toInt(item_split_vec[2])
            if itemid == medalItemId then
                num = num + item_num
            end
        end
    end

    return num
end

UIHeroMedalShopCtrl.CloseSelf = CloseSelf
UIHeroMedalShopCtrl.Close = Close
UIHeroMedalShopCtrl.GetPanelData = GetPanelData
UIHeroMedalShopCtrl.GetDailyReward = GetDailyReward
UIHeroMedalShopCtrl.GetCurrItemNum = GetCurrItemNum
UIHeroMedalShopCtrl.GetItemMaxNum = GetItemMaxNum
UIHeroMedalShopCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UIHeroMedalShopCtrl.BuyGift = BuyGift
UIHeroMedalShopCtrl.CheckStorageIsFull = CheckStorageIsFull
UIHeroMedalShopCtrl.ConfirmBuyGift = ConfirmBuyGift
UIHeroMedalShopCtrl.GetDailyRewardItemNum = GetDailyRewardItemNum
UIHeroMedalShopCtrl.GetPackageRewardItemNum = GetPackageRewardItemNum

return UIHeroMedalShopCtrl