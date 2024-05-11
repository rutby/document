---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/25 14:44
---
local WorldBossBloodTipManager = BaseClass("WorldBossBloodTipManager", Singleton)
local WorldBossBloodTip = require "Scene.WorldBossBloodTip.WorldBossBloodTip"
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.marchHeadTopUIList = {}
    self.isOnCreateList = {}
    self.tempHideUuid = {}
    self.cacheBloodTip = {}
    self:AddListener()
    self.isViewOpen = false
end

local function __delete(self)
    self:RemoveListener()
    self:RemoveAllTip()
    self.isViewOpen = nil
    self.tempHideUuid = nil
    self.marchHeadTopUIList = nil
    self.isOnCreateList = nil
    self.cacheBloodTip = nil
end
local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.ShowActBossHeadInBattle, self.ShowTroopHeadInBattle)
    EventManager:GetInstance():AddListener(EventId.ShowActBossBattleValue, self.ShowTroopBattleSignal)
    EventManager:GetInstance():AddListener(EventId.HideActBossHead, self.HideTroopHead)
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.ShowActBossHeadInBattle, self.ShowTroopHeadInBattle)
    EventManager:GetInstance():RemoveListener(EventId.ShowActBossBattleValue, self.ShowTroopBattleSignal)
    EventManager:GetInstance():RemoveListener(EventId.HideActBossHead, self.HideTroopHead)
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function ChangeCameraLodSignal(lod)
    WorldBossBloodTipManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
    if self.lodCache ~=lod then
        self.lodCache =lod
    end
end

local function SetViewOpen(self,uuid)
    if self.isViewOpen ==false then
        self.isViewOpen = true
        if self.marchHeadTopUIList[uuid]~=nil or self.isOnCreateList[uuid]~=nil then
            self:HideHeadUI(uuid)
            self.tempHideUuid[uuid] = 1
        end
    end
end
local function SetViewClose(self)
    if self.isViewOpen == true then
        self.isViewOpen = false
        for k,v in pairs(self.tempHideUuid) do
            self:ShowHeadUI(k)
        end
    end
    self.tempHideUuid = {}
end

local function AddToBloodCacheList(self,uuid)
    local oneData = {}
    oneData.uuid = uuid
    oneData.curBlood =-1
    oneData.maxBlood = 0
    self.cacheBloodTip[uuid] = oneData
end

local function RemoveFormBloodCacheList(self,uuid)
    if self.cacheBloodTip[uuid]~=nil then
        self.cacheBloodTip[uuid] = nil
    end
end

local function RefreshToBloodCacheList(self,uuid,anger,hp,hpMax)
    if self.cacheBloodTip[uuid]~=nil then
        local data = self.cacheBloodTip[uuid]
        data.curBlood = hp
        data.maxBlood = hpMax
    end
end
local function GetBloodCacheByUuid(self,uuid)
    return self.cacheBloodTip[uuid]
end
local function ShowTroopBattleSignal(data)
    local str = data
    if str~=nil then
        local strArr = string.split(str,";")
        if #strArr>3 then
            local marchUuid = tonumber(strArr[1])
            local anger = tonumber(strArr[2])
            local hp = tonumber(strArr[3])
            local hpMax = tonumber(strArr[4])
            WorldBossBloodTipManager:GetInstance():UpdateBattleHeadUI(marchUuid,anger,hp,hpMax)
            WorldBossBloodTipManager:GetInstance():RefreshToBloodCacheList(marchUuid,anger,hp,hpMax)
        end
    end
end

local function HideTroopHead(uuid)
    WorldBossBloodTipManager:GetInstance():RemoveFormBloodCacheList(uuid)
    WorldBossBloodTipManager:GetInstance():HideHeadUI(uuid)
end


local function ShowTroopHeadInBattle(uuid)
    WorldBossBloodTipManager:GetInstance():ShowHeadUI(uuid)
end

local function ShowHeadUI(self,marchUuid)
    if SceneUtils.GetIsInWorld() == false then
        return
    end
    local troop = DataCenter.WorldPointManager:GetObjectByUuid(marchUuid)
    if troop~=nil then
        self:ShowActBossBlood(troop,marchUuid)
        self:AddToBloodCacheList(marchUuid)
    end
