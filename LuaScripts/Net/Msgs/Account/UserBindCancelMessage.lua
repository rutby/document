---
--- Created by shimin.
--- DateTime: 2020/10/12 12:28
---
local UserBindCancelMessage = BaseClass("UserBindCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param,cancelType)
    base.OnCreate(self)
    DataCenter.UserBindManager:SetParam(param)
    if param ~= nil then
        self.sfsObj:PutUtfString("type", tostring(param.type))
    end
    if cancelType~=nil then
        self.sfsObj:PutInt("cancelType",cancelType)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["cancelType"]~=nil then
        UIUtil.ShowTipsId(208275)
        CS.UnityEngine.PlayerPrefs.DeleteAll()
        CS.ApplicationLaunch.Instance:Quit()
    end
    --DataCenter.UserBindManager:UserBindCancelHandle(t)
end

UserBindCancelMessage.OnCreate = OnCreate
UserBindCancelMessage.HandleMessage = HandleMessage

return UserBindCancelMessage