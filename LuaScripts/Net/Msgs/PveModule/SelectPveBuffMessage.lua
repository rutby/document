local SelectPveBuffMessage = BaseClass("SelectPveBuffMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

local base = SFSBaseMessage

local function OnCreate(self, levelId, triggerId, buffGroupId, buffId)
    base.OnCreate(self)
    self.sfsObj:PutInt("level", levelId)
    self.sfsObj:PutInt("trigger", triggerId)
    self.sfsObj:PutInt("buffGroupId", buffGroupId)
    self.sfsObj:PutInt("buffId", buffId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
        return
    end
    
    DataCenter.BattleLevel:OnSelectPveBuffMessage(t)
end

SelectPveBuffMessage.OnCreate = OnCreate
SelectPveBuffMessage.HandleMessage = HandleMessage

return SelectPveBuffMessage