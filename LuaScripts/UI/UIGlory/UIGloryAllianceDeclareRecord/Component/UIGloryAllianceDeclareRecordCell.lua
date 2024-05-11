---
--- 荣耀之战宣战记录
--- Created by shimin.
--- DateTime: 2023/3/2 17:33
---
local UIGloryAllianceDeclareRecordCell = BaseClass("UIGloryAllianceDeclareRecordCell", UIBaseContainer)
local base = UIBaseContainer
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local left_alliance_name_text_path = "LeftAllianceName"
local left_alliance_flag_path = "LeftAllianceFlag"
local left_alliance_score_text_path = "LeftScoreText"
local left_alliance_direct_lose_text_path = "LeftDirectLoseText"
local left_alliance_win_text_path = "LeftWinText"
local left_alliance_lose_text_path = "LeftLoseText"
local left_alliance_change_score_text_path = "LeftChangeScoreText"
local left_alliance_change_rank_text_path = "LeftChangeRankText"

local this_path = ""
local time_text_path = "TimeText"

local right_alliance_name_text_path = "RightAllianceName"
local right_alliance_flag_path = "RightAllianceFlag"
local right_alliance_score_text_path = "RightScoreText"
local right_alliance_change_score_text_path = "RightChangeScoreText"
local right_alliance_change_rank_text_path = "RightChangeRankText"
local right_alliance_win_text_path = "RightWinText"
local right_alliance_direct_lose_text_path = "RightDirectLoseText"

function UIGloryAllianceDeclareRecordCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIGloryAllianceDeclareRecordCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryAllianceDeclareRecordCell:OnEnable()
    base.OnEnable(self)
end

function UIGloryAllianceDeclareRecordCell:OnDisable()
    base.OnDisable(self)
end

function UIGloryAllianceDeclareRecordCell:ComponentDefine()
    self.left_alliance_name_text = self:AddComponent(UIText, left_alliance_name_text_path)
    self.left_alliance_flag = self:AddComponent(AllianceFlagItem, left_alliance_flag_path)
    self.left_alliance_score_text = self:AddComponent(UIText, left_alliance_score_text_path)
    self.left_alliance_direct_lose_text = self:AddComponent(UIText, left_alliance_direct_lose_text_path)
    self.left_alliance_win_text = self:AddComponent(UIText, left_alliance_win_text_path)
    self.left_alliance_lose_text = self:AddComponent(UIText, left_alliance_lose_text_path)
    self.left_alliance_change_score_text = self:AddComponent(UIText, left_alliance_change_score_text_path)
    self.left_alliance_change_rank_text = self:AddComponent(UIText, left_alliance_change_rank_text_path)
    self.bg_icon = self:AddComponent(UIImage, this_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.right_alliance_name_text = self:AddComponent(UIText, right_alliance_name_text_path)
    self.right_alliance_flag = self:AddComponent(AllianceFlagItem, right_alliance_flag_path)
    self.right_alliance_score_text = self:AddComponent(UIText, right_alliance_score_text_path)
    self.right_alliance_change_score_text = self:AddComponent(UIText, right_alliance_change_score_text_path)
    self.right_alliance_change_rank_text = self:AddComponent(UIText, right_alliance_change_rank_text_path)
    self.right_alliance_win_text = self:AddComponent(UIText, right_alliance_win_text_path)
    self.right_alliance_direct_lose_text = self:AddComponent(UIText, right_alliance_direct_lose_text_path)
    self.detail_btn = self:AddComponent(UIButton, this_path)
    self.detail_btn:SetOnClick(function()
        self:OnDetailBtnClick()
    end)
end

function UIGloryAllianceDeclareRecordCell:ComponentDestroy()

end

function UIGloryAllianceDeclareRecordCell:DataDefine()
    self.param = {}
end

function UIGloryAllianceDeclareRecordCell:DataDestroy()
    self.param = {}
end

function UIGloryAllianceDeclareRecordCell:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryAllianceDeclareRecordCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryAllianceDeclareRecordCell:ReInit(param, declareRecordType)
    self.param = param
    self.declareRecordType = declareRecordType
    self.time_text:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(self.param.t))
    if self.declareRecordType == DeclareRecordType.Alliance then
        self:RefreshAllianceCell()
    else
        self:RefreshSeverZoneCell()
    end
