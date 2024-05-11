
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/27 16:08
---LeagueMatchAllianceRankPanel.lua

local base = UIBaseContainer--Variable
local Tb = BaseClass("LeagueMatchAllianceRankPanel", base)--Variable
local Localization = CS.GameEntry.Localization
local LeagueMatchAlRankItem = require "UI.UIAllianceCompeteNew.Component.LeagueMatchAllianceRank.LeagueMatchAlRankItem"

local subtTitle_path = "main/Title/desTxt"
local groupName_path = "main/Title/groupName"
local infoBtn_path = "rightLayer/infoBtn"
local rankBtn_path = "rightLayer/rankBtn"
local rankBtnTxt_path = "rightLayer/rankBtn/rankBtnTxt"
local rankNum_path = "rightLayer/rankBtn/Text_num"
local detailBtn_path = "rightLayer/detailBtn"
local detailBtnTxt_path = "rightLayer/detailBtn/detailBtnTxt"
local rewardBtn_path = "rightLayer/rewardBtn"
local rewardBtnTxt_path = "rightLayer/rewardBtn/rewardBtnTxt"
local headPosition_path = "main/head/rank"
local headAlName_path = "main/head/alName"
local headWeek_path = "main/head/week_"
local upTip_path = "main/ScrollView/Viewport/Content/tipUp"
local upTipTxt_path = "main/ScrollView/Viewport/Content/tipUp/upTip"
local downTip_path = "main/ScrollView/Viewport/Content/tipDown"
local downTipTxt_path = "main/ScrollView/Viewport/Content/tipDown/downTip"
local content_path = "main/ScrollView/Viewport/Content"
local segmentImg_path = "main/Title/Image (1)"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.subTitleN = self:AddComponent(UITextMeshProUGUIEx, subtTitle_path)
    self.groupNameN = self:AddComponent(UITextMeshProUGUIEx, groupName_path)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.rankBtnN = self:AddComponent(UIButton, rankBtn_path)
    self.rankBtnN:SetOnClick(function()
        self:OnClickPersonalRankBtn()
    end)
    self.rankBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, rankBtnTxt_path)
    self.rankBtnTxtN:SetLocalText(372631)
    self.rankNumN = self:AddComponent(UITextMeshProUGUIEx, rankNum_path)
    self.rankNumN:SetText("")
    self.detailBtnN = self:AddComponent(UIButton, detailBtn_path)
    self.detailBtnN:SetOnClick(function()
        self:OnClickMatchDetailBtn()
    end)
    self.detailBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, detailBtnTxt_path)
    self.detailBtnTxtN:SetLocalText(372630)
    self.rewardBtnN = self:AddComponent(UIButton, rewardBtn_path)
    self.rewardBtnN:SetOnClick(function()
        self:OnClickRewardBtn()
    end)
    self.rewardBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, rewardBtnTxt_path)
    self.rewardBtnTxtN:SetLocalText(372817)
    self.headPositionN = self:AddComponent(UITextMeshProUGUIEx, headPosition_path)
    self.headPositionN:SetLocalText(302043)
    self.headAlNameN = self:AddComponent(UITextMeshProUGUIEx, headAlName_path)
    self.headAlNameN:SetLocalText(390288)
    for i = 1, 4 do
        local weekIndex = self:AddComponent(UITextMeshProUGUIEx, headWeek_path .. i)
        weekIndex:SetLocalText(320631, i)
    end
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self.upTipN = self:AddComponent(UIBaseContainer, upTip_path)
    self.upTipTxtN = self:AddComponent(UITextMeshProUGUIEx, upTipTxt_path)
    self.upTipTxtN:SetLocalText(372635)
    self.downTipN = self:AddComponent(UIBaseContainer, downTip_path)
    self.downTipTxtN = self:AddComponent(UITextMeshProUGUIEx, downTipTxt_path)
    self.downTipTxtN:SetLocalText(372636)
    self.segmentImgN = self:AddComponent(UIImage, segmentImg_path)
end

local function ComponentDestroy(self)
    self.subTitleN = nil
    self.groupNameN = nil
    self.infoBtnN = nil
    self.rankBtnN = nil
    self.rankBtnTxtN = nil
    self.detailBtnN = nil
    self.detailBtnTxtN = nil
    self.rewardBtnN = nil
    self.rewardBtnTxtN = nil
    self.headPositionN = nil
    self.headAlNameN = nil
    self.contentN = nil
    self.upTipN = nil
    self.upTipTxtN = nil
    self.downTipN = nil
    self.downTipTxtN = nil
end

local function DataDefine(self)
    self.allianceList = {}
    self.allianceItems = {}
end

local function DataDestroy(self)
    self.allianceList = nil
    self.allianceItems = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnLeagueMatchGroupUpdate, self.RefreshAll)
    self:AddUIListener(EventId.OnLastLeagueMatchGroupInfoUpdate, self.RefreshAll)
    self:AddUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshPersonalRank)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnLeagueMatchGroupUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.OnLastLeagueMatchGroupInfoUpdate, self.RefreshAll)
    self:RemoveUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshPersonalRank)
    base.OnRemoveListener(self)
end

local function ShowPanel(self)
    DataCenter.LeagueMatchManager:TryUpdateLeagueMatchGroup()
    self:RefreshAll()
end

