---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---

local UIColonizeWarRank = BaseClass("UIColonizeWarRank", UIBaseView)
local base = UIBaseView
local RankListItem = require "UI.UIActivityCenterTable.Component.ColonizeWarRank.RankListItem"
local DesertScoreCell = require "UI.UIActivityCenterTable.Component.ColonizeWarRank.DesertScoreCell"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local Localization = CS.GameEntry.Localization
local tabSelect_img = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_open.png"
local tabUnSelect_img = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_close.png"
local tabUnSelect_color= Color.New(183/255,102/255,48/255,1)
local tabSelect_color= Color.New(255/255,255/255,255/255,1)
local tabSelect_shadow= Color.New(128/255,56/255,24/255,1)
function UIColonizeWarRank:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIColonizeWarRank:OnDestroy()
    self:ClearScroll()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIColonizeWarRank:OnEnable()
    base.OnEnable(self)
end

function UIColonizeWarRank:OnDisable()
    base.OnDisable(self)

end

function UIColonizeWarRank:ComponentDefine()

    self._actName_txt = self:AddComponent(UIText, "RightView/Top/Txt_ActName")
    self.intro_btn = self:AddComponent(UIButton, "RightView/Top/Txt_ActName/infoBtn")
    self.intro_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnIntroClick()
    end)
    
    self._time_txt = self:AddComponent(UIText,"RightView/Top/Txt_ActTime")


    self._select = self:AddComponent(UIText,"RightView/Rect_Rank/select")
    self._nameDes_txt = self:AddComponent(UIText,"RightView/Rect_Rank/select/nameDes")
    self._desertDesc_txt = self:AddComponent(UIText,"RightView/Rect_Rank/select/Txt_ScoreDes")
    self._rewardScoreDes_txt = self:AddComponent(UIText,"RightView/Rect_Rank/select/Txt_RewardScoreDes")
    self._country_txt = self:AddComponent(UIText,"RightView/Rect_Rank/select/Txt_Country")

    self._noRankAlliance_txt = self:AddComponent(UIText,"RightView/Rect_Rank/ScrollViewAlliance/Txt_NoRankAlliance")
    self._noRankPlayer_txt = self:AddComponent(UIText,"RightView/Rect_Rank/ScrollViewPlayer/Txt_NoRankPlayer")

    self._scoreTip_txt = self:AddComponent(UIText,"RightView/Rect_Rank/Txt_ScoreBg/Txt_ScoreTip")
    self._scoreTip_bg = self:AddComponent(UIBaseContainer,"RightView/Rect_Rank/Txt_ScoreBg")
    self._scoreTip_txt:SetLocalText(373161)

    self.scrollView_Alliance = self:AddComponent(UIScrollView, "RightView/Rect_Rank/ScrollViewAlliance")
    self.scrollView_Alliance:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankAllianceMoveIn(itemObj, index)
    end)
    self.scrollView_Alliance:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankAllianceMoveOut(itemObj, index)
    end)

    self.scrollView_Player = self:AddComponent(UIScrollView, "RightView/Rect_Rank/ScrollViewPlayer")
    self.scrollView_Player:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankPlayerMoveIn(itemObj, index)
    end)
    self.scrollView_Player:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankPlayerMoveOut(itemObj, index)
    end)

    self.scrollView_Desert = self:AddComponent(UIScrollView, "RightView/Rect_Rank/ScrollViewDesert")
    self.scrollView_Desert:SetOnItemMoveIn(function(itemObj, index)
        self:OnDesertMoveIn(itemObj, index)
    end)
    self.scrollView_Desert:SetOnItemMoveOut(function(itemObj, index)
        self:OnDesertMoveOut(itemObj, index)
    end)

    self._selfObj = self:AddComponent(UIBaseComponent,"RightView/Rect_Rank/selfObj")
    self._selfAllianceRank_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfAllianceRank")
    self._selfPlayerRank_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfPlayerRank")
    
    self._selfName_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfName")
    self._selfAllianceLeader_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfAllianceLeader")
    
    self._selfAllianceScore_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfAllianceScore")
    self._selfPlayerScore_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfPlayerScore")
    
    self._selfRewardScore_txt = self:AddComponent(UIText,"RightView/Rect_Rank/selfObj/Txt_SelfRewardScore")
    
    self._allianceFlag_rect = self:AddComponent(UIBaseContainer,"RightView/Rect_Rank/selfObj/allianceFlag")
    self.allianceFlag = self:AddComponent(AllianceFlagItem,"RightView/Rect_Rank/selfObj/allianceFlag/AllianceFlag")
    self.player_flag = self:AddComponent(UIBaseContainer,"RightView/Rect_Rank/selfObj/playerFlag")
    self.player_img =self:AddComponent(UIPlayerHead,"RightView/Rect_Rank/selfObj/playerFlag/UIPlayerHead/HeadIcon")
    
    self._selfCountry_img = self:AddComponent(UIImage,"RightView/Rect_Rank/selfObj/country")
    
    self._allianceRank_btn = self:AddComponent(UIButton,"RightView/Rect_BtnList/Btn_AllianceRank")
    self._allianceRank_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRank(1)
    end)
    self._allianceRank_txt = self:AddComponent(UIText,"RightView/Rect_BtnList/Btn_AllianceRank/Txt_AllianceRank")
    self._allianceRank_txt:SetLocalText(302144)
    self._playerRank_btn = self:AddComponent(UIButton,"RightView/Rect_BtnList/Btn_PlayerRank")
    self._playerRank_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRank(2)
    end)
    self._playerRank_txt = self:AddComponent(UIText,"RightView/Rect_BtnList/Btn_PlayerRank/Txt_PlayerRank")
    self._playerRank_txt:SetLocalText(373159)
    self._scoreRule_btn = self:AddComponent(UIButton,"RightView/Rect_BtnList/Btn_ScoreRule")
    self._scoreRule_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRank(3)
    end)
    self._scoreRule_txt = self:AddComponent(UIText,"RightView/Rect_BtnList/Btn_ScoreRule/Txt_ScoreRule")
    self._scoreRule_txt:SetLocalText(373160)
