---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/28 15:54
---
local GetNewUserInfoMessage = BaseClass("GetNewUserInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,uid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("uid",uid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.PlayerInfoDataManager:RefreshPlayerData(t)

        EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc)
		
		local userMgr = ChatManager2:GetInstance().User
		userMgr:CheckUserNameAndPicVer(t.uid, t.abbr, t.name, t.picVer, t.pic)
    end
end

GetNewUserInfoMessage.OnCreate = OnCreate
GetNewUserInfoMessage.HandleMessage = HandleMessage

return GetNewUserInfoMessage