end

function UIGloryAllianceDeclareRecordCell:OnDetailBtnClick()
    local showTabs = { GloryInfoTab.RankHistory, GloryInfoTab.SummaryHistory }
    local historyData = self.param
    local leftData = historyData:GetLeftData()
    local rightData = historyData:GetRightData()
    local param =
    {
        historyData = historyData,
        leftAllianceId = leftData.allianceId,
        rightAllianceId = rightData.allianceId,
        readyTime = historyData.readyTime,
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryInfo, { anim = true }, showTabs, param)
end

function UIGloryAllianceDeclareRecordCell:RefreshAllianceCell()
    --自己联盟在左边，结果在左边
    self.bg_icon:LoadSprite(string.format(LoadPath.UIGlory, "glorylianmeng_board"))
    local myAllianceUid = LuaEntry.Player.allianceId
    if self.param.vsDataList ~= nil then
        for k,v in ipairs(self.param.vsDataList) do
            if v.allianceId == myAllianceUid then
                --左边
                self.left_alliance_name_text:SetText("#" .. v.serverId .. " [" .. v.abbr .. "]" .. v.alName)
                self.left_alliance_flag:SetData(v.alIcon)
                self.left_alliance_change_rank_text:SetActive(true)
                self.left_alliance_change_score_text:SetActive(true)
                if v.isWin == GloryDeclareRecordWinType.Win then
                    self.left_alliance_change_rank_text:SetText("+" .. v.changeRank)
                    self.left_alliance_change_score_text:SetText("+" .. self.param.seasonChangeScore)
                    self.left_alliance_change_rank_text:SetColor(GreenColor)
                    self.left_alliance_change_score_text:SetColor(GreenColor)
                    self.left_alliance_win_text:SetActive(true)
                    self.left_alliance_win_text:SetLocalText(GameDialogDefine.WIN)
                    self.left_alliance_lose_text:SetActive(false)
                    self.left_alliance_direct_lose_text:SetActive(false)
                    self.left_alliance_score_text:SetActive(true)
                    self.left_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                else
                    self.left_alliance_change_rank_text:SetText("-" .. v.changeRank)
                    self.left_alliance_change_score_text:SetText("-" .. self.param.seasonChangeScore)
                    self.left_alliance_change_rank_text:SetColor(RedColor)
                    self.left_alliance_change_score_text:SetColor(RedColor)
                    if self.param:IsKo() then
                        self.left_alliance_win_text:SetActive(false)
                        self.left_alliance_lose_text:SetActive(false)
                        self.left_alliance_direct_lose_text:SetActive(true)
                        self.left_alliance_direct_lose_text:SetLocalText(GameDialogDefine.DIRECT_LOSE)
                        self.left_alliance_score_text:SetActive(false)
                    else
                        self.left_alliance_win_text:SetActive(false)
                        self.left_alliance_lose_text:SetActive(true)
                        self.left_alliance_lose_text:SetLocalText(GameDialogDefine.FAIL)
                        self.left_alliance_direct_lose_text:SetActive(false)
                        self.left_alliance_score_text:SetActive(true)
                        self.left_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                    end
                end
            else
                --右边
                self.right_alliance_change_rank_text:SetActive(false)
                self.right_alliance_change_score_text:SetActive(false)
                self.right_alliance_win_text:SetActive(false)
                self.right_alliance_name_text:SetText("#" .. v.serverId .. " [" .. v.abbr .. "]" .. v.alName)
                self.right_alliance_flag:SetData(v.alIcon)
                self.right_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                if v.isWin == GloryDeclareRecordWinType.Lose and self.param:IsKo() then
                    self.right_alliance_direct_lose_text:SetActive(true)
                    self.right_alliance_direct_lose_text:SetLocalText(GameDialogDefine.DIRECT_LOSE)
                    self.right_alliance_score_text:SetActive(false)
                else
                    self.right_alliance_direct_lose_text:SetActive(false)
                    self.right_alliance_score_text:SetActive(true)
                    self.right_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                end
            end
        end
    end
