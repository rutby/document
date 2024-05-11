---
--- PVE sprite特效，带有淡出效果
---
---@class Scene.LWBattle.EffectObj.EffectSprite
local base = require("Scene.LWBattle.EffectObj.EffectObj")
local EffectSprite = BaseClass("EffectSprite",base)
local FADING_TIME = 0.5--淡出时间
local FADING_SPEED = 1 / FADING_TIME

function EffectSprite:Destroy()
    base.Destroy(self)
    self.spriteRender=nil
    self.color=nil
    self.fading=nil
end

function EffectSprite:Show(pos,rot,time,parent)
    base.Show(self,pos,rot,time,parent)
    self.spriteRender=self.req.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.SpriteRenderer))
    self.color=self.spriteRender.color
    self.color.a=1
    self.spriteRender.color=self.color
    self.fading=false
end

function EffectSprite:OnUpdate()
    if self.countDown<=0 then
        return
    end
    self.countDown=self.countDown-Time.deltaTime
    if self.countDown<=0 then
        if self.fading then
            self.mgr:InnerRemove(self)
        else--倒计时完成时不直接移除，而是进入3秒的淡出状态
            self.fading=true
            self.countDown=FADING_TIME
        end
    elseif self.fading then
        self.color.a=self.color.a - Time.deltaTime * FADING_SPEED
        self.spriteRender.color=self.color
    end
end

return EffectSprite