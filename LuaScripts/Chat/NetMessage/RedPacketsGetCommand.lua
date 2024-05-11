--[[
    领取红包协议
    add by sunliwen
]]

local RedPacketsGetCommand = BaseClass("RedPacketsGetCommand", SFSBaseMessage)

local function OnCreate(self, param)

    self.super.OnCreate(self)

    self.sfsObj:PutUtfString("uuid",tostring(param.redPacketId))
    self.sfsObj:PutLong("serverId",tonumber(param.serverId))
    if param.isViewOnly then 
        self.sfsObj:PutLong("info",1)
    end 
end


local function HandleMessage(self, msg)
    self.super.HandleMessage(self)

	if msg.params then 
        local params = msg.params
        local  status = params.status and params.status  or ""
        if params.getGold then 
            status = "0"
        end
        local  redPacketAttachmentId = self.data.uuid .. "_" .. self.data.serverId .. "|" .. status
        --更新数据
        ChatInterface.getChatRoomManagerInst():refreshRedPacketStatus(redPacketAttachmentId);
        ChatInterface.postNotification("HongBaoGetView_get", params);
        ChatInterface.postNotification("HongBaoGetNewView_get", params);
    end 
end

RedPacketsGetCommand.OnCreate = OnCreate
RedPacketsGetCommand.HandleMessage = HandleMessage

return RedPacketsGetCommand