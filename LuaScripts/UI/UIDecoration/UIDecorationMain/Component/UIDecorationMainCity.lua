---
--- Created by shimin.
--- DateTime: 2023/5/8 21:25
---
local UIDecorationMainCity = BaseClass("UIDecorationMainCity", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera

local LayerName = "Hide"
local ResetLayerName = "Default"
local ResetMarchLayerName = "WorldArmy"

local ResetMarchRotation = Vector3.New(0, 225, 0)

--创建
function UIDecorationMainCity:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIDecorationMainCity:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDecorationMainCity:ComponentDefine()

end

function UIDecorationMainCity:ComponentDestroy()
   
end

function UIDecorationMainCity:DataDefine()
    self.mainCamera = Camera.main
    self.mainCullingMask = self.mainCamera.cullingMask
    self.data = {}
    self.resetLayer = ResetLayerName
    self.enable_cell = {}
end

function UIDecorationMainCity:DataDestroy()
    self.data = {}
    self:DestroyModel()
    self:DestroyScene()
end

function UIDecorationMainCity:OnEnable()
    base.OnEnable(self)
end

function UIDecorationMainCity:OnDisable()
    base.OnDisable(self)
    self:EnableWorldCamera()
end

function UIDecorationMainCity:ReInit(data)
    self.data = data
    self:RefreshView()
    self:LoadScene()
end

function UIDecorationMainCity:RefreshView()
    self:DestroyModel()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
    if template.type == DecorationType.DecorationType_Main_City then
        self:LoadBuild()
    elseif template.type == DecorationType.DecorationType_TittleName then
        self:LoadTitleBuild(template.img)
    elseif template.type == DecorationType.DecorationType_MarchSkin then
        self:LoadMarch(template)
    end
end

function UIDecorationMainCity:LoadBuild()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
    local modelName = ""
    if template:IsDefault() then
        local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, mainBuild.level)
        if buildTemplate ~= nil then
            modelName = buildTemplate.model_world
        end
    else
        modelName = template.model_world
    end
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/Building/"..modelName..".prefab")
    
    self.request = request
    request:completed('+', function()
        if request.isError then
            return
        end
        if request.gameObject == nil then
            return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform.position = DecorationUtil.GetWorldPos()
        self.resetLayer = ResetLayerName
        request.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(LayerName))
        local worldLabelGo = request.gameObject.transform:Find("ModelGo/CityLabel")
        if worldLabelGo ~= nil then
            worldLabelGo.gameObject:SetActive(false)
        end
    end)
end

function UIDecorationMainCity:LoadTitleBuild(icon)
    local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/Building/"..modelName..".prefab")
    self.request = request
    request:completed('+', function()
        if request.isError then
            return
        end
        if request.gameObject == nil then
            return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform.position = DecorationUtil.GetWorldPos()
        self.resetLayer = ResetLayerName
        request.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(LayerName))
        local worldLabelGo = request.gameObject.transform:Find("ModelGo/CityLabel")
        if worldLabelGo ~= nil then
            worldLabelGo.gameObject:SetActive(true)
            local worldLabel = worldLabelGo:GetComponent(typeof(CS.UIWorldLabel))
            if worldLabel ~= nil then
                if worldLabel.SetNameBgSkin ~= nil then
                    worldLabel:SetNameBgSkin(self.data.decorationId)
                end
                local nameStr = LuaEntry.Player.name
                if LuaEntry.Player:IsInAlliance() then
                    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
                    if allianceBase then
                        nameStr = "[" .. allianceBase.abbr .. "]" .. LuaEntry.Player.name
                    end
                end
                worldLabel:SetName(nameStr, WorldGreenColor)
                local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
                if buildData ~= nil then
                    worldLabel:SetLevel(buildData.level)
                end
            else
                local levelLabel = request.gameObject.transform:Find("ModelGo/CityLabel/LevelLabel/LevelText"):GetComponent((typeof(CS.SuperTextMesh)))
                local nameLabel = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel/NameText"):GetComponent((typeof(CS.SuperTextMesh)))
                local nameLabelBg = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel"):GetComponent((typeof(CS.UnityEngine.SpriteRenderer)))
                if levelLabel then
                    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
                    if buildData ~= nil then
                        levelLabel.text = tostring(buildData.level)
                    end
                end
                if nameLabel then
                    nameLabel.text = LuaEntry.Player.name
                    nameLabel.color32 = WorldGreenColor32
                    nameLabelBg.size = Vector2.New(1.6, nameLabelBg.size.y)
                end
                if nameLabelBg then
                    nameLabelBg:LoadSprite(icon)
                end
            end
        end
    end)
