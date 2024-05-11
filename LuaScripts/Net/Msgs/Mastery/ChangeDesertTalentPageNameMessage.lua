---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
--- 天赋页改名
local ChangeDesertTalentPageNameMessage = BaseClass("ChangeDesertTalentPageNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,page,name)
    base.OnCreate(self)
	self.sfsObj:PutInt("page",page)
    self.sfsObj:PutUtfString("name",name)
end

local function HandleMessage(self, t)

    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.MasteryManager:HandleChangePageName(t)
    end
end

ChangeDesertTalentPageNameMessage.OnCreate = OnCreate
ChangeDesertTalentPageNameMessage.HandleMessage = HandleMessage

return ChangeDesertTalentPageNameMessage