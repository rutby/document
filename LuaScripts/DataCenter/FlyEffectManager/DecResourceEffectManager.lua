---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2021/4/22 14:13
---
local DecResourceEffectManager = BaseClass("DecResourceEffectManager")
local ResourceManager = CS.GameEntry.Resource
local DecResourceEffect = require "UI.DecResourceEffect.View.DecResourceEffect"

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

local function DecOneItemEffect(self,pos,icon,desNum,bUuid)
    if self.allEffect[bUuid] ~= nil then
        return
    end
    local request = ResourceManager:InstantiateAsync(UIAssets.DecResourceEffect)
    self.allEffect[bUuid] = request
    request:completed('+', function()
        if request.isError then
            self.allEffect[bUuid] =nil
            return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

        local decResourceEffect = DecResourceEffect.New()
        decResourceEffect:OnCreate(request)
        local param = {}
        param.pos= pos
        param.desNum= desNum
        param.icon_name = icon
        param.bUuid =bUuid
        param.request = request
        param.resType = DataCenter.BuildManager:GetResTypeByBuildUuid(bUuid)
        decResourceEffect:ShowPanel(param)
        self.allEffect[bUuid] = decResourceEffect
    end)
end

local function RemoveOneEffect(self,param)
    local bUuid = param.bUuid
    if self.allEffect[bUuid] ~= nil then
        self.allEffect[bUuid]:OnDestroy()
        self.allEffect[bUuid] =nil
    end
    if param.request ~= nil then
        param.request:Destroy()
    end
end

DecResourceEffectManager.__init = __init
DecResourceEffectManager.__delete = __delete
DecResourceEffectManager.RemoveOneEffect = RemoveOneEffect
DecResourceEffectManager.DecOneItemEffect =DecOneItemEffect

return DecResourceEffectManager