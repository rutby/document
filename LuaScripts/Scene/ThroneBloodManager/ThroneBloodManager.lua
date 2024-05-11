---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/3/24 10:48
---
local ThroneBloodManager = BaseClass("ThroneBloodManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local ThroneHeadUI = require "Scene.ThroneBloodManager.ThroneHeadUI"
local function __init(self)
    self.allTips = {} --所有标签
    self.OnCreateTips = {}
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    self:RemoveAllEffect()
    self.allTips = nil
    self.OnCreateTips = nil
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.ShowThroneArmyHeadUI, self.ShowThroneArmyHeadUISignal)
    EventManager:GetInstance():AddListener(EventId.HideThroneArmyHeadUI, self.HideThroneArmyHeadUISignal)
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnBeforeEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.ShowThroneArmyHeadUI, self.ShowThroneArmyHeadUISignal)
    EventManager:GetInstance():RemoveListener(EventId.HideThroneArmyHeadUI, self.HideThroneArmyHeadUISignal)
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnBeforeEnterCity, self.OnEnterCity)
end

local function ChangeCameraLodSignal(lod)
    ThroneBloodManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
    if self.lodCache ~= lod then
        self.lodCache = lod
    end
end

local function RemoveOneEffect(self,uuid)
    local temp = self.allTips[uuid]
    if temp ~= nil then
        local request = temp.request
        temp:OnDestroy()
        request:Destroy()
        self.allTips[uuid] = nil
    end
    temp = self.OnCreateTips[uuid]
    if temp ~= nil then
        temp:Destroy()
        self.OnCreateTips[uuid] = nil
    end
end

local function RemoveAllTips(data)
    ThroneBloodManager:GetInstance():RemoveAllEffect()
end

local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    ThroneBloodManager:GetInstance():RemoveAllEffect()
end


local function RemoveAllEffect(self)
    for k,v in pairs(self.allTips) do
        local request = v.request
        v:OnDestroy()
        request:Destroy()
    end
    self.allTips = {}
    for k,v in pairs(self.OnCreateTips) do
        v:Destroy()
    end
    self.OnCreateTips = {}
end

local function HideThroneArmyHeadUISignal(uuid)
    ThroneBloodManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function ShowThroneArmyHeadUISignal(data)
    local str = data
    if str ~= nil then
        local strArr = string.split(str, ";")
        if #strArr >=3 then
            local uuid = tonumber(strArr[1])
            local hp = tonumber(strArr[2])
            local hpMax = tonumber(strArr[3])
            ThroneBloodManager:GetInstance():CheckShowThroneBlood(uuid,hpMax, hp)
        end
    end
end

local function CheckShowThroneBlood(self,marchUuid, initHealth, curHealth)
    if SceneUtils.GetIsInWorld() == false then
        return
    end
    if self.allTips[marchUuid] == nil and self.OnCreateTips[marchUuid] == nil then
        if self.lodCache ~= nil and self.lodCache > 3 then
            return
        end
        local request = ResourceManager:InstantiateAsync(UIAssets.ThroneBuildBloodTip)
        self.OnCreateTips[marchUuid] = request
        request:completed('+', function()
            self.OnCreateTips[marchUuid] = nil
            if request.isError then
                return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
            request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local labelUI = ThroneHeadUI.New()
            labelUI:OnCreate(request)
            self.allTips[marchUuid] = labelUI
            self.allTips[marchUuid]:ShowBloodInfo(marchUuid,initHealth, curHealth)
        end)
    else
        if self.allTips[marchUuid] ~= nil then
            self.allTips[marchUuid]:SetHP(curHealth, initHealth)
        end
    end
end



ThroneBloodManager.__init = __init
ThroneBloodManager.__delete = __delete
ThroneBloodManager.AddListener = AddListener
ThroneBloodManager.RemoveListener = RemoveListener
ThroneBloodManager.RemoveOneEffect = RemoveOneEffect
ThroneBloodManager.UpdateLod = UpdateLod
ThroneBloodManager.ChangeCameraLodSignal = ChangeCameraLodSignal
ThroneBloodManager.RemoveAllEffect  = RemoveAllEffect
ThroneBloodManager.RemoveAllTips = RemoveAllTips
ThroneBloodManager.OnEnterWorld = OnEnterWorld
ThroneBloodManager.OnEnterCity = OnEnterCity
ThroneBloodManager.HideThroneArmyHeadUISignal =HideThroneArmyHeadUISignal
ThroneBloodManager.ShowThroneArmyHeadUISignal = ShowThroneArmyHeadUISignal
ThroneBloodManager.CheckShowThroneBlood =CheckShowThroneBlood
return ThroneBloodManager