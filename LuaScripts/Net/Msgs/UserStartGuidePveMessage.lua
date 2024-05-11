--- Created by shimin.
--- DateTime: 2023/8/30 18:43
--- 引导进入pve

local UserStartGuidePveMessage = BaseClass("UserStartGuidePveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserStartGuidePveMessage:OnCreate(param)
    base.OnCreate(self)
    self.sfsObj:PutInt("id", param.id)
end

function UserStartGuidePveMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnStartLevelMessage(message)
end

return UserStartGuidePveMessage