---
--- 随机池
---
---@class Common.StringPool
local StringPool = BaseClass("StringPool")

--local STAT={}
--local rapidjson = require "rapidjson"

function StringPool:__init(str,separator)
    if not string.IsNullOrEmpty(str) then
        self.pool = string.split(str,separator)
        self.poolLength = #self.pool
    end
end

function StringPool:__delete()
    self.pool = nil
end


function StringPool:GetRandom()
    if self.pool then
        local rand=math.random(self.poolLength)
        --if not STAT[self.poolLength] then
        --    STAT[self.poolLength]={}
        --end
        --if not STAT[self.poolLength][rand] then
        --    STAT[self.poolLength][rand] = 0
        --end
        --STAT[self.poolLength][rand] = STAT[self.poolLength][rand] + 1
        --local json = rapidjson.encode(STAT)
        --Logger.LogError(json)
        return self.pool[rand]
    end
    return nil
end




return StringPool