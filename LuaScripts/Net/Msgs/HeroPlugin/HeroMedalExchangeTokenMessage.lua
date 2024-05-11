--- Created by shimin.
--- DateTime: 2023/7/19 20:17
--- 英雄勋章兑换代币
---
local HeroMedalExchangeTokenMessage = BaseClass("HeroMedalExchangeTokenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroMedalExchangeTokenMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        local oneArr = SFSArray.New()
        for _,v in ipairs(param.costGoods) do
            local obj = SFSObject.New()
            obj:PutUtfString("goodsId", v.goodsId)
            obj:PutInt("count", v.count)
            oneArr:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("costGoods", oneArr)--sfs arr 消耗的勋章
    end
end

function HeroMedalExchangeTokenMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroMedalRedemptionManager:HeroMedalExchangeTokenHandle(t)
end

return HeroMedalExchangeTokenMessage