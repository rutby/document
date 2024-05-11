---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 上午11:31
---
local WorldTroop = require"Scene.WorldTroopManager.WorldTroop"
local WorldTroopManager = BaseClass("WorldTroopManager", Singleton)
local SelfMarchLod = 8
local OtherMarchLod = 4
local ResourceManager = CS.GameEntry.Resource
function WorldTroopManager:__init()
    self.syncTime = 0
    self.lodLv = 1
    self.troopDic = {}
    self.createMarchDict = {}
    self.destroyMarchDict ={}
    self.dragTroopLineInst = nil
    self.dragTroopLine = nil
    self.troopDestinationInst = nil
    self.troopDestination = nil
    self.vfxList = {}
    self.on_LodChanged = function(msg) self:OnLodChanged(msg) end
    
end

function WorldTroopManager:__delete()
end
function WorldTroopManager:StartUp()
    self.syncTime = 0
    self.lodLv = 1
    self.troopDic = {}
    self.createMarchDict = {}
    self.destroyMarchDict ={}
    self.dragTroopLineInst = nil
    self.dragTroopLine = nil
    self.troopDestinationInst = nil
    self.troopDestination = nil
    self.vfxList = {}
    self.needUpdateTroopList = {}
    
    self:AddListener()
    self:EnableUpdate()
    self.isInit = true
end
function WorldTroopManager:Close()
    self.isInit = false
    if self.troopDic~=nil then
        for k,v in pairs(self.troopDic) do
            v:Destroy()
        end
        self.troopDic = {}
    end
    if self.vfxList~=nil then
        for k,v in pairs(self.vfxList) do
            if v.inst~=nil then
                v.inst:Destroy()
            end
        end
        self.vfxList = {}
    end
    self.syncTime = 0
    self.lodLv = 1
    self.troopDic = {}
    self.needUpdateTroopList = {}
    self.createMarchDict = {}
    self.destroyMarchDict ={}
    self.dragTroopLineInst = nil
    self.dragTroopLine = nil
    self.troopDestinationInst = nil
    self.troopDestination = nil
    self.vfxList = {}
    self:RemoveListener()
    self:DisableUpdate()
end
function WorldTroopManager:EnableUpdate()
    self:DisableUpdate()
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end
function WorldTroopManager:DisableUpdate()
    if self.__update_handle then
        UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
        self.__update_handle = nil
    end
end

function WorldTroopManager:AddListener()
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.on_LodChanged)
end

function WorldTroopManager:RemoveListener()
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.on_LodChanged)
end
function WorldTroopManager:Update()
    if self.isInit ==false then
        return
    end
    self.syncTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = Time.deltaTime
    self:UpdateAllTroops()
    self:UpdateBattleVFX(deltaTime)
    self:CreateTroopsAsync()
    self:DestroyTroopsAsync()
end
function WorldTroopManager:IsSyncBusy()
    return (UITimeManager:GetInstance():GetServerTime()-self.syncTime) >= 10
end
function WorldTroopManager:UpdateAllTroops()
    local needRemove = {}
    for k,v in pairs(self.needUpdateTroopList) do
        local item = self.troopDic[k]
        if item~=nil then
            item:OnUpdate()
            if item:IsDelayDestroyed() then
                self:DestroyTroop(k)
                table.insert(needRemove,k)
            end
        else
            table.insert(needRemove,k)
        end
    end
    for i=1,#needRemove do
        self:UpdateListRemove(needRemove[i])
    end
end
function WorldTroopManager:AddToUpdateList(marchUuid)
    self.needUpdateTroopList[marchUuid] = 1
end
function WorldTroopManager:UpdateListRemove(marchUuid)
    self.needUpdateTroopList[marchUuid] = nil
end
function WorldTroopManager:CreateBattleVFX(prefabPath,life,callBack)
   local inst = ResourceManager:InstantiateAsync(prefabPath)
    local item = {}
    item.inst = inst
    item.life  =life
    table.insert(self.vfxList,item)
    inst:completed('+',function()
        if inst.isError or inst.gameObject == nil then
            return
        end
        callBack(inst.gameObject)
    end)
