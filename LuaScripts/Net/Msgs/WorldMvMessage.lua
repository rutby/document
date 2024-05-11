---
--- Created by shimin.
--- DateTime: 2021/7/29 11:41
---
local WorldMvMessage = BaseClass("WorldMvMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("pointId", param.pointId)--迁城的pointId
        if param.itemId then
            self.sfsObj:PutUtfString("itemId", param.itemId)--使用道具的uuid
        end
        if param.freeAllianceMove then
            self.sfsObj:PutBool("freeAllianceMove", param.freeAllianceMove)
        end
        if param.freeEdenMove then
            self.sfsObj:PutBool("freeEdenMove", param.freeEdenMove)
        end
        --老代码 用的时候在添加
        -- req.PutUtfString("mailUid", data.mailUid);
        -- req.PutUtfString("alcitymove", data.alcitymove); 
        -- req.PutInt("toAllianceRound", data.toAllianceRound);
        -- req.PutInt("toAllianceRound", data.toAllianceRound);
        -- req.PutUtfString("assemblePoint", data.assemblePoint);
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:WorldMvHandle(t)

    if t["lastFreeMoveTime"] then
        LuaEntry.Player:SetLastFreeMvTime(t["lastFreeMoveTime"])
    end
    if t["edenMoveTime"] then
        LuaEntry.Player:UpdateEdenMvCoolDownTime(t)
    end
end

WorldMvMessage.OnCreate = OnCreate
WorldMvMessage.HandleMessage = HandleMessage

return WorldMvMessage