end

function UIColonizeWarRank:DataDefine()
    self.scoreList = {}
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    LocalController:instance():visitTable(TableName.Desert, function(id, lineData)
        local xmlType = toInt(lineData["desert_type"])
        local xmlLevel = toInt(lineData["desert_level"])
        local xmlScore = toInt(lineData["landclash_score"])
        local xmlSeason = toInt(lineData["season"])
        if xmlSeason == (seasonId - 1) and xmlType == 1 then
            table.insert(self.scoreList,{lv = xmlLevel,score = xmlScore})
        end
    end)
    table.sort(self.scoreList,function(a,b)
        if a.lv < b.lv then
            return true
        end
        return false
    end)
end

function UIColonizeWarRank:DataDestroy()
   
end

function UIColonizeWarRank:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ColonizeWarAllianceRank, self.OnRefreshAlliance)
    self:AddUIListener(EventId.ColonizeWarPlayerRank, self.OnRefreshPlayer)
end

function UIColonizeWarRank:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ColonizeWarAllianceRank, self.OnRefreshAlliance)
    self:RemoveUIListener(EventId.ColonizeWarPlayerRank, self.OnRefreshPlayer)
end

function UIColonizeWarRank:SetData(activityId,actId)
    self.activityId = activityId
    self:ClearScroll()
    SFSNetwork.SendMessage(MsgDefines.GetColonialWarAllianceRank,activityId)
    SFSNetwork.SendMessage(MsgDefines.GetColonialWarUserRank,activityId)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    self.actListData = actListData
    if actListData then
        self:RefreshTitle(actListData)
    end
    
    self.player_img:SetData(LuaEntry.Player:GetUid(),LuaEntry.Player:GetPic(),LuaEntry.Player.picVer)
    self:OnClickRank(1)
end

