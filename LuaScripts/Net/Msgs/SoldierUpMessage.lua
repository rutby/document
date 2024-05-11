---
--- Created by shimin.
--- DateTime: 2020/8/3 20:55
---
local SoldierUpMessage = BaseClass("SoldierUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    if param ~= nil then
        self.sfsObj:PutUtfString("curArmyId", tostring(param.curArmyId))--将要晋级的配置id
        self.sfsObj:PutBool("isGold", param.isGold) --是否使用钻石 false：不使用 true:使用
        self.sfsObj:PutInt("num", param.num) --晋级的数量
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ArmyManager:SoldierUpMessageHandle(t)
end

SoldierUpMessage.OnCreate = OnCreate
SoldierUpMessage.HandleMessage = HandleMessage

return SoldierUpMessage