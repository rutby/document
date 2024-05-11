--[[
    解除屏蔽玩家
	注意发送的是uuid
]]

local ChatUnLockCommand = BaseClass("ChatUnLockCommand", SFSBaseMessage)

local function OnCreate(self, uuid)
    self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, msg)

    if not string.IsNullOrEmpty(msg.uuid) then 
		local Restrict = ChatManager2:GetInstance().Restrict
        local shieldInfo = Restrict:getShieldInfoByUuid(msg.uuid)
        if shieldInfo ~= nil then
            local name = shieldInfo.name
			Restrict:removeRestrictUser(shieldInfo.uid, RestrictType.BLOCK)
			-- 290012=已解除对{0}的屏蔽
            ChatInterface.flyHint(ChatInterface.getString("290012",name))
            EventManager:GetInstance():Broadcast(EventId.OnGetBlockList)
        end
    end 
end

ChatUnLockCommand.OnCreate = OnCreate
ChatUnLockCommand.HandleMessage = HandleMessage

return ChatUnLockCommand