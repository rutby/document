---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/10 12:17
---
local AllianceWarMemberData = BaseClass("AllianceWarMemberData")

local function __init(self)
    self.uuid =0
    self.ownerUid =""
    self.ownerName =""
    self.status = MarchStatus.DEFAULT
    self.startTime = 0
    self.endTime =0
    self.teamUuid = 0 
    self.ownerIcon=""
    self.ownerIconVer = 0
    self.armyInfos = {}
    self.monthCardEndTime = 0
    self.headSkinId = nil
    self.headSkinET = nil
end

local function __delete(self)
    self.uuid = nil
    self.ownerUid =nil
    self.ownerName =nil
    self.status = nil
    self.startTime = nil
    self.endTime =nil
    self.teamUuid = nil
    self.ownerIcon =nil
    self.ownerIconVer = nil
    self.armyInfos = nil
    self.monthCardEndTime = nil
end
local function ParseData(self,message)
    if message ==nil then
        return
    end
    if message["uuid"]~=nil then
        self.uuid = message["uuid"]
    end
    if message["ownerUid"]~=nil then
        self.ownerUid = message["ownerUid"]
    end
    if message["ownerName"]~=nil then
        self.ownerName = message["ownerName"]
    end
    if message["status"]~=nil then
        self.status = message["status"]
    end
    if message["startTime"]~=nil then
        self.startTime = message["startTime"]
    end
    if message["endTime"]~=nil then
        self.endTime = message["endTime"]
    end
    if message["teamUuid"]~=nil then
        self.teamUuid = message["teamUuid"]
    end
    if message["ownerIcon"]~=nil then
        self.ownerIcon = message["ownerIcon"]
    end
    if message["ownerIconVer"]~=nil then
        self.ownerIconVer = message["ownerIconVer"]
    end
    if message["armyInfo"]~=nil then
        local armyCombatUnit = PBController.ParsePb1(message["armyInfo"], "protobuf.ArmyCombatUnit")
        self.armyInfos.soldiers = armyCombatUnit.armyInfo["soldiers"] or {}
        self.armyInfos.heros = armyCombatUnit.armyInfo["heroes"] or {}
    end
    if message["monthCardEndTime"] then
        self.monthCardEndTime = message["monthCardEndTime"]
    end
    if message["headSkinId"] ~= nil  then
        self.headSkinId = message["headSkinId"]
    end
    if message["headSkinET"] ~= nil  then
        self.headSkinET = message["headSkinET"]
    end
end

local function GetHeadBgImg(self)
    --local headBgImg = nil
    --
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    --if self.monthCardEndTime and self.monthCardEndTime > serverTimeS then
    --    headBgImg = "Common_playerbg_golloes"
    --end
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, self.monthCardEndTime and self.monthCardEndTime > serverTimeS)
    return headBgImg
    --if headBgImg and headBgImg ~= "" then
    --    return string.format(LoadPath.CommonNewPath,headBgImg)
    --end
    
end



AllianceWarMemberData.__init = __init
AllianceWarMemberData.__delete = __delete
AllianceWarMemberData.ParseData = ParseData
AllianceWarMemberData.GetHeadBgImg = GetHeadBgImg
return AllianceWarMemberData