---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2021/4/14 18:48
---
local DropResourceEffectManager = BaseClass("DropResourceEffectManage")
local ResourceManager = CS.GameEntry.Resource
local DropResourceEffect = require "UI.DropResourceEffect.View.DropResourceEffect"
local DropMultiResourceEffect = require "UI.DropMultiResourceEffect.View.DropMultiResourceEffect"

local function __init(self)
    self.allEffect = {} --所有特效
end

local function __delete(self)
    for k,v in pairs(self.allEffect) do
        if v.param == nil then
            v:Destroy()
        else
            v:OnDestroy()
            if v.param.request == nil then
                v.param.request:Destroy()
            end
        end
    end
    self.allEffect = nil
end

local function DropOneItemEffect(self,pos,icon,bUuid)

    local layer = UIManager:GetInstance():GetLayer(UILayer.Dialog.Name)
    if layer == nil then
        Logger.Log("can not get layer")
        return
    end
    if self.allEffect[pos] ~= nil then
        return
    end
    local request = ResourceManager:InstantiateAsync(UIAssets.DropResourceEffect)
    self.allEffect[pos] = request
    request:completed('+', function()
        if request.isError then
            self.allEffect[pos] =nil
            return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(layer.transform, false)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

        local dropResourceEffect = DropResourceEffect.New()
        dropResourceEffect:OnCreate(request)
        local param = {}
        param.pos= pos
        
        param.icon = icon
        param.bUuid =bUuid
        param.request = request
        dropResourceEffect:ReInit(param)
        self.allEffect[pos] = dropResourceEffect
    end)
end

local function RemoveOneEffect(self,param)
    local pos = param.pos
    if self.allEffect[pos] ~= nil then
        self.allEffect[pos]:OnDestroy()
        self.allEffect[pos] =nil
    end
    if param.request ~= nil then
        param.request:Destroy()
    end

    self.allEffect[pos] =nil
end

DropResourceEffectManager.__init = __init
DropResourceEffectManager.__delete = __delete
DropResourceEffectManager.RemoveOneEffect = RemoveOneEffect
DropResourceEffectManager.DropOneItemEffect =DropOneItemEffect
return DropResourceEffectManager