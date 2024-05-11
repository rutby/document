--- Created by zzl.
--- DateTime: 
--- 

local UIDeclareWarItem = BaseClass("UIDeclareWarItem", UIBaseContainer)
local base = UIBaseContainer
local allianceInfo_txt_path = "Rect_Alliance/Txt_AllianceInfo"
local st_txt_path = "Rect_Alliance/Txt_St"
local et_txt_path = "Rect_Alliance/Txt_Et"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
  --  self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self._allianceInfo_txt = self:AddComponent(UIText, allianceInfo_txt_path)
    self._st_txt           = self:AddComponent(UIText,st_txt_path)
    self._et_txt           = self:AddComponent(UIText,et_txt_path)
end

local function ComponentDestroy(self)
    self._allianceInfo_txt = nil
    self._st_txt           = nil
    self._et_txt           = nil
end


local function DataDefine(self)
    self.timer_action = function(temp)
        self:RefreshEndTime(temp)
    end
end

local function DataDestroy(self)
   self:DeleteTimer()
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self,param)
    self._allianceInfo_txt:SetLocalText(311026,param.alAbbr,param.alName)
    self._st_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(param.st))
    self:RefreshEndTime(param)
    self:AddTime(param)
end


local function AddTime(self,data)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , data, false,false,false)
    end
    self.timer:Start()
end

local function RefreshEndTime(self,data)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= data.et then
        self:DeleteTimer()
    else
        self._et_txt:SetLocalText(143564,UITimeManager:GetInstance():MilliSecondToFmtString(data.et - curTime))
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

UIDeclareWarItem.OnCreate = OnCreate
UIDeclareWarItem.OnDestroy = OnDestroy
UIDeclareWarItem.OnEnable = OnEnable
UIDeclareWarItem.OnDisable = OnDisable
UIDeclareWarItem.ComponentDefine = ComponentDefine
UIDeclareWarItem.ComponentDestroy = ComponentDestroy
UIDeclareWarItem.DataDefine = DataDefine
UIDeclareWarItem.DataDestroy = DataDestroy
UIDeclareWarItem.ReInit = ReInit
UIDeclareWarItem.AddTime = AddTime
UIDeclareWarItem.RefreshEndTime = RefreshEndTime
UIDeclareWarItem.DeleteTimer = DeleteTimer



return UIDeclareWarItem