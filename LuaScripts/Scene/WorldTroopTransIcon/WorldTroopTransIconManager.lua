---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/6/13 20:35
---
local WorldTroopTransIconManager = BaseClass("WorldTroopTransIconManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldTroopTransIcon = require "Scene.WorldTroopTransIcon.WorldTroopTransIcon"

local function __init(self)
    self.allTips = {} --所有标签
    self.OnCreateTips ={}
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    self:RemoveAllEffect()
    self.allTips = nil
    self.OnCreateTips = nil
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.ShowMarchTrans, self.ShowMarchTransIconSignal)
    EventManager:GetInstance():AddListener(EventId.HideMarchTrans, self.HideMarchTransIconSignal)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.ShowMarchTrans, self.ShowMarchTransIconSignal)
    EventManager:GetInstance():RemoveListener(EventId.HideMarchTrans, self.HideMarchTransIconSignal)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
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

local function RemoveAllTips(data)
    WorldTroopTransIconManager:GetInstance():RemoveAllEffect()
end

local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    WorldTroopTransIconManager:GetInstance():RemoveAllEffect()
end

local function HideMarchTransIconSignal(uuid)
    WorldTroopTransIconManager:GetInstance():RemoveOneEffect(tonumber(uuid))

end

local function ShowMarchTransIconSignal(uuid)
    WorldTroopTransIconManager:GetInstance():CheckShowEffect(tonumber(uuid))
end


local function CheckShowEffect(self,marchUuid)
    local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if info~=nil and info:GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME then
        local troop = WorldTroopManager:GetInstance():GetTroop(marchUuid)
        if troop~=nil then
            local startTime = info.startTime
            local endTime = info.endTime
            local transform = troop:GetTransform()
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if curTime>=endTime then
                self:RemoveOneEffect(marchUuid)
                return
            end
            if self.allTips[marchUuid] ==nil and self.OnCreateTips[marchUuid] == nil then
                local request = ResourceManager:InstantiateAsync(UIAssets.TroopTransUI)
                self.OnCreateTips[marchUuid] = request
                request:completed('+', function()
                    self.OnCreateTips[marchUuid] =nil
                    if request.isError then
                        return
                    end
                    if transform==nil then
                        request:Destroy()
                    end
                    request.gameObject:SetActive(true)
                    request.gameObject.transform:SetParent(transform)
                    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    request.gameObject.transform:Set_localPosition(0, 0, 0)
                    local labelUI = WorldTroopTransIcon.New()
                    labelUI:OnCreate(request)
                    self.allTips[marchUuid] = labelUI
                    self.allTips[marchUuid]:SetShowTime(marchUuid,startTime,endTime)
                end)
            else
                if self.allTips[marchUuid]~=nil then
                    self.allTips[marchUuid]:SetShowTime(marchUuid,startTime,endTime)
                end
            end
        else
            self:RemoveOneEffect(marchUuid)
        end
    end

end

WorldTroopTransIconManager.__init = __init
WorldTroopTransIconManager.__delete = __delete
WorldTroopTransIconManager.AddListener = AddListener
WorldTroopTransIconManager.RemoveListener = RemoveListener
WorldTroopTransIconManager.RemoveOneEffect = RemoveOneEffect
WorldTroopTransIconManager.CheckShowEffect = CheckShowEffect
WorldTroopTransIconManager.HideMarchTransIconSignal =HideMarchTransIconSignal
WorldTroopTransIconManager.ShowMarchTransIconSignal =ShowMarchTransIconSignal
WorldTroopTransIconManager.RemoveAllEffect= RemoveAllEffect
WorldTroopTransIconManager.RemoveAllTips = RemoveAllTips
WorldTroopTransIconManager.OnEnterWorld = OnEnterWorld
WorldTroopTransIconManager.OnEnterCity = OnEnterCity
return WorldTroopTransIconManager