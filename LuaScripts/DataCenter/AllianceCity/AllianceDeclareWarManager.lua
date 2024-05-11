
---
--- Created by zzl.
--- DateTime: 
--- 联盟宣战(所有联盟)
---
local AllianceDeclareWarManager = BaseClass("AllianceDeclareWarManager")

--st et alName alAbbr type anno uuid aId alIcon content

local function __init(self)
    self.list = {}
    self.bubbleUuid = 0
    self.isNew = true
    self.k6 = LuaEntry.DataConfig:TryGetNum("alliance_declare_war","k6") -- 当日最大次数
    self.declareTimes = 0 --今日已宣战次数
    self.cityParam = {}
end

local function __delete(self)
    self.bubbleUuid = nil
    self.isNew = nil
    self.cityParam = nil
end

local function InitSend(self)
    SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarGet)
end

local function Init(self,message)
    self.list = message
    self.isNew = self:GetSelfDeclareWarData()
    EventManager:GetInstance():Broadcast(EventId.DeclareWar)
end

--更新当前宣战次数
local function CheckIsCanDeclare(self,message)
    if message["allianceCityDeclareTimes"] then
        self.declareTimes = message["allianceCityDeclareTimes"]
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldDeclareWar,{ anim = true, UIMainAnim = UIMainAnimType.AllHide },self.cityParam.cityId,self.cityParam.pointId,self.cityParam.uuid)
        self.cityParam = nil
    end
end

local function SetWarCityParam(self,param)
    self.cityParam = param
end

local function GetDeclareTime(self)
    return self.declareTimes
end

--只有自己创建
local function CreateWar(self,message)
    table.insert(self.list,message)
    self:SetWarState(true)
    local cityData = LocalController:instance():getLine(TableName.WorldCity,tonumber(message.content))
    local cityLoc = string.split(cityData.location, "|")
    local v2 = Vector2.New(tonumber(cityLoc[1]), tonumber(cityLoc[2]))
    local worldPos = SceneUtils.TileToWorld(v2)
    worldPos.x = worldPos.x - 6
    worldPos.z = worldPos.z - 6
    local posIndex  = SceneUtils.WorldToTileIndex(worldPos)
    local str = string.SubStr(message.anno,1,25)
    str = str.."..."
    DataCenter.WorldFavoDataManager:TryAddAllianceMask(posIndex * 10 + 1,LuaEntry.Player:GetCurServerId(),MarkType.Alliance_Attack,str)
    EventManager:GetInstance():Broadcast(EventId.DeclareWar)
end

local function DeleteWar(self,message)
    local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    for i = 1, #self.list do
        if self.list[i].uuid == message["uuid"] then
            --删除的是自己联盟的
            if self.list[i].aId == allianceInfo.uid then
                self:SetWarState(false)
                self.bubbleUuid = 0
            end
            table.remove(self.list,i)
            break
        end
    end
    EventManager:GetInstance():Broadcast(EventId.DeclareWar)
    DataCenter.WorldFavoDataManager:TryDelAllianceMask(MarkType.Alliance_Attack)
end


local function GetAllianceDeclareWarData(self)
    return self.list
end

--根据cityId获取宣战信息
local function GetWarDataByCityId(self,cityId)
    local list = {}
    for i = 1, #self.list do
        if self.list[i].content == tostring(cityId) then
            table.insert(list,self.list[i])
        end
    end
    return list 
end

--获取自己联盟宣战信息
local function GetSelfDeclareWarData(self)
    local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceInfo then
        for i = 1, #self.list do
            if self.list[i].aId == allianceInfo.uid then
                return self.list[i]
            end
        end
    end
end

local function CheckWarIsNew(self)
    if self.isNew then
        return true
    end
    return false
end

local function SetWarState(self,state)
    
    self.isNew = state
end

local function CheckIsShowBubble(self)
    local data = self:GetSelfDeclareWarData()
    if data then
        if self.bubbleUuid == nil or self.bubbleUuid == 0 then
            self.bubbleUuid = data.uuid
            return true
        elseif self.bubbleUuid == data.uuid then
            return false
        end
    end
    return false
end


AllianceDeclareWarManager.__init = __init
AllianceDeclareWarManager.__delete = __delete
AllianceDeclareWarManager.InitSend = InitSend
AllianceDeclareWarManager.Init = Init
AllianceDeclareWarManager.CheckIsCanDeclare = CheckIsCanDeclare
AllianceDeclareWarManager.SetWarCityParam = SetWarCityParam
AllianceDeclareWarManager.GetDeclareTime = GetDeclareTime
AllianceDeclareWarManager.CreateWar = CreateWar
AllianceDeclareWarManager.DeleteWar = DeleteWar
AllianceDeclareWarManager.GetAllianceDeclareWarData = GetAllianceDeclareWarData
AllianceDeclareWarManager.GetWarDataByCityId = GetWarDataByCityId
AllianceDeclareWarManager.GetSelfDeclareWarData = GetSelfDeclareWarData
AllianceDeclareWarManager.CheckWarIsNew = CheckWarIsNew
AllianceDeclareWarManager.SetWarState = SetWarState
AllianceDeclareWarManager.CheckIsShowBubble = CheckIsShowBubble
return AllianceDeclareWarManager
