---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/9/19 22:12
---AlCompeteCrossServerPanel.lua

local base = UIBaseContainer--Variable
local AlCompeteCrossServerPanel = BaseClass("AlCompeteCrossServerPanel", base)--Variable
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local title_path = "startGo/middleGo/titleTxt"
local subTitle_path = "startGo/middleGo/desTxt"
local actTime_path = "startGo/middleGo/timeTxt"
local cdTip_path = "startGo/middleGo/timeTxt/cdTip"
local cdTime_path = "startGo/middleGo/timeTxt/cdTxt"
local allianceFlagL_path = "startGo/redGo/redAllianceIcon/AllianceFlagRed"
local allianceFlagR_path = "startGo/blueGo/blueAllianceIcon/AllianceFlagBlue"
local alNameL_path = "startGo/redGo/redAllianceGo/redAllianceNameTxt"
local alNameR_path = "startGo/blueGo/blueAllianceGo/blueAllianceNameTxt"
local attackBtn_path = "startGo/attackBtn"
local attackBtnTxt_path = "startGo/attackBtn/attackTxt"
local attackTip_path = "startGo/attackTip"

local infoBtn_path = "rightLayer/infoBtn"
local group_btn_path = "rightLayer/Group"
local group_text_path = "rightLayer/Group/GroupText"
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetText(Localization:GetString("110214"))
    
    self.subTitleN = self:AddComponent(UITextMeshProUGUIEx, subTitle_path)
    self.subTitleN:SetText(Localization:GetString("372418"))
    self.actTimeN = self:AddComponent(UIBaseContainer, actTime_path)
    self.cdTipN = self:AddComponent(UITextMeshProUGUIEx, cdTip_path)
    self.cdTimeN = self:AddComponent(UITextMeshProUGUIEx, cdTime_path)
    self.allianceFlagLN = self:AddComponent(AllianceFlagItem, allianceFlagL_path)
    self.allianceFlagRN = self:AddComponent(AllianceFlagItem, allianceFlagR_path)
    self.alNameLN = self:AddComponent(UITextMeshProUGUIEx, alNameL_path)
    self.alNameRN = self:AddComponent(UITextMeshProUGUIEx, alNameR_path)
    self.attackBtnN = self:AddComponent(UIButton, attackBtn_path)
    self.attackBtnN:SetOnClick(function()
        self:OnClickAttackBtn()
    end)
    self.attackBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, attackBtnTxt_path)
    self.attackBtnTxtN:SetLocalText(100150)
    self.attackTipN = self:AddComponent(UITextMeshProUGUIEx, attackTip_path)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.group_btn = self:AddComponent(UIButton, group_btn_path)
    self.group_btn:SetOnClick(function()
        self:OnGroupClick()
    end)
    self.group_text = self:AddComponent(UITextMeshProUGUIEx, group_text_path)
    self.group_text:SetLocalText(302743)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.subTitleN = nil
    self.cdTipN = nil
    self.cdTimeN = nil
    self.allianceFlagLN = nil
    self.allianceFlagRN = nil
    self.alNameLN = nil
    self.alNameRN = nil
    self.attackBtnN = nil
    self.attackBtnTxtN = nil
    self.attackTipN = nil
    self.infoBtnN = nil
end

local function DataDefine(self)
    self.activityInfo = nil
    self.eventInfo = nil
    self.isCrossServerOpen = nil
    self.curStatus = nil
end

local function DataDestroy(self)
    self.activityInfo = nil
    self.eventInfo = nil
    self.isCrossServerOpen = nil
    self.curStatus = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.CrossServerAlliancePoint, self.OnGotoPoint)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.CrossServerAlliancePoint, self.OnGotoPoint)
    base.OnRemoveListener(self)
end

local function ShowPanel(self)
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not self.activityInfo then
        return
    end
    self.eventInfo = self.activityInfo:GetEventInfo()
    if not self.eventInfo then
        return
    end
    --local actData = nil
    --
    --local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.EdenAllianceActMine)
    --if table.count(dataList) > 0 then
    --    actData = dataList[1]
    --end
    self.group_btn:SetActive(false)
    self:RefreshAll()
end

local function RefreshAll(self)
    self:SetTimeTip()
    
    local myAllianceId = LuaEntry.Player.allianceId
    local allianceList = self.eventInfo.vsAllianceList
    table.walk(allianceList , function(k,v)
        local name = string.format("#%s [%s] %s" , v.serverId, v.abbr,v.alName)
        if k == myAllianceId then
            self.alNameLN:SetText(name)
            self.allianceFlagLN:SetData(v.icon)
        else
            self.alNameRN:SetText(name)
            self.allianceFlagRN:SetData(v.icon)
            self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
        end
    end)
end

