--- Created by shimin
--- DateTime: 2024/1/31
--- 道具材料钻石购买（补齐）
local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_BuildBuyItem = BaseClass("ResLackItem_BuildBuyItem", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_BuildBuyItem:CheckIsOk( _itemId, _count )
    self.itemId = _itemId
    self._needCnt = _count
    if self:GetBuyNum() <= 0 then
        return false
    end
    
    self.perCost = 0
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if template ~= nil then
        if template.sales[1] ~= nil and template.sales[1][2] ~= nil then
            self.perCost = template.sales[1][2]
        else
            self.perCost = template.price
        end
    end
    if self.perCost <= 0 then
        return false
    end
    return true
end

function ResLackItem_BuildBuyItem:TodoAction()
    self:Buy(self:GetBuyNum())
end

function ResLackItem_BuildBuyItem:Buy(count)
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

function ResLackItem_BuildBuyItem:ConfirmBuy(count)
    SFSNetwork.SendMessage(MsgDefines.BuyItemAndResource, nil, { [tostring(self.itemId)] = count })
end

function ResLackItem_BuildBuyItem:GetBtnName()
    return string.GetFormattedSeperatorNum(self:GetCostGoldNum())
end

function ResLackItem_BuildBuyItem:GetCostGoldNum()
    return self:GetBuyNum() * self.perCost
end

function ResLackItem_BuildBuyItem:GetBuyNum()
    local own = DataCenter.ItemData:GetItemCount(self.itemId)
    local needCount =  self._needCnt - own
    if needCount > 0 then
        return needCount
    end
    return 0
end

function ResLackItem_BuildBuyItem:GetConsume()
    local param = {}
    param.itemId = tonumber(self.itemId)
    param.rewardType = RewardType.GOODS
    param.count = self:GetBuyNum()
    return param
end


return ResLackItem_BuildBuyItem