end

function UIDecorationMainCity:EnableWorldCamera()
    self.mainCamera.cullingMask = self.mainCullingMask
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIDecorationMain) then
        if CS.SceneManager.World ~= nil then
            CS.SceneManager.World:AutoLookat(DecorationUtil.GetCityPos(), DataCenter.CityCameraManager:GetDecorationMainViewCameraZoom(), 0)
        end
    end
end

function UIDecorationMainCity:DisableWorldCamera()
    self.mainCamera.cullingMask = 1 << CS.UnityEngine.LayerMask.NameToLayer(LayerName)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
    if template.type == DecorationType.DecorationType_MarchSkin then
        CS.SceneManager.World:AutoLookat(DecorationUtil.GetWorldCameraPos(), DataCenter.CityCameraManager:GetDecorationMarchViewCameraZoom(), 0)
    else
        CS.SceneManager.World:AutoLookat(DecorationUtil.GetWorldCameraPos(), DataCenter.CityCameraManager:GetDecorationWorldViewCameraZoom(), 0)
    end
end

function UIDecorationMainCity:DestroyModel()
    for k, v in pairs(self.enable_cell) do
        if v ~= nil then
            v.enabled = true
        end
    end
    self.enable_cell = {}
    if self.request ~= nil then
        if self.request.gameObject ~= nil then
            self.request.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(self.resetLayer))
        end
        self.request:Destroy()
        self.request = nil
    end
end

function UIDecorationMainCity:LoadScene()
    if self.scene == nil then
        self.scene = ResourceManager:InstantiateAsync(UIAssets.UIDecorationWorldScene)
        self.scene:completed('+', function()
            if self.scene.isError then
                return
            end
            self.scene.gameObject:SetActive(true)
            self.scene.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.scene.gameObject.transform.position = DecorationUtil.GetWorldPos()
            self:DisableWorldCamera()
        end)
    else
        if self.scene.gameObject ~= nil then
            self.scene.gameObject.transform.position = DecorationUtil.GetWorldPos()
        end
        self:DisableWorldCamera()
    end
end

function UIDecorationMainCity:DestroyScene()
    if self.scene ~= nil then
        self.scene:Destroy()
        self.scene = nil
    end
end


function UIDecorationMainCity:LoadMarch(template)
    local request = ResourceManager:InstantiateAsync(string.format(UIAssets.March, template.model_world))
    self.request = request
    request:completed('+', function()
        if request.isError then
            return
        end
        if request.gameObject == nil then
            return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform.position = DecorationUtil.GetMarchPos()
        self.resetLayer = ResetMarchLayerName
        request.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(LayerName))
        local model = request.gameObject.transform:Find("Model")
        if model ~= nil then
            model.transform.rotation = Quaternion.Euler(ResetMarchRotation.x, ResetMarchRotation.y, ResetMarchRotation.z)
        end
        local AutoAdjustScale = request.gameObject:GetComponent(typeof(CS.AutoAdjustScale))
        if AutoAdjustScale ~= nil then
            AutoAdjustScale.enabled = false
            table.insert(self.enable_cell, AutoAdjustScale)
        end
    end)
end


return UIDecorationMainCity
