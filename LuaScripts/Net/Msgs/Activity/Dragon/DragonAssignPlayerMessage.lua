---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 指派成员出战
local DragonAssignPlayerMessage = BaseClass("DragonAssignPlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,targetUid,state)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("targetUid", targetUid)
    self.sfsObj:PutInt("state", state)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        if errCode == 501066 or errCode == 501103 then
            DataCenter.ActDragonManager:SendGetPlayerList()
            UIUtil.ShowTipsId(376092) 
        elseif errCode == 376167 then
            DataCenter.ActDragonManager:SendGetPlayerList()
            UIUtil.ShowTipsId(376167)
        end
    else
        DataCenter.ActDragonManager:HandleSelectPlayer(t)
    end
end

DragonAssignPlayerMessage.OnCreate = OnCreate
DragonAssignPlayerMessage.HandleMessage = HandleMessage

return DragonAssignPlayerMessage