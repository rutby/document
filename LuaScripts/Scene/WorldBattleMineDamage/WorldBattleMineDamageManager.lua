---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/9/19 20:39
---
local WorldBattleMineDamageManager = BaseClass("WorldBattleMineDamageManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldBattleMineDamage = require "Scene.WorldBattleMineDamage.WorldBattleMineDamage"
local Localization = CS.GameEntry.Localization
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
    EventManager:GetInstance():AddListener(EventId.MergeEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.ShowTroopMineDamage, self.ShowSiegeAttackSignal)
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.MergeEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.ShowTroopMineDamage, self.ShowSiegeAttackSignal)
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function ChangeCameraLodSignal(lod)
    WorldBattleMineDamageManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
    if self.lodCache ~=lod then
        self.lodCache =lod
    end
end

local function RemoveAllTips(data)
    WorldBattleMineDamageManager:GetInstance():RemoveAllBuff()
end
local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    WorldBattleMineDamageManager:GetInstance():RemoveAllBuff()
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
    WorldBattleMineDamageManager:GetInstance():CheckShowBattleBuff(data)
end

local function HideSiegeAttackSignal(data)
    WorldBattleMineDamageManager:GetInstance():CheckRemove(tonumber(data))
end

local function CheckShowBattleBuff(self,data)
    if self.lodCache>3 then
        return
    end
    local buffStr = string.split(data,"|")
    if #buffStr>=4 then
        local uuid = tonumber(buffStr[1])
        local pointId = tonumber(buffStr[2])
        local num = tonumber(buffStr[3])
        local skillId= tonumber(buffStr[4])
        self:ShowBattleBuff(uuid,pointId,num,skillId)
    end
end

local function CheckRemove(self,uuid)
    self:RemoveOneEffect(uuid)
end

local function ShowBattleBuff(self,uuid,pointId,num,skillId)
    if SceneUtils.GetIsInWorld() == false then
        return
    end
    local skillName = GetTableData(TableName.SkillTab, skillId, "name")
    if skillName~=nil and skillName~=""then
        skillName = Localization:GetString(skillName)
        if self.allTips[uuid] ==nil and self.OnCreateTips[uuid] == nil then
            local request = ResourceManager:InstantiateAsync(UIAssets.BattleMineDamageTip)
            self.OnCreateTips[uuid] = request
            request:completed('+', function()
                self.OnCreateTips[uuid] =nil
                if request.isError then
                    return
                end
                request.gameObject:SetActive(true)
                request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
                request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local buffTip = WorldBattleMineDamage.New()
                buffTip:OnCreate(request)
                local msgData = {}
                msgData.uuid = uuid
                msgData.pointId = pointId
                msgData.damageNum = num
                msgData.name = skillName
                buffTip:ReInit(msgData)
                self.allTips[uuid] = buffTip
            end)
        end
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

WorldBattleMineDamageManager.OnEnterWorld = OnEnterWorld
WorldBattleMineDamageManager.OnEnterCity = OnEnterCity
WorldBattleMineDamageManager.__init = __init
WorldBattleMineDamageManager.__delete = __delete
WorldBattleMineDamageManager.AddListener = AddListener
WorldBattleMineDamageManager.RemoveListener = RemoveListener
WorldBattleMineDamageManager.RemoveOneEffect = RemoveOneEffect
WorldBattleMineDamageManager.ShowBattleBuff = ShowBattleBuff
WorldBattleMineDamageManager.CheckRemove = CheckRemove
WorldBattleMineDamageManager.CheckShowBattleBuff = CheckShowBattleBuff
WorldBattleMineDamageManager.HideSiegeAttackSignal =HideSiegeAttackSignal
WorldBattleMineDamageManager.ShowSiegeAttackSignal = ShowSiegeAttackSignal
WorldBattleMineDamageManager.UpdateLod = UpdateLod
WorldBattleMineDamageManager.RemoveAllBuff = RemoveAllBuff
WorldBattleMineDamageManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBattleMineDamageManager.RemoveAllTips =RemoveAllTips
return WorldBattleMineDamageManager