local function SetTimeTip(self)
    local _, startT, endT = self.eventInfo:CheckIfShowCrossServer()
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    if serverTime < startT then
        --self.actTimeN:SetActive(true)
        self.cdTipN:SetText(Localization:GetString("372114"))
        self.endTime = startT
        self.cdTimeN:SetActive(true)
        self:AddTimer()
        CS.UIGray.SetGray(self.attackBtnN.transform, true, true)
        self.isCrossServerOpen = false
        self.curStatus = 1
    elseif serverTime < endT then
        --self.actTimeN:SetActive(true)
        self.cdTipN:SetText(Localization:GetString("372420"))
        self.endTime = endT
        self.cdTimeN:SetActive(true)
        self:AddTimer()
        CS.UIGray.SetGray(self.attackBtnN.transform, false, true)
        self.isCrossServerOpen = true
        self.curStatus = 2
    else
        --self.actTimeN:SetActive(false)
        self.endTime = nil
        self.cdTipN:SetText(Localization:GetString("370100"))
        self.cdTimeN:SetActive(false)
        self:DelTimer()
        CS.UIGray.SetGray(self.attackBtnN.transform, true, true)
        self.isCrossServerOpen = false
        self.curStatus = 3
    end
end

local function AddTimer(self)
    self.TimerAction = function()
        self:SetRemainTime()
    end

    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction , self, false,false,false)
    end
    self.timer:Start()
    self:SetRemainTime()
end

local function SetRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.endTime then
        local remainT = self.endTime - curTime
        if remainT > 0 then
            self.cdTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainT))
        else
            self:DelTimer()
            self:SetTimeTip()
        end
    else
        self:SetTimeTip()
    end
end

local function DelTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnClickAttackBtn(self)
    if self.curStatus == 2 then
        if CrossServerUtil.GetCrossServerIsInSameSeason() == false then
            UIUtil.ShowTips(Localization:GetString("372604"))
        else
            if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and LuaEntry.Player:IsInCrossFight() then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local startTime = LuaEntry.Player:GetEdenCoolDownTime()
                local addTime = 0
                local configTime = LuaEntry.DataConfig:TryGetNum("eden_activity_config", "k1")
                if configTime~=nil then
                    addTime = configTime*1000
                end
                local endTime = addTime+startTime
                if endTime>curTime then
                    UIUtil.ShowTipsId(111211)
                else
                    UIUtil.ShowMessage(Localization:GetString("111210"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                        SFSNetwork.SendMessage(MsgDefines.MoveCrossServer,LuaEntry.Player.crossFightSrcServerId,0, 2)
                        Setting:SetPrivateBool("ForAlCompeteEdenToNormal",true)
                        EventManager:GetInstance():Broadcast(EventId.OnSetEdenUI,UISetEdenType.Open)
                    end)
                end
                return
            end
            
            local fightServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
            if fightServerId>0 then
                if fightServerId == LuaEntry.Player:GetSelfServerId() then
                    SFSNetwork.SendMessage(MsgDefines.CrossGetAlliancePoint)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteTips,fightServerId,1)
                end
            end
        end
    elseif self.curStatus == 1 then
        UIUtil.ShowTips(Localization:GetString("E100172"))
    elseif self.curStatus == 3 then
        UIUtil.ShowTips(Localization:GetString("370100"))
    end
end

local function OnClickInfoBtn(self)
    UIUtil.ShowIntro(Localization:GetString("110214"), Localization:GetString("110223"), Localization:GetString("110221"))
end

local function OnGroupClick(self)
    local activityData = DataCenter.GloryManager:GetActivityData()
    if activityData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryGroup, activityData.groupId)
    end
end
local function OnGotoPoint(self,data)
    local str = tostring(data)
    local arr = string.split(str,";")
    if #arr>=2 then
        local serverId = tonumber(arr[1])
        local pointId = tonumber(arr[2])
        if serverId == LuaEntry.Player:GetSelfServerId() then
            GoToUtil.CloseAllWindows()
            local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
            position.x = position.x-1
            position.y = position.y
            position.z = position.z-1
            GoToUtil.GotoWorldPos(position, 223,LookAtFocusTime, nil)
            WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
        end
    end
    
end
AlCompeteCrossServerPanel.OnCreate = OnCreate
AlCompeteCrossServerPanel.OnDestroy = OnDestroy
AlCompeteCrossServerPanel.OnAddListener = OnAddListener
AlCompeteCrossServerPanel.OnRemoveListener = OnRemoveListener
AlCompeteCrossServerPanel.ComponentDefine = ComponentDefine
AlCompeteCrossServerPanel.ComponentDestroy = ComponentDestroy
AlCompeteCrossServerPanel.DataDefine = DataDefine
AlCompeteCrossServerPanel.DataDestroy = DataDestroy

AlCompeteCrossServerPanel.ShowPanel = ShowPanel
AlCompeteCrossServerPanel.RefreshAll = RefreshAll
AlCompeteCrossServerPanel.SetTimeTip = SetTimeTip
AlCompeteCrossServerPanel.AddTimer = AddTimer
AlCompeteCrossServerPanel.SetRemainTime = SetRemainTime
AlCompeteCrossServerPanel.DelTimer = DelTimer
AlCompeteCrossServerPanel.OnClickAttackBtn = OnClickAttackBtn
AlCompeteCrossServerPanel.OnClickInfoBtn = OnClickInfoBtn
AlCompeteCrossServerPanel.OnGotoPoint =OnGotoPoint
AlCompeteCrossServerPanel.OnGroupClick = OnGroupClick
return AlCompeteCrossServerPanel