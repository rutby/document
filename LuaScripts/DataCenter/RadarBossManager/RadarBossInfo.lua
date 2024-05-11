--- Created by shimin
--- DateTime: 2023/9/25 17:25
--- 雷达召唤海盗船信息

local RadarBossInfo = BaseClass("RadarBossInfo");

function RadarBossInfo:__init()
    self.monsterPointId = 0
    self.monsterUuid = ""
end

function RadarBossInfo:__delete()
    self.monsterPointId = 0
    self.monsterUuid = ""
end


function RadarBossInfo:ParseData(message)
    if message == nil then
        return
    end
    if message["monsterPointId"] ~= nil then
        self.monsterPointId = message["monsterPointId"]
    end
    if message["monsterUuid"] ~= nil then
        self.monsterUuid = message["monsterUuid"]
    end
end


return RadarBossInfo