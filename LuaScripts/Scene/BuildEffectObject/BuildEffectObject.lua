--- Created by shimin.
--- DateTime: 2024/1/23 14:37
--- 建筑特效
local BuildEffectObject = BaseClass("BuildEffectObject")
local Resource = CS.GameEntry.Resource

function BuildEffectObject:__init()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.prefabName = ""
    self.specialScript = nil
end

function BuildEffectObject:Destroy()
    self:RemoveReq()
    self.prefabName = ""
end

function BuildEffectObject:Create()
    if self.prefabName ~= self.param.prefabName then
        self.prefabName = self.param.prefabName
        self:RemoveReq()
    end
    if self.req == nil then
        self.req = Resource:InstantiateAsync(self.param.prefabName)
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

function BuildEffectObject:InitComponent()
end

function BuildEffectObject:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

function BuildEffectObject:ReInit(param)
    self.param = param
    self:Create()
end

function BuildEffectObject:RemoveReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.transform = nil
        self.gameObject = nil

        self:RemoveSpecialScript()
    end
end

function BuildEffectObject:Refresh()
    if self.gameObject ~= nil then
        self.gameObject:SetActive(true)
        self.transform:Set_position(self.param.worldPos.x, self.param.worldPos.y, self.param.worldPos.z)
        if self.param.rot then
            self.transform.rotation = self.param.rot
        end
        if self.param.scale then
            self.transform.localScale = self.param.scale
        end
    end
    self:LoadSpecialScript()
end

function BuildEffectObject:SetScale(scale)
    
    self.transform.localScale = Vector3.New(scale, 1, scale)
end

function BuildEffectObject:LoadSpecialScript()
    --针对一些特殊的类型，分别处理
    if self.param.specialScript ~= nil then
        if self.specialScript == nil then
            self.specialScript = self.param.specialScript.New()
        end
        self.specialScript:ReInit(self.param.specialParam)
    end
end

function BuildEffectObject:RemoveSpecialScript()
    if self.specialScript ~= nil then
        self.specialScript:Destroy()
        self.specialScript = nil
    end
end

return BuildEffectObject