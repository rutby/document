
---获得物品

local GetGoodsTriggerEvent = BaseClass("GetGoodsTriggerEvent")

function GetGoodsTriggerEvent:__init()
end

function GetGoodsTriggerEvent:__delete()
end

--extra：金币世界坐标
function GetGoodsTriggerEvent:Execute(param,extra)
    local spl = string.split(param.para,"|")
    local goodsId = tonumber(spl[1])
    local goodsCount = tonumber(spl[2])

    --先在数据层记录
    DataCenter.LWBattleManager:GetCurBattleLogic():RecordGoods(goodsId,goodsCount)
    --播放飞金币动画
    TimerManager:GetInstance():DelayInvoke(function()
        local para={}
        para.goodsId = goodsId
        para.goodsCount = goodsCount
        para.worldPosition = extra
        EventManager:GetInstance():Broadcast(EventId.OnPVEBattleGetGoods,para)
    end, 0.3)

end

return GetGoodsTriggerEvent 