end

function UIGloryAllianceDeclareRecordCell:RefreshSeverZoneCell()
    --只有胜利和绿色增加积分
    self.bg_icon:LoadSprite(string.format(LoadPath.UIGlory, "glorylianmeng_otherboard"))
    if self.param.vsDataList ~= nil then
        for k,v in ipairs(self.param.vsDataList) do
            if v.isAtk == GloryDeclareRecordAtkType.Attack then
                --左边
                self.left_alliance_name_text:SetText("#" .. v.serverId .. " [" .. v.abbr .. "]" .. v.alName)
                self.left_alliance_flag:SetData(v.alIcon)
                if v.isWin == GloryDeclareRecordWinType.Win then
                    self.left_alliance_change_rank_text:SetActive(true)
                    self.left_alliance_change_score_text:SetActive(true)
                    self.left_alliance_change_rank_text:SetText("+" .. v.changeRank)
                    self.left_alliance_change_score_text:SetText("+" .. self.param.seasonChangeScore)
                    self.left_alliance_change_rank_text:SetColor(GreenColor)
                    self.left_alliance_change_score_text:SetColor(GreenColor)
                    self.left_alliance_win_text:SetActive(true)
                    self.left_alliance_win_text:SetLocalText(GameDialogDefine.WIN)
                    self.left_alliance_lose_text:SetActive(false)
                    self.left_alliance_direct_lose_text:SetActive(false)
                    self.left_alliance_score_text:SetActive(true)
                    self.left_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                else
                    self.left_alliance_change_rank_text:SetActive(false)
                    self.left_alliance_change_score_text:SetActive(false)
                    self.left_alliance_win_text:SetActive(false)
                    self.left_alliance_lose_text:SetActive(false)
                    if self.param:IsKo() then
                        self.left_alliance_direct_lose_text:SetActive(true)
                        self.left_alliance_direct_lose_text:SetLocalText(GameDialogDefine.DIRECT_LOSE)
                        self.left_alliance_score_text:SetActive(false)
                    else
                        self.left_alliance_direct_lose_text:SetActive(false)
                        self.left_alliance_score_text:SetActive(true)
                        self.left_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                    end
                end
            else
                --右边
                self.right_alliance_name_text:SetText("#" .. v.serverId .. " [" .. v.abbr .. "]" .. v.alName)
                self.right_alliance_flag:SetData(v.alIcon)
                if v.isWin == GloryDeclareRecordWinType.Win then
                    self.right_alliance_change_rank_text:SetActive(true)
                    self.right_alliance_change_score_text:SetActive(true)
                    self.right_alliance_change_rank_text:SetText("+" .. v.changeRank)
                    self.right_alliance_change_score_text:SetText("+" .. self.param.seasonChangeScore)
                    self.right_alliance_change_rank_text:SetColor(GreenColor)
                    self.right_alliance_change_score_text:SetColor(GreenColor)
                    self.right_alliance_win_text:SetActive(true)
                    self.right_alliance_win_text:SetLocalText(GameDialogDefine.WIN)
                    self.right_alliance_direct_lose_text:SetActive(false)
                    self.right_alliance_score_text:SetActive(true)
                    self.right_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                else
                    self.right_alliance_change_rank_text:SetActive(false)
                    self.right_alliance_change_score_text:SetActive(false)
                    self.right_alliance_win_text:SetActive(false)
                    if self.param:IsKo() then
                        self.right_alliance_direct_lose_text:SetActive(true)
                        self.right_alliance_direct_lose_text:SetLocalText(GameDialogDefine.DIRECT_LOSE)
                        self.right_alliance_score_text:SetActive(false)
                    else
                        self.right_alliance_direct_lose_text:SetActive(false)
                        self.right_alliance_score_text:SetActive(true)
                        self.right_alliance_score_text:SetText(string.GetFormattedSeperatorNum(v.alScore))
                    end
                end
            end
        end
    end
end

return UIGloryAllianceDeclareRecordCell