--UIAllianceCompeteNewView.lua


local base = UIBaseView--Variable
local UIAllianceCompeteNewView = BaseClass("UIAllianceCompeteNewView", base)--Variable
local Localization = CS.GameEntry.Localization
local AlCompeteActivityPanel = require "UI.UIAllianceCompeteNew.Component.AlCompeteActivity.AlCompeteActivityPanel"
local AlCompetePanel = require "UI.UIAllianceCompeteNew.Component.AlCompete.AlCompetePanel"
local AlCompeteCrossDesertServerPanel = require "UI.UIAllianceCompeteNew.Component.AlCompeteCrossServer.AlCompeteCrossDesertServerPanel"
local AlCompeteCrossServerPanel = require "UI.UIAllianceCompeteNew.Component.AlCompeteCrossServer.AlCompeteCrossServerPanel"
local LeagueMatchNoticePanel = require "UI.UIAllianceCompeteNew.Component.LeagueMatchNotice.LeagueMatchNoticePanel"
local LeagueMatchDrawLotsPanel = require "UI.UIAllianceCompeteNew.Component.LeagueMatchDrawLots.LeagueMatchDrawLotsPanel"
local LeagueMatchAllianceRankPanel = require "UI.UIAllianceCompeteNew.Component.LeagueMatchAllianceRank.LeagueMatchAllianceRankPanel"
local SelectColor = Color.New(0.99, 0.8, 0.44)
local UnselectColor = Color.New(1, 0.9, 8)

local TabName = {
    [LeagueMatchTab.Activity] = "372284",
    [LeagueMatchTab.Compete] = "361000",
    [LeagueMatchTab.CrossServer] = "110214",
    [LeagueMatchTab.CrossServerDesert] = "110563",
    [LeagueMatchTab.Notice] = "372617",
    [LeagueMatchTab.DrawLots] = "372617",
    [LeagueMatchTab.AllianceRank] = "372629",
}

local panelContainer_path = "safeArea/panelContainer"
local closeBtn_path = "safeArea/closeBtn"
local toggle_path = "safeArea/tabsSv/Viewport/Content/Toggle"

