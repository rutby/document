--[[
    ---发送其他消息，可能更多的是分享消息
]]
local ChatShareCommand = BaseClass("ChatShareCommand", SFSBaseMessage)


--[[
    需要传入的参数 
    param.post   postType类型   必须发
    param.msg    不能为空
    param.roomId 私聊频道发的
	param.attachmentId 转发的自定义消息格式
	
	--交易行
	param.tradeName
	param.itemIds
	param.tradePoint
]]

function ChatShareCommand:OnCreate(param)
    if not param then 
        ChatPrint("ChatShareCommand 分享没传参！！！ ")
        return 
    end
	
	-- 类型及语言
	self.sfsObj:PutLong("post", param.post)
	self.sfsObj:PutUtfString("lang", param.lang)
	
	-- 因为msg不能为空，所以这里随便填充一个
	if param.msg then
		self.sfsObj:PutUtfString("msg", param.msg)
	else 
		self.sfsObj:PutUtfString("msg", "?")
	end
	
	-- 私聊的话，需要传房间id
	if param.roomId then
		self.sfsObj:PutUtfString("roomId", param.roomId)
	end

    if param.tradeName then
        self.sfsObj:PutUtfString("tradeName", param.tradeName)
    end

    if param.itemIds then
        local array = SFSArray.New()
        table.walk(param.itemIds,function (k,v)
            array:AddInt(v)
            --array:AddSFSObject(obj)
        end)
        self.sfsObj:PutSFSArray("itemIds", array)
    end

    if param.tradePoint then
        self.sfsObj:PutLong("tradePoint", param.tradePoint)
    end
	
	-- 这个服务器只做了一个转发，目前都使用json处理了
    if param.attachmentId then
        if #param.attachmentId>=32767 then
            local luaTable =string.SubStrByNum(param.attachmentId,32767)
            local array = SFSArray.New()
            for i=1,#luaTable do
                array:AddUtfString(luaTable[i])
            end
            self.sfsObj:PutSFSArray("attachmentIdArr", array)
        else
            self.sfsObj:PutUtfString("attachmentId", param.attachmentId)
        end
    end
	

    if param.chatType then
        self.sfsObj:PutInt("chatType", param.chatType)
    end
	if param.langRoomLang then
		self.sfsObj:PutUtfString("langRoomLang", param.langRoomLang)
	end
	--self.sfsObj:PutLuaTable(nil, data)
end

function ChatShareCommand:getShareChannelGroup()
    if self.shareChannel == ChatShareChannel.TO_COUNTRY then 
        return ChatGroupType.GROUP_COUNTRY
    elseif self.shareChannel == ChatShareChannel.TO_ALLIANCE then 
        return ChatGroupType.GROUP_ALLIANCE
    elseif self.shareChannel == ChatShareChannel.TO_PERSON then  
        return ChatGroupType.GROUP_CUSTOM
    end 
end

function ChatShareCommand:processErrorMessage(msg)
    if msg.errorCode and istable(msg.errorPara2) then
        UIUtil.ShowTips(msg.errorCode, msg.errorPara2[1]);
    end 
end


function ChatShareCommand:HandleMessage(msg)
    if msg.errorCode then 
        return
    end 
    if self.noShowChat then
        return
    end
    -- tip 分享成功
    UIUtil.ShowTipsId(120061) 
    local roomGroup = self:getShareChannelGroup();
    
    if msg["gold"] then
        LuaEntry.Player.gold = msg["gold"]
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    --ChatInterface.openChatRoomView(roomGroup,self.data.roomId)
end

return ChatShareCommand