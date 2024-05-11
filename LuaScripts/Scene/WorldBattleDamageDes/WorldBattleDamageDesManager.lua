---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/5/18 18:07
---

local WorldBattleDamageDesManager = BaseClass("WorldBattleDamageDesManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldBattleDamageDes = require "Scene.WorldBattleDamageDes.WorldBattleDamageDes"

local function __init(self)
    self.allTips = {}
    self.OnCreateTips ={}
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    if self.allTips~=nil then
        for k,v in pairs(self.allTips) do
            local request = v.request
            v:OnDestroy()
            request:Destroy()
        end
        self.allTips = nil
    end
    if self.OnCreateTips~=nil then
        for k,v in pairs(self.OnCreateTips) do
            v:Destroy()
        end
        self.OnCreateTips = nil
    end

end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.ShowBattleDamageType, self.ShowSiegeAttackSignal)
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.ShowBattleDamageType, self.ShowSiegeAttackSignal)
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function ChangeCameraLodSignal(lod)
    WorldBattleDamageDesManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
    if self.lodCache ~=lod then
        self.lodCache =lod
    end
end

local function RemoveAllTips(data)
    WorldBattleDamageDesManager:GetInstance():RemoveAllBuff()
end
local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    WorldBattleDamageDesManager:GetInstance():RemoveAllBuff()
end
local function RemoveAllBuff(self)
    if self.allTips~=nil then
        for k,v in pairs(self.allTips) do
            local request = v.request
            v:OnDestroy()
            request:Destroy()
        end
        self.allTips = {}
    end
    if self.OnCreateTips~=nil then
        for k,v in pairs(self.OnCreateTips) do
            v:Destroy()
        end
        self.OnCreateTips = {}
    end
end

local function ShowSiegeAttackSignal(data)
    WorldBattleDamageDesManager:GetInstance():CheckShowBattleBuff(data)
end

local function HideSiegeAttackSignal(data)
    WorldBattleDamageDesManager:GetInstance():CheckRemove(tonumber(data))
end

local function CheckShowBattleBuff(self,data)
    if self.lodCache>3 then
        return
    end
    local buffStr = string.split(data,"|")
    if #buffStr>=3 then
        local uuid = tonumber(buffStr[1])
        local pointId = tonumber(buffStr[2])
        local state = tonumber(buffStr[3])
        if state == APSDamageEffectType.MISS then
            self:ShowBattleBuff(uuid,pointId,state)
        end

    end
end

local function CheckRemove(self,uuid)
    self:RemoveOneEffect(uuid)
end

local function ShowBattleBuff(self,uuid,pointId,state)
    if SceneUtils.GetIsInWorld() == false then
        return
    end
    if self.allTips[uuid] ==nil and self.OnCreateTips[uuid] == nil then
        local request = ResourceManager:InstantiateAsync(UIAssets.BattleDamageDesTip)
        self.OnCreateTips[uuid] = request
        request:completed('+', function()
            self.OnCreateTips[uuid] =nil
            if request.isError then
                return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local buffTip = WorldBattleDamageDes.New()
            buffTip:OnCreate(request)
            local msgData = {}
            msgData.uuid = uuid
            msgData.pointId = pointId
            msgData.state = state
            buffTip:ReInit(msgData)
            self.allTips[uuid] = buffTip
        end)
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

WorldBattleDamageDesManager.OnEnterWorld = OnEnterWorld
WorldBattleDamageDesManager.OnEnterCity = OnEnterCity
WorldBattleDamageDesManager.__init = __init
WorldBattleDamageDesManager.__delete = __delete
WorldBattleDamageDesManager.AddListener = AddListener
WorldBattleDamageDesManager.RemoveListener = RemoveListener
WorldBattleDamageDesManager.RemoveOneEffect = RemoveOneEffect
WorldBattleDamageDesManager.ShowBattleBuff = ShowBattleBuff
WorldBattleDamageDesManager.CheckRemove = CheckRemove
WorldBattleDamageDesManager.CheckShowBattleBuff = CheckShowBattleBuff
WorldBattleDamageDesManager.HideSiegeAttackSignal =HideSiegeAttackSignal
WorldBattleDamageDesManager.ShowSiegeAttackSignal = ShowSiegeAttackSignal
WorldBattleDamageDesManager.UpdateLod = UpdateLod
WorldBattleDamageDesManager.RemoveAllBuff = RemoveAllBuff
WorldBattleDamageDesManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBattleDamageDesManager.RemoveAllTips =RemoveAllTips
return WorldBattleDamageDesManager