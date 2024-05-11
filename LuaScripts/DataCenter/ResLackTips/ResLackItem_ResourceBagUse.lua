--- Created by shimin
--- DateTime: 2024/2/21 15:50
--- 使用背包道具

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_ResourceBagUse = BaseClass("ResLackItem_ResourceBagUse", ResLackItemBase)

function ResLackItem_ResourceBagUse:CheckIsOk( _resType, _needCnt, _, _,isType)
    self._resType = _resType
    self._needCnt = _needCnt
    self.perParaCount = 1
    self.isType = isType
    self.itemArr = {}
    local para1 = self._config:getValue("para1")
    if para1 ~= nil and para1 ~= "" then
        self.itemArr = string.split_ii_array(para1,";")
        for k, v in ipairs(self.itemArr) do
            local own = DataCenter.ItemData:GetItemCount(v)
            if own > 0 then
                self.itemId = v
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
        end
    end
    return false
end

function ResLackItem_ResourceBagUse:TodoAction()
    self:Use(1)
end

function ResLackItem_ResourceBagUse:TodoMoreAction()
    self:Use(self:GetMoreCount())
end

function ResLackItem_ResourceBagUse:Use(count)
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

function ResLackItem_ResourceBagUse:GetMoreCount()
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

function ResLackItem_ResourceBagUse:GetConsume()
    local param = {}
    param.itemId = tonumber(self.itemId)
    param.rewardType = RewardType.GOODS
    param.count = DataCenter.ItemData:GetItemCount(self.itemId)
    return param
end

return ResLackItem_ResourceBagUse