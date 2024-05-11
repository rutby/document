---
--- PVE 特效管理器，管理特效新增、自然销毁、提前销毁
---
---@class Scene.LWBattle.EffectObj.EffectObjManager
local EffectObjManager = BaseClass("EffectObjManager")
local Resource = CS.GameEntry.Resource
local EffectObj = require("Scene.LWBattle.EffectObj.EffectObj")
local EffectSprite = require("Scene.LWBattle.EffectObj.EffectSprite")
local MAX_INSTANCE_PERFRAME = 20

function EffectObjManager:__init()
    self.allEffects={}---@type table<number,Scene.LWBattle.EffectObj.EffectObj>
    self.nextObjId=0
    self.tasks={}--正在创建的Effect的id的集合
    self.curFrameTaskCount = 0
end

function EffectObjManager:__delete()
    self:Destroy()
end

function EffectObjManager:Destroy()
    self.tasks={}
    self:ResetData()
    ObjectPool:GetInstance():Clear(EffectObj)
    ObjectPool:GetInstance():Clear(EffectSprite)
end

function EffectObjManager:ResetData()
    for _,effect in pairs(self.allEffects) do
        effect:Destroy()
    end
    self.allEffects={}
    self.curFrameTaskCount=0
end

--公共方法
--显示特效
--pos 世界坐标，可以为空
--rot 世界四元数，可以为空
--time=nil则1秒后回收；time<=0 则永远显示；time>0则显示time秒
--parent 可以为空，不为空表示特效挂在某个transform下，此时pos表示本地坐标
--type 可以为空，特殊特效类型
--返回特效的uid，用来提前删除
function EffectObjManager:ShowEffectObj(path,pos,rot,time,parent,type)
    if string.IsNullOrEmpty(path) then
        --Logger.LogError("特效路径为空")
        return
    end
    self.curFrameTaskCount = self.curFrameTaskCount + 1
    if self.curFrameTaskCount > MAX_INSTANCE_PERFRAME then--如果一帧超过20个，则忽略
        return
    end
    
    self.nextObjId = self.nextObjId + 1
    local id = self.nextObjId
    self.tasks[id]=true
    local effectReq = Resource:InstantiateAsync(path)
    effectReq:completed('+', function(req)
        if req.isError or IsNull(req.gameObject) then
            req:Destroy()
            self.tasks[id]=nil
            return
        end
        if self.tasks[id] then
            self.tasks[id]=nil
            local effect
            if type==EffectObjType.Sprite then
                effect = ObjectPool:GetInstance():Load(EffectSprite)
            else
                effect = ObjectPool:GetInstance():Load(EffectObj)
            end
            effect:Init(self,req,id)
            effect:Show(pos,rot,time,parent)
            self.allEffects[id]=effect
        else
            req:Destroy()
        end
    end)
    return id
end

--公共方法
--提前移除特效
function EffectObjManager:RemoveEffectObj(id)
    if not id then
        return
    end
    local effectObj=self.allEffects[id]
    if effectObj then
        self:InnerRemove(effectObj)
    elseif self.tasks[id] then
        self.tasks[id]=nil
    end
end



function EffectObjManager:OnUpdate()
    self.curFrameTaskCount = 0
    for _,v in pairs(self.allEffects) do
        v:OnUpdate()
    end
end



function EffectObjManager:InnerRemove(effect)
    self.allEffects[effect.id]=nil
    effect:Destroy()
    ObjectPool:GetInstance():Save(effect)
end



return EffectObjManager