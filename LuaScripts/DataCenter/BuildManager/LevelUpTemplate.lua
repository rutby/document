---
--- Created by shimin
--- DateTime: 2021/6/17 20:38
---
local LevelUpTemplate = BaseClass("LevelUpTemplate")

local function __init(self)
    self.id = 0 
    self.describe = "" 
    self.unlockList = {}--解锁数据
end

local function __delete(self)
    self.id = nil
    self.describe = nil
    self.unlockList = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.describe = tostring(row:getValue("describe"))
    local building = row:getValue("building")
    if building ~= nil and building ~= "" then
        local spl = string.split(building,";")
        for k,v in ipairs(spl) do
            local spl1 = string.split(v,",")
            local count = table.count(spl1)
            local param = {}
            param.unlockType = BuildLevelUpUnlockType.Build
            if count > 1 then
                param.id = tonumber(spl1[1])
                param.showType = tonumber(spl1[2])
            end
            if count > 2 then
                param.addNum = tonumber(spl1[3])
            end
            table.insert(self.unlockList,param)
        end
    end
end

LevelUpTemplate.__init = __init
LevelUpTemplate.__delete = __delete
LevelUpTemplate.InitData = InitData

return LevelUpTemplate