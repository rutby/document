--[[
    查看红包状态
    为什么需要这个协议呢，因为红包有可能被别人领了，但是并没有给我推送,所以我不知道
    add by sunliwen
]]

local GetRedPacketStatusCommand = BaseClass("GetRedPacketStatusCommand", SFSBaseMessage)

local function OnCreate(self, param)
    self.super.OnCreate(self)

    self.sfsObj:PutUtfString("uid", tostring(redPacketId))
    self.sfsObj:PutLong("serverId",tonumber(serverId))
end


local function HandleMessage(self, msg)
    self.super.HandleMessage(self)

    local params = msg.params
	if params and params.status then 
        local  status = params.status and params.status  or ""
        local  redPacketId = self.data.uid .. "_" .. self.data.serverId
        local  redPacketAttachmentId = redPacketId .. "|" .. status
        -- 更新数据
        --ChatInterface.getChatRoomManagerInst():refreshRedPacketStatus(redPacketAttachmentId);
        local data = {
            status       = status
        }
        ChatInterface.postNotification("kRefreshRedPackageStatus",data)
        EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().REFRESH_RED_PACKAGE, status)
    end 
end

GetRedPacketStatusCommand.OnCreate = OnCreate
GetRedPacketStatusCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码
local function OnSend(param)
    SFSNetwork.SendMessage(MsgDefines.GET_RED_PACKET_STATUS, param)
end

function GetRedPacketStatusCommand.create(redPacketId, serverId)
    if not redPacketId or not serverId then 
        -- ChatPrint("GetRedPacketStatusCommand 参数错误")
        return nil
    end

    local ret = {}
    ret.send = OnSend
    ret.redPacketId = redPacketId
    ret.serverId = serverId
    return ret
end
----------------------------------------------------------------


return GetRedPacketStatusCommand