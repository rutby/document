--- Created by shimin
--- DateTime: 2023/4/17 16:57
--- 大本被攻击后盟友援助表现管理器
---
local AllianceHelpVirtualMarchManager = BaseClass("AllianceHelpVirtualMarchManager")
local AllianceHelpVirtualMarch = require "Scene.AllianceHelpVirtualMarch.AllianceHelpVirtualMarch"

local UPDATE_TIMER_DELTATIME = 0.03

function AllianceHelpVirtualMarchManager:__init()
    self.updateTimer = nil
    self.update_timer_callback = function()
        self:OnUpdateTimerCallBack()
    end
    self.marchSpeed = 0--行军速度
    self.virtualMarchesArr = {}--实际加载出来的实体
    self.visible = false
    self:AddListener()
end

function AllianceHelpVirtualMarchManager:__delete()
    self:DeleteUpdateTimer()
    self:RemoveListener()
    self.update_timer_callback = nil
    self.marchSpeed = 0--行军速度
    self.visible = false
    self.virtualMarchesArr = {}--实际加载出来的实体
end

--测试数据
function AllianceHelpVirtualMarchManager:TestVirtualMarch()
    local member1 = {
        name = "member1",
        pointId = 41749949,
        alAbbr = "mem",
    }
    local member2 = {
        name = "member2",
        pointId = 1774624,
        alAbbr = "mem",
    }
    local member3 = {
        name = "member3",
        pointId = 40290749,
        alAbbr = "mem",
    }
    local tb = {}
    table.insert(tb, member1)
    table.insert(tb, member2)
    table.insert(tb, member3)

    local testEnemy = {
        name = "enemy",
        pointId = 40290749,
        alAbbr = "ene",
    }
    self:OnGetDefenceFailInfo(tb, testEnemy, false)
end

function AllianceHelpVirtualMarchManager:OnGetDefenceFailInfo(alMemberList, enemyInfo, isLogin)
    if isLogin then
        if LuaEntry.Player:GetMainWorldPos() <= 0 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIDefenceFailTip, alMemberList, enemyInfo.alAbbr, enemyInfo.name)
        end
    else
        self:ShowVirtualMarches(alMemberList)
        EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
    end
end

function AllianceHelpVirtualMarchManager:ShowVirtualMarches(alMemberList)
    self:CreateMarches(alMemberList)
    self:AddUpdateTimer()
end

function AllianceHelpVirtualMarchManager:CreateMarches(alMemberList)
    if alMemberList ~= nil then
        for k, v in ipairs(alMemberList) do
            self:CreateTroop(v)
        end
    end
end

function AllianceHelpVirtualMarchManager:CreateTroop(memberInfo)
    local cell = AllianceHelpVirtualMarch.New()
    local param = {}
    param.startPointV3 = self:GetStartPointV3(memberInfo)
    param.endPointV3 = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
    local deltaV3 = {}
    deltaV3.x = param.endPointV3.x - param.startPointV3.x
    deltaV3.y = param.endPointV3.y - param.startPointV3.y
    deltaV3.z = param.endPointV3.z - param.startPointV3.z
    param.dir = Vector3.Normalize(deltaV3)
    param.speed = self:GetMarchSpeed()
    param.memberInfo = memberInfo
    param.visible = self.visible
    cell:ReInit(param)
    table.insert(self.virtualMarchesArr, cell)
end

