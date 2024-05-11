--[[
    --根据名字搜索玩家
]]

local SearchPlayerCommand = BaseClass("SearchPlayerCommand", SFSBaseMessage)

-- page = int
-- key = string
local function OnCreate(self, param)

    self.sfsObj:PutUtfString("key", param.searchKey)
    self.sfsObj:PutInt("page", param.page)
end

local function HandleMessage(self, msg)

    local list = msg.list
    if list and #list > 0 then    
        ChatManager2:GetInstance().User:__onSearchUserInfos(list)
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, list)
	else
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, nil)
    end
end

SearchPlayerCommand.OnCreate = OnCreate
SearchPlayerCommand.HandleMessage = HandleMessage

return SearchPlayerCommand