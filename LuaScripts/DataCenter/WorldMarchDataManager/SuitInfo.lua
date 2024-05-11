---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/3/27 11:20
---
local SuitInfo = BaseClass("SuitInfo")

local function __init(self)
    self.carIndex =0
    self.suitType = 0
    self.skillInfos = {}
    self.equipInfos = {}
end

local function __delete(self)
    self.carIndex =0
    self.suitType = 0
    self.skillInfos = {}
    self.equipInfos = {}
end

local function UpdateSuitInfo(self,proto)
    if proto ==nil then
        return
    end
    self.carIndex = proto.carIndex
    self.suitType = proto.suitType
    self.skillInfos = proto.skillInfos
    self.equipInfos = proto.equipInfos
end
SuitInfo.__init = __init
SuitInfo.__delete = __delete
SuitInfo.UpdateSuitInfo = UpdateSuitInfo

return SuitInfo