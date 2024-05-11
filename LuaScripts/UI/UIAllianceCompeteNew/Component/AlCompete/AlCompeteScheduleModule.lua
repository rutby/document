---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/9/19 19:15
---AlCompeteScheduleModule.lua
local UIAllianceCompeteScheduleView = BaseClass("UIAllianceCompeteScheduleView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceCompeteScheduleItem = require "UI.UIAllianceCompeteNew.Component.AlCompete.AlCompeteScheduleItem"

local progressGo_path = "progressGo"
local itemContainer_path = "itemContainer"
local rate_path = "progressGo/Image jindutiao/rate"
local dateTxt_path = "topGo/Image/TextDate"
local typeTxt_path = "topGo/Image/TextMatch"
local scoreTxt_path = "topGo/Image/TextPoints"
local resultTxt_path = "topGo/Image/TextWinner"
local weekScoreTip_path = "topGo/Image/weekScoreTip"
local weekScoreL_path = "topGo/Image/redRatTxt"
local weekScoreR_path = "topGo/Image/blueRatTxt"

local function OnCreate(self)
    base.OnCreate(self)

    self.dateTxt = self:AddComponent(UITextMeshProUGUIEx, dateTxt_path)
    self.dateTxt:SetLocalText(361016)
    self.typeTxt = self:AddComponent(UITextMeshProUGUIEx, typeTxt_path)
    self.typeTxt:SetLocalText(361017)
    self.scoreTxt = self:AddComponent(UITextMeshProUGUIEx, scoreTxt_path)
    self.scoreTxt:SetLocalText(361018)
    self.resultTxt = self:AddComponent(UITextMeshProUGUIEx, resultTxt_path)
    self.resultTxt:SetLocalText(361019)
    self.progressGo = self:AddComponent(UIBaseContainer, progressGo_path)
    self.itemContainer = self:AddComponent(UIBaseContainer, itemContainer_path)
    self.rates = {}
    for i = 1, 7 do
        self.rates[i] = self:AddComponent(UIBaseContainer, rate_path .. i)
    end
    self.weekScoreTipN = self:AddComponent(UITextMeshProUGUIEx, weekScoreTip_path)
    self.weekScoreTipN:SetText(Localization:GetString("372421"))
    self.weekScoreLN = self:AddComponent(UITextMeshProUGUIEx, weekScoreL_path)
    self.weekScoreRN = self:AddComponent(UITextMeshProUGUIEx, weekScoreR_path)

    self:UpdateData()
end

local function OnDestroy(self)
    self.progressGo = nil
    self.itemContainer = nil
    self.rates = nil
    base.OnDestroy(self)
end

local function OnAddListener(self)
    self:AddUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
end

local function UpdateData(self)
    SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeeklySummary)
end

local function RefreshUI(self)
    if IsNull(self.gameObject) then
        return
    end
    
    self.allianceInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if self.allianceInfo == nil then
        return
    end
    self.eventInfo = self.allianceInfo:GetEventInfo()
    if not self.eventInfo then
        return
    end

    self:RefreshTop()
    self:RefreshList()
end

local function RefreshTop(self)
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if not hasAlliance then
        return
    end
    local myAllianceId = LuaEntry.Player.allianceId
    table.walk(self.eventInfo.vsAllianceList, function(k, v)
        local name = string.format("#%s [%s] %s", v.serverId, v.abbr, v.alName)
        local scoreStr = string.GetFormattedSeperatorNum(v.winScore)
        if k == myAllianceId then
            self.weekScoreLN:SetText(scoreStr)
        else
            self.weekScoreRN:SetText(scoreStr)
        end
    end)
end

local function RefreshList(self)
    for i = 1, 7 do
        self.rates[i]:SetActive(false)
    end

    local selfAlName = ""
    local otherAlName = ""
    local myAllianceId = LuaEntry.Player.allianceId
    table.walk(self.eventInfo.vsAllianceList, function(k, v)
        if k == myAllianceId then
            selfAlName = v.abbr
        else
            otherAlName = v.abbr
        end
    end)

    self.itemList = {}
    local dataList = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryList()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startT = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryStartTime()
    local day = math.ceil((curTime - startT) / 86400000)

    local list = dataList
    self:SetAllScheduleItemsDestroy()
    self.scheduleItemCount =0

    self.scheduleItemModel ={}
    self.scheduleItemsList = {}
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.scheduleItemCount= self.scheduleItemCount+1
            self.scheduleItemModel[self.scheduleItemCount] = self:GameObjectInstantiateAsync(UIAssets.AllianceCompeteScheduleItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.itemContainer.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.itemContainer:AddComponent(AllianceCompeteScheduleItem,nameStr)
                cell:RefreshData(list[i], i, day, selfAlName, otherAlName)

                if i <= day then-- list[i].isWin then
                    self.rates[i]:SetActive(true)
                end

                table.insert(self.scheduleItemsList,cell)
            end)
        end
    end
end

local function SetAllScheduleItemsDestroy(self)
    self.itemContainer:RemoveComponents(AllianceCompeteScheduleItem)
    if self.scheduleItemModel~=nil then
        for k,v in pairs(self.scheduleItemModel) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.scheduleItemModel ={}
    self.scheduleItemsList = {}
end

UIAllianceCompeteScheduleView.OnCreate = OnCreate
UIAllianceCompeteScheduleView.OnDestroy = OnDestroy
UIAllianceCompeteScheduleView.OnAddListener = OnAddListener
UIAllianceCompeteScheduleView.OnRemoveListener = OnRemoveListener

UIAllianceCompeteScheduleView.UpdateData = UpdateData
UIAllianceCompeteScheduleView.RefreshUI = RefreshUI
UIAllianceCompeteScheduleView.RefreshTop = RefreshTop
UIAllianceCompeteScheduleView.RefreshList = RefreshList
UIAllianceCompeteScheduleView.SetAllScheduleItemsDestroy = SetAllScheduleItemsDestroy
UIAllianceCompeteScheduleView.OnClickBlueScoreBtn = OnClickBlueScoreBtn
UIAllianceCompeteScheduleView.OnClickRedScoreBtn = OnClickRedScoreBtn

return UIAllianceCompeteScheduleView