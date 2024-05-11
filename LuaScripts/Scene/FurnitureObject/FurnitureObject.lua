--- Created by shimin.
--- DateTime: 2023/11/9 11:11
--- 家具
local FurnitureObject = BaseClass("FurnitureObject")
local Resource = CS.GameEntry.Resource

function FurnitureObject:__init(param)
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.param = param
    self.prefabName = ""
    self:Create()
end

function FurnitureObject:Destroy()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end
    self.transform = nil
    self.gameObject = nil
end

function FurnitureObject:Create()
    if self.req == nil then
        self.prefabName = self:GetPrefabName()
        if self.prefabName ~= nil then
            self.req = Resource:InstantiateAsync(self.prefabName)
            self.req:completed('+', function()
                self.gameObject = self.req.gameObject
                self.transform = self.req.gameObject.transform
                self:ReInit()
            end)
        end
    end
end

function FurnitureObject:InitComponent()
end

function FurnitureObject:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

--获取预制体名字
function FurnitureObject:GetPrefabName()
    local furnitureData = DataCenter.FurnitureManager:GetFurnitureByUuid(self.param.uuid)
    if furnitureData ~= nil then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(furnitureData.fId, furnitureData.lv)
        if buildLevelTemplate ~= nil and buildLevelTemplate.model ~= DefaultBuildModelName then
            return string.format(UIAssets.Furniture, buildLevelTemplate.model)
        end
    end
end

function FurnitureObject:ReInit()
    self.transform:SetParent(self.param.parent)
    self.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local quaternion = Quaternion.Euler(0, 0, 0)
    self.transform:Set_localRotation(quaternion.x, quaternion.y, quaternion.z, quaternion.w)
    self:InitComponent()
    self.gameObject:SetActive(self.param.visible)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    DataCenter.FurnitureObjectManager:CheckSelectObj(self.param.uuid)
    EventManager:GetInstance():Broadcast(EventId.FurnitureCreateObject, self.param.uuid)
end


function FurnitureObject:Refresh()
    if self.prefabName ~= "" then
        local prefabName = self:GetPrefabName()
        if prefabName ~= self.prefabName then
            self:Destroy()
            self:Create()
        end
    end
end

return FurnitureObject