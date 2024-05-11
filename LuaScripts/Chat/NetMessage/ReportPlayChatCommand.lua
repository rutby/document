--[[
    举报聊天消息

    add by sunliwen
]]

local ReportPlayChatCommand = BaseClass("ReportPlayChatCommand", SFSBaseMessage)

local function OnCreate(self, param)
    self.super.OnCreate(self)

    self.sfsObj:PutUtfString("reportUid", param.reportUid)
    self.sfsObj:PutUtfString("content", param.content)
    self.sfsObj:PutUtfString("msgCreateTime", param.msgCreateTime)
    self.sfsObj:PutLong("type", param.type)
    
end


local function HandleMessage(self, msg)
    self.super.HandleMessage(self)

    if msg.errorCode then 
    	return
    end 
    ChatInterface.flyHint("290037")
   
end



ReportPlayChatCommand.OnCreate = OnCreate
ReportPlayChatCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码
local function OnSend(param)
    SFSNetwork.SendMessage(MsgDefines.REPORT_PALYER_CHAT, param)
end

function ReportPlayChatCommand.create(param)
    local ret = param
    ret.send = OnSend
    return ret
end
----------------------------------------------------------------


return ReportPlayChatCommand