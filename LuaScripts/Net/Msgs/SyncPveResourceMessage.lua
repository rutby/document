---
--- Created by shimin.
--- DateTime: 2022/8/1 12:27
--- 同步pve资源
---
local SyncPveResourceMessage = BaseClass("SyncPveResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SyncPveResourceMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("level", param.level)
        local arr = SFSArray.New()
        for k,v in pairs(param.pveResArr) do
            local obj = SFSObject.New()
            obj:PutInt("id", k)
            obj:PutInt("num", v)
            arr:AddSFSObject(obj)
        end
        self.sfsObj:PutSFSArray("pveResArr", arr)
    end
end

function SyncPveResourceMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.BattleLevel:SyncPveResourceHandle(t)
end

return SyncPveResourceMessage