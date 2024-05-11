---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cola.
--- DateTime: 2022/11/1 下午3:45
---

local PlayerHunger = BaseClass("PlayerHunger")
local Const = require("Scene.PVEBattleLevel.Const")

function PlayerHunger:__init(player)
    self.player = player
    self.attenuationTime = LuaEntry.DataConfig:TryGetNum("hunger_thirst", "k3") --衰减周期, 默认15s
    self.attenuationValue = 1.0 --衰减值, 默认1
    self.checkThreshold = 20.0 --判断是否饥饿的检测阀值, 默认20
    self.speedAttenuation = 0.5 --衰减后的速度, 默认0.5
    self.loseBloodTime = 0 --扣血周期, 默认0s
    self.loseBlood = 0 --饥渴值到0后的扣血, 默认0
    local k4 = LuaEntry.DataConfig:TryGetStr("hunger_thirst", "k4") or ""
    local k4_arr = string.split_ii_array(k4, ";")
    if table.count(k4_arr) == 2 then
        self.loseBloodTime = k4_arr[1]
        self.loseBlood = k4_arr[2]
    end
    self.loseBloodTimer = 0
    self.hungerTimer = 0
    self.updateTime = 5
    self.updateTimer = 0
    self.updateHunger = self:GetHunger()
    self.updateThirsty = self:GetThirsty()
    self.startIdleTime = 0 --开始待机的时间
    self.idleIntervalTime = 5 --待机间隔时间
    self.pickLoseHunger = 0 -- 捡垃圾（包括砍树和锄地）每次减去多少饥渴值
    self.pickLoseThirsty = 0 -- 捡垃圾（包括砍树和锄地）每次减去多少饥渴值
    local k5 = LuaEntry.DataConfig:TryGetStr("hunger_thirst", "k5") or ""
    local k5_arr = string.split_ff_array(k5, "|")
    if table.count(k5_arr) == 2 then
        self.pickLoseHunger = k5_arr[1]
        self.pickLoseThirsty = k5_arr[2]
    end
    self.attackLoseHunger = 0 -- 攻击每次减去多少饥渴值
    self.attackLoseThirsty = 0 -- 攻击每次减去多少饥渴值
    local k6 = LuaEntry.DataConfig:TryGetStr("hunger_thirst", "k6") or ""
    local k6_arr = string.split_ff_array(k6, "|")
    if table.count(k6_arr) == 2 then
        self.attackLoseHunger = k6_arr[1]
        self.attackLoseThirsty = k6_arr[2]
    end

    self.batheAttenuationTime = LuaEntry.DataConfig:TryGetNum("shower", "k3")--洗澡衰减周期
    self.batheTimer = 0
    self.peeMaxValue = LuaEntry.DataConfig:TryGetNum("pee", "k1")--小便最大值
    self.stoolMaxValue = LuaEntry.DataConfig:TryGetNum("pee", "k2")--大便最大值
    self:OnCheck()
end

function PlayerHunger:Destroy()
    self.player = nil
    self.attenuationTime = nil
    self.attenuationValue = nil
    self.checkThreshold = nil
    self.speedAttenuation = nil
    self.loseBloodTime = nil
    self.loseBlood = nil
    self.loseBloodTimer = nil
    self.hungerTimer = nil
    self.updateTime = nil
    self.updateTimer = nil
    self.updateHunger = nil
    self.updateThirsty = nil

    self.batheTimer = nil
    self.batheAttenuationTime = nil
    self.peeMaxValue = nil
    self.stoolMaxValue = nil
end

function PlayerHunger:OnUpdate(deltaTime)
    self.batheTimer = self.batheTimer + deltaTime
    if self.batheTimer >= self.batheAttenuationTime and not self:IsBathe() then
        self.batheTimer = 0
        self:AddBathe(-self.attenuationValue)
        self:OnCheck()
    end

    if self:CheckIdleState(deltaTime) then --待机条件满足情况下不掉饥饿和饥渴值
        return
    end
    
    if self.player.info:GetCurBlood() > 0 then
        self.hungerTimer = self.hungerTimer + deltaTime
        if self.hungerTimer >= self.attenuationTime then
            self.hungerTimer = 0
            --self:AddHunger(-self.attenuationValue)
            --self:AddThirsty(-self.attenuationValue)
            self:AddPee(-self.attenuationValue)
            self:AddStool(-self.attenuationValue)
            self:OnCheck()
        end

        local hunger = self:GetHunger()
        local thirsty = self:GetThirsty()
        if (hunger == 0 or thirsty == 0) and self.loseBloodTime > 0 and self.loseBlood > 0 then
            self.loseBloodTimer = self.loseBloodTimer + deltaTime
            if self.loseBloodTimer >= self.loseBloodTime then
                self.loseBloodTimer = 0
                self.player:BeAttack(self.loseBlood, Const.DamageType.Hungery)
                if self.player:IsDie() then
                    if hunger == 0 then
                        self.player:SetCauseOfDeath(799009)
                    else
                        self.player:SetCauseOfDeath(799010)
                    end
                end
            end
        else
            self.loseBloodTimer = 0
        end

        --self.updateTimer = self.updateTimer + deltaTime
        --if self.updateTimer >= self.updateTime then
        --    self.updateTimer = 0
        --    self:SendInfo()
        --end
    end
end

function PlayerHunger:CheckIdleState(deltaTime)
    if self.player:IsIdle() then
        self.startIdleTime = self.startIdleTime + deltaTime
        if self.startIdleTime >= self.idleIntervalTime then
            return true
        end
    else
        self.startIdleTime = 0
    end
    return false
end

function PlayerHunger:AddHunger(value)
    local hunger = self:GetHunger()
    self.player.info:SetHunger(math.max(0, math.min(hunger + value, 100)))
end

