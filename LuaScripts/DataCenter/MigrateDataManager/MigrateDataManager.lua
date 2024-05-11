---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/14 18:55
---
local MigrateDataManager = BaseClass("MigrateDataManager");
local MigrateServerData= require "DataCenter.MigrateDataManager.MigrateServerData"
local MigrateApplyData= require "DataCenter.MigrateDataManager.MigrateApplyData"
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.migrateList = {}--移民列表
    self.myApplyList = {}--我的移民列表
    self.migApplyList = {}--本服移民申请列表--总统
    self.myServerTotalCount = 0
    self.myServerUseCount = 0
    self.powerLimit = 0
    self.initServer = 0 --我的原始服
    self.serverLimit = 0
end

local function __delete(self)
    self.migrateList = {}--移民列表
    self.myApplyList = {}--我的移民列表
    self.migApplyList = {}--本服移民申请列表--总统
    self.initServer = 0 --我的原始服
    self.serverLimit = 0
end

local function InitData(self)
    self:GetMigrateRequest()
    self:CheckGetPresidentData()
    local serverLimit = LuaEntry.DataConfig:TryGetStr("aps_migrate_server", "k6")
    local arr = string.split(serverLimit,";")
    if arr~=nil and #arr>0 then
        local season = DataCenter.SeasonDataManager:GetSeason() or 0
        season = season +1
        if season>#arr then
            season = #arr
        end
        self.serverLimit = tonumber(arr[season])
    end
end

local function GetServerLimit(self)
    return self.serverLimit
end
local function GetMigrateRequest(self)
    SFSNetwork.SendMessage(MsgDefines.GetMigrateServers)
end

local function CheckGetPresidentData(self)
    if DataCenter.GovernmentManager:IsSelfPresident() then
        SFSNetwork.SendMessage(MsgDefines.MigrateApplyList,LuaEntry.Player:GetSelfServerId())
    end
end

local function OnRefreshServerList(self,message)
    self.migrateList = {}
    self.myApplyList = {}
    if message["servers"]~=nil then
        local arr = message["servers"]
        for k,v in pairs(arr) do
            local oneData = MigrateServerData.New()
            oneData:ParseData(v)
            if oneData.serverId~=nil and oneData.serverId>0 then
                self.migrateList[oneData.serverId] = oneData
            end
        end
    end
    if message["selfApplies"]~=nil then
        local arr = message["selfApplies"]
        for k,v in pairs(arr) do
            local oneData = MigrateApplyData.New()
            oneData:ParseData(v)
            if oneData.serverId~=nil and oneData.serverId>0 then
                oneData:SetUid(LuaEntry.Player.uid)
                self.myApplyList[oneData.serverId] = oneData
            end
        end
    end
    if message["initServerId"]~=nil then
        self.initServer = message["initServerId"]
    end
    EventManager:GetInstance():Broadcast(EventId.GetMigrateList)
end

local function OnGetServerList(self)
    return self.migrateList
end

local function RefreshServerDetailData(self,message)
    if message["toServerId"]~=nil then
        local serverId = message["toServerId"]
        if self.migrateList[serverId]~=nil then
            self.migrateList[serverId]:ParseServerData(message)
            EventManager:GetInstance():Broadcast(EventId.GetMigrateServerDetail,serverId)
        end
    end
end

local function OnGetServerDetailDataByServerId(self,serverId)
    return self.migrateList[serverId]
end

local function OnMigrateApply(self,message)
    local oneData = MigrateApplyData.New()
    oneData:ParseData(message)
    if oneData.serverId~=nil and oneData.serverId>0 then
        self.myApplyList[oneData.serverId] = oneData
        EventManager:GetInstance():Broadcast(EventId.OnMigrateApplyToPresident,oneData.serverId)
    end
end

local function OnGetMigrateApplyDataByServerId(self,severId)
    return self.myApplyList[severId]
end

-- 总统操作