--切换页签
function UIColonizeWarRank:OnClickRank(type)
    self.scrollView_Alliance:SetActive(type == 1)
    self.scrollView_Player:SetActive(type == 2)
    self.scrollView_Desert:SetActive(type == 3)
    self._allianceFlag_rect:SetActive(type == 1)
    self.player_flag:SetActive(type == 2)
    self._selfAllianceRank_txt:SetActive(type == 1)
    self._selfPlayerRank_txt:SetActive(type == 2)
    self._selfAllianceScore_txt:SetActive(type == 1)
    self._selfPlayerScore_txt:SetActive(type == 2)
    self._select:SetActive(type ~= 3)
    self._selfObj:SetActive(type ~= 3)
    self._scoreTip_bg:SetActive(type == 3)
    self._selfRewardScore_txt:SetActive(type == 1)
    self._desertDesc_txt:SetActive(type == 1)
   
    if type == 1 then
        local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if allianceData~=nil and LuaEntry.Player:IsInAlliance()  then
            self._selfName_txt:SetLocalText(311026,allianceData.abbr,allianceData.allianceName)
            self.allianceFlag:SetData(allianceData.icon)
            self._selfAllianceLeader_txt:SetText(allianceData.leaderName)
            if LuaEntry.Player:IsHideCountryFlag() then
                self._country_txt:SetActive(false)
            else
                self._country_txt:SetActive(true)
                self._selfCountry_img:SetActive(true)
                local countryConfig = DataCenter.NationTemplateManager:GetNationTemplate(allianceData:GetCountryFlagTemplate())
                self._selfCountry_img:LoadSprite(countryConfig:GetNationFlagPath())
            end
        else
            self._selfCountry_img:SetActive(false)
            self._selfName_txt:SetText("-")
        end
        self._allianceRank_btn:LoadSprite(tabSelect_img)
        self._playerRank_btn:LoadSprite(tabUnSelect_img)
        self._allianceRank_txt:SetColor(tabSelect_color)
        self._playerRank_txt:SetColor(tabUnSelect_color)
        self._scoreRule_btn:LoadSprite(tabUnSelect_img)
        self._scoreRule_txt:SetColor(tabUnSelect_color)
        self._allianceRank_txt.transform:Set_localPosition(0,7,0)
        self._playerRank_txt.transform:Set_localPosition(0,4,0)
        self._scoreRule_txt.transform:Set_localPosition(0,4,0)
        
        self._nameDes_txt:SetLocalText(390288)
        self._rewardScoreDes_txt:SetLocalText(373158)
    elseif type == 2 then
        self._selfName_txt:SetText(LuaEntry.Player:GetName())
        local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if allianceData~=nil and LuaEntry.Player:IsInAlliance()  then
            self._selfAllianceLeader_txt:SetLocalText(311026,allianceData.abbr,allianceData.allianceName)
        else
            self._selfAllianceLeader_txt:SetText("-")
        end
        self._allianceRank_btn:LoadSprite(tabUnSelect_img)
        self._playerRank_btn:LoadSprite(tabSelect_img)
        self._allianceRank_txt:SetColor(tabUnSelect_color)
        self._playerRank_txt:SetColor(tabSelect_color)
        self._scoreRule_btn:LoadSprite(tabUnSelect_img)
        self._scoreRule_txt:SetColor(tabUnSelect_color)
        self._allianceRank_txt.transform:Set_localPosition(0,4,0)
        self._playerRank_txt.transform:Set_localPosition(0,7,0)
        self._scoreRule_txt.transform:Set_localPosition(0,4,0)
        
        
        self._selfCountry_img:SetActive(false)
        self._country_txt:SetActive(false)
        self._nameDes_txt:SetLocalText(320763)
        self._rewardScoreDes_txt:SetLocalText(302042)
    elseif type == 3 then
        self._allianceRank_btn:LoadSprite(tabUnSelect_img)
        self._playerRank_btn:LoadSprite(tabUnSelect_img)
        self._allianceRank_txt:SetColor(tabUnSelect_color)
        self._playerRank_txt:SetColor(tabUnSelect_color)
        self._scoreRule_btn:LoadSprite(tabSelect_img)
        self._scoreRule_txt:SetColor(tabSelect_color)
       
        self._allianceRank_txt.transform:Set_localPosition(0,4,0)
        self._playerRank_txt.transform:Set_localPosition(0,4,0)
        self._scoreRule_txt.transform:Set_localPosition(0,7,0)
        self.scrollView_Desert:ClearCells()
        self.scrollView_Desert:RemoveComponents(DesertScoreCell)
        if self.scoreList and table.count(self.scoreList) > 0 then
            self.scrollView_Desert:SetTotalCount(#self.scoreList)
            self.scrollView_Desert:RefillCells()
        end
    end
end

--刷新联盟排行榜
function UIColonizeWarRank:OnRefreshAlliance(message)
    self.rankAllianceList = message["rankList"]

    self.selfAllianceRank = message["selfRank"]
    if self.selfAllianceRank == -1 then
        self._selfAllianceRank_txt:SetText("-")
    else
        self._selfAllianceRank_txt:SetText(self.selfAllianceRank)
    end
    
    self._selfAllianceScore_txt:SetText(message["selfScore"])

    self.rankRewardArr = {}
    if message["rankRewardArr"] and next(message["rankRewardArr"]) then
        for i = 1 ,#message["rankRewardArr"] do
            self.rankRewardArr[i] = {}
            self.rankRewardArr[i].addScore = message["rankRewardArr"][i]["addScore"]
            self.rankRewardArr[i].startN = message["rankRewardArr"][i]["start"]
            self.rankRewardArr[i].endN = message["rankRewardArr"][i]["end"]
        end
        --自己排名的奖励积分
        local rewardAddScore = 0
        for i = 1 ,#self.rankRewardArr do
            if self.selfAllianceRank >= self.rankRewardArr[i].startN and self.selfAllianceRank <= self.rankRewardArr[i].endN then
                rewardAddScore = self.rankRewardArr[i].addScore
                break
            end
        end
        self._selfRewardScore_txt:SetText(rewardAddScore)
    end
    
    if self.rankAllianceList and table.count(self.rankAllianceList) > 0 then
        self._noRankAlliance_txt:SetActive(false)
        self.scrollView_Alliance:SetTotalCount(#self.rankAllianceList)
        self.scrollView_Alliance:RefillCells()
    else
        self._noRankAlliance_txt:SetActive(true)
        self._noRankAlliance_txt:SetLocalText(110535)
    end
end

--刷新玩家排行榜，自己盟的
function UIColonizeWarRank:OnRefreshPlayer(message)
    self.rankPlayerList = message["rankList"]

    local selfRank = message["selfRank"]
    if selfRank == -1 then
        self._selfPlayerRank_txt:SetText("-")
    else
        self._selfPlayerRank_txt:SetText(selfRank)
    end
    self._selfPlayerScore_txt:SetText(message["selfScore"])

    if self.rankPlayerList and table.count(self.rankPlayerList) > 0 then
        self._noRankPlayer_txt:SetActive(false)
        self.scrollView_Player:SetTotalCount(#self.rankPlayerList)
        self.scrollView_Player:RefillCells()
    else
        self._noRankPlayer_txt:SetActive(true)
        self._noRankPlayer_txt:SetLocalText(110534)
    end
end

--联盟排行榜刷新
function UIColonizeWarRank:OnRankAllianceMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollView_Alliance:AddComponent(RankListItem, itemObj)
    cellItem:SetAllianceShow(self.rankAllianceList[index],self.rankRewardArr)
end
function UIColonizeWarRank:OnRankAllianceMoveOut(itemObj, index)
    self.scrollView_Alliance:RemoveComponent(itemObj.name, RankListItem)
end

--玩家排行榜刷新
function UIColonizeWarRank:OnRankPlayerMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollView_Player:AddComponent(RankListItem, itemObj)
    cellItem:SetPlayerShow(self.rankPlayerList[index])
end
function UIColonizeWarRank:OnRankPlayerMoveOut(itemObj, index)
    self.scrollView_Player:RemoveComponent(itemObj.name, RankListItem)
end

--地块等级积分
function UIColonizeWarRank:OnDesertMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scrollView_Desert:AddComponent(DesertScoreCell, itemObj)
    cellItem:SetScoreShow(self.scoreList[index],index)
end
function UIColonizeWarRank:OnDesertMoveOut(itemObj, index)
    self.scrollView_Desert:RemoveComponent(itemObj.name, DesertScoreCell)
end

function UIColonizeWarRank:ClearScroll()
    self.scrollView_Alliance:ClearCells()
    self.scrollView_Alliance:RemoveComponents(RankListItem)
    self.scrollView_Player:ClearCells()
    self.scrollView_Player:RemoveComponents(RankListItem)
end

--活动标题
function UIColonizeWarRank:RefreshTitle(actListData)
    self._actName_txt:SetLocalText(actListData.name)
    --self._desc_txt:SetLocalText(actListData.desc_info)
    local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(actListData.startTime)
    local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(actListData.endTime)
    self._time_txt:SetText(startT .. "-" .. endT)
    
    self._country_txt:SetLocalText(143589)
    self._desertDesc_txt:SetLocalText(302042)
end

function UIColonizeWarRank:OnIntroClick()
    UIUtil.ShowIntro(Localization:GetString(self.actListData.name), Localization:GetString("100239"),Localization:GetString(self.actListData.story))
end

return UIColonizeWarRank