--- Created by shimin.
--- DateTime: 2023/3/6 20:36
--- 黑骑士活动个人杀怪排行数据

local ActBlackKnightUserRankInfo = BaseClass("ActBlackKnightUserRankInfo")

function ActBlackKnightUserRankInfo:__init()
    self.abbr = ""--联盟简称 string  
    self.allianceName = 0--联盟名字 string  
    self.score = 0--分数 long  
    self.rank = 0--排名 int
    self.icon = ""--联盟图标 string  
    self.uid = ""--玩家uid
    self.pic = ""--玩家头像
    self.picVer = 0--玩家头像
    self.name = ""--完加名字
    self.headSkinId = 0
    self.headSkinET = 0
end

function ActBlackKnightUserRankInfo:__delete()
    self.abbr = ""--联盟简称 string  
    self.allianceName = 0--联盟名字 string  
    self.score = 0--分数 long  
    self.rank = 0--排名 int
    self.icon = ""--联盟图标 string  
    self.uid = ""--玩家uid
    self.pic = ""--玩家头像
    self.picVer = 0--玩家头像
    self.name = ""--完加名字
    self.headSkinId = 0
    self.headSkinET = 0
end

function ActBlackKnightUserRankInfo:ParseInfo(message)
    if message["abbr"] ~= nil then
        self.abbr = message["abbr"]
    end
    if message["alName"] ~= nil then
        self.allianceName = message["alName"]
    end
    if message["score"] ~= nil then
        self.score = message["score"]
    end
    if message["rank"] ~= nil then
        self.rank = message["rank"]
    end
    if message["icon"] ~= nil then
        self.icon = message["icon"]
    end
    if message["uid"] ~= nil then
        self.uid = message["uid"]
    end
    if message["pic"] ~= nil then
        self.pic = message["pic"]
    end
    if message["picver"] ~= nil then
        self.picVer = message["picver"]
    end
    if message["name"] ~= nil then
        self.name = message["name"]
    end
    if message["headSkinId"] ~= nil then
        self.headSkinId = message["headSkinId"]
    end
    if message["headSkinET"] ~= nil then
        self.headSkinET = message["headSkinET"]
    end
end

return ActBlackKnightUserRankInfo