local function OnGetApplyList(self,message)
    self.migApplyList = {}
    if message["list"]~=nil then
        local arr = message["list"]
        for k,v in pairs(arr) do
            local oneData = MigrateApplyData.New()
            oneData:ParseData(v)
            if oneData.uid~=nil and oneData.uid~="" then
                self.migApplyList[oneData.uid] = oneData
            end
        end
    end
    if message["totalCount"]~=nil then
        self.myServerTotalCount = message["totalCount"]
    end
    if message["useCount"]~=nil then
        self.myServerUseCount = message["useCount"]
    end
    if message["powerLimit"]~=nil then
        self.powerLimit = message["powerLimit"]
    end
    EventManager:GetInstance():Broadcast(EventId.GetMigrateApplyList)
    EventManager:GetInstance():Broadcast(EventId.OnRefreshMigrateRedPot)
end

local function OnRefreshApplyData(self,message)
    local oneData = MigrateApplyData.New()
    oneData:ParseData(message)
    if oneData.uid~=nil and oneData.uid~="" then
        self.migApplyList[oneData.uid] = oneData
    end
    EventManager:GetInstance():Broadcast(EventId.OnRefreshMigrateRedPot)
end

local function OnApproveUser(self,message)
    if message["applyUid"]~=nil and message["type"]~=nil then
        local applyUid = message["applyUid"]
        local approveType = message["type"]
        if self.migApplyList[applyUid]~=nil then
            local data = self.migApplyList[applyUid]
            if approveType == ApproveMigrateState.AGREE then
                data:SetAgreeUser(message["special"])
            elseif approveType == ApproveMigrateState.REFUSE then
                data:SetRefuseUser()
            end
        end
    end
    if message["useCount"]~=nil then
        self.myServerUseCount = message["useCount"]
    end
    EventManager:GetInstance():Broadcast(EventId.OnMigrateApprove)
    EventManager:GetInstance():Broadcast(EventId.OnRefreshMigrateRedPot)
end

local function SetPowerLimit(self,message)
    if message["powerLimit"]~=nil then
        self.powerLimit = message["powerLimit"]
    end
end
local function GetPowerLimit(self)
    return self.powerLimit
end

local function GetApplyList(self)
    local list = {}
    for k,v in pairs(self.migApplyList) do
        if v.state == MigrateApplyType.APPLY then
            list[v.uid] = v
        end
    end
    return list
end

local function GetSpecialNum(self)
    return self.myServerUseCount,self.myServerTotalCount
end

local function GetHasAccept(self)
    local has = false
    if self.myApplyList~=nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        for k,v in pairs(self.myApplyList) do
            if has == false then
                if v.serverId~=nil and v.serverId ~= LuaEntry.Player:GetSelfServerId() then
                    if v.state == MigrateApplyType.AGREE then
                        local deltaTime = LuaEntry.DataConfig:TryGetNum("aps_migrate_server", "k5")
                        local endTime = v.approveTime+(deltaTime*1000*60)
                        if endTime> curTime then
                            has = true
                        end
                    end
                end
            end
        end
    end
    return has
end
MigrateDataManager.__init = __init
MigrateDataManager.__delete = __delete
MigrateDataManager.InitData = InitData
MigrateDataManager.GetMigrateRequest = GetMigrateRequest
MigrateDataManager.CheckGetPresidentData = CheckGetPresidentData
MigrateDataManager.OnRefreshServerList =OnRefreshServerList
MigrateDataManager.OnGetServerList =OnGetServerList
MigrateDataManager.RefreshServerDetailData = RefreshServerDetailData
MigrateDataManager.OnGetServerDetailDataByServerId = OnGetServerDetailDataByServerId
MigrateDataManager.OnMigrateApply =  OnMigrateApply
MigrateDataManager.OnGetMigrateApplyDataByServerId = OnGetMigrateApplyDataByServerId
MigrateDataManager.OnGetApplyList = OnGetApplyList
MigrateDataManager.OnRefreshApplyData = OnRefreshApplyData
MigrateDataManager.OnApproveUser= OnApproveUser
MigrateDataManager.SetPowerLimit = SetPowerLimit
MigrateDataManager.GetApplyList = GetApplyList
MigrateDataManager.GetPowerLimit =GetPowerLimit
MigrateDataManager.GetServerLimit = GetServerLimit
MigrateDataManager.GetSpecialNum= GetSpecialNum
MigrateDataManager.GetHasAccept = GetHasAccept
return MigrateDataManager