---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/2/14 11:59
---
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local WorldAllianceBuild = BaseClass("WorldAllianceBuild", UIBaseContainer)
local base = UIBaseContainer
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local Localization = CS.GameEntry.Localization
local player_obj_path = "info/playerObj"
local build_obj_path = "info/buildObj"
local alliance_flag_path = "info/allianceFlag"
local name_txt_path = "info/buildObj/TextName"
local slider_path = "info/buildObj/Slider"
local num_path = "info/buildObj/Txt_Num"
local desc_path = "desc"

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
    self.name_txt = self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_path)
    self.slider = self:AddComponent(UISlider,slider_path)
    self.allianceFlag = self:AddComponent(AllianceFlagItem,alliance_flag_path)
    self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

--控件的销毁
local function ComponentDestroy(self)
end

--变量的定义
local function DataDefine(self)
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

--变量的销毁
local function DataDestroy(self)
end

local function RefreshData(self,param)
    self.data = param
    self.name_txt:SetText("")
    self.num_txt:SetText("")
    if self.data~=nil then
        self.slider:SetActive(true)
        if self.data.maxHp <=self.data.curHp then
            self.num_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.maxHp)).."/"..string.GetFormattedSeperatorNum(math.floor(self.data.maxHp)))
            self.slider:SetValue(1)
            self:DeleteTimer()
        else
            self:AddTimer()
            self:RefreshTime()
        end
        
    else
        self:DeleteTimer()
        self.slider:SetActive(false)
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
    if self.data ==nil then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - self.data.lastHpTime
    if self.data.maxHp>0 then
        if deltaTime<=0 then
            deltaTime = 0
        end
        local realBlood  = math.min((deltaTime/1000) * self.data.coverSpeed + self.data.curHp,self.data.maxHp)
        local percent = math.min(realBlood/self.data.maxHp,1)
        self.num_txt:SetText(string.GetFormattedSeperatorNum(math.floor(realBlood)).."/"..string.GetFormattedSeperatorNum(math.floor(self.data.maxHp)))
        self.slider:SetValue(percent)

        self.desc_txt:SetText("")
        if WorldAllianceBuildUtil.IsAllianceFrontGroup(self.data.buildId) then
            if realBlood < self.data.maxHp then
                self.desc_txt:SetLocalText(302862)
            end
        end
    else
        self.num_txt:SetText("0/0")
        self.slider:SetValue(0)
    end
end

local function SetData(self,pointId)
    self.pointId = pointId
    local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
    if detail~=nil then
        local allianceBuild = detail.alBuilding
        if allianceBuild~=nil then
            local flag = allianceBuild.flag
            if flag~=nil then
                self.allianceFlag:SetData(flag)
            end
            local allianceName = ""
            if allianceBuild.alAbbr~=nil and allianceBuild.alAbbr~="" then
                allianceName = "["..allianceBuild.alAbbr.."]"..allianceBuild.alName
            else
                allianceName = "-"
            end
            self.name_txt:SetText(allianceName)
        end
    end
end

local function OnInfoClick(self)
    if self.data~=nil then
        local buildId = self.data.buildId
        if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) then
            local scaleFactor = UIManager:GetInstance():GetScaleFactor()
            local position = self.view.btn_detail.gameObject.transform.position + Vector3.New(0, -33, 0) * scaleFactor
            local param = UIHeroTipView.Param.New()
            param.content = Localization:GetString("302730")
            param.dir = UIHeroTipView.Direction.BELOW
            param.defWidth = 200
            param.pivot = 0.5
            param.position = position
            param.deltaX = 0
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
        elseif WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
            UIUtil.ShowIntro(Localization:GetString("302868"), Localization:GetString("302027"), Localization:GetString("302869"))
            self.view.ctrl:CloseSelf()
        elseif buildId == BuildingTypes.ALLIANCE_FLAG_BUILD then
            UIUtil.ShowIntro(Localization:GetString("110536"), Localization:GetString("302027"), Localization:GetString("110551"))
            self.view.ctrl:CloseSelf()
        end
    end
end


WorldAllianceBuild.OnCreate = OnCreate
WorldAllianceBuild.OnDestroy = OnDestroy
WorldAllianceBuild.OnEnable = OnEnable
WorldAllianceBuild.OnDisable = OnDisable
WorldAllianceBuild.ComponentDefine = ComponentDefine
WorldAllianceBuild.ComponentDestroy = ComponentDestroy
WorldAllianceBuild.DataDefine = DataDefine
WorldAllianceBuild.DataDestroy = DataDestroy
WorldAllianceBuild.AddTimer = AddTimer
WorldAllianceBuild.DeleteTimer = DeleteTimer
WorldAllianceBuild.RefreshTime = RefreshTime
WorldAllianceBuild.RefreshData = RefreshData
WorldAllianceBuild.SetData = SetData
WorldAllianceBuild.OnInfoClick = OnInfoClick
return WorldAllianceBuild