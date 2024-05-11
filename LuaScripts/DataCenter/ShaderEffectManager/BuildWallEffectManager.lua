--建筑墙表现管理器
local BuildWallEffectManager = BaseClass("BuildWallEffectManager")
local Resource = CS.GameEntry.Resource

local MinColor = Color.New(1,1,1,0/255)
local MaxColor = Color.New(1,1,1,1)
local ChangeTime = 0.4

local AnimState =
{
    ToMin = 1,--虚化
    ToMax = 2,--恢复
    Min = 3,--虚化完毕
    Max = 4,--恢复完毕
}

function BuildWallEffectManager:__init()
    self.originalMaterial = {}
    self.isShow = true
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
    self.toggleFlashId = CS.UnityEngine.Shader.PropertyToID("_BaseColor")
    self.curTime = 0
    self.state = AnimState.Max
    self.needRemoveBuild = {}
    self.time = 0
    self:AddListener()
end

function BuildWallEffectManager:__delete()
    if self.__update_handle~=nil then
        UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
        self.__update_handle = nil
    end
    self:RemoveListener()
    self.originalMaterial = {}
    self.isShow = true
    self.needRemoveBuild = {}
    self.time = 0
    self.state = AnimState.Max
end
function BuildWallEffectManager:Startup()

end

function BuildWallEffectManager:AddListener()
    if self.refreshCityBuildMarkSignal == nil then
        self.refreshCityBuildMarkSignal = function(uuid)
            self:RefreshCityBuildMarkSignal(uuid)
        end
        EventManager:GetInstance():AddListener(EventId.RefreshCityBuildMark, self.refreshCityBuildMarkSignal)
    end
end

function BuildWallEffectManager:RemoveListener()
    if self.refreshCityBuildMarkSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.RefreshCityBuildMark, self.refreshCityBuildMarkSignal)
        self.refreshCityBuildMarkSignal = nil
    end
end

function BuildWallEffectManager:AddOneWallEffect(bUuid)
    local list = DataCenter.FurnitureObjectManager:GetBuildWall(bUuid)
    if list ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        if buildData ~= nil then
            local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
            if desTemplate ~= nil and desTemplate.hide_wall ~= nil and desTemplate.hide_wall[1] ~= nil then
                for k,v in ipairs(desTemplate.hide_wall) do
                    if list[v] ~= nil then
                        for k1, v1 in pairs(list[v]) do
                            if v1.material.shader.name == "DarkRim/BuildUnit" then
                                if self.originalMaterial[bUuid] == nil then
                                    self.originalMaterial[bUuid] = {}
                                end
                                self.originalMaterial[bUuid][v1] = v1.sharedMaterial
                                self:SetMaterialProperty(v1.sharedMaterial,false)
                            end
                        end
                    end
                end
            end
        end
    end
end

function BuildWallEffectManager:SetMaterialProperty(material,t)
	local dstQueue = t and 2000 or 3000
	local zWrite = t and 1 or 0
	local srcBlend = (t and 1 or 5)
	local dstBlend = (t and 0 or 10)	
	material:SetInt("_ZWrite", zWrite)
	material.renderQueue = dstQueue
	material:SetInt("_SrcBlend", srcBlend)
	material:SetInt("_DstBlend", dstBlend)
end

function BuildWallEffectManager:RemoveOneWallEffect(bUuid)
    local list = self.originalMaterial[bUuid]
    if list ~= nil then
        for k, v in pairs(list) do
			self:SetMaterialProperty(k.sharedMaterial,true)
        end
        self.originalMaterial[bUuid] = nil
    end
    DataCenter.FurnitureObjectManager:SetFurnitureVisible(bUuid, false)
end

function BuildWallEffectManager:RefreshCityBuildMarkSignal()
    self.isShow = not DataCenter.CityLabelManager:IsShowBuildMark()
    local list = DataCenter.FurnitureObjectManager.furnitureTransformDic
    if list ~= nil then
        for k, v in pairs(list) do
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(k)
            if buildData ~= nil and buildData.level > 0 and buildData:IsUpgrading() then
                self:RemoveOneWallEffect(k)
            elseif not DataCenter.CityLabelManager:IsNeedHideMark(k) then
                self:RefreshOneWallEffect(k)
            end
        end
    end
end

function BuildWallEffectManager:RefreshOneWallEffect(bUuid)
    if self.originalMaterial[bUuid] == nil then
        self:AddOneWallEffect(bUuid)
    end
    if self.isShow then
        self:EnterAnim()
        DataCenter.FurnitureObjectManager:SetFurnitureVisible(bUuid, true)
    else
        self:ResetAnim()
        DataCenter.FurnitureObjectManager:SetFurnitureVisible(bUuid, false)
    end
end

function BuildWallEffectManager:EnterAnim()
    self.curTime = 0
    self.time = ChangeTime
    self.from = MaxColor
    self.to = MinColor
    self.state = AnimState.ToMin
end

function BuildWallEffectManager:ResetAnim()
    self.curTime = 0
    self.time = ChangeTime
    self.from = MinColor
    self.to = MaxColor
    self.state = AnimState.ToMax
end

function BuildWallEffectManager:Update()
    if self.time ~= 0 then
        self.curTime = self.curTime + Time.deltaTime
        if self.curTime > self.time then
            self.curTime = 0
            self.time = 0
            self:SetMaterialColor(self.to)
            if self.state == AnimState.ToMin then
                self.state = AnimState.Min
            elseif self.state == AnimState.ToMax then
                self.state = AnimState.Max
                for k,v in pairs(self.originalMaterial) do
                    for k1, v1 in pairs(v) do
                        self:SetMaterialProperty(k1.sharedMaterial, true)
                    end
                end
                self.originalMaterial = {}
            end
        else
            self:SetMaterialColor(Color.Lerp(self.from, self.to, self.curTime / self.time))
        end
    end
end

function BuildWallEffectManager:SetMaterialColor(value)
    for k,v in pairs(self.originalMaterial) do
        if not DataCenter.CityLabelManager:IsNeedHideMark(k) then
            for k1, v1 in pairs(v) do
                v1:SetColor(self.toggleFlashId, value)
            end
        end
    end
end

function BuildWallEffectManager:SetOriginalMaterial(bUuid, visible)
    if visible then
        if self.originalMaterial[bUuid] == nil then
            self:AddOneWallEffect(bUuid)
        end
    else
        if self.originalMaterial[bUuid] ~= nil then
            self.originalMaterial[bUuid] = nil
        end
    end
end


return BuildWallEffectManager