--- Created by shimin.
--- DateTime: 2023/7/19 19:22
--- 英雄海报兑换代币
---
local HeroPosterExchangeTokenMessage = BaseClass("HeroPosterExchangeTokenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroPosterExchangeTokenMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        local oneArr = SFSArray.New()
        for _,v in ipairs(param.heroArr) do
            oneArr:AddLong(v)
        end
        self.sfsObj:PutSFSArray("heroArr", oneArr)--sfs long arr 消耗的海报uuid
    end
end

function HeroPosterExchangeTokenMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.HeroMedalRedemptionManager:HeroPosterExchangeTokenHandle(t)
end

return HeroPosterExchangeTokenMessage