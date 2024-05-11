---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 15:06
---

local GloryWarData = BaseClass("GloryWarData")
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.seasonRank = 0 -- 赛季积分排名
    self.seasonScore = 0 -- 赛季积分
    self.readyTime = 0 -- 准备阶段开始时间
    self.startTime = 0 -- 宣战开始时间
    self.endTime = 0 -- 宣战结束时间
    self.avoidWarInfo =
    {
        setTime = 0, -- 上次设置时间
        avoidTimeInfo = "", -- 避战时间范围
    }
end

local function ParseServerData(self, serverData)
    if serverData.seasonRank then
        self.seasonRank = serverData.seasonRank
    end
    if serverData.seasonScore then
        self.seasonScore = serverData.seasonScore
    end
    if serverData.readyTime then
        self.readyTime = serverData.readyTime
    end
    if serverData.startTime then
        self.startTime = serverData.startTime
    end
    if serverData.endTime then
        self.endTime = serverData.endTime
    end
    if serverData.avoidWarInfo then
        self.avoidWarInfo = serverData.avoidWarInfo
    end
end

--获取显示的休战时间
function GloryWarData:GetShowAvoidTime()
    local result = ""
    if self.avoidWarInfo ~= nil then
        result = string.gsub(self.avoidWarInfo.avoidTimeInfo, "_", "-")
    end
    if result == "" or result == "0" then
        local list = DataCenter.GloryManager:GetAllShowAvoidTime()
        if list[1] ~= nil then
            return list[1].showTime
        end
        return Localization:GetString(GameDialogDefine.Nothing)
    end
    return result
end

--获取修改休战时间冷却结束时间(毫秒)
function GloryWarData:GetChangeAvoidEndTime()
    local result = LuaEntry.DataConfig:TryGetNum("plant_battlerule", "k2") * 1000
    if self.avoidWarInfo ~= nil then
        result = result + self.avoidWarInfo.setTime + result
    end
    return result
end

GloryWarData.__init = __init

GloryWarData.ParseServerData = ParseServerData

return GloryWarData