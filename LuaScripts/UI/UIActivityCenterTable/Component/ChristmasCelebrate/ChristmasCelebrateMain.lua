---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/5 12:24
---ChristmasCelebrateMain.lua


local ChristmasCelebrateMain = BaseClass("ChristmasCelebrateMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChristmasCelebrateJumpItem = require "UI.UIActivityCenterTable.Component.ChristmasCelebrate.ChristmasCelebrateJumpItem"

local JumpConf = 
{
    [1] = {
        Name = "302351",
        Desc = "302352"
    },
    [2] = {
        Name = "302353",
        Desc = "302354"
    },
    [3] = {
        Name = "302355",
        Desc = "302356"
    },
    [4] = {
        Name = "302357",
        Desc = "302358"
    },
}

local title_path = "Panel/titleBg/Title"
local infoBtn_path = "Panel/titleBg/Title/Info"
local restTime_path = "Panel/RestTimeBg/RestTime"
local activityTime_path = "Panel/activityTime"
local jumpItems_path = "Panel/jumps/jump"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.restTimeN = self:AddComponent(UIText, restTime_path)
    self.activityTimeN = self:AddComponent(UIText, activityTime_path)
    self.jumpItems = {}
    for i = 1, 4 do
        local tempPath = jumpItems_path .. i
        local jumpItem = self:AddComponent(ChristmasCelebrateJumpItem, tempPath)
        self.jumpItems[i] = jumpItem
    end
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.infoBtnN = nil
    self.restTimeN = nil
    self.activityTimeN = nil
    self.jumpItems = nil
end

local function DataDefine(self)
    self.activityId = nil
    self.activityInfo = nil
    self.countDownTimer = nil
end

local function DataDestroy(self)
    self.activityId = nil
    self.activityInfo = nil
    self.countDownTimer = nil
end

local function SetData(self, activityId)
    self.activityId = activityId
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    
    self:Refresh()
end

local function Refresh(self)
    if not self.activityInfo then
        return
    end
    
    local para1 = self.activityInfo.para1
    local params = string.split(para1, "|")
    for i, v in ipairs(self.jumpItems) do
        if i <= #params then
            v:SetActive(true)
            v:SetItem(i, params[i])
        else
            v:SetActive(false)
        end
    end
    --local dialogArr = string.split(para1, ";")
    --for i, v in ipairs(self.jumpItems) do
    --    v:SetItem(i, JumpConf[i])
    --end

    self.titleN:SetLocalText(self.activityInfo.name)
    
    local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityInfo.startTime)
    local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityInfo.endTime)
    self.activityTimeN:SetText(startT .. "-" .. endT)
    
    self:AddCountDownTimer()
end

local function AddCountDownTimer(self)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityInfo.endTime - curTime
    if remainTime > 0 then
        self.restTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.restTimeN:SetText("")
        self:DelCountDownTimer()
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnClickInfoBtn(self)
    UIUtil.ShowIntro(Localization:GetString(self.activityInfo.name), Localization:GetString("100239")
            , Localization:GetString(self.activityInfo.story))
end

ChristmasCelebrateMain.OnCreate = OnCreate
ChristmasCelebrateMain.OnDestroy = OnDestroy
ChristmasCelebrateMain.ComponentDefine = ComponentDefine
ChristmasCelebrateMain.ComponentDestroy = ComponentDestroy
ChristmasCelebrateMain.DataDefine = DataDefine
ChristmasCelebrateMain.DataDestroy = DataDestroy

ChristmasCelebrateMain.Refresh = Refresh
ChristmasCelebrateMain.AddCountDownTimer = AddCountDownTimer
ChristmasCelebrateMain.RefreshRemainTime = RefreshRemainTime
ChristmasCelebrateMain.DelCountDownTimer = DelCountDownTimer
ChristmasCelebrateMain.SetData = SetData
ChristmasCelebrateMain.OnClickInfoBtn = OnClickInfoBtn

return ChristmasCelebrateMain