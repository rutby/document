---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/31 16:57
---
local NickNameChangeMessage = BaseClass("NickNameChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,nickName)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("nickName",nickName)
end

local function HandleMessage(self, t)

    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
		if t["gold"]~=nil then
			LuaEntry.Player.gold = t["gold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end
		UIUtil.ShowTipsId(280032) 
        if t["nickName"]~=nil then
            DataCenter.PlayerInfoDataManager:ChangeSelfName(t["nickName"])
            LuaEntry.Player:SetName(t['nickName'])
        end
		
		if t["lastUpdateTime"] then
			LuaEntry.Player:SetLastUpdateTime(t["lastUpdateTime"])
		end
        LuaEntry.Player.renameTime = LuaEntry.Player.renameTime + 1
        DataCenter.ChangeNameAndPicManager:CheckSendGetUploadPicActivityInfo()
        EventManager:GetInstance():Broadcast(EventId.NickNameChangeEvent)
    end
end

NickNameChangeMessage.OnCreate = OnCreate
NickNameChangeMessage.HandleMessage = HandleMessage

return NickNameChangeMessage