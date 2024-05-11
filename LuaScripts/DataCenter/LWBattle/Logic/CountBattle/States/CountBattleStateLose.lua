local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

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

-- function State:OnExit()
-- end

function State:OnEnter()
    self.owner.playerGroupProxy:SetBubbleVisible(false)
    local mainView = UIManager:GetInstance():GetWindow(UIWindowNames.LWCountBattleMain).View
    if mainView then
        mainView:OnBattleLose()
    end
    local param = {}
    param.time = self.owner.useTime
    param.kill = self.owner.killCount
    param.stageId = self.owner.cfg.levelId
    param.canSkip = self.owner.cfg.canSkip
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCountBattleLose,
            {anim=true,UIMainAnim=UIMainAnimType.AllHide,playEffect=DataCenter.LWSoundManager:GetSound(10023)},param)

    --PostEventLog.BattleResultLog(PVEType.Count, 0)
end

return State