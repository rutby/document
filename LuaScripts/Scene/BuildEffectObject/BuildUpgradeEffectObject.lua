--- Created by shimin.
--- DateTime: 2024/3/6 16:05
--- 建筑升级架子特效
local BuildUpgradeEffectObject = BaseClass("BuildUpgradeEffectObject")
local Resource = CS.GameEntry.Resource

function BuildUpgradeEffectObject:__init()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
end

function BuildUpgradeEffectObject:Destroy()
    self:RemoveReq()
end

function BuildUpgradeEffectObject:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.BuildUpgradeJiaZi)
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

function BuildUpgradeEffectObject:InitComponent()
end

function BuildUpgradeEffectObject:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

function BuildUpgradeEffectObject:ReInit(param)
    self.param = param
    self:Create()
end

function BuildUpgradeEffectObject:RemoveReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.transform = nil
        self.gameObject = nil
    end
end

function BuildUpgradeEffectObject:Refresh()
    if self.gameObject ~= nil then
        self.gameObject:SetActive(true)
        if self.param.effect_go ~= nil then
            self.transform:SetParent(self.param.effect_go)
            self.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.transform:Set_localRotation(ResetRotation.x, ResetRotation.y, ResetRotation.z, ResetRotation.w)
        end
    end
end

return BuildUpgradeEffectObject