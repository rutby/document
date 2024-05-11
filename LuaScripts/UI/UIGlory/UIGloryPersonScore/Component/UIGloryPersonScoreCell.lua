---
--- 荣耀之战个人积分详情cell
--- Created by shimin.
--- DateTime: 2023/3/2 10:51
---
local UIGloryPersonScoreCell = BaseClass("UIGloryPersonScoreCell", UIBaseContainer)
local base = UIBaseContainer

local attribute_text_path = "Desc"
local score_text_path = "Right"

function UIGloryPersonScoreCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIGloryPersonScoreCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryPersonScoreCell:OnEnable()
    base.OnEnable(self)
end

function UIGloryPersonScoreCell:OnDisable()
    base.OnDisable(self)
end

function UIGloryPersonScoreCell:ComponentDefine()
    self.attribute_text = self:AddComponent(UIText, attribute_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
end

function UIGloryPersonScoreCell:ComponentDestroy()

end

function UIGloryPersonScoreCell:DataDefine()
    self.param = {}
end

function UIGloryPersonScoreCell:DataDestroy()
    self.param = {}
end

function UIGloryPersonScoreCell:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryPersonScoreCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryPersonScoreCell:ReInit(param)
    self.param = param
    if self.param.contributionType == GloryContributionType.OCCUPY_DESERT then
        self.attribute_text:SetLocalText(GameDialogDefine.GLORY_SCORE_OCCUPY_DESERT)
    elseif self.param.contributionType == GloryContributionType.SEASON_BUILDING then
        self.attribute_text:SetLocalText(GameDialogDefine.GLORY_SCORE_SEASON_BUILDING)
    elseif self.param.contributionType == GloryContributionType.DONATE_ALLIANCE_STORE then
        self.attribute_text:SetLocalText(GameDialogDefine.GLORY_SCORE_DONATE_ALLIANCE_STORE)
    elseif self.param.contributionType == GloryContributionType.DECLARE_SCORE then
        self.attribute_text:SetLocalText(GameDialogDefine.GLORY_SCORE_DECLARE_SCORE)
    elseif self.param.contributionType == GloryContributionType.OCCUPY_ENEMY_DESERT then
        self.attribute_text:SetLocalText(GameDialogDefine.GLORY_SCORE_OCCUPY_ENEMY_DESERT)
    end
    
    self.score_text:SetText(string.GetFormattedSeperatorNum(math.floor(self.param.score)))
end

return UIGloryPersonScoreCell