end
function WorldTroopManager:UpdateBattleVFX(deltaTime)
    local needRemoveList = {}
    for k,v in pairs(self.vfxList) do
        if v.life ~=nil then
            v.life = v.life - deltaTime
            if v.life<=0 then
                table.insert(needRemoveList,k)
            end
        end
    end
    for i=1,#needRemoveList do
        local key = needRemoveList[i]
        local value = self.vfxList[key]
        if value~=nil then
            local inst = value.inst
            if inst~=nil then
                inst:Destroy()
            end
        end
        self.vfxList[key] = nil
    end
end

function WorldTroopManager:OnLodChanged(lod)
    if self.lodLv~=lod then
        self.lodLv = lod
    end
end

function WorldTroopManager:CreateTroopsAsync()
    local count = 0
    local beforeTime = UITimeManager:GetInstance():GetServerTime()
    local removeList = {}
    local isBreak = false
    for k,v in pairs(self.createMarchDict) do
        if self:IsSyncBusy() then
            Logger.Log("[world Troop] BuildAsync break because long  count"..count)
            isBreak = true
            break
        end
        local checkLod =  OtherMarchLod
        local marchData = DataCenter.WorldMarchDataManager:GetMarch(k)
        if marchData~=nil then
            if marchData.ownerUid == LuaEntry.Player.uid then
                checkLod = SelfMarchLod
            end
            if self.lodLv <=checkLod then
                self:CreateTroopObj(k)
            end
        end
        table.insert(removeList,k)
        count = count+1
    end
    for i =1,#removeList do
        local key = removeList[i]
        self.createMarchDict[key] = nil
    end
    if isBreak ==false then
        local endTime = UITimeManager:GetInstance():GetServerTime()
        if count>0 then
            Logger.Log(string.format("[world Troop] BuildAsync %s data  use %s ms",count,(endTime-beforeTime)))
        end
    end
    
end
function WorldTroopManager:DestroyTroopsAsync()
    local count = 0
    local beforeTime = UITimeManager:GetInstance():GetServerTime()
    local removeList = {}
    local isBreak = false
    for k,v in pairs(self.destroyMarchDict) do
        if self:IsSyncBusy() then
            Logger.Log("[world Troop] DestroyTroopsAsync break, count"..count)
            isBreak = true
            break
        end
        self:DestroyTroopObj(k)
        table.insert(removeList,k)
        count = count+1
    end
    for i =1,#removeList do
        local key = removeList[i]
        self.destroyMarchDict[key] = nil
    end
    if isBreak ==false then
        local endTime = UITimeManager:GetInstance():GetServerTime()
        if count>0 then
            Logger.Log(string.format("[world Troop] DestroyTroopsAsync %s data  use %s ms",count,(endTime-beforeTime)))
        end
    end
end
function WorldTroopManager:CreateTroop(marchUuid)
    local value = self.troopDic[marchUuid]
    if value~=nil then
        value:Refresh()
    else
        self.createMarchDict[marchUuid] = true
        self.destroyMarchDict[marchUuid] = nil
    end
end
function WorldTroopManager:DestroyTroop(marchUuid,isBattleFailed)
    if isBattleFailed then
        local troop = self:GetTroop(marchUuid)
        if troop~=nil then
            troop:ShowBattleDefeat()
            troop:DelayDestroy(2.14)
        end
    else
        self.destroyMarchDict[marchUuid] = isBattleFailed
        self.createMarchDict[marchUuid] = nil
    end
end
function WorldTroopManager:GetTroop(marchUuid)
    if CommonUtil.IsUseLuaWorldPoint() ==false and SceneUtils.GetIsInWorld() and CS.SceneManager.World ~= nil and CS.SceneManager.World:IsBuildFinish()  then
        return CS.SceneManager.World:GetTroop(marchUuid)
    end
    return self.troopDic[marchUuid]
end
function WorldTroopManager:CreateTroopObj(marchUuid)
    if self.troopDic[marchUuid] == nil then
        local troop = WorldTroop.New()
        troop:Create(marchUuid)
        self.troopDic[marchUuid] = troop
    else
        self.troopDic[marchUuid]:Refresh()
    end
end
function WorldTroopManager:DestroyTroopObj(marchUuid)
    local troop = self.troopDic[marchUuid]
    if troop~=nil then
        troop:Destroy()
        self.troopDic[marchUuid] = nil
    end
end

return WorldTroopManager