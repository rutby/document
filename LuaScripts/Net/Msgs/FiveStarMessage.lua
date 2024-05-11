---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/1/25 14:21
---
local FiveStarMessage = BaseClass("FiveStarMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,index, message)
    base.OnCreate(self)
    self.sfsObj:PutInt("platforom",index)
    self.sfsObj:PutUtfString("roastMsg", message)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    end
end

FiveStarMessage.OnCreate = OnCreate
FiveStarMessage.HandleMessage = HandleMessage

return FiveStarMessage