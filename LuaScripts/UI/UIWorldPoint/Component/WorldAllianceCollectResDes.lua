---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/13 21:56
---
local WorldAllianceCollectResDes = BaseClass("WorldAllianceCollectResDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local icon_path = "BuildInfo/Image"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local slider_path = "BuildInfo/Slider"
local rest_num_path = "BuildInfo/restNum"
local rest_des_path = "BuildInfo/restDes"
local reset_time_path = "BuildInfo/resetTime"
local animator_path = ""
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
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
    self.animator = self:AddComponent(UIAnimator, animator_path)
    self.main_obj = self:AddComponent(UIBaseContainer,main_obj_path)
    self.des_obj = self:AddComponent(UIBaseContainer,des_obj_path)
    self.main_obj_canvas = self:AddComponent(UICanvasGroup,main_obj_path)
    self.des_obj_canvas = self:AddComponent(UICanvasGroup,des_obj_path)
    self.main_obj_canvas:SetAlpha(1)
    self.des_obj_canvas:SetAlpha(1)
    self.icon = self:AddComponent(UIImage,icon_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx,des_txt_path)
    self.slider = self:AddComponent(UISlider,slider_path)
    self.rest_des = self:AddComponent(UITextMeshProUGUIEx,rest_des_path)
    self.rest_num = self:AddComponent(UITextMeshProUGUIEx,rest_num_path)
    self.reset_time = self:AddComponent(UITextMeshProUGUIEx,reset_time_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.icon = nil
    self.des_txt = nil
end

--变量的定义
local function DataDefine(self)
    self.param = nil
    self.isUpdate = false
    self.collectStartTime = 0
    self.reset_des = Localization:GetString("142510")
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
end

local function OnInfoClick(self)
    self.animator:Enable(true)
    self.animator:Play("switchEnter",0,0)
end
--返回
local function OnReturnClick(self)
    self.animator:Enable(true)
    self.animator:Play("switchOut",0,0)
end

local function RefreshData(self,param)
    self.data = param
    self.isUpdate = false
    self.isReset = false
    self.resetEndTime = 0
    self.icon:LoadSprite(self.data.icon)
    self.des_txt:SetLocalText(self.data.desc)
    self.reset_time:SetText("")
    self.rest_des:SetText(Localization:GetString("142509")..math.floor(self.data.collectSpeedDes).."/h")
    CS.SceneManager.World:SetShowCollectTypeForLua(self.data.resourceType)
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
    if self.isUpdate == true then
        if self.serverData ~=nil then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = curTime-self.collectStartTime
            if deltaTime<0 then
                deltaTime = 0
            end
            local realNum = deltaTime*self.serverData.speed/1000
            if realNum<0 then
                realNum = 0
            end
            local restNum = self.serverData.remainRes-realNum
            if restNum>0 then
                local tempValue = math.min((restNum / math.max(self.serverData.initRes,1)),1)
                self.slider:SetValue(tempValue)
                self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(restNum)).."/"..string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
                if self.serverData.speed<=0 then
                    self.collectStartTime = 0
                    self.isUpdate = false
                end
            else
                self.collectStartTime = 0
                self.isUpdate = false
                self.rest_num:SetText("0/"..string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
                self.slider:SetValue(0)
            end
        end
    end
    if self.isReset == true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.resetEndTime-curTime
        if deltaTime>0 then
            self.reset_time:SetText(self.reset_des..UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        else
            self.reset_time:SetText("")
            self.isReset = false
            if self.serverData~=nil and self.serverData.remainRes~=nil and self.serverData.remainRes<1 then
                self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes).."/"..string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes))))
                self.slider:SetValue(1)
            end
        end
    end
end

local function UpdateInfo(self,data)
    self.isUpdate = false
    self.isReset = false
    self.serverData = data.playerData
    if self.serverData~=nil then
        if self.serverData.remainRes>1 then
            self.collectStartTime = UITimeManager:GetInstance():GetServerTime()
            self.isUpdate = true
            self:AddTimer()
            self:RefreshTime()
        else
            self.rest_num:SetText("0/"..string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
            self.slider:SetValue(0)
        end
        self.resetEndTime = self.serverData.expireTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.resetEndTime-curTime
        if deltaTime>0 then
            self.reset_time:SetText(self.reset_des..UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
            self.isReset = true
            self:AddTimer()
            self:RefreshTime()
        else
            self.reset_time:SetText("")
            self.isReset = false
            if self.serverData.remainRes<=1 then
                self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes).."/"..string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes))))
                self.slider:SetValue(1)
            end
        end
    end
end
WorldAllianceCollectResDes.OnCreate = OnCreate
WorldAllianceCollectResDes.OnDestroy = OnDestroy
WorldAllianceCollectResDes.OnEnable = OnEnable
WorldAllianceCollectResDes.OnDisable = OnDisable
WorldAllianceCollectResDes.ComponentDefine = ComponentDefine
WorldAllianceCollectResDes.ComponentDestroy = ComponentDestroy
WorldAllianceCollectResDes.DataDefine = DataDefine
WorldAllianceCollectResDes.DataDestroy = DataDestroy
WorldAllianceCollectResDes.RefreshData = RefreshData
WorldAllianceCollectResDes.UpdateInfo =UpdateInfo
WorldAllianceCollectResDes.RefreshTime =RefreshTime
WorldAllianceCollectResDes.AddTimer = AddTimer
WorldAllianceCollectResDes.DeleteTimer = DeleteTimer
WorldAllianceCollectResDes.OnReturnClick =OnReturnClick
WorldAllianceCollectResDes.OnInfoClick = OnInfoClick
return WorldAllianceCollectResDes