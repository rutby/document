--[[
    屏蔽玩家
]]


local ChatLockCommand = BaseClass("ChatLockCommand", SFSBaseMessage)

local function OnCreate(self, uid)
   
    self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, msg)

	local Restrict = ChatManager2:GetInstance().Restrict
    if not table.IsNullOrEmpty(msg.chatShield) then 
        for _,obj in ipairs(msg.chatShield) do 
            local shieldInfo = Restrict:CreateChatShieldInfo()
            shieldInfo:onParseServerData(obj)
			Restrict:addShieldInfo(shieldInfo)
			-- 290011=您已屏蔽{0}
            ChatInterface.flyHint(ChatInterface.getString("290011", obj.name))
			
			-- 一般情况下，系统已经存在这个user信息了。因为你毕竟是要在聊天UI中屏蔽别人的
			--ChatManager2:GetInstance().User:__onReceiveUserInfos(msg.chatShield)
        end 
        
    end 
end

ChatLockCommand.OnCreate = OnCreate
ChatLockCommand.HandleMessage = HandleMessage

return ChatLockCommand