local assetsPath = "Assets/Main/Prefab_Dir/UI/UIAllianceCompeteNew/%s.prefab"
local subPanelConf = {
    {
        Type = LeagueMatchTab.Activity,
        Asset = "AlCompeteActivity",
        Script = AlCompeteActivityPanel,
    },
    {
        Type = LeagueMatchTab.Compete,
        Asset = "AlCompetePanel",
        Script = AlCompetePanel,
    },
    {
        Type = LeagueMatchTab.AllianceRank,
        Asset = "LeagueMatchAlRankPanel",
        Script = LeagueMatchAllianceRankPanel,
    },
    {
        Type = LeagueMatchTab.DrawLots,
        Asset = "LeagueMatchDrawLotsPanel",
        Script = LeagueMatchDrawLotsPanel,
    },
    {
        Type = LeagueMatchTab.Notice,
        Asset = "LeagueMatchNoticePanel",
        Script = LeagueMatchNoticePanel,
    },
    {
        Type = LeagueMatchTab.CrossServer,
        Asset = "AlCompeteCrossServerPanel",
        Script = AlCompeteCrossServerPanel,
    },
    {
        Type = LeagueMatchTab.CrossServerDesert,
        Asset = "AlCompeteCrossDesertServerPanel",
        Script = AlCompeteCrossDesertServerPanel,
    },
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    if self.refreshTimer then
        self.refreshTimer:Stop()
        self.refreshTimer = nil
    end
    DataCenter.AllianceCompeteDataManager:CacheOpeningTabIndex(self.curTabIndex)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.bg = self:AddComponent(UIImage, "bg")
    if SeasonUtil.IsInSeasonDesertMode() then
        self.bg:LoadSprite("Assets/Main/TextureEx/UIActivity/UIleagueduel_img_unionbg.png")
    else
        self.bg:LoadSprite("Assets/Main/TextureEx/UIActivity/UIleagueduel_img_PICbg.png")
    end
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.showNews3 = self:AddComponent(UIButton, "safeArea/tabs/Toggle3/showNew3")
    self.newsTxt3 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/tabs/Toggle3/showNew3/showTxt3")
    self.showNews4 = self:AddComponent(UIButton, "safeArea/tabs/Toggle4/showNew4")
    self.newsTxt4 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/tabs/Toggle4/showNew4/showTxt4")
    self.newsTxt3:SetLocalText(302049)
    self.newsTxt4:SetLocalText(302049)
    self.showNews3:SetActive(false)
    self.showNews4:SetActive(false)
    self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
    self.togglesTbN = {}
    for i = 1, 8 do
        local tempPath = toggle_path .. i
        local toggle = self:AddComponent(UIButton, tempPath)
        toggle:SetOnClick(function()
            self:ChangeShowType(i)
        end)
        local newTog = {}
        newTog.toggleN = toggle
        newTog.chooseN = toggle:AddComponent(UIBaseContainer, "Choose")
        newTog.redN = toggle:AddComponent(UIBaseContainer, "ImgWarn")
        newTog.redNumN = toggle:AddComponent(UITextMeshProUGUIEx, "ImgWarn/TxtNum")
        newTog.nameN = toggle:AddComponent(UITextMeshProUGUIEx, "Text_lv_bold20")
        newTog.showNewN = toggle:AddComponent(UIBaseContainer, "showNew")
        newTog.showNewN:SetActive(false)
        newTog.ShowNewTxtN= toggle:AddComponent(UITextMeshProUGUIEx, "showNew/showTxt")
        if i == LeagueMatchTab.CrossServer then
            newTog.ShowNewTxtN:SetLocalText(302049)
        elseif i == LeagueMatchTab.CrossServerDesert then
            newTog.ShowNewTxtN:SetLocalText(302049)
        end
        table.insert(self.togglesTbN, newTog)
        --if self.ctrl:CheckIfTabIsVisible(i) then
        --    newTog.isVisible = true
        --    newTog.toggleN:SetActive(true)
        --else
        --    newTog.isVisible = false
        --    newTog.toggleN:SetActive(false)
        --end
    end
    local theLastIndex = LeagueMatchTab.CrossServerDesert
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)

    if actInfo then
        local eventInfo = actInfo:GetEventInfo()
        if eventInfo ~=nil then
            local fightStartTime = eventInfo.fightStartTime
            local desertFightStartTime = eventInfo.desertFightStartTime
            local fightEndTime = eventInfo.fightEndTime
            local desertFightEndTime = eventInfo.desertFightEndTime
            if fightStartTime ~=nil and desertFightStartTime~=nil then
                if fightStartTime>desertFightStartTime then
                    theLastIndex = LeagueMatchTab.CrossServer
                else
                    theLastIndex = LeagueMatchTab.CrossServerDesert
                end
            end
            local serverTime = UITimeManager:GetInstance():GetServerTime()
            if desertFightStartTime~=nil and desertFightEndTime~=nil and desertFightStartTime<serverTime and serverTime<desertFightEndTime then
                self.togglesTbN[LeagueMatchTab.CrossServerDesert].showNewN:SetActive(true)
            end
            if fightStartTime ~=nil and fightEndTime~=nil and fightStartTime<serverTime and serverTime<fightEndTime then
                self.togglesTbN[LeagueMatchTab.CrossServer].showNewN:SetActive(true)
            end
        end
    end
    local togglesLast = self.togglesTbN[theLastIndex]
    if togglesLast~=nil and togglesLast.toggleN~=nil and togglesLast.toggleN.transform~=nil then
        togglesLast.toggleN.transform:SetSiblingIndex(LeagueMatchTab.CrossServerDesert)
    end
--[[
    local theLastIndex = 4
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    
    if actInfo then
        local eventInfo = actInfo:GetEventInfo()
        if eventInfo ~=nil then
            local fightStartTime = eventInfo.fightStartTime
            local desertFightStartTime = eventInfo.desertFightStartTime
            local fightEndTime = eventInfo.fightEndTime
            local desertFightEndTime = eventInfo.desertFightEndTime
            if fightStartTime ~=nil and desertFightStartTime~=nil then
                if fightStartTime>desertFightStartTime then
                    theLastIndex = 3
                else
                    theLastIndex = 4
                end
            end
            local serverTime = UITimeManager:GetInstance():GetServerTime()
            if desertFightStartTime~=nil and desertFightEndTime~=nil and desertFightStartTime<serverTime and serverTime<desertFightEndTime then
                self.showNews4:SetActive(true)
            end
            if fightStartTime ~=nil and fightEndTime~=nil and fightStartTime<serverTime and serverTime<fightEndTime then
                self.showNews3:SetActive(true)
            end
        end
    end
    local togglesLast = self.togglesTbN[theLastIndex]
    if togglesLast~=nil and togglesLast.toggleN~=nil and togglesLast.toggleN.transform~=nil then
        togglesLast.toggleN.transform:SetAsLastSibling()
    end
--]]
end

