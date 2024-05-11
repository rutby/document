---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/4/22 19:05
---
local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_ResourceBagUse_New = BaseClass("ResLackItem_ResourceBagUse_New", ResLackItemBase)

function ResLackItem_ResourceBagUse_New:CheckIsOk( _resType, _needCnt, _, _,isType,itemId)
    self._resType = _resType
    self._needCnt = _needCnt
    self.perParaCount = 1
    self.isType = isType
    self.itemArr = {}
    table.insert(self.itemArr,itemId)
    local own = DataCenter.ItemData:GetItemCount(itemId)
    if own > 0 then
        self.itemId = itemId
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
        if template ~= nil then
            if template.type == GOODS_TYPE.GOODS_TYPE_59 or template.type == GOODS_TYPE.GOODS_TYPE_204 then
                self.perParaCount = 1
            else
                self.perParaCount = tonumber(template.para2)
            end
        end
        return true
    end
    return false
end

function ResLackItem_ResourceBagUse_New:GetName()
    if self.itemId then
        local item = DataCenter.ItemData:GetItemById(tonumber(self.itemId))
        if item then
            return DataCenter.ItemTemplateManager:GetName(self.itemId)
        end
    end
end

function ResLackItem_ResourceBagUse_New:GetDesc()
    if self.itemId then
        local item = DataCenter.ItemData:GetItemById(tonumber(self.itemId))
        if item then
            return DataCenter.ItemTemplateManager:GetDes(self.itemId)
        end
    end
end

function ResLackItem_ResourceBagUse_New:TodoAction()
    self:Use(1)
end

function ResLackItem_ResourceBagUse_New:TodoMoreAction()
    self:Use(self:GetMoreCount())
end

function ResLackItem_ResourceBagUse_New:Use(count)
    if count > 0 then
        local item = DataCenter.ItemData:GetItemById(self.itemId)
        if item ~= nil then
            local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
            if itemTemp.type == GOODS_TYPE.GOODS_TYPE_59 then
                local perNum , index = DataCenter.ItemManager:GetCustomResourceInfoByIdResType(self.itemId,self._resType)
                SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid, num = count , para1 = tostring(index)})
            else
                SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid, num = count})
            end
        end
    end
end

function ResLackItem_ResourceBagUse_New:GetMoreCount()
    local own = LuaEntry.Resource:GetCntByResType(self._resType)
    local needCount =  self._needCnt - own
    if needCount > 0 then
        local fullNeedCount = math.ceil(needCount / self.perParaCount)
        local maxOwn = DataCenter.ItemData:GetItemCount(self.itemId)
        if fullNeedCount > maxOwn then
            fullNeedCount = maxOwn
        end
        return fullNeedCount
    end
    return 0
end

function ResLackItem_ResourceBagUse_New:GetConsume()
    local param = {}
    param.itemId = tonumber(self.itemId)
    param.rewardType = RewardType.GOODS
    param.count = DataCenter.ItemData:GetItemCount(self.itemId)
    return param
end

return ResLackItem_ResourceBagUse_New