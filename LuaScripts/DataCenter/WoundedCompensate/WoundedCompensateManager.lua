---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 伤兵补偿

local WoundedCompensateManager = BaseClass("WoundedCompensateManager")
local UINpcWoundedBubble = require "DataCenter.WoundedCompensate.UINpcWoundedBubble"
local ResourceManager = CS.GameEntry.Resource

local NpcName = "CityNpc_jianzhang"

local function __init(self)
    self.bubble = nil
    self.TaskPeopleIndex = nil
    self.isCreate = false
    self.currentFollow = nil
    self.isShowNpc = false--是否显示了npc
    self:AddListener()
end

local function __delete(self)
    self.bubble = nil
    self.isCreate = nil
    self.currentFollow = nil
    self.TaskPeopleIndex = nil
    self.isShowNpc = false--是否显示了npc
    self:RemoveWoundedBubble()
    self:RemoveListener()
end

local function StartUp(self)
    if self.isCreate then
        return
    end
    self.isCreate = true
    local posArr = {}
    local vec = {}
    vec.x = DataCenter.BuildManager.main_city_pos.x - 2
    vec.y = DataCenter.BuildManager.main_city_pos.y - 2
    table.insert(posArr,vec)
    if SceneUtils.GetIsInCity() then
        self.isShowNpc = true
        DataCenter.CityNpcManager:AddOneNpc(NpcName, posArr, nil, nil, nil,2)
    end
end

local function AddWoundedBubble(self)
    if self.request ~= nil or self.bubble ~= nil then
        return
    end
    if self.isCreate == false then
        return
    end
    self.request = ResourceManager:InstantiateAsync((string.format(LoadPath.CityScene,"UINpcWoundedBubble")))
    self.request:completed('+', function()
        if self.request.isError then
            return
        end
        self.request.gameObject:SetActive(true)
        local npc = DataCenter.CityNpcManager:GetNpcObjectByName(NpcName)
        if npc then
            self.request.gameObject.transform:SetParent(npc.transform)
            -- self.request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            self.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.request.gameObject.name = "WoundedBubble"
            local pt = self.currentFollow.position
            self.request.gameObject.transform.position = Vector3.New(pt.x, pt.y, pt.z)
            --self.request.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
            self.bubble = UINpcWoundedBubble.New()
            self.bubble:OnCreate(self.request)
        end
    end)
end

local function RemoveWoundedBubble(self)
    if self.bubble ~= nil then
        self.bubble:OnDestroy()
        self.bubble = nil
    end
    if self.request ~= nil then
        self.request:Destroy()
        self.request = nil
    end
end

local function ClearBubble(self)
    self.bubble = nil
    self.request = nil
end

local function OnEnterCrossServer(data)
    DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
end

local function UpdateWoundedBubble(self,param)
    local target = param.target
    self.currentFollow = target

    if not CS.SceneManager:IsInWorld() and not CS.SceneManager:IsInCity() then
        return
    end
    if CS.SceneManager.World == nil then
        return
    end
    if self.currentFollow == nil then
        return
    end

    self:AddWoundedBubble()
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnExitPveLevel)
    EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnExitPveLevel)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnExitPveLevel)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnExitPveLevel)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function OnEnterWorld(self)
    DataCenter.WoundedCompensateManager:HideNpc()
end

local function OnEnterCity()
    DataCenter.WoundedCompensateManager:ShowNpc()
end

local function OnExitPveLevel()
    DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
    if SceneUtils.GetIsInCity() then
        DataCenter.WoundedCompensateManager:AddWoundedBubble()
    end
end

local function GetBubble(self)
    return self.bubble
end

local function HideNpc(self)
    self.isCreate = false
    DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
    if self.isShowNpc then
        DataCenter.CityNpcManager:RemoveOneNpc(NpcName)
    end
end

local function ShowNpc(self)
    DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
    local data = DataCenter.WoundedCompensateData:GetDataInfo()
    if data then
        self.isCreate = true
        local posArr = {}
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x - 2
        vec.y = DataCenter.BuildManager.main_city_pos.y - 2
        table.insert(posArr,vec)
        self.isShowNpc = true
        DataCenter.CityNpcManager:AddOneNpc(NpcName, posArr, nil, nil, nil,2)
    end
end



WoundedCompensateManager.__init = __init
WoundedCompensateManager.__delete = __delete
WoundedCompensateManager.AddWoundedBubble = AddWoundedBubble
WoundedCompensateManager.RemoveWoundedBubble = RemoveWoundedBubble
WoundedCompensateManager.ClearBubble = ClearBubble
WoundedCompensateManager.UpdateWoundedBubble = UpdateWoundedBubble
WoundedCompensateManager.StartUp = StartUp

WoundedCompensateManager.AddListener = AddListener
WoundedCompensateManager.RemoveListener = RemoveListener
WoundedCompensateManager.OnExitPveLevel = OnExitPveLevel
WoundedCompensateManager.OnEnterCrossServer = OnEnterCrossServer
WoundedCompensateManager.GetBubble = GetBubble
WoundedCompensateManager.OnEnterWorld = OnEnterWorld
WoundedCompensateManager.OnEnterCity = OnEnterCity

WoundedCompensateManager.ShowNpc = ShowNpc
WoundedCompensateManager.HideNpc = HideNpc

return WoundedCompensateManager