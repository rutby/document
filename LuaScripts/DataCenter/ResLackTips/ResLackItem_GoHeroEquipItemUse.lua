---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/4/18 17:14
---

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_GoHeroEquipItemUse = BaseClass("ResLackItem_GoHeroEquipItemUse", ResLackItemBase)

function ResLackItem_GoHeroEquipItemUse:CheckIsOk(_resType, _needCnt)
    local para1 = self._config:getValue("para1")
    local itemList = string.split(para1, ";")
    for i = 1, #itemList do
        local item = DataCenter.ItemData:GetItemById(itemList[i])
        if item and item.count > 0 then
            self.itemId = itemList[i]
            break
        end
    end

    local noneItem = self.itemId == nil
    return not noneItem
end

function ResLackItem_GoHeroEquipItemUse:TodoAction()
    self:Use(1)
end

function ResLackItem_GoHeroEquipItemUse:TodoMoreAction()
    self:Use(self:GetMoreCount())
end

function ResLackItem_GoHeroEquipItemUse:GetMoreCount()
    local item = DataCenter.ItemData:GetItemById(self.itemId)
    if item then
        return item.count
    end
    return 0
end

function ResLackItem_GoHeroEquipItemUse:GetConsume()
    local param = {}
    param.itemId = tonumber(self.itemId)
    param.rewardType = RewardType.GOODS
    param.count = DataCenter.ItemData:GetItemCount(self.itemId)
    return param
end

function ResLackItem_GoHeroEquipItemUse:Use(count)
    if count > 0 then
        local item = DataCenter.ItemData:GetItemById(self.itemId)
        if item ~= nil then
            SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid, num = count})
        end
    end
end

return ResLackItem_GoHeroEquipItemUse