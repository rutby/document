--- Created by shimin
--- DateTime: 2023/3/21 12:07
--- 王座嘉奖记录详情

local PresentRecordInfoDetail = BaseClass("PresentRecordInfoDetail")
local Localization = CS.GameEntry.Localization

function PresentRecordInfoDetail:__init()
    self.presentId = 0--int 礼物id
    self.sendTime = 0--long 发送时间
    self.toUid = ""--string 发送uid
    self.name = ""--string 玩家名称
    self.abbr = ""--string 玩家联盟简称
end
function PresentRecordInfoDetail:__delete()
    self.presentId = 0--int 礼物id
    self.sendTime = 0--long 发送时间
    self.toUid = ""--string 发送uid
    self.name = ""--string 玩家名称
    self.abbr = ""--string 玩家联盟简称
end

function PresentRecordInfoDetail:ParseData(message)
    if message == nil then
        return
    end
    if message["presentId"] then
        self.presentId = message["presentId"]
    end
    if message["sendTime"] then
        self.sendTime = message["sendTime"]
    end
    if message["toUid"] then
        self.toUid = message["toUid"]
    end
    if message["name"] then
        self.name = message["name"]
    end
    if message["abbr"] then
        self.abbr = message["abbr"]
    end
end

function PresentRecordInfoDetail:GetPlayerName()
    if self.abbr ~= nil and self.abbr ~= "" then
        return "["..self.abbr.."]".. self.name
    end
    return self.name
end

function PresentRecordInfoDetail:GetPacketName()
    local result = ""
    local template = DataCenter.WonderGiftTemplateManager:GetTemplate(self.presentId)
    if template ~= nil then
        result = Localization:GetString(template.name) 
    end
    return result
end


return PresentRecordInfoDetail