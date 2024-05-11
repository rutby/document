--[[
    举报头像
]]

local ReportCustomHeadPicCommand = BaseClass("ReportCustomHeadPicCommand", SFSBaseMessage)

local function OnCreate(self, uid)

    self.sfsObj:PutUtfString("uid", tostring(uid))
end


local function HandleMessage(self, msg)

    ChatInterface.flyHint(ChatInterface.getString("105781"))
end


ReportCustomHeadPicCommand.OnCreate = OnCreate
ReportCustomHeadPicCommand.HandleMessage = HandleMessage

----------------------------------------------------------------
-- 兼容代码
local function OnSend(param)
    SFSNetwork.SendMessage(MsgDefines.REPORT_PICVER, param)
end

function ReportCustomHeadPicCommand.create(uid)
    local ret = {}
    ret.send = OnSend
    ret.uid = uid
    return ret
end
----------------------------------------------------------------

return ReportCustomHeadPicCommand