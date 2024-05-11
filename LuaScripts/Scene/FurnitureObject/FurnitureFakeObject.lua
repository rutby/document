--- Created by shimin.
--- DateTime: 2024/1/8 20:29
--- 0级绿色闪烁家具
local FurnitureFakeObject = BaseClass("FurnitureFakeObject")
local Resource = CS.GameEntry.Resource

function FurnitureFakeObject:__init(param)
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.selectMeshList = {}
    self.param = param
    self:Create()
end

function FurnitureFakeObject:Destroy()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end

    if self.selectMeshList[1] ~= nil then
        DataCenter.ShaderEffectManager:RemoveOneFurnitureFlashEffect(self.selectMeshList)
        self.selectMeshList = {}
    end
    self.transform = nil
    self.gameObject = nil
end

function FurnitureFakeObject:Create()
    if self.req == nil then
        local prefabName = self:GetPrefabName()
        if prefabName ~= nil then
            self.req = Resource:InstantiateAsync(prefabName)
            self.req:completed('+', function()
                self.gameObject = self.req.gameObject
                self.transform = self.req.gameObject.transform
                self.transform:SetParent(self.param.parent)
                self.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                local quaternion = Quaternion.Euler(0, 0, 0)
                self.transform:Set_localRotation(quaternion.x, quaternion.y, quaternion.z, quaternion.w)
                self:InitComponent()
                self.gameObject:SetActive(self.param.visible)
                self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                self.selectMeshList = {}
                local renders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
                if renders ~= nil and renders.Length > 0 then
                    for i = 0, renders.Length -1, 1 do
                        table.insert(self.selectMeshList, renders[i])
                    end
                end
                DataCenter.ShaderEffectManager:AddOneFurnitureFlashEffect(self.selectMeshList)
            end)
        end
    end
end

function FurnitureFakeObject:InitComponent()
end

function FurnitureFakeObject:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

--获取预制体名字
function FurnitureFakeObject:GetPrefabName()
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.fId, 1)
    if buildLevelTemplate ~= nil and buildLevelTemplate.model ~= DefaultBuildModelName then
        return string.format(UIAssets.Furniture, buildLevelTemplate.model)
    end
end

return FurnitureFakeObject