function PlayerHunger:SetHunger(value)
    self.player.info:SetHunger(math.max(0, math.min(value, 100)))
end

function PlayerHunger:AddThirsty(value)
    local thirsty = self:GetThirsty()
    self.player.info:SetThirsty(math.max(0, math.min(thirsty + value, 100)))
end

function PlayerHunger:SetThirsty(value)
    self.player.info:SetThirsty(math.max(0, math.min(value, 100)))
end

function PlayerHunger:OnCheck(isAdd)
    local hunger = self:GetHunger()
    local thirsty = self:GetThirsty()
    if self.player.hungerBar ~= nil then
        local isShowBathe = self:IsBathe()
        local isShowPeeOrStool = self:IsPeeOrStoolState()
        self.player.hungerBar:OnCheck(hunger, thirsty, self.checkThreshold, isAdd,isShowBathe,isShowPeeOrStool)
    end

    self.player:Weakness(hunger == 0 or thirsty == 0 or self:IsPeeOrStoolState())

    EventManager:GetInstance():Broadcast(EventId.SU_PlayerHungerChange)
    self:BatheChangeHP()
    self:SendInfo()
end

function PlayerHunger:GetSpeed()
    if self:GetHunger() == 0 or self:GetThirsty() == 0 or self:IsPeeOrStoolState() then
        return self.speedAttenuation
    end
    return 1
end

function PlayerHunger:GetHunger()
    return self.player.info:GetHunger()
end

function PlayerHunger:IsHunger()
    local hunger = self:GetHunger()
    return hunger < self.checkThreshold, hunger
end

function PlayerHunger:GetThirsty()
    return self.player.info:GetThirsty()
end

function PlayerHunger:IsThirsty()
    local thirsty = self:GetThirsty()
    return thirsty < self.checkThreshold, thirsty
end

function PlayerHunger:SendInfo()
    local param = {}
    param["playerInfo"] = 1
    param["food"] = self:GetHunger()
    param["water"] = self:GetThirsty()
    param["shower"] = self:GetBathe()
    param["waterOutput"] = self:GetPee()
    param["foodOutput"] = self:GetStool()
    param["hp"] = self:GetCurBlood()
    SFSNetwork.SendMessage(MsgDefines.SU_PvePlayerInfoUpdate, param)
end

function PlayerHunger:OnPickLoseHunger()
    if self.pickLoseHunger > 0 then
        self:AddHunger(-self.pickLoseHunger)
        self:AddPee(-self.pickLoseHunger)
    end
    if self.pickLoseThirsty > 0 then
        self:AddThirsty(-self.pickLoseThirsty)
        self:AddStool(-self.pickLoseThirsty)
    end
    if self.pickLoseHunger > 0 or self.pickLoseThirsty > 0 then
        self:OnCheck()
    end
end

function PlayerHunger:OnAttackLoseHunger()
    if self.attackLoseHunger > 0 then
        self:AddHunger(-self.attackLoseHunger)
        self:AddPee(-self.attackLoseHunger)
    end
    if self.attackLoseThirsty > 0 then
        self:AddThirsty(-self.attackLoseThirsty)
        self:AddStool(-self.attackLoseThirsty)
    end
    if self.attackLoseHunger > 0 or self.attackLoseThirsty > 0 then
        self:OnCheck()
    end
end

function PlayerHunger:AddBathe(value)
    local bathe = self:GetBathe()
    self.player.info:SetBathe(math.max(0, math.min(bathe + value, 100)))
end

function PlayerHunger:IsBathe()
    return self.player.info:IsBathe()
end

function PlayerHunger:GetBathe()
    return self.player.info:GetBathe()
end

--洗澡改变血量
function PlayerHunger:BatheChangeHP()
    if self:IsBathe() then
        --需要洗澡状态下血量减少10%
        local maxBlood = math.floor(self.player.info:GetNewMaxBlood() * 0.9)
        local curBlood = self.player.info:GetCurBlood()
        self.player.info:SetMaxBlood(maxBlood)
        if curBlood > self.player.info:GetMaxBlood() then
            self.player.info:SetCurBlood(maxBlood)
        end
        --更新血量
        EventManager:GetInstance():Broadcast(EventId.SU_PlayerHpChanged)
    end
end

--小便
function PlayerHunger:GetPee()
    return self.player.info:GetPee()
end

--小便
function PlayerHunger:AddPee(value)
    local hunger = self:GetPee()
    self.player.info:SetPee(math.max(0, math.min(hunger + value, self.peeMaxValue)))
end

--大便
function PlayerHunger:GetStool()
    return self.player.info:GetStool()
end

--大便
function PlayerHunger:AddStool(value)
    local thirsty = self:GetStool()
    self.player.info:SetStool(math.max(0, math.min(thirsty + value, self.stoolMaxValue)))
end

--是否是小便状态
function PlayerHunger:IsPeeState()
    return self.player.info:IsPeeState()
end

--是否是大便状态
function PlayerHunger:IsStoolState()
    return self.player.info:IsStoolState()
end

--是否是大小便状态
function PlayerHunger:IsPeeOrStoolState()
    return self.player.info:IsPeeOrStoolState()
end

--是否有debuff
function PlayerHunger:GetIsShowHungerBar()
    local hunger = self:GetHunger()
    local thirsty = self:GetThirsty()
    local isShowBathe = self:IsBathe()
    local isShowPeeOrStool = self:IsPeeOrStoolState()
    local isShow = (hunger < self.checkThreshold or thirsty < self.checkThreshold or isShowBathe or isShowPeeOrStool) and DataCenter.BattleLevel:GetViewMode() ~= ViewMode.SLG
    return isShow
end

function PlayerHunger:GetCurBlood()
    return self.player.info:GetCurBlood()
end

return PlayerHunger