local function ComponentDestroy(self)
    self.closeBtnN = nil
    self.togglesTbN = nil
    self.infoBtnN = nil
    self.panelContainerN = nil
end

local function DataDefine(self)
    self.panelList = {}
    self.reqList = {}
    self.curTabIndex = nil
end

local function DataDestroy(self)
    self.panelList = nil
    self.reqList = nil
    self.curTabIndex = nil
end

--  [[
local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
    self:AddUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAll)
    self:AddUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
    self:AddUIListener(EventId.OnPassDay, self.OnPassDayCallback)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
    self:RemoveUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.OnPassDay, self.OnPassDayCallback)
    base.OnRemoveListener(self)
end
--]]

local function InitUI(self)
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
        local leagueMatchStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
        if leagueMatchStage ~= LeagueMatchStage.None then
            DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
        end
        SFSNetwork.SendMessage(MsgDefines.AllianceCompeteRankList, 0)
    end

    local targetTabIndex,boxIndex = self:GetUserData()
    if not targetTabIndex then
        targetTabIndex = DataCenter.AllianceCompeteDataManager:GetDefaultOpenTabIndex()
    end
    targetTabIndex = targetTabIndex or LeagueMatchTab.Activity
    targetTabIndex = self:RefreshTabs(targetTabIndex, boxIndex)
    self:ChangeShowType(targetTabIndex)
    self:RefreshRed()
end

local function RefreshAll(self)
    local tempIndex = self:RefreshTabs(self.curTabIndex)
    self:ChangeShowType(tempIndex)
    self:RefreshRed()
end

local function RefreshTabs(self, targetTabIndex, boxIndex)
    for i, v in ipairs(self.togglesTbN) do
        v.nameN:SetText(TabName[i] and Localization:GetString(TabName[i]) or "")
        if self.ctrl:CheckIfTabIsVisible(i) then
            v.isVisible = true
            v.toggleN:SetActive(true)
        else
            v.isVisible = false
            v.toggleN:SetActive(false)
        end
    end
    
    local theLastIndex = LeagueMatchTab.CrossServerDesert
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if actInfo then
        local eventInfo = actInfo:GetEventInfo()
        if eventInfo ~=nil then
            local fightStartTime = eventInfo.fightStartTime
            local desertFightStartTime = eventInfo.desertFightStartTime
            if fightStartTime ~=nil and desertFightStartTime~=nil then
                if fightStartTime>desertFightStartTime then
                    theLastIndex = LeagueMatchTab.CrossServer
                else
                    theLastIndex = LeagueMatchTab.CrossServerDesert
                end
            end
        end
    end
    local togglesLast = self.togglesTbN[theLastIndex]
    if togglesLast~=nil and togglesLast.toggleN~=nil and togglesLast.toggleN.transform~=nil then
        togglesLast.toggleN.transform:SetAsLastSibling()
    end
    
    targetTabIndex = targetTabIndex or 1
    if not self.togglesTbN[targetTabIndex].isVisible then
        for i, v in ipairs(self.togglesTbN) do
            if v.isVisible then
                targetTabIndex = i
                break
            end
        end
    end
    if targetTabIndex == 1 then
        if boxIndex and boxIndex ~= 0 then
            self.boxIndex = boxIndex
        end
    end
    return targetTabIndex
end

local function OnRefreshCallback(self)
    self:RefreshRed()
end

local function OnPassDayCallback(self)
    self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.refreshTimer = nil
        local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
        if tempStage == LeagueMatchStage.WeeklySummary or tempStage == LeagueMatchStage.FinalSummary then
            self:OnClickCloseBtn()
        end
    end, 3)
end

