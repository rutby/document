---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/7 18:09
---
local AllianceWarInfo = BaseClass("AllianceWarInfo")
local WorldMarchData = require "DataCenter.WorldMarchDataManager.WorldMarchData"
local function __init(self)
    self.uuid =""
    self.type = 0
    self.worldId =0
    self.attackPointId = 0
    self.attackUid = ""
    self.attackName = ""
    self.attackIcon =""
    self.attackAllianceId = ""
    self.attackAllianceAbbr =""
    self.targetPointId = 0
    self.targetUid = ""
    self.targetName = ""
    self.targetIcon =""
    self.targetIconVer = 0    
    self.monthCardEndTime = 0
    self.targetAllianceId = ""
    self.targetAllianceAbbr =""
    self.targetContentId = 0
    self.createTime =0
    self.waitTime =0
    self.marchTime =0
    self.currentSoldiers = 0
    self.maxSoldiers =0
    self.assemblyMarchMax =0
    self.memberList={}
    self.leaderMarch = nil
    self.waitMemberTime = 0
    self.server = 0
    self.srcServer = 0
    self.headSkinId = nil
    self.headSkinET = nil
    self.leaderMarchInfo = nil
end

local function __delete(self)
    self.uuid =nil
    self.type = nil
    self.worldId =nil
    self.attackPointId = nil
    self.attackUid = nil
    self.attackName = nil
    self.attackIcon =nil
    self.attackAllianceId = nil
    self.attackAllianceAbbr =nil
    self.targetPointId = nil
    self.targetUid = nil
    self.targetName = nil
    self.targetIcon =nil
    self.targetIconVer = nil
    self.targetAllianceId = nil
    self.targetAllianceAbbr =nil
    self.targetContentId = nil
    self.createTime =nil
    self.waitTime =nil
    self.marchTime =nil
    self.currentSoldiers =nil
    self.maxSoldiers =nil
    self.assemblyMarchMax =nil
    self.memberList=nil
    self.leaderMarch = nil
    self.waitMemberTime = nil
    self.monthCardEndTime = nil
    self.headSkinId = nil
    self.headSkinET = nil
end
local function ParseData(self,message)
    if message ==nil then
        return
    end
    if message["uuid"]~=nil then
        self.uuid = message["uuid"]
    end
    if message["type"]~=nil then
        self.type = message["type"]
    end
    if message["worldId"]~=nil then
        self.worldId = message["worldId"]
    end
    if message["attackPointId"]~=nil then
        self.attackPointId = message["attackPointId"]
    end
    if message["attackUid"]~=nil then
        self.attackUid = message["attackUid"]
    end
    if message["attackName"]~=nil then
        self.attackName = message["attackName"]
    end
    if message["attackIcon"]~=nil then
        self.attackIcon = message["attackIcon"]
    end
    if message["attackAllianceId"]~=nil then
        self.attackAllianceId = message["attackAllianceId"]
    end
    if message["attackAllianceAbbr"]~=nil then
        self.attackAllianceAbbr = message["attackAllianceAbbr"]
    end
    if message["targetUuid"]~=nil then
        self.targetUuid = message["targetUuid"]
    end
    if message["targetPointId"]~=nil then
        self.targetPointId = message["targetPointId"]
    end
    if message["targetUid"]~=nil then
        self.targetUid = message["targetUid"]
    end
    if message["targetName"]~=nil then
        self.targetName = message["targetName"]
    end
    if message["targetIcon"]~=nil then
        self.targetIcon = message["targetIcon"]
    end
    if message["targetIconVer"]~=nil then
        self.targetIconVer = message["targetIconVer"]
    end
    if message["targetAAbbr"]~=nil then
        self.targetAllianceAbbr = message["targetAAbbr"]
    end
    if message["targetAId"]~=nil then
        self.targetAllianceId = message["targetAId"]
    end
    if message["targetContentId"]~=nil then
        self.targetContentId = message["targetContentId"]
    end
    if message["currSoldiers"]~=nil then
        self.currentSoldiers = message["currSoldiers"]
    end
    if message["maxSoldiers"]~=nil then
        self.maxSoldiers = message["maxSoldiers"]
    end
    if message["assemblyMarchMax"]~=nil then
        self.assemblyMarchMax = message["assemblyMarchMax"]
    end
    if message["createTime"]~=nil then
        self.createTime = message["createTime"]
    end
    if message["waitTime"]~=nil then
        self.waitTime = message["waitTime"]
    end
    if message["marchTime"]~=nil then
        self.marchTime = message["marchTime"]
    end
    if message["waitMemberTime"]~=nil then
        self.waitMemberTime = message["waitMemberTime"]
    end
    
    if message["leaderMarch"]~=nil then
        local data = AllianceWarLeaderData.New()
        data:ParseData(message["leaderMarch"])
        local marchData = WorldMarchData.New()
        marchData:UpdateWorldMarch(message["leaderMarch"])
        self.leaderMarch = data
        self.leaderMarchInfo = marchData
    end

    if message["targetMonthCardEndTime"] then
        self.monthCardEndTime = message["targetMonthCardEndTime"]
    end
    if message["headSkinId"] ~= nil  then
        self.headSkinId = message["headSkinId"]
    end
    if message["headSkinET"] ~= nil  then
        self.headSkinET = message["headSkinET"]
    end
    if message["server"] then
        self.server = message["server"]
    end
    if message["srcServer"] then
        self.srcServer = message["srcServer"]
    end
    
    if message["members"]~=nil then
        self.memberList={}
        local list = message["members"]
        table.walk(list,function (k,v)
            local data = AllianceWarMemberData.New()
            data:ParseData(v)
            if data.uuid~=nil and data.uuid~= "" then
                self.memberList[data.uuid] = data
            end
        end)
    end
end

local function GetHeadBgImg(self)
    --local headBgImg = nil
    --
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    --if self.monthCardEndTime and self.monthCardEndTime > serverTimeS then
    --    headBgImg = "Common_playerbg_golloes"
    --end
    --
    --if headBgImg and headBgImg ~= "" then
    --    return string.format(LoadPath.CommonNewPath,headBgImg)
    --end
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, self.monthCardEndTime and self.monthCardEndTime > serverTimeS)
    return headBgImg
end

local function CheckCanJoinAllianceWar(self)
    local canJoin = true --是否可加入
    local isSelfRally=  false --是否是自己的集结
    --队长
    if self.leaderMarch.ownerUid == LuaEntry.Player.uid then
        return false, true
    end
    --目标是自己
    if self.targetUid == LuaEntry.Player.uid then
        return false, false
    end
    --是防守方
    if LuaEntry.Player.allianceId ~= self.attackAllianceId then
        return false, false
    end
    --满员
    local count = table.count(self.memberList) + 1
    if count >= self.assemblyMarchMax then
        return false, false
    end
    --是否在等待时间内
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.waitTime then
        return false, false
    end
    for k,v in pairs(self.memberList) do
        if v.ownerUid == LuaEntry.Player.uid then
            canJoin = false
        end
    end
    return canJoin,isSelfRally
end

AllianceWarInfo.__init = __init
AllianceWarInfo.__delete = __delete
AllianceWarInfo.ParseData = ParseData
AllianceWarInfo.GetHeadBgImg = GetHeadBgImg
AllianceWarInfo.CheckCanJoinAllianceWar =CheckCanJoinAllianceWar
return AllianceWarInfo