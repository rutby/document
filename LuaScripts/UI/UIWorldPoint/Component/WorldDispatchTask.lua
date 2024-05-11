---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 7/4/2024 下午2:01
---
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"
local WorldDispatchTask = BaseClass("WorldDispatchTask", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_obj_path = "BuildInfo/rewardDes/rewardTxt"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local time_obj_path = "BuildInfo/time"
local time_txt_path = "BuildInfo/time/timeLabel"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.desc = self:AddComponent(UITextMeshProUGUIEx,des_obj_path)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.time_obj = self:AddComponent(UIBaseContainer,time_obj_path)
    self.time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.btn = nil
    self.btnImage = nil
    self.power_txt = nil
    self.power_rect = nil
end

--变量的定义
local function DataDefine(self)
    self.data = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

--变量的销毁
local function DataDestroy(self)
    self.data = nil
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(RewardItem)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end
local function RefreshData(self,param)
    self.data = param
    if self.data.isSelf then
        self.desc:SetLocalText(302181)
    elseif self.data.isAlliance then
        self.desc:SetLocalText(461014)
    else
        self.desc:SetLocalText(461015)
    end
    self:SetAllCellDestroy()
    local list = self.data.rewardStr
    if list~=nil then
        local num =0
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            num = num+1
            self.model[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.content:AddComponent(RewardItem,nameStr)
                cell:RefreshData(list[i],true)
            end)
        end
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.data.refreshTime> curTime then
        self.time_obj:SetActive(true)
        self:AddTimer()
        self:RefreshTime()
    else
        self.time_obj:SetActive(false)
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

local function RefreshTime(self)
    if self.data == nil then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.data.refreshTime - curTime
    if self.data~=nil and deltaTime>0 then
        self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        self.time_txt:SetText("")
    end
end

WorldDispatchTask.OnCreate = OnCreate
WorldDispatchTask.OnDestroy = OnDestroy
WorldDispatchTask.OnEnable = OnEnable
WorldDispatchTask.OnDisable = OnDisable
WorldDispatchTask.ComponentDefine = ComponentDefine
WorldDispatchTask.ComponentDestroy = ComponentDestroy
WorldDispatchTask.DataDefine = DataDefine
WorldDispatchTask.DataDestroy = DataDestroy
WorldDispatchTask.AddTimer = AddTimer
WorldDispatchTask.DeleteTimer = DeleteTimer
WorldDispatchTask.RefreshTime = RefreshTime
WorldDispatchTask.RefreshData = RefreshData
WorldDispatchTask.SetAllCellDestroy = SetAllCellDestroy
return WorldDispatchTask