local function RefreshRed(self)
    for i, v in ipairs(self.togglesTbN) do
        local redCount = self:GetRedCountByType(i)
        if redCount and redCount > 0 then
            v.redN:SetActive(true)
            v.redNumN:SetText(redCount)
        else
            v.redN:SetActive(false)
        end
    end
end

local function GetRedCountByType(self, tabType)
    if tabType == LeagueMatchTab.Activity then
        local redCount = DataCenter.AllianceCompeteDataManager:GetAlCompeteActivityRedCount()
        return redCount
    else
        return 0
    end
end


local function ChangeShowType(self, tabIndex)
    for i = 1, #self.togglesTbN do
        self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
        self.togglesTbN[i].nameN:SetColor(i == tabIndex and SelectColor or WhiteColor)
    end

    local prefabName = subPanelConf[tabIndex].Asset

    if self.curTabIndex and prefabName == subPanelConf[self.curTabIndex].Asset then
        self.curTabIndex = tabIndex
        self:RefreshOnShowPanel()
    else
        if not self.panelList[prefabName] then
            if self.reqList[prefabName] then
                return
            end
            local assetFullPath = string.format(assetsPath, prefabName)
            self.reqList[prefabName] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
                if request.isError then
                    return
                end
                --在新预制加载完之前仍然显示之前的界面
                if self.curTabIndex then
                    self.panelList[subPanelConf[self.curTabIndex].Asset]:SetActive(false)
                end
                self.curTabIndex = tabIndex

                local go = request.gameObject;
                go.transform:SetParent(self.panelContainerN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local v3 = go.transform.position
                v3.x = 0
                v3.y = 0
                go.transform.position = v3
                go.transform:Set_sizeDelta(0, 0)
                go.transform:Set_anchoredPosition(0, 0)
                
                local cell = self.panelContainerN:AddComponent(subPanelConf[tabIndex].Script, go)
                self.panelList[prefabName] = cell
                self.panelList[prefabName]:SetActive(true)
                self:RefreshOnShowPanel()
            end)
        else
            if self.curTabIndex then
                self.panelList[subPanelConf[self.curTabIndex].Asset]:SetActive(false)
            end
            self.curTabIndex = tabIndex
            self.panelList[prefabName]:SetActive(true)

            self:RefreshOnShowPanel()
        end
    end
end

local function RefreshOnShowPanel(self)
    local tempPanel = subPanelConf[self.curTabIndex].Asset
    local showType = subPanelConf[self.curTabIndex].Type
    self.panelList[tempPanel]:ShowPanel(showType)
end

local function CheckIfDoubleReward(self)
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ONE_MORE_TIMES)
    if effectNum and effectNum > 0 then
        return true
    end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UIAllianceCompeteNewView.OnCreate = OnCreate
UIAllianceCompeteNewView.OnDestroy = OnDestroy
UIAllianceCompeteNewView.ComponentDefine = ComponentDefine
UIAllianceCompeteNewView.ComponentDestroy = ComponentDestroy
UIAllianceCompeteNewView.DataDefine = DataDefine
UIAllianceCompeteNewView.DataDestroy = DataDestroy
UIAllianceCompeteNewView.OnAddListener = OnAddListener
UIAllianceCompeteNewView.OnRemoveListener = OnRemoveListener

UIAllianceCompeteNewView.InitUI = InitUI
UIAllianceCompeteNewView.RefreshTabs = RefreshTabs
UIAllianceCompeteNewView.RefreshAll = RefreshAll
UIAllianceCompeteNewView.ChangeShowType = ChangeShowType
UIAllianceCompeteNewView.RefreshOnShowPanel = RefreshOnShowPanel
UIAllianceCompeteNewView.CheckIfTabIsVisible = CheckIfTabIsVisible
UIAllianceCompeteNewView.GetRedCountByType = GetRedCountByType
UIAllianceCompeteNewView.RefreshRed = RefreshRed
UIAllianceCompeteNewView.CheckIfDoubleReward = CheckIfDoubleReward
UIAllianceCompeteNewView.OnClickCloseBtn = OnClickCloseBtn
UIAllianceCompeteNewView.OnRefreshCallback = OnRefreshCallback
UIAllianceCompeteNewView.OnPassDayCallback = OnPassDayCallback
UIAllianceCompeteNewView.OnStageChange = OnStageChange

return UIAllianceCompeteNewView