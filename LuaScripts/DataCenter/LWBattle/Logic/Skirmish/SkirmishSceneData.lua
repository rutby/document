---
---战斗回放场景配置
---

local SkirmishSceneData = BaseClass("SkirmishSceneData")

local function __init(self,id)
    self:InitData(id)
end
local function __delete(self)
end

local function InitData(self)
    --场景名
    self.sceneName = "LastWar_Scene_army_001_clean_03"
    --军队出生点
    self.armyBirthPos={}
    self.armyBirthPos[1]=Vector3.New(36,0,11.13)--下
    self.armyBirthPos[2]=Vector3.New(36,0,36.19)--上
    --士兵相对军队的坐标
    self.minionLocalPos={
        [1]=Vector3.New(-1.51,0,3.09),
        [2]=Vector3.New(-1.51,0,1.14),
        [3]=Vector3.New(-0.74,0,2.64),
        [4]=Vector3.New(-0.06,0,2.73),
        [5]=Vector3.New(0.7,0,2.56),
        [6]=Vector3.New(1.42,0,2.04),
        [7]=Vector3.New(-1.43,0,2.18),
        [8]=Vector3.New(-0.79,0,1.69),
        [9]=Vector3.New(-0.07,0,1.65),
        [10]=Vector3.New(0.65,0,1.60),
        [11]=Vector3.New(1.38,0,1.09),
        [12]=Vector3.New(1.56,0,2.95),
    }
    --一个英雄满血时士兵数
    self.MAX_MINION_PER_HERO=12
    --移动速度
    self.MOVE_SPEED=1
    --开场时长
    self.OPENING_TIME=2
    --镜头初始位置
    self.camPoint=Vector3.New(36,0,23.8)
    --开场镜头高度
    self.OPENING_CAMERA_HEIGHT=80
    --开场镜头fov
    self.OPENING_CAMERA_FOV=25
    --开场镜头转角
    self.OPENING_CAMERA_ROTATION=55
    --战斗镜头高度
    self.FIGHT_CAMERA_HEIGHT=65
    --小兵普攻初始CD
    self.MINION_ATTACK_PRECD=5
    --小兵普攻CD
    self.MINION_ATTACK_CD=3
    
    --英雄相对军队的坐标
    --军队终点
    --这俩读取lw_replay_distance表格
    self.platoonLocalPos={}
    self.armyEndPos={}
    for i = 1, 12 do
        local lineData = LocalController:instance():getLine(TableName.LW_Replay_Distance, i)
        if i==1 then
            local posStrs = string.split(lineData.pos_center,",")
            --军队终点
            self.armyEndPos[1]=Vector3.New(tonumber(posStrs[1]),tonumber(posStrs[2]),tonumber(posStrs[3]))--下
        end
        if i==6 then
            local posStrs = string.split(lineData.pos_center,",")
            --军队终点
            self.armyEndPos[2]=Vector3.New(tonumber(posStrs[1]),tonumber(posStrs[2]),tonumber(posStrs[3]))--上
        end
        local posStrs = string.split(lineData.pos,",")
        --英雄相对军队的坐标
        self.platoonLocalPos[i]=Vector3.New(tonumber(posStrs[1]),tonumber(posStrs[2]),tonumber(posStrs[3]))
    end

    local platoonPos={}
    for i = 1, 5 do
        platoonPos[i] = self.armyEndPos[1] + self.platoonLocalPos[i]
    end
    for i = 6, 10 do
        platoonPos[i] = self.armyEndPos[2] - self.platoonLocalPos[i]
    end

    if self.platoonLocalPos[11] then
        platoonPos[11] = self.armyEndPos[1] + self.platoonLocalPos[11]
    end
    if self.platoonLocalPos[12] then
        platoonPos[12] = self.armyEndPos[2] - self.platoonLocalPos[12]
    end
    
    self.distanceTable = {}
    for i = 1, 12 do
        self.distanceTable[i] = {}
    end
    for i = 1, 12 do
        for j = 1, i-1 do
            self.distanceTable[i][j] = self.distanceTable[j][i]
        end
        self.distanceTable[i][i] = 0
        for j = i+1, 12 do
            self.distanceTable[i][j] = Vector3.Distance(platoonPos[i],platoonPos[j])
        end
    end
end

local function GetCaptainDistance(self,i,j)
    return self.distanceTable[i][j]
end


SkirmishSceneData.__init = __init
SkirmishSceneData.__delete = __delete
SkirmishSceneData.InitData = InitData
SkirmishSceneData.GetCaptainDistance = GetCaptainDistance


return SkirmishSceneData


----军队终点
--self.armyEndPos={}
--self.armyEndPos[1]=Vector3.New(36,0,15.13)--下
--self.armyEndPos[2]=Vector3.New(36,0,32.74)--上
----英雄相对军队的坐标
--self.platoonLocalPos={
--    [1]=Vector3.New(-2,0,3.35),
--    [2]=Vector3.New(2,0,3.35),
--    [3]=Vector3.New(-3.72,0,-1.52),
--    [4]=Vector3.New(0,0,-1.52),
--    [5]=Vector3.New(3.72,0,-1.52),
--}
