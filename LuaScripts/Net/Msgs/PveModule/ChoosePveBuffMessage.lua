local ChoosePveBuffMessage = BaseClass("ChoosePveBuffMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, levelId, triggerId, index)
    base.OnCreate(self)
    self.sfsObj:PutInt("level", levelId)
    self.sfsObj:PutInt("trigger", triggerId)
    self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BattleLevel:OnChoosePveBuff(t)
end

ChoosePveBuffMessage.OnCreate = OnCreate
ChoosePveBuffMessage.HandleMessage = HandleMessage

return ChoosePveBuffMessage