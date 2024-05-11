--道具型trigger，效果为获得物品或资源

local base = require "Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase"
---@class Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGoods : Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase
local TriggerGoods = BaseClass("TriggerGoods",base)




function TriggerGoods:DestroyView()
    base.DestroyView(self)
    if self.deathTimer then
        self.deathTimer:Stop()
        self.deathTimer=nil
    end
    self.animator = nil
end


--override trigger的渲染表现
function TriggerGoods:InitView()
    self.gameObject.name = "TriggerGoods"..self.guid
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

--override trigger的触发效果
function TriggerGoods:Trigger(colliderComponentCnt, colliderComponentArray)
    self:TriggerEvent(self.deathEvent,Vector3.New(self.x, 6, self.y))
    if self.colliderComponent then
        self.colliderComponent:Destroy()
        self.colliderComponent = nil
    end
    self:ShowDissolveEffect()

    local citySpaceManTrigger = colliderComponentArray[0]:GetComponent(typeof(CS.CitySpaceManTrigger))
    if citySpaceManTrigger ~= nil and citySpaceManTrigger.ObjectId ~= 0 then
        local objId = citySpaceManTrigger.ObjectId
        local obj = self.battleMgr:GetUnit(objId)
        if obj ~= nil and obj:GetCurBlood() > 0 then
            self.battleMgr:ShowEffectObj("Assets/_Art/Effect_B/Prefab/UI/Beizengmen/Eff_beizengmen_jinbi_chupeng.prefab",
                    Vector3.New(0,0,1),nil,1,citySpaceManTrigger.transform)
        end
    end
    
    --self.battleMgr:ShowEffectObj("Assets/_Art/Effect/Prefab/UI/Beizengmen/Eff_beizengmen_jinbi_chupeng.prefab",self:GetPosition())
    self.animator:Play("Eff_beizengmen_jinbi_xiaoshi",0,0)
    self.deathTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:Death()
    end, 1)
end


return TriggerGoods
