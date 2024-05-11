


---BuffBase buff基类
---@class Scene.LWBattle.Buff.BuffBase
---@field meta DataCenter.LWBuff.LWBuffTemplate
local BuffBase = BaseClass("BuffBase")


function BuffBase:__init(logic,mgr,unit,meta,id)
    self.logic=logic
    self.mgr=mgr---@type Scene.LWBattle.Buff.BuffManager
    self.unit=unit
    self.meta=meta
    self.id=id
    if meta.buff_time<0 then
        self.duration = nil--nil表示无限期buff
    else
        self.duration = meta.buff_time
    end
end


function BuffBase:__delete()
    self:Destroy()
end


function BuffBase:Destroy()
    self.unit=nil
    self.meta=nil
    self.mgr=nil
    self.duration = nil
    self.id=nil
end


function BuffBase:Update()
    if self.duration then
        self.duration=self.duration-Time.deltaTime
        if self.duration<0 then
            self:End()
            return
        end
    end
    self:OnUpdate()
end

--Buff开始
function BuffBase:Start()
    --Logger.Log("Buff开始："..self.meta.id)
    self.logic:ShowEffectObj(self.meta.active_effect,nil,Quaternion.identity,nil,self.unit:GetTransform())
    self.effectId = nil
    if self.meta.additive_type ~= 2 then
        --叠加buff的持续特效在BuffManager中管理
        local trans = self.unit:GetTransform()
        if self.meta.ignore_rotate then
            self.effectId = self.logic:ShowEffectObj(self.meta.activing_effect,trans.localPosition,Quaternion.identity,0,trans.parent)
        else
            self.effectId = self.logic:ShowEffectObj(self.meta.activing_effect,nil,Quaternion.identity,0,trans)
        end
    end
    self:PlaySound()
    self:OnStart()
    EventManager:GetInstance():Broadcast(EventId.LWBattleBuffStart, self.meta.id)
end

--Buff结束
function BuffBase:End()
    local cacheId = self.meta.id
    self.logic:RemoveEffectObj(self.effectId)
    self:OnEnd()
    self.mgr:InnerRemoveBuff(self)
    self:Destroy()
    EventManager:GetInstance():Broadcast(EventId.LWBattleBuffEnd, cacheId)
end

--Buff重置
function BuffBase:Reset()
    if self.duration then
        self.duration=self.meta.buff_time
    end
    self:PlaySound()
end

--buff生效结算（virtual）
function BuffBase:OnStart()

end

--buff消失结算（virtual）
function BuffBase:OnEnd()

end

--buff更新（virtual）
function BuffBase:OnUpdate()

end

--播放获得音效
function BuffBase:PlaySound()
    if self.meta.active_effect_sound then
        local sound = self.meta.active_effect_sound:GetRandom()
        if sound then
            CS.GameEntry.Sound:PlayEffect(sound)
        end
    end
end


return BuffBase