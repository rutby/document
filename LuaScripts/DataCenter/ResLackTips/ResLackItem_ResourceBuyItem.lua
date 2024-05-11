--- Created by shimin
--- DateTime: 2024/1/26 18:36
--- 钻石购买资源
local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_ResourceBuyItem = BaseClass("ResLackItem_ResourceBuyItem", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_ResourceBuyItem:CheckIsOk(_resType, _needCnt)
    self._resType = _resType
    self._needCnt = _needCnt
    self.itemId = tonumber(self._config:getValue("para1"))
    self.perCost = 0
    self.perParaCount = 1
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if template ~= nil then
        if template.sales[1] ~= nil and template.sales[1][2] ~= nil then
            self.perCost = template.sales[1][2]
        else
            self.perCost = template.price
        end
        self.perParaCount = tonumber(template.para2)
    end
    if self.perCost <= 0 then
        return false
    end
    return true
end

function ResLackItem_ResourceBuyItem:TodoAction()
    self:Buy(1)
end

function ResLackItem_ResourceBuyItem:TodoMoreAction()
    self:Buy(self:GetMoreCount())
end

function ResLackItem_ResourceBuyItem:Buy(count)
    if count > 0 then
        local cost = count * self.perCost
        if LuaEntry.Player.gold >= cost then
            UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING,
                    string.GetFormattedSeperatorNum(cost), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(self.itemId)), 2,GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,
                    function()
                        self:ConfirmBuy(count)
                    end, function() end)

        else
            GoToUtil.GotoPayTips()
        end
    end
end

function ResLackItem_ResourceBuyItem:ConfirmBuy(count)
    SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, { itemId = tostring(self.itemId), num = count })
end

function ResLackItem_ResourceBuyItem:GetPerCost()
    return self.perCost
end

function ResLackItem_ResourceBuyItem:GetMoreCount()
    local own = LuaEntry.Resource:GetCntByResType(self._resType)
    local needCount =  self._needCnt - own
    if needCount > 0 then
        return math.ceil(needCount / self.perParaCount)
    end
    return 0
end

function ResLackItem_ResourceBuyItem:GetConsume()
    local param = {}
    param.itemId = tonumber(self.itemId)
    param.rewardType = RewardType.GOODS
    return param
end


return ResLackItem_ResourceBuyItem