local function RefreshAll(self)
    if IsNull(self.gameObject) then
        return
    end
    
    local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
    if not duelInfo then
        return
    end
    
    local groupType = ""
    if duelInfo.rankType == SegmentType.Silver then
        self.segmentImgN:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UIleagueduel_icon_silver.png")
        groupType = Localization:GetString("372611")
    elseif duelInfo.rankType == SegmentType.Gold then
        self.segmentImgN:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UIleagueduel_icon_metals.png")
        groupType = Localization:GetString("372612")
    elseif duelInfo.rankType == SegmentType.Diamond then
        self.segmentImgN:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UIleagueduel_icon_diamond.png")
        groupType = Localization:GetString("372613")
    end

    local strArr = string.split(duelInfo.group, "_")
    local groupName = Localization:GetString("372629") .. " " .. groupType .. " " .. strArr[1] .. "-" .. strArr[3]
    self.groupNameN:SetText(groupName)
    
    self:RefreshPersonalRank()
    
    self:RefreshAllianceItems()
    
    self:RefreshSubTitle()
end

local function RefreshSubTitle(self)
    local showUpDown = false
    local upCount = 0
    local downCount = 0
    local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    if tempStage == LeagueMatchStage.Notice or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
        for i, v in ipairs(self.allianceList) do
            local alInfo = self.allianceList[i]
            if alInfo.upOrDown == 1 then
                upCount = upCount + 1
                showUpDown = true
            elseif alInfo.upOrDown == 2 then
                downCount = downCount + 1
                showUpDown = true
            end
        end
    else
        upCount, downCount = DataCenter.LeagueMatchManager:GetUpDownCount()
        showUpDown = upCount >= 0
    end

    if not showUpDown then
        self.subTitleN:SetLocalText("372633")
    elseif upCount > 0 and downCount > 0 then
        self.subTitleN:SetLocalText("372634", upCount, downCount)
    elseif upCount > 0 then
        self.subTitleN:SetLocalText("372830", upCount)
    elseif downCount > 0 then
        self.subTitleN:SetLocalText("372831", downCount)
    else
        self.subTitleN:SetLocalText("372852")
    end
end

local function RefreshPersonalRank(self)
    self.rankBtnN:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UIleagueduel_btn_ranking.png")
end


local function InstantiateAllianceItems(self)
    if self.allianceList ~= nil then
        self.reqList = {}
        for i = 1, table.length(self.allianceList) do
            --复制基础prefab，每次循环创建一次
            self.reqList[i] = self:GameObjectInstantiateAsync(UIAssets.LeagueMatchAlRankItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                --go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentN.transform)
                go.transform:Set_localScale(1, 1, 1)
                --go.transform:Set_localPosition(0, -50,0)
                go.name ="item" .. i
                local cell = self.contentN:AddComponent(LeagueMatchAlRankItem, go.name)
                table.insert(self.allianceItems, cell)
                if #self.allianceItems == table.count(self.allianceList) then
                    self:RefreshAllianceItems()
                end
            end)
        end
    end
end

local function RefreshAllianceItems(self)
    self.allianceList = self.view.ctrl:GetAllianceListRanked()

    if not self.reqList or table.count(self.reqList) == 0 then
        self:InstantiateAllianceItems()
    else
        for i, v in ipairs(self.allianceItems) do
            v:SetItem(self.allianceList[i])
        end
        local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
        
        self.downTipN:SetActive(false)
        self.upTipN:SetActive(false)
        local upOrDown = nil
        if tempStage == LeagueMatchStage.Notice or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.FinalSummary
            or tempStage == LeagueMatchStage.DrawLotsFinished then
            for i = #self.allianceItems, 1, -1 do
                local alInfo = self.allianceList[i]
                if upOrDown == nil then
                    upOrDown = alInfo.upOrDown
                elseif upOrDown ~= alInfo.upOrDown then
                    upOrDown = alInfo.upOrDown
                    if upOrDown == 0 then
                        self.downTipN:SetActive(true)
                        self.downTipN.transform:SetSiblingIndex(i + 1)
                    elseif upOrDown == 1 then
                        self.upTipN:SetActive(true)
                        self.upTipN.transform:SetSiblingIndex(i + 1)
                    end
                end
            end
        end
    end
end


local function OnClickInfoBtn(self)
    UIUtil.ShowIntro(Localization:GetString("100239"), Localization:GetString("100239")
        , Localization:GetString("372813"))
end

local function OnClickMatchDetailBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILeagueMatchResult, { anim = true })
end

local function OnClickPersonalRankBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true }, 3)
end

local function OnClickRewardBtn(self)
    local targetTab = 3
    local targetSeg = SegmentType.Silver
    local matchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
    local duelInfo = matchInfo and matchInfo.duelInfo-- DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
    if duelInfo then
        if duelInfo.rankType == SegmentType.Silver then
            targetSeg = SegmentType.Silver
        elseif duelInfo.rankType == SegmentType.Gold then
            targetSeg = SegmentType.Gold
        else
            targetSeg = SegmentType.Diamond
        end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILeagueMatchReward, { anim = true }, targetTab, targetSeg)
end


Tb.OnCreate = OnCreate
Tb.OnDestroy = OnDestroy
Tb.OnAddListener = OnAddListener
Tb.OnRemoveListener = OnRemoveListener
Tb.ComponentDefine = ComponentDefine
Tb.ComponentDestroy = ComponentDestroy
Tb.DataDefine = DataDefine
Tb.DataDestroy = DataDestroy

Tb.ShowPanel = ShowPanel
Tb.RefreshAll = RefreshAll
Tb.RefreshAllianceItems = RefreshAllianceItems
Tb.InstantiateAllianceItems = InstantiateAllianceItems
Tb.RefreshPersonalRank = RefreshPersonalRank
Tb.RefreshSubTitle = RefreshSubTitle
Tb.OnClickInfoBtn = OnClickInfoBtn
Tb.OnClickMatchDetailBtn = OnClickMatchDetailBtn
Tb.OnClickPersonalRankBtn = OnClickPersonalRankBtn
Tb.OnClickRewardBtn = OnClickRewardBtn

return Tb