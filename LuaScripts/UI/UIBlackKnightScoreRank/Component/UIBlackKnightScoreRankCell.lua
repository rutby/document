---
--- 黑骑士排行榜个人排行cell
--- Created by shimin.
--- DateTime: 2024/2/23 14:16
---
local UIBlackKnightScoreRankCell = BaseClass("UIBlackKnightScoreRankCell", UIBaseContainer)
local base = UIBaseContainer
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local player_name_text_path = "mainContent/nameTxt"
local score_text_path = "mainContent/powerTxt"
local rank_img_path = "mainContent/rankImg"
local rank_text_path = "mainContent/rankNumTxt"
local player_head_btn_path = "mainContent/UIPlayerHead"
local player_head_icon_path = "mainContent/UIPlayerHead/HeadIcon"
local player_head_frame_path = "mainContent/UIPlayerHead/Foreground"
local alliance_go_path = "mainContent/AllianceFlag"
local rank_bg_path = "Common_supple"

function UIBlackKnightScoreRankCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIBlackKnightScoreRankCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightScoreRankCell:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightScoreRankCell:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightScoreRankCell:ComponentDefine()
    self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
    self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
    self.rank_num_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
    self.alliance_go = self:AddComponent(AllianceFlagItem, alliance_go_path)
    self.rank_bg = self:AddComponent(UIImage, rank_bg_path)
end

function UIBlackKnightScoreRankCell:ComponentDestroy()

end

function UIBlackKnightScoreRankCell:DataDefine()
    self.param = {}
end

function UIBlackKnightScoreRankCell:DataDestroy()
    self.param = {}
end

function UIBlackKnightScoreRankCell:OnAddListener()
    base.OnAddListener(self)
end

function UIBlackKnightScoreRankCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIBlackKnightScoreRankCell:ReInit(param)
    self.param = param
    if self.param.rankType == UIBlackKnightRankType.PersonalRank then
        self.player_head_btn:SetActive(true)
        self.alliance_go:SetActive(false)

        self.player_head_icon:SetData(self.param.data.uid, self.param.data.pic, self.param.data.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.param.data.headSkinId, self.param.data.headSkinET)
        if headBgImg ~= nil then
            self.player_head_frame:SetActive(true)
            self.player_head_frame:LoadSprite(headBgImg)
        else
            self.player_head_frame:SetActive(false)
        end
        if self.param.data.abbr ~= nil and self.param.data.abbr ~= "" then
            self.player_name_text:SetText("[" .. self.param.data.abbr .. "]" .. self.param.data.name)
        else
            self.player_name_text:SetText(self.param.data.name)
        end
    elseif self.param.rankType == UIBlackKnightRankType.AllianceRank then
        self.player_head_btn:SetActive(false)
        self.alliance_go:SetActive(true)
        self.player_name_text:SetText("[" .. self.param.data.abbr .. "]" .. self.param.data.allianceName)
        self.alliance_go:SetData(self.param.data.icon)
    end
    
    self.score_text:SetText(string.GetFormattedSeperatorNum(self.param.data.score))
    local iconName, showName, bgName = CommonUtil.GetRankImgAndShowText(self.param.data.rank)
    if iconName ~= nil then
        self.rank_img:SetActive(true)
        self.rank_num_text:SetActive(false)
        self.rank_img:LoadSprite(iconName)
    else
        self.rank_img:SetActive(false)
        self.rank_num_text:SetActive(true)
        self.rank_num_text:SetText(showName)
    end
    if bgName ~= nil and (not self.param.noUseBg) then
        self.rank_bg:LoadSprite(bgName)
    end
end

function UIBlackKnightScoreRankCell:OnClickPlayerHead()
    if self.param.data.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true}, self.param.data.uid)
    end
end

return UIBlackKnightScoreRankCell