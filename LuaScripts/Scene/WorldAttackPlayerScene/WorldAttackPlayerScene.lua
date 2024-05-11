--- Created by shimin.
--- DateTime: 2022/12/28 11:20
--- 世界赛季城特效动画

local WorldAttackPlayerScene = BaseClass("WorldAttackPlayerScene")
local ResourceManager = CS.GameEntry.Resource

local pos_node_path = "PosNode"
local troop_line_path = "TroopLine"

local ChangeMoveDis = 0.3 --每0.3格（unity坐标）改变一次位置

--创建
function WorldAttackPlayerScene:__init(param)
    self:DataDefine()
    self.param = param
    self:Create()
end

function WorldAttackPlayerScene:Create()
    if self.req == nil then
        self.req = ResourceManager:InstantiateAsync(UIAssets.WorldAttackPlayerScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:ReInit(self.param)
        end)
    end
end

-- 销毁
function WorldAttackPlayerScene:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function WorldAttackPlayerScene:ComponentDefine()
    self.pos_node = self.transform:Find(pos_node_path)
    self.troop_line = self.transform:Find(troop_line_path):GetComponent(typeof(CS.WorldTroopLine))
end

function WorldAttackPlayerScene:ComponentDestroy()
end


function WorldAttackPlayerScene:DataDefine()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.param = {}
    self.mainWorldPos = 0
    self.changeTime = 0
    self.move_timer_callback = function()
        self:MoveTimerCallBack()
    end
end

function WorldAttackPlayerScene:DataDestroy()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end
    self.transform = nil
    self.gameObject = nil
    self.param = {}
    self.mainWorldPos = 0
    self.changeTime = 0
    self:DeleteMoveTimer()
end

function WorldAttackPlayerScene:ReInit(param)
    self.param = param
    if self.gameObject ~= nil then
        local pos, angle, needTimer = DataCenter.GuideNeedLoadManager:GetFakeNpcMarchPosAndAngle()
        self.mainWorldPos = LuaEntry.Player:GetMainWorldPos()
        if self.mainWorldPos > 0 then
            local mainPos = SceneUtils.TileIndexToWorld(self.mainWorldPos, ForceChangeScene.World)
            self.transform.position = mainPos
            self.pos_node.transform.position = pos
            self.pos_node.transform.rotation = Quaternion.Euler(angle.x, angle.y, angle.z)
            self.troop_line:SetColor(Color.New(0.98,0.31,0.30,1))
            self.troop_line:SetStraightMovePath(pos, mainPos)
            if needTimer then
                self:AddMoveTimer(ChangeMoveDis * self.param.perTimeMoveDis)
            end
        end
    end
end

function WorldAttackPlayerScene:DeleteMoveTimer()
    if self.moveTimer ~= nil then
        self.moveTimer:Stop()
        self.moveTimer = nil
    end
end
function WorldAttackPlayerScene:AddMoveTimer(time)
    if self.moveTimer == nil then
        self.moveTimer = TimerManager:GetInstance():GetTimer(time, self.move_timer_callback, self, false, false, false)
        self.moveTimer:Start()
    end
end

function WorldAttackPlayerScene:MoveTimerCallBack()
    local pos, angle, needTimer = DataCenter.GuideNeedLoadManager:GetFakeNpcMarchPosAndAngle()
    local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
    if mainWorldPos > 0 then
        local mainPos = SceneUtils.TileIndexToWorld(self.mainWorldPos, ForceChangeScene.World)
        self.pos_node.transform.position = pos
        self.troop_line:SetStraightMovePath(pos, mainPos)
        if mainWorldPos ~= self.mainWorldPos then
            self.mainWorldPos = mainWorldPos
            self.transform.position = mainPos
            self.pos_node.transform.rotation = Quaternion.Euler(angle.x, angle.y, angle.z)
        end
    end

    if not needTimer then
        self:DeleteMoveTimer()
    end
end

return WorldAttackPlayerScene