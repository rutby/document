---
--- 荣耀之战联盟情报cell
--- Created by shimin.
--- DateTime: 2023/3/1 15:30
---
local UIGloryAllianceIntelligenceCell = BaseClass("UIGloryAllianceIntelligenceCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local player_name_text_path = "firstNameTxt"
local power_text_path = "secondNameTxt"
local score_text_path = "scoreTxt"
local rank_img_path = "rankIcon"
local rank_num_text_path = "numTxt"
local player_head_btn_path = "UIPlayerHead"
local player_head_icon_path = "UIPlayerHead/HeadIcon"
local player_head_frame_path = "UIPlayerHead/Foreground"
local sex_img_path = "sexImg"

function UIGloryAllianceIntelligenceCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIGloryAllianceIntelligenceCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryAllianceIntelligenceCell:OnEnable()
    base.OnEnable(self)
end

function UIGloryAllianceIntelligenceCell:OnDisable()
    base.OnDisable(self)
end

function UIGloryAllianceIntelligenceCell:ComponentDefine()
    self.detail_btn = self:AddComponent(UIButton, this_path)
    self.detail_btn:SetOnClick(function()
        self:OnDetailBtnClick()
    end)
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.power_text = self:AddComponent(UIText, power_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.rank_num_text = self:AddComponent(UIText, rank_num_text_path)
    self.sex_img = self:AddComponent(UIImage, sex_img_path)

    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
end

function UIGloryAllianceIntelligenceCell:ComponentDestroy()

end

function UIGloryAllianceIntelligenceCell:DataDefine()
    self.param = {}
end

function UIGloryAllianceIntelligenceCell:DataDestroy()
    self.param = {}
end

function UIGloryAllianceIntelligenceCell:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryAllianceIntelligenceCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryAllianceIntelligenceCell:ReInit(param)
    self.param = param
    local contribution = self.param.contribution
    if contribution ~= nil then
        self.player_name_text:SetText(contribution.name)
        self.player_head_icon:SetData(contribution.uid, contribution.pic, contribution.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(contribution.headSkinId, contribution.headSkinET)
        if headBgImg ~= nil then
            self.player_head_frame:SetActive(true)
            self.player_head_frame:LoadSprite(headBgImg)
        else
            self.player_head_frame:SetActive(false)
        end
        self.score_text:SetText(string.GetFormattedSeperatorNum(contribution.score))
        self.sex_img:LoadSprite(SexUtil.GetSexIconName(contribution.sex))
        self.power_text:SetText(string.GetFormattedSeperatorNum(contribution.power))
    end
    local iconName, showName = CommonUtil.GetRankImgAndShowText(self.param.rank)
    if iconName ~= nil then
        self.rank_img:SetActive(true)
        self.rank_num_text:SetActive(false)
        self.rank_img:LoadSprite(iconName)
    else
        self.rank_img:SetActive(false)
        self.rank_num_text:SetActive(true)
        self.rank_num_text:SetText(showName)
    end
end

function UIGloryAllianceIntelligenceCell:OnDetailBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGloryPersonScore,{ anim = true}, self.param.contribution.uid, self.param.contribution, self.param.rank)
end
 
function UIGloryAllianceIntelligenceCell:OnClickPlayerHead()
    if self.param.contribution.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, self.param.contribution.uid)
    end
end


return UIGloryAllianceIntelligenceCell