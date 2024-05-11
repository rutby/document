local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

local Const = require("Scene.LWBattle.Const")

function State.Create()
    local copy = {}
    setmetatable(copy, State)
    copy:Init()
    return copy
end

-- function State:Init()
-- end

-- function State:Dispose()
-- end

-- function State:OnUpdate(deltaTime)
-- end

function State:OnExit()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

function State:OnEnter()
    self.owner.playerGroupProxy:SetBubbleVisible(false)
    local mainView = UIManager:GetInstance():GetWindow(UIWindowNames.LWCountBattleMain).View
    if mainView then
        mainView:OnBattleWin()
    end

    local param = {}
    param.time = self.owner.useTime
    param.kill = self.owner.killCount
    param.stageId = self.owner.cfg.levelId
    param.score = self.owner.playerGroupProxy:GetPoint()
    param.rank = string.format("%02d.%02d%%", (param.score >= self.owner.cfg.baseScore and 99 or math.floor(param.score / self.owner.cfg.baseScore * 100)), math.random(1, 99))
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCountBattleWin, 
            { anim = true, UIMainAnim = UIMainAnimType.AllHide,playEffect = DataCenter.LWSoundManager:GetSound(10024) }, param)

    self.owner:NoticeWin()
    --PostEventLog.BattleResultLog(PVEType.Count, 1)

    for _, trap in pairs(self.owner.traps) do
        if trap and trap.OnBattleWin then trap:OnBattleWin() end
    end

    local cfg = self.owner.cfg
    if cfg and cfg.stageType and cfg.stageType == Const.CountBattleType.Defense then
        --塔防模式胜利小队向前跑
        if self.owner.playerGroupProxy and self.owner.playerGroupProxy.unitProxies then
            for _, unitProxy in pairs(self.owner.playerGroupProxy.unitProxies) do
                if unitProxy then
                    unitProxy:ResetSyncUnit()
                    unitProxy:PlayAnim("Default", 0.2)
                end
            end
            
            self.owner.playerGroupProxy:SetVelocity(0, 30)

            self.timer = TimerManager:GetInstance():DelayInvoke(function()
                if self.owner and self.owner.playerGroupProxy then
                    self.owner.playerGroupProxy:SetVelocity(0, 0)
                end
            end, 5)
        end
    end
end

return State