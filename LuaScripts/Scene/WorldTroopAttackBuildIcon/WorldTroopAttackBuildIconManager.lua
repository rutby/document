---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/12/24 15:37
---
local WorldTroopAttackBuildIconManager = BaseClass("WorldTroopAttackBuildIconManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldTroopAttackBuildIcon = require "Scene.WorldTroopAttackBuildIcon.WorldTroopAttackBuildIcon"

local function __init(self)
    self.allTips = {} --所有标签
    self.OnCreateTips ={}
    self:AddListener()
    self.showIcon= Setting:GetBool("ShowTroopDestroyIcon",true)
end

local function __delete(self)
    self:RemoveListener()
    self:RemoveAllEffect()
    self.allTips = nil
    self.OnCreateTips = nil
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.ShowTroopAtkBuildIcon, self.ShowTroopAtkBuildIconSignal)
    EventManager:GetInstance():AddListener(EventId.HideTroopAtkBuildIcon, self.HideTroopAtkBuildIconSignal)
    EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
    EventManager:GetInstance():AddListener(EventId.ChangeShowTroopDestroyIconState, self.OnRefreshTroopIconSignal)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.ShowTroopAtkBuildIcon, self.ShowTroopAtkBuildIconSignal)
    EventManager:GetInstance():RemoveListener(EventId.HideTroopAtkBuildIcon, self.HideTroopAtkBuildIconSignal)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
    EventManager:GetInstance():RemoveListener(EventId.ChangeShowTroopDestroyIconState, self.OnRefreshTroopIconSignal)
end

local function OnRefreshTroopIconSignal()
    WorldTroopAttackBuildIconManager:GetInstance():OnRefreshTroopIcon()
end

local function OnRefreshTroopIcon(self)
    local showIcon = Setting:GetBool("ShowTroopDestroyIcon",true)
    if self.showIcon~=showIcon then
        if self.showIcon == true then
            self:RemoveAllEffect()
        end
        self.showIcon = showIcon
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

local function HideTroopAtkBuildIconSignal(uuid)
    WorldTroopAttackBuildIconManager:GetInstance():RemoveOneEffect(tonumber(uuid))

end

local function ShowTroopAtkBuildIconSignal(uuid)
    WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function RemoveAllTips(data)
    WorldTroopAttackBuildIconManager:GetInstance():RemoveAllEffect()
end

local function OnEnterWorld(data)
end
local function OnEnterCity(data)
    WorldTroopAttackBuildIconManager:GetInstance():RemoveAllEffect()
end

local function CheckShowEffect(self,marchUuid)
    if self.showIcon ==false then
        return
    end
    local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if info~=nil and info:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
        local troop = WorldTroopManager:GetInstance():GetTroop(marchUuid)
        if troop~=nil and troop:IsBattle() == false then
            local startTime = info.startTime
            local endTime = info.endTime
            local transform = troop:GetTransform()
            if self.allTips[marchUuid] ==nil and self.OnCreateTips[marchUuid] == nil then
                local request = ResourceManager:InstantiateAsync(UIAssets.TroopAttackBuildUI)
                self.OnCreateTips[marchUuid] = request
                request:completed('+', function()
                    self.OnCreateTips[marchUuid] =nil
                    if request.isError then
                        return
                    end
                    if transform==nil then
                        request:Destroy()
                        return
                    end
                    request.gameObject:SetActive(true)
                    request.gameObject.transform:SetParent(transform)
                    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    request.gameObject.transform:Set_localPosition(0, 0, 0)
                    local labelUI = WorldTroopAttackBuildIcon.New()
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

WorldTroopAttackBuildIconManager.__init = __init
WorldTroopAttackBuildIconManager.__delete = __delete
WorldTroopAttackBuildIconManager.AddListener = AddListener
WorldTroopAttackBuildIconManager.RemoveListener = RemoveListener
WorldTroopAttackBuildIconManager.RemoveOneEffect = RemoveOneEffect
WorldTroopAttackBuildIconManager.CheckShowEffect = CheckShowEffect
WorldTroopAttackBuildIconManager.HideTroopAtkBuildIconSignal =HideTroopAtkBuildIconSignal
WorldTroopAttackBuildIconManager.ShowTroopAtkBuildIconSignal =ShowTroopAtkBuildIconSignal
WorldTroopAttackBuildIconManager.RemoveAllEffect= RemoveAllEffect
WorldTroopAttackBuildIconManager.RemoveAllTips = RemoveAllTips
WorldTroopAttackBuildIconManager.OnEnterWorld = OnEnterWorld
WorldTroopAttackBuildIconManager.OnEnterCity = OnEnterCity
WorldTroopAttackBuildIconManager.OnRefreshTroopIcon = OnRefreshTroopIcon
WorldTroopAttackBuildIconManager.OnRefreshTroopIconSignal =OnRefreshTroopIconSignal
return WorldTroopAttackBuildIconManager