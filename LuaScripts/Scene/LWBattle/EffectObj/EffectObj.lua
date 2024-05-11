---
--- PVE 特效类，例如墓碑、血渍，纯表现，无互动
---
---@class Scene.LWBattle.EffectObj.EffectObj
local EffectObj = BaseClass("EffectObj")



function EffectObj:__delete()
    self:Destroy()
end

function EffectObj:Destroy()
    if self.req then
        self.req:Destroy()
        self.req=nil
    end
    self.mgr=nil
    self.id=nil
    self.countDown=nil
end

function EffectObj:Init(mgr,req,id)
    self.mgr=mgr---@type Scene.LWBattle.EffectObj.EffectObjManager
    self.req=req
    self.id=id
end


--显示特效，参数都可以为空
--pos 世界坐标
--rot 世界四元数
--time =nil则1秒后隐藏；time<=0 则永远显示；time>0则显示time秒
--parent 不为空表示特效挂在某个transform下，此时pos表示本地坐标,rot表示本地旋转
function EffectObj:Show(pos,rot,time,parent)
    if parent then
        self.req.gameObject.transform:SetParent(parent)
        if pos then
            self.req.gameObject.transform.localPosition=pos
        else
            self.req.gameObject.transform:Set_localPosition(0,0,0)
        end
        if rot then
            self.req.gameObject.transform.localRotation=rot
        end
    else
        if pos then
            self.req.gameObject.transform.position=pos
        end
        if rot then
            self.req.gameObject.transform.rotation=rot
        end
    end
    self.req.gameObject:SetActive(true)
    self.countDown = time or 1
end


function EffectObj:OnUpdate()
    if self.countDown<=0 then
        return
    end
    self.countDown=self.countDown-Time.deltaTime
    if self.countDown<=0 then
        self.mgr:InnerRemove(self)
    end
end

return EffectObj