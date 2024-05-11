--- Created by shimin.
--- DateTime: 2023/3/6 11:21
--- 黑骑士活动数据

local ActBlackKnightInfo = BaseClass("ActBlackKnightInfo")

function ActBlackKnightInfo:__init()
    self.activityST = 0--活动开启时间 long  
    self.activityET = 0--活动结束时间 long  
    self.siegeST = 0--盟主开启攻城时间 long  
    self.siegeET = 0-- 攻城结束时间 long
    self.state = BlackKnightState.END --联盟状态 int   
    self.rewardTime = 0--活动结束后排行榜发奖时间 long  
    self.userState = BlackKnightUserState.NORMAL --玩家状态 int
    self.allKill = 0-- 联盟击杀积分  long
    self.allRank = 0--联盟排行 int
    self.userKill = 0--玩家击杀积分  int
    self.userRank = 0-- 玩家排行  int
    self.round = 0--怪物攻城轮次 int
    self.pointId = 0 --出兵位置 int
    self.nextRoundTime = 0 --下轮怪物攻城时间 long 
    self.monsterInfo = {} --本轮怪物信息 SFSArr {{ monsterId = 怪物id(string), count = 怪物数量(int)}}
    self.power = 0 --本轮怪物战力 int
end

function ActBlackKnightInfo:__delete()
    self.activityST = 0--活动开启时间 long  
    self.activityET = 0--活动结束时间 long  
    self.siegeST = 0--盟主开启攻城时间 long  
    self.siegeET = 0-- 攻城结束时间 long
    self.state = BlackKnightState.END --联盟状态 int   
    self.rewardTime = 0--活动结束后排行榜发奖时间 long  
    self.userState = BlackKnightUserState.NORMAL --玩家状态 int
    self.allKill = 0-- 联盟击杀积分  long
    self.allRank = 0--联盟排行 int
    self.userKill = 0--玩家击杀积分  int
    self.userRank = 0-- 玩家排行  int
    self.round = 0--怪物攻城轮次 int
    self.pointId = 0 --出兵位置 int
    self.nextRoundTime = 0 --下轮怪物攻城时间 long 
    self.monsterInfo = {} --本轮怪物信息 SFSArr {{ monsterId = 怪物id(string), count = 怪物数量(int)}}
    self.power = 0 --本轮怪物战力 int
end

function ActBlackKnightInfo:ParseInfo(message)
    if message["activityST"] ~= nil then
        self.activityST = message["activityST"]
    end
    if message["activityET"] ~= nil then
        self.activityET = message["activityET"]
    end
    if message["siegeST"] ~= nil then
        self.siegeST = message["siegeST"]
    end
    if message["siegeET"] ~= nil then
        self.siegeET = message["siegeET"]
    end
    if message["state"] ~= nil then
        self.state = message["state"]
    end
    if message["rewardTime"] ~= nil then
        self.rewardTime = message["rewardTime"]
    end
    if message["userState"] ~= nil then
        self.userState = message["userState"]
    end
    self.allKill = message["allKill"] or 0
    self.allRank = message["allRank"] or 0
    if message["userKill"] ~= nil then
        self.userKill = message["userKill"]
    end
    if message["userRank"] ~= nil then
        self.userRank = message["userRank"]
    end
    if message["round"] ~= nil then
        self.round = message["round"]
    end
    if message["x"] ~= nil and message["y"] ~= nil then
        self.pointId = SceneUtils.TileXYToIndex(message["x"], message["y"], ForceChangeScene.World)
    else
        self.pointId = 0
    end
    if message["nextRoundTime"] ~= nil then
        self.nextRoundTime = message["nextRoundTime"]
    end
    if message["monsterInfo"] ~= nil then
        self.monsterInfo = message["monsterInfo"]
    end
    if message["power"] ~= nil then
        self.power = message["power"]
    end
end

function ActBlackKnightInfo:ChangePoint(message)
    if message["pointId"] ~= nil then
        self.pointId = message["pointId"]
    end
end

return ActBlackKnightInfo