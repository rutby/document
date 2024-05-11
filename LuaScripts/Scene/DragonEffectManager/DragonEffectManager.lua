---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/16 18:51
---
local DragonEffectManager = BaseClass("DragonEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local DragonBuildProtectEffect = require "Scene.DragonEffectManager.DragonBuildProtectEffect"
local function __init(self)
    self.allEffect = {} --所有建筑特效
    self.OnCreateEffect ={}
    self:AddListener()
end

local function __delete(self)
    for k,v in pairs(self.allEffect) do
        local request = v.request
        v:OnDestroy()
        request:Destroy()
    end
    for k,v in pairs(self.OnCreateEffect) do
        v:Destroy()
    end
    self.OnCreateEffect = nil
    self.allEffect = nil
    self:RemoveListener()
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.DragonBuildInView, self.BuildInViewSignal)
    EventManager:GetInstance():AddListener(EventId.DragonBuildOutView, self.BuildOutViewSignal)
    EventManager:GetInstance():AddListener(EventId.QuitDragonWorld, self.RemoveAllTips)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.DragonBuildInView, self.BuildInViewSignal)
    EventManager:GetInstance():RemoveListener(EventId.DragonBuildOutView, self.BuildOutViewSignal)
    EventManager:GetInstance():RemoveListener(EventId.QuitDragonWorld, self.RemoveAllTips)
end

local function RemoveAllTips(data)
    DragonEffectManager:GetInstance():RemoveAllEffect()
end

local function RemoveAllEffect(self)
    for k,v in pairs(self.allEffect) do
        local request = v.request
        v:OnDestroy()
        request:Destroy()
    end
    for k,v in pairs(self.OnCreateEffect) do
        v:Destroy()
    end
    self.OnCreateEffect = {}
    self.allEffect = {}
end
local function ShowBuildProtectEffect(self,bUuid,posIndex,endTime,tile)
    local param = {}
    param.bUuid = bUuid
    param.posIndex = posIndex
    param.endTime = endTime
    param.tile = tile
    if self.allEffect[bUuid]==nil and self.OnCreateEffect[bUuid] == nil then
        local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/CityDomeProtectEffect_new.prefab")
        self.OnCreateEffect[bUuid] = request
        request:completed('+', function()
            self.OnCreateEffect[bUuid] =nil
            if request.isError then
                return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            local scale = 1
            request.gameObject.transform:Set_localScale(scale, scale, scale)
            local effect = DragonBuildProtectEffect.New()
            effect:OnCreate(request)
            effect:ReInit(param)
            self.allEffect[bUuid] = effect
        end)
    end
end


local function RemoveBuildProtectEffect(self,bUuid)
    local temp = self.allEffect[bUuid]
    if temp ~= nil then
        local request = temp.request
        temp:OnDestroy()
        request:Destroy()
        self.allEffect[bUuid] = nil
    end
    if self.OnCreateEffect[bUuid]~=nil then
        self.OnCreateEffect[bUuid]:Destroy()
        self.OnCreateEffect[bUuid] = nil
    end
end

local function BuildInViewSignal(uuid)
    DragonEffectManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function BuildOutViewSignal(uuid)
    DragonEffectManager:GetInstance():RemoveBuildProtectEffect(tonumber(uuid))
end


local function CheckShowEffect(self,bUuid)
    local info = DataCenter.WorldPointManager:GetPointInfoByUuid(bUuid)
    if info~=nil then
        local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
        if dragonBuildingPointInfo then
            local id = dragonBuildingPointInfo["buildId"]
            local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
            if template then
                local size = template.size
                local endTime = dragonBuildingPointInfo.protectTime
                local curTime = UITimeManager:GetInstance():GetServerTime()
                if curTime<endTime then
                    self:ShowBuildProtectEffect(info.uuid,info.mainIndex,endTime,size)
                end
            end
        end
    end
end


local function TimeCallBack(bUuid)
    DragonEffectManager:GetInstance():RemoveOneEffect(bUuid)
end

DragonEffectManager.__init = __init
DragonEffectManager.__delete = __delete
DragonEffectManager.AddListener = AddListener
DragonEffectManager.RemoveListener = RemoveListener
DragonEffectManager.BuildInViewSignal = BuildInViewSignal
DragonEffectManager.BuildOutViewSignal = BuildOutViewSignal
DragonEffectManager.RemoveBuildProtectEffect= RemoveBuildProtectEffect
DragonEffectManager.CheckShowEffect = CheckShowEffect
DragonEffectManager.ShowBuildProtectEffect = ShowBuildProtectEffect
DragonEffectManager.TimeCallBack = TimeCallBack
DragonEffectManager.RemoveAllEffect = RemoveAllEffect
DragonEffectManager.RemoveAllTips = RemoveAllTips
return DragonEffectManager