end
local function ShowActBossBlood(self,troop,marchUuid)
    local transform = troop:GetTransform()
    local info = DataCenter.WorldPointManager:GetPointInfoByUuid(marchUuid)
    if info~=nil then
        if self.marchHeadTopUIList[marchUuid] == nil and self.isOnCreateList[marchUuid]==nil then
            if self.isViewOpen == true then
                self.tempHideUuid[marchUuid] = 1
                return
            end
            local request = ResourceManager:InstantiateAsync(UIAssets.ActBossBloodTip)
            self.isOnCreateList[marchUuid] = request
            request:completed('+', function()
                self.isOnCreateList[marchUuid] =nil
                if request.isError then
                    return
                end

                request.gameObject:SetActive(true)
                if transform==nil then
                    request:Destroy()
                end
                request.gameObject.transform:SetParent(transform)
                request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                local tileUI = WorldBossBloodTip.New()
                tileUI:OnCreate(request)
                self.marchHeadTopUIList[marchUuid] = tileUI
                self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info)
            end)
        else
            if self.marchHeadTopUIList[marchUuid]~=nil then
                self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info)
            end
        end
    end
end

local function UpdateBattleHeadUI(self,marchUuid,anger,hp,hpMax)
    if SceneUtils.GetIsInWorld() == false then
        return
    end
    if self.lodCache~=nil and self.lodCache>3 then
        return
    end
    if self.marchHeadTopUIList[marchUuid]~=nil then
        local headUI = self.marchHeadTopUIList[marchUuid]
        headUI:RefreshSoldierData(hp,hpMax)
    end
end

local function HideHeadUI(self,marchUuid)
    if self.marchHeadTopUIList[marchUuid]~=nil or self.isOnCreateList[marchUuid]~=nil then
        local headUI = self.marchHeadTopUIList[marchUuid]
        if headUI~=nil then
            local request = headUI.request
            headUI:OnDestroy()
            if request~=nil then
                request:Destroy()
            end
            self.marchHeadTopUIList[marchUuid] = nil
        end
        local temp = self.isOnCreateList[marchUuid]
        if temp ~= nil then
            temp:Destroy()
            self.isOnCreateList[marchUuid] = nil
        end
        self.tempHideUuid[marchUuid] = nil
    end
end
local function RemoveAllTips(data)
    WorldBossBloodTipManager:GetInstance():RemoveAllTip()
end
local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    WorldBossBloodTipManager:GetInstance():RemoveAllTip()
end
local function RemoveAllTip(self)
    self.buffList ={}
    if self.marchHeadTopUIList~=nil then
        for k,v in pairs(self.marchHeadTopUIList) do
            local request = v.request
            v:OnDestroy()
            request:Destroy()
        end
        self.marchHeadTopUIList = {}
    end
    if self.isOnCreateList~=nil then
        for k,v in pairs(self.isOnCreateList) do
            v:Destroy()
        end
        self.isOnCreateList = {}
    end
    self.tempHideUuid = {}
end


WorldBossBloodTipManager.__init = __init
WorldBossBloodTipManager.__delete = __delete
WorldBossBloodTipManager.AddListener =AddListener
WorldBossBloodTipManager.RemoveListener =RemoveListener
WorldBossBloodTipManager.ShowTroopHeadInBattle =ShowTroopHeadInBattle
WorldBossBloodTipManager.HideTroopHead =HideTroopHead
WorldBossBloodTipManager.ShowTroopBattleSignal =ShowTroopBattleSignal
WorldBossBloodTipManager.ShowHeadUI =ShowHeadUI
WorldBossBloodTipManager.HideHeadUI =HideHeadUI
WorldBossBloodTipManager.UpdateBattleHeadUI =UpdateBattleHeadUI
WorldBossBloodTipManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBossBloodTipManager.UpdateLod = UpdateLod
WorldBossBloodTipManager.ShowActBossBlood = ShowActBossBlood
WorldBossBloodTipManager.SetViewOpen =SetViewOpen
WorldBossBloodTipManager.SetViewClose =SetViewClose
WorldBossBloodTipManager.RemoveAllTip = RemoveAllTip
WorldBossBloodTipManager.OnEnterCity = OnEnterCity
WorldBossBloodTipManager.RemoveAllTips = RemoveAllTips
WorldBossBloodTipManager.OnEnterWorld = OnEnterWorld
WorldBossBloodTipManager.AddToBloodCacheList= AddToBloodCacheList
WorldBossBloodTipManager.GetBloodCacheByUuid = GetBloodCacheByUuid
WorldBossBloodTipManager.RefreshToBloodCacheList = RefreshToBloodCacheList
WorldBossBloodTipManager.RemoveFormBloodCacheList = RemoveFormBloodCacheList
return WorldBossBloodTipManager