---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 
--- DateTime: 
---，
---

local CaravanRecordSendArr = BaseClass("CaravanRecordSendArr")

local function __init(self)
    self.uid = ""
    self.name = ""
    self.serverId = 0
    self.pic = ""
    self.picVer = 0
    self.headSkinId = nil
    self.headSkinET = nil
    self.count = nil    --发送次数
    self.pointId = 0    --大本坐标，大于0有效
end

local function __delete(self)
    self.uid = ""
    self.name = ""
    self.serverId = 0
    self.pic = ""
    self.picVer = 0
    self.headSkinId = nil
    self.headSkinET = nil
    self.count = nil    --发送次数
    self.pointId = 0    --大本坐标，大于0有效
end

local function ParseData(self,message)
    if not message then
        return
    end
    
    if message.uid then
        self.uid = message.uid
    end
    if message.name then
        self.name = message.name
    end
    if message.serverId then
        self.serverId = message.serverId
    end
    if message.pic then
        self.pic = message.pic
    end
    if message.picVer then
        self.picVer = message.picVer
    end
    if message.headSkinId then
        self.headSkinId = message.headSkinId
    end
    if message.headSkinET then
        self.headSkinET = message.headSkinET
    end
    if message.count then
        self.count = message.count
    end
    if message.pointId then
        self.pointId = message.pointId
    end
end

CaravanRecordSendArr.__init = __init
CaravanRecordSendArr.__delete = __delete
CaravanRecordSendArr.ParseData = ParseData
return CaravanRecordSendArr