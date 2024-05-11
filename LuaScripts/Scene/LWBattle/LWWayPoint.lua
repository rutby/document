
local RandomGenZombieTask = require "Scene.LWBattle.Scene.RandomGenZombieTask"
local FixPointGenZombieTask = require "Scene.LWBattle.Scene.FixPointGenZombieTask"


---路径点 数据类
---@class Scene.LWBattle.LWWayPoint
local LWWayPoint = BaseClass("LWWayPoint")
local ZombieCrowdID = {203,204,208,209}
local TotalWayPointsPerScene = 10
function LWWayPoint:__init(battleMgr,cfg,sceneMeta)
    self.battleMgr = battleMgr
    self.order = cfg.max_blood
    self.metaId = cfg.refresh_cd
    self.pos = Vector3.New(cfg.t.x,cfg.t.y,cfg.t.z)
    if sceneMeta.splitWayPoint == nil then
        local spl = string.split(sceneMeta:getValue("path_point"),",")
        local map = {}
        for _, str in ipairs(spl)do
            local inner = string.split(str,"|")
            if table.count(inner) == 2 then
                map[tonumber(inner[1])] = tonumber(inner[2])
            end
        end
        sceneMeta.splitWayPoint = map
    end
    
    self.sceneMeta = sceneMeta
    
    self.metaId = sceneMeta.splitWayPoint[self.order] or 1
    self.autoMonsterGroupType = self.order == 1 and "start" or (self.order == (TotalWayPointsPerScene-1) and "final" or "default") -- (TotalWayPointsPerScene-1)是特殊处理，策划希望最后空出一个路点
    self.meta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_PathPoint),self.metaId)
    if(self.meta == nil) then
        Logger.LogError("Error config waypoint.order:"..self.order.." scene:"..sceneMeta.id.." scene wayPoint:"..sceneMeta.path_point.." wayPointId:"..self.metaId)
    end

    local pointLogic = string.split(self.meta.point_type,",")
    local pointParam = string.split(self.meta.para,",")

    self.triggers = {}
    self.limit = 0
    
    for i, logicType in ipairs(pointLogic) do
        local param = pointParam[i]
        self.triggers[i] = {}
        self.triggers[i].type = logicType
        self.triggers[i].args = {}
        if logicType == "2" then
            local para = string.split(param,"|")
            if #para ~= 4 then
                Logger.LogError("LWWayPoint Init Error! 路点触发器参数错误，路点ID："..self.metaId.." 参数："..param)
            end
            self.triggers[i].args.limit = tonumber(para[1])
            self.triggers[i].args.interval = tonumber(para[2])
            self.triggers[i].args.r1 = tonumber(para[3])
            self.triggers[i].args.r2 = tonumber(para[4])
            self.limit = self.limit + self.triggers[i].args.limit
        elseif logicType == "3" then
            local spl = string.split(param,"_")
            for _, splPara in ipairs(spl) do
                local para = string.split(splPara,"|")
                if #para ~= 3 then
                    Logger.LogError("LWWayPoint Init Error! 路点触发器参数错误，路点ID："..self.metaId.." 参数："..param)
                end
                local areaArgs = {["pointId"] = tonumber(para[1]),
                                  ["limit"] = tonumber(para[2]),
                                  ["interval"] = tonumber(para[3]),}
                table.insert(self.triggers[i].args, areaArgs)
                self.limit = self.limit + areaArgs.limit
            end
        end
    end
end

function LWWayPoint:Execute()
    --if self.meta
    --Logger.Log("execute point "..self.order)
    for _, trigger in ipairs(self.triggers)do
        if trigger.type == "2" then
            local limit = trigger.args.limit
            local interval = trigger.args.interval
            local r1 = trigger.args.r1
            local r2 = trigger.args.r2

            local task = RandomGenZombieTask.New( self.battleMgr,limit,interval,r1,r2,self.sceneMeta,self.autoMonsterGroupType, self.metaId)
            task.id = self.battleMgr:GetNextObjId()
            self.battleMgr:AddGenZombieTask(task)
            for _, pid in ipairs(ZombieCrowdID) do
                if self.metaId == pid then
                    EventManager:GetInstance():Broadcast(EventId.BattleZombiesEnter)
                end
            end
        end

        if trigger.type == "3" then
            for _, areaArgs in ipairs(trigger.args) do
                local pointId = areaArgs.pointId
                local limit = areaArgs.limit
                local interval = areaArgs.interval

                local task = FixPointGenZombieTask.New(self.battleMgr,limit,interval,pointId,self.sceneMeta, self.metaId)
                task.id = self.battleMgr:GetNextObjId()
                self.battleMgr:AddGenZombieTask(task)
            end
        end
    end
end



return LWWayPoint