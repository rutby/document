local base = require "DataCenter.LWBattle.Logic.CountBattle.Group.SteerGroupProxy"
local EnemySteerGroupProxy = BaseClass("EnemySteerGroupProxy", base)

local FSMachine = require("Common.FSMachine")
local Resource = CS.GameEntry.Resource

function EnemySteerGroupProxy:__init(logic, cfg)
    self.fsm = FSMachine.Create(self)
    self.fsm:Add("Sleep", require("DataCenter.LWBattle.Logic.CountBattle.Group.States.EnemySteerGroupProxyStateSleep").Create())
    self.fsm:Add("Awake", require("DataCenter.LWBattle.Logic.CountBattle.Group.States.EnemySteerGroupProxyStateAwake").Create())
    self.fsm:Add("Chase", require("DataCenter.LWBattle.Logic.CountBattle.Group.States.EnemySteerGroupProxyStateChase").Create())
    self.fsm:Switch("Sleep")

    local hideCircle = logic.cfg.hideEnemyCircle
    if not hideCircle then
        self.circleHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/LWCountBattle/Huds/GroupCircleRed.prefab")
        self.circleHandle:completed('+', function(handle)
            local transform = handle.gameObject.transform
            transform:SetParent(self.transform, false)
            transform.localPosition = Vector3.zero + Vector3.up * 0.01
            transform.localScale = Vector3.one * (self:GetRadius() * 2 + 0.5)
            self.circleTrans = transform
            self.circleTransValid = true
            self.circleMat = transform:GetComponent(typeof(CS.UnityEngine.Renderer)).material
        end)
        
    end
    
    self.alertRange = cfg.alertRange or 0
end

function EnemySteerGroupProxy:__delete()
    if self.fsm ~= nil then
        self.fsm:Dispose()
        self.fsm = nil
    end

    if not IsNull(self.circleHandle) then
        local handle = self.circleHandle
        local x, y = self.circleTrans:Get_localScale()
        self.circleTrans:DOScale(Vector3(x + 5, y + 5, 1), 0.5):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
            handle:RealDestroy()
        end)
        self.circleMat:DOFade(0, '_Main_Color', 0.5):SetEase(CS.DG.Tweening.Ease.OutCubic)
    end
    self.circleHandle = nil
    self.circleTrans = nil
    self.circleTransValid = nil
    self.circleMat = nil
end

function EnemySteerGroupProxy:OnUpdate()
    base.OnUpdate(self)
    if self.fsm then
        self.fsm:Update(Time.deltaTime)
    end

    if not self.engagingGroup and self.circleTransValid then
        local scale = self:GetRadius() * 2 + 0.5
        self.circleTrans:Set_localScale(scale, scale, 1)
    end
end

function EnemySteerGroupProxy:TryAwake()
    if self.fsm.currStateName == "Sleep" then
        self.fsm:Switch("Awake")
        return true
    end
    return false
end

function EnemySteerGroupProxy:TryAlert()
    local stateName = self.fsm.currStateName
    if stateName == "Sleep" then
        self.fsm:Switch("Awake")
    elseif stateName == "Awake" and self.cfg.moveSpeed > 0 then
        self.fsm:Switch("Chase")
    end
end

function EnemySteerGroupProxy:OnNotice()
    if self.cfg.moveSpeed > 0 and self.fsm.currStateName == "Awake" then
        self.fsm:Switch("Chase")
    end
end

function EnemySteerGroupProxy:OnEngageBegin(otherGroup)
    base.OnEngageBegin(self, otherGroup)
    self.scoreBubble.parent = nil
    if self.circleTransValid then
        self.circleTrans:SetParent(nil, true)
    end
end

function EnemySteerGroupProxy:OnGroupPointChanged(point)
    base.OnGroupPointChanged(self, point)
    if point <= 0 then
        self.logic:DeleteSteerGroup(self.cfg.name)
    end
end

function EnemySteerGroupProxy:GetAlertRange()
    return self.alertRange
end

return EnemySteerGroupProxy