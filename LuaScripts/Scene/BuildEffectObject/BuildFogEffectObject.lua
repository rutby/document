--- Created by shimin.
--- DateTime: 2024/2/22 11:49
--- 建筑迷雾中特效
local BuildFogEffectObject = BaseClass("BuildFogEffectObject")
local Resource = CS.GameEntry.Resource
local RemoveTime = 2.7

function BuildFogEffectObject:__init()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.prefabName = ""
    self.timer = nil
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
    self.renders = {}
end

function BuildFogEffectObject:Destroy()
    self:SetEffectEnable(false)
    self:RemoveReq()
    self:RemoveOneTime()
    self.prefabName = ""
    self.timer = nil
end

function BuildFogEffectObject:Create()
    if self.req == nil then
        local modelName = BuildingUtils.GetCityBuildingModelName(self.param.buildId, 1)
        self.req = Resource:InstantiateAsync(string.format(LoadPath.Building, modelName))
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:InitComponent()
            self:Refresh()
        end)
    else
        self:Refresh()
    end
end

function BuildFogEffectObject:InitComponent()
    self.renders = {}
    local renders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
    if renders ~= nil and renders.Length > 0 then
        for i = 0, renders.Length -1, 1 do
            table.insert(self.renders, renders[i])
        end
    end
end

function BuildFogEffectObject:ReInit(param)
    self.param = param
    self:Create()
end

function BuildFogEffectObject:RemoveReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.transform = nil
        self.gameObject = nil
    end
end

function BuildFogEffectObject:Refresh()
    if self.gameObject ~= nil then
        self.gameObject:SetActive(true)
        local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
        if desTemplate ~= nil then
            local pos = desTemplate:GetPosition()
            self.transform:Set_position(pos.x, pos.y, pos.z)
            self.transform.rotation = Quaternion.Euler(0, desTemplate.rotation, 0)
            self:AddOneTime()
            self:SetEffectEnable(true)

            local param = {}
            param.positionType = PositionType.World
            param.position = pos
            param.noShowFinger = true
            param.isPanel = false
            param.isAutoClose = RemoveTime
            DataCenter.ArrowManager:ShowArrow(param)
        end
    end
end

function BuildFogEffectObject:AddOneTime()
    self:RemoveOneTime()
    self.timer = TimerManager:GetInstance():GetTimer(RemoveTime, self.timer_callback, nil, true, false, false)
    self.timer:Start()
end

function BuildFogEffectObject:RemoveOneTime()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function BuildFogEffectObject:OnTimerCallBack()
    self:RemoveOneTime()
    DataCenter.BuildFogEffectManager:RemoveOneEffect(self.param.buildId)
end

function BuildFogEffectObject:SetEffectEnable(enable)
    if enable then
        for k,v in ipairs(self.renders) do
            v.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("Hud3D"))
            v.material:EnableKeyword("_Toggle_Flash_ON")
        end
    else
        for k,v in ipairs(self.renders) do
            v.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("Default"))
            v.material:DisableKeyword("_Toggle_Flash_ON")
        end
    end
end


return BuildFogEffectObject