function AllianceHelpVirtualMarchManager:GetStartPointV3(memberInfo)
    local tempSpeed = self:GetMarchSpeed() * CS.SceneManager.World.TileSize
    local point1 = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
    local point2 = SceneUtils.TileIndexToWorld(memberInfo.pointId, ForceChangeScene.World)
    local tempTime = 5
    local str = LocalController:instance():getStrValue("subsidy", 1, "arrival_time")
    if str ~= nil and str ~= "" then
        local randTimesArr = string.split_ii_array(str, "|")
        if randTimesArr[1] ~= nil then
            local timeIndex = math.random(1, #randTimesArr)
            tempTime = randTimesArr[timeIndex]
        end
    end
 
    local deltaV3 = {}
    deltaV3.x = point2.x - point1.x
    deltaV3.y = point2.y - point1.y
    deltaV3.z = point2.z - point1.z
    local startPointV3Offset = Vector3.Normalize(deltaV3) * tempTime * tempSpeed
    local startPointV3 = {}
    startPointV3.x = startPointV3Offset.x + point1.x
    startPointV3.y = startPointV3Offset.y + point1.y
    startPointV3.z = startPointV3Offset.z + point1.z
    return startPointV3
end


function AllianceHelpVirtualMarchManager:GetMarchSpeed()
    if self.marchSpeed == 0 then
        self.marchSpeed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k3") -- speed
    end
    return self.marchSpeed
end

function AllianceHelpVirtualMarchManager:DestroyAllTroops()
    for k, v in ipairs(self.virtualMarchesArr) do
        v:Destroy()
    end
    self.virtualMarchesArr = {}
    EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
end

function AllianceHelpVirtualMarchManager:HasVirtualMarch()
    return self.virtualMarchesArr[1] ~= nil
end

--获取警告列表中需要显示的数据（已到达的不显示）
function AllianceHelpVirtualMarchManager:GetVirtualMemberList()
    local result = {}
    for k, v in ipairs(self.virtualMarchesArr) do
        local param = v:GetVirtualMemberShowParam()
        if param ~= nil then
            table.insert(result, param)
        end
    end
    return result
end

function AllianceHelpVirtualMarchManager:AddUpdateTimer()
    if self.updateTimer == nil  then
        self.updateTimer = TimerManager:GetInstance():GetTimer(UPDATE_TIMER_DELTATIME, self.update_timer_callback, self, false, false, false)
        self.updateTimer:Start()
    end
end
function AllianceHelpVirtualMarchManager:DeleteUpdateTimer()
    if self.updateTimer ~= nil then
        self.updateTimer:Stop()
        self.updateTimer = nil
    end
end
function AllianceHelpVirtualMarchManager:OnUpdateTimerCallBack()
    local allReached = true
    for i, v in ipairs(self.virtualMarchesArr) do
        if not v.isReached then
            allReached = false
            v:RefreshPosition(UPDATE_TIMER_DELTATIME)
        end
    end
    if allReached then
        self:DeleteUpdateTimer()
        self:DestroyAllTroops()
    end
end


function AllianceHelpVirtualMarchManager:AddListener()
    if self.pveLevelEnterSignal == nil then
        self.pveLevelEnterSignal = function()
            self:PveLevelEnterSignal()
        end
        EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
    end
    if self.onEnterWorldSignal == nil then
        self.onEnterWorldSignal = function()
            self:OnEnterWorldSignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
    end
    if self.onEnterCitySignal == nil then
        self.onEnterCitySignal = function()
            self:OnEnterCitySignal()
        end
        EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
    end
end

function AllianceHelpVirtualMarchManager:RemoveListener()
    if self.onEnterCitySignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
        self.onEnterCitySignal = nil
    end
    if self.pveLevelEnterSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.pveLevelEnterSignal)
        self.pveLevelEnterSignal = nil
    end
    if self.onEnterWorldSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.onEnterWorldSignal)
        self.onEnterWorldSignal = nil
    end
end

function AllianceHelpVirtualMarchManager:OnEnterCitySignal()
    self:SetVirtualMarchVisible(false)
end
function AllianceHelpVirtualMarchManager:OnEnterWorldSignal()
    self:SetVirtualMarchVisible(true)
end
function AllianceHelpVirtualMarchManager:PveLevelEnterSignal()
    self:SetVirtualMarchVisible(false)
end

function AllianceHelpVirtualMarchManager:SetVirtualMarchVisible(visible)
    if self.visible ~= visible then
        self.visible = visible
        for i, v in ipairs(self.virtualMarchesArr) do
            v:SetVirtualMarchVisible(visible)
        end
    end
end

return AllianceHelpVirtualMarchManager