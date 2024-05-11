---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2022/9/23 18:40
---
---遥感移动
---
local CharacterBaseState = require("Scene.PVEBattleLevel.Character.State.CharacterBaseState")
local CharacterMoveState = BaseClass("CharacterMoveState",CharacterBaseState)
local CharacterStateType = require("Scene.PVEBattleLevel.Character.State.CharacterStateType")
local SU_Util = require "Scene.PVEBattleLevel.Utils.SU_Util"

function CharacterMoveState:__init(owner,type,completeHandler)
    CharacterBaseState.__init(self,owner,type,completeHandler)

    self.m_tmpV = Vector3.New(0,0,0)
	self.m_simpleMove = Vector3.New(0,0,0)
	self.m_moveForward = Vector3.New(0,0,0)
    self.characterController = self.m_owner:GetCharacterController();
    if not IsNull(self.characterController) and not self.characterController.enabled then
        self.characterController.enabled = true --在移动的时候再启用，只需要启动一次就行
    end
	self.targetRotation = Quaternion.New()
    self.footPrintRate = tonumber(SU_Util.GetItemConfig(DataCenter.BattleLevel:GetLevelId(), "foot_print_rate")) or 1.0
	self.moveSoundTick = 0
	self.footprintTick = 0
end

function CharacterMoveState:OnEnter()
    self.speed = self.m_owner:GetMoveSpeed()
    self.m_owner:PlayAnim(self.m_owner:GetMoveAnimName())
    self.m_owner:SetAnimSpeed(self.m_owner:GetMoveAnimSpeed())
    
    self.m_timer = TimerManager:GetInstance():GetTimer(0.1,function() self:CheckComplete() end)
    self.m_timer:Start()
end

function CharacterMoveState:SetData(data)
    CharacterBaseState.SetData(self, nil)
    local vx = data.vx
    local vz = data.vz
    local length = data.length or 1
    if vx == 0 and vz == 0 then
        return
    end
    self.m_tmpV:Set(vx,0,vz)
    self.m_isMove = true
    self.length = length > 1 and 1 or length
    self.length = length < 0.15 and 0.15 or length
    
    self.length = 1 --临时代码，杨涵需求
    
    self.m_owner:SetAnimFloat("speed",self.length)

    if self.m_timer then
        self.m_timer:Reset()
    end
end

function CharacterMoveState:OnUpdate(deltaTime)
    if not self.m_isMove then
        return
    end
    self.m_isMove = false
    self.targetRotation:Set(Quaternion.FastLookRotation(self.m_tmpV, Vector3.up))
    self.m_moveForward:Set(self.targetRotation:MulVec3XYZ(Vector3.forward))
    self.m_owner:SetRotation(self.targetRotation)

    local newForward = nil
    local canChange = true
    local pos = self.m_owner:GetPosition()
    --canChange, newForward = self.m_owner.battleLevel.fog:CheckWalkPos(pos, self.m_moveForward, self.speed / 50, canChange)
    --if not canChange or newForward == nil then
    --    return
    --end
    newForward = self.m_moveForward
    
    --Move移动并防止悬空
--[[    if not self.characterController.isGrounded then
        pos.y = 0 --强制Y轴归0，防止悬空
        self.m_owner:SetPosition(pos)
    end
    local vvv = Vector3.Normalize(newForward) * self.speed * self.length * deltaTime
    self.characterController:Move(vvv)]]
    
    --SimpleMove移动，自带重力，不需要*deltaTime
    --local vvv = Vector3.Normalize(newForward) * self.speed * self.length
    --self.characterController:SimpleMove(vvv)
	local v = self.m_simpleMove
	v:Set(newForward.x, newForward.y, newForward.z)
	v:Mul(self.speed)
	v:Mul(self.length)
	self.characterController:SimpleMove(v.x, v.y, v.z)
	
    self.m_owner:UpdateShaderPos()

    self.footprintTick = self.footprintTick + deltaTime
    local interval = 0.5 / self.speed * self.footPrintRate
    if self.footprintTick >= interval then
        self.footprintTick = 0
        self.m_owner:OnPlayFootprintEffect()
    end

    interval = 2.5 / self.speed * self.footPrintRate
	self.moveSoundTick = self.moveSoundTick + deltaTime
	if self.moveSoundTick > interval then
		self.m_owner:OnPlayFootstepSound()
		self.moveSoundTick = 0
	end
end

function CharacterMoveState:CheckComplete()
    if not self.m_isMove then
        --没有再进行移动
        self:OnExit()
    end
end

function CharacterMoveState:OnExit()
    self.m_owner:SetAnimFloat("speed",1)
    self.m_owner:SetAnimSpeed(1)
    self:ClearTimer()
    self:OnStateComplete()
end

function CharacterMoveState:AllowStopByType(type)
    return CharacterStateType.Die == type or CharacterStateType.Default == type or CharacterStateType.PeeOrStool == type
            or CharacterStateType.Attack == type or CharacterStateType.Collect == type
end

function CharacterMoveState:ChangeCharacterState()
    self.speed = self.m_owner:GetMoveSpeed()
    self.m_owner:PlayAnim(self.m_owner:GetMoveAnimName())
end

function CharacterMoveState:ClearTimer()
    if self.m_timer then
        self.m_timer:Stop()
        self.m_timer = nil
    end
end

function CharacterMoveState:Destroy()
    CharacterBaseState.Destroy(self)
    self:ClearTimer()
    self.characterController = nil
end

return CharacterMoveState