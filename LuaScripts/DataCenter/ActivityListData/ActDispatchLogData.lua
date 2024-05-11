---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 3/4/2024 下午7:09
---
local ActDispatchLogData = BaseClass("ActDispatchLogData")


function ActDispatchLogData:__init()
    self.uuid = 0
    self.createTime = 0
    self.type = 0 -- 1 偷取  2帮助
    self.pointId = 0
    self.uid= ""
    self.name = ""
    self.picVer = 0
    self.pic = ""
    self.allianceAbbr = ""
    self.headSkinId = 0
    self.headSkinET = 0
    self.missionUuid = 0
    self.missionId = 0
end

function ActDispatchLogData:__delete()
    self.uuid = 0
    self.createTime = 0
    self.type = 0
    self.pointId = 0
    self.uid= ""
    self.name = ""
    self.picVer = 0
    self.pic = ""
    self.allianceAbbr = ""
    self.headSkinId = 0
    self.headSkinET = 0
    self.missionUuid = 0
    self.missionId = 0
end

function ActDispatchLogData:RefreshData(message)
    if message == nil then
        return
    end
    if message["uuid"]~=nil then
        self.uuid = message["uuid"]
    end
    if message["createTime"]~=nil then
        self.createTime = message["createTime"]
    end
    if message["type"]~=nil then
        self.type = message["type"]
    end
    if message["pointId"]~=nil then
        self.pointId = message["pointId"]
    end
    if message["uid"]~=nil then
        self.uid = message["uid"]
    end
    if message["name"]~=nil then
        self.name = message["name"]
    end
    if message["picVer"]~=nil then
        self.picVer = message["picVer"]
    end
    if message["pic"]~=nil then
        self.pic = message["pic"]
    end
    if message["allianceAbbr"]~=nil then
        self.allianceAbbr = message["allianceAbbr"]
    end
    if message["headSkinId"]~=nil then
        self.headSkinId = message["headSkinId"]
    end
    if message["headSkinET"]~=nil then
        self.headSkinET = message["headSkinET"]
    end
    if message["missionUuid"]~=nil then
        self.missionUuid = message["missionUuid"]
    end
    if message["missionId"]~=nil then
        self.missionId = message["missionId"]
    end 
end

return ActDispatchLogData