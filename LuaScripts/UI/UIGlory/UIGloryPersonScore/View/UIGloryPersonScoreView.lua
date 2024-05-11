---
--- 荣耀之战个人积分详情
--- Created by shimin.
--- DateTime: 2023/3/2 10:51
---

local UIGloryPersonScoreView = BaseClass("UIGloryPersonScoreView", UIBaseView)
local base = UIBaseView
local UIGloryPersonScoreCell = require "UI.UIGlory.UIGloryPersonScore.Component.UIGloryPersonScoreCell"

--排序
local GloryContributionTypeSort = 
{
    GloryContributionType.OCCUPY_DESERT, GloryContributionType.SEASON_BUILDING,GloryContributionType.DONATE_ALLIANCE_STORE,
    GloryContributionType.DECLARE_SCORE, GloryContributionType.OCCUPY_ENEMY_DESERT,
}

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"

local player_name_text_path = "PersonGo/player_name_text"
local power_text_path = "PersonGo/power_text"
local score_text_path = "PersonGo/score_text"
local score_value_text_path = "PersonGo/score_value_text"
local rank_img_path = "PersonGo/rank_icon"
local rank_num_text_path = "PersonGo/rank_value_text"
local player_head_btn_path = "PersonGo/UIPlayerHead"
local player_head_icon_path = "PersonGo/UIPlayerHead/HeadIcon"
local player_head_frame_path = "PersonGo/UIPlayerHead/Foreground"
local sex_img_path = "PersonGo/sex_icon"
local attribute_1_text_path = "attribute_bg/attribute_1_text"
local attribute_2_text_path = "attribute_bg/attribute_2_text"
local scroll_view_path = "ScrollView"

function UIGloryPersonScoreView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryPersonScoreView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryPersonScoreView:OnEnable()
    base.OnEnable(self)
end

function UIGloryPersonScoreView:OnDisable()
    base.OnDisable(self)
end

function UIGloryPersonScoreView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.power_text = self:AddComponent(UIText, power_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.score_value_text = self:AddComponent(UIText, score_value_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.rank_num_text = self:AddComponent(UIText, rank_num_text_path)
    self.sex_img = self:AddComponent(UIImage, sex_img_path)

    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
    self.attribute_1_text = self:AddComponent(UIText, attribute_1_text_path)
    self.attribute_2_text = self:AddComponent(UIText, attribute_2_text_path)
end

function UIGloryPersonScoreView:ComponentDestroy()
  
end

function UIGloryPersonScoreView:DataDefine()
    self.list = {}
end

function UIGloryPersonScoreView:DataDestroy()
    self.list = {}
end

function UIGloryPersonScoreView:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryPersonScoreView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryPersonScoreView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.PERSON_CONTRIBUTE)
    local uid, contributionData, rank  = self:GetUserData()
    if contributionData == nil then
        contributionData = DataCenter.GloryManager:GetContributionByUid(uid)
    end
    self.contributionData = contributionData
    if contributionData ~= nil then
        self.player_name_text:SetText(contributionData.name)
        self.player_head_icon:SetData(contributionData.uid, contributionData.pic, contributionData.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(contributionData.headSkinId, contributionData.headSkinET)
        if headBgImg ~= nil then
            self.player_head_frame:SetActive(true)
            self.player_head_frame:LoadSprite(headBgImg)
        else
            self.player_head_frame:SetActive(false)
        end
        self.score_value_text:SetText(string.GetFormattedSeperatorNum(contributionData.score))
        self.sex_img:LoadSprite(SexUtil.GetSexIconName(contributionData.sex))
        self.power_text:SetText(string.GetFormattedSeperatorNum(contributionData.power))

        local iconName, showName = CommonUtil.GetRankImgAndShowText(rank)
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
    self.score_text:SetLocalText(GameDialogDefine.SCORE)
    self.attribute_1_text:SetLocalText(GameDialogDefine.TYPE)
    self.attribute_2_text:SetLocalText(GameDialogDefine.CONTRIBUTE)
    self:ShowCells()
end

function UIGloryPersonScoreView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIGloryPersonScoreView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIGloryPersonScoreCell)--清循环列表gameObject
end

function UIGloryPersonScoreView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryPersonScoreCell, itemObj)
    item:ReInit(self.list[index])
end

function UIGloryPersonScoreView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryPersonScoreCell)
end

function UIGloryPersonScoreView:GetDataList()
    self.list = {}
    for k,v in ipairs(GloryContributionTypeSort) do
        local param = {}
        param.contributionType = v
        param.score = self.contributionData ~= nil and self.contributionData:GetScoreByContributionType(v) or 0
        table.insert(self.list, param)
    end
end



return UIGloryPersonScoreView