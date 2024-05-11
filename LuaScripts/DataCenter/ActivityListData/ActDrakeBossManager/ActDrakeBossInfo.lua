--- Created by shimin.
--- DateTime: 2023/10/30 21:00
--- 德雷克活动数据

local ActDrakeBossInfo = BaseClass("ActDrakeBossInfo")

function ActDrakeBossInfo:__init()
    self.uuid = 0--世界上野怪uuid
    self.pointId = 0--世界上野怪坐标点
end

function ActDrakeBossInfo:__delete()
    self.uuid = 0--世界上野怪uuid
    self.pointId = 0--世界上野怪坐标点
end

function ActDrakeBossInfo:ParseInfo(message)
    if message["hasBoss"] then
        self:UpdateInfo(message)
    else
        self.uuid = 0
        self.pointId = 0
    end
end

function ActDrakeBossInfo:UpdateInfo(message)
    if message["uuid"] ~= nil then
        self.uuid = message["uuid"]
    end
    if message["pointId"] ~= nil then
        self.pointId = message["pointId"]
    end
end

--是否有boss
function ActDrakeBossInfo:HasBoss()
    return self.uuid ~= 0 and self.pointId ~= 0
end

return ActDrakeBossInfo