--- Created by shimin.
--- DateTime: 2023/1/12 12:57
--- 改变性别

local UserModifySexMessage = BaseClass("UserModifySexMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserModifySexMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("sex", param.sex)
    end
end

function UserModifySexMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    SexUtil.UserModifySexHandle(message)
end

return UserModifySexMessage