
-- 获取玩家用户信息
local GetMultiUserInfoCommand = BaseClass("GetMultiUserInfoCommand", SFSBaseMessage)

local function OnCreate(self, uidArr)

    self.sfsObj:PutUtfString("allservers", "1")
    -- self.sfsObj:PutUtfString("uids", uidArr)

    -- FIXME: 这个地方直接加一个PutLuaTable...
    --local array = SFSArray.New()
    --table.walk(uidArr,function (k,v)
        --array:AddUtfString(v)
    --end)
    --self.sfsObj:PutSFSArray("uids", array)
	self.sfsObj:PutLuaArray("uids", uidArr)
end

local function HandleMessage(self, msg)

    if msg and msg.uids then 
        ChatManager2:GetInstance().User:__onReceiveUserInfos(msg.uids)
    end 
end

GetMultiUserInfoCommand.OnCreate = OnCreate
GetMultiUserInfoCommand.HandleMessage = HandleMessage

return GetMultiUserInfoCommand

