---
--- 黑骑士排行榜积分奖励cell
--- Created by shimin.
--- DateTime: 2023/3/7 14:16
---
local UIBlackKnightRankScoreRewardCell = BaseClass("UIBlackKnightRankScoreRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local Localization = CS.GameEntry.Localization

local personal_score_value_text_path = "mainContent/Slider_Personal/personal_score_value_text"
local alliance_score_value_text_path = "mainContent/Slider_Alliance/alliance_score_value_text"
local reward_scroll_view_path = "mainContent/reward_scroll_view"
local rank_name_text_path_path = "mainContent/rankTxt"
local personal_score_slider_path = "mainContent/Slider_Personal"
local alliance_score_slider_path = "mainContent/Slider_Alliance"
local text_bg_path = "Common_supple"
local title_bg_path = "Common_supple/Common_supple1"

local TitleColor =
{
    No = Color.New(0.9098039, 0.8470588, 0.7529412, 1),
    Reach = Color.New(0.9294118, 0.7686275, 0.4588236, 1),
}

local TextColor =
{
    No = Color.New(0.9098039, 0.8784314, 0.8196079, 1),
    Reach = Color.New(0.9411765, 0.8000001, 0.5294118, 1),
}

function UIBlackKnightRankScoreRewardCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIBlackKnightRankScoreRewardCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBlackKnightRankScoreRewardCell:OnEnable()
    base.OnEnable(self)
end

function UIBlackKnightRankScoreRewardCell:OnDisable()
    base.OnDisable(self)
end

function UIBlackKnightRankScoreRewardCell:ComponentDefine()
    self.personal_score_value_text = self:AddComponent(UITextMeshProUGUIEx, personal_score_value_text_path)
    self.alliance_score_value_text = self:AddComponent(UITextMeshProUGUIEx, alliance_score_value_text_path)
    self.rank_name_text_path = self:AddComponent(UITextMeshProUGUIEx, rank_name_text_path_path)
    self.scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.personal_score_slider = self:AddComponent(UISlider, personal_score_slider_path)
    self.alliance_score_slider = self:AddComponent(UISlider, alliance_score_slider_path)
    self.title_bg = self:AddComponent(UIImage, title_bg_path)
    self.text_bg = self:AddComponent(UIImage, text_bg_path)
end

function UIBlackKnightRankScoreRewardCell:ComponentDestroy()

end

function UIBlackKnightRankScoreRewardCell:DataDefine()
    self.param = {}
    self.list = {}
end

function UIBlackKnightRankScoreRewardCell:DataDestroy()
    self.param = {}
    self.list = {}
end

function UIBlackKnightRankScoreRewardCell:OnAddListener()
    base.OnAddListener(self)
end

function UIBlackKnightRankScoreRewardCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIBlackKnightRankScoreRewardCell:ReInit(param)
    self.param = param
    self.rank_name_text_path:SetText(Localization:GetString(GameDialogDefine.LEVEL_NUMBER, tostring(self.param.rank + 1)) 
            .. " " .. Localization:GetString(GameDialogDefine.REWARD))
    self:Refresh()
    self:ShowCells()
end

function UIBlackKnightRankScoreRewardCell:Refresh()
    local info = DataCenter.ActBlackKnightManager:GetActInfo()
    if info ~= nil then
        local reach = true
        if info.userKill >= self.param.memberKill then
            self.personal_score_value_text:SetText(string.format(TextColorStr, TextColorGreen, string.GetFormattedSeperatorNum(info.userKill))  
                    .. "/" .. string.GetFormattedSeperatorNum(self.param.memberKill))
            self.personal_score_slider:SetValue(1)
        else
            self.personal_score_value_text:SetText(string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(info.userKill))
                    .. "/" .. string.GetFormattedSeperatorNum(self.param.memberKill))
            self.personal_score_slider:SetValue((info.userKill / self.param.memberKill))
            reach = false
        end

        if info.allKill >= self.param.allianceKill then
            self.alliance_score_value_text:SetText(string.format(TextColorStr, TextColorGreen, string.GetFormattedSeperatorNum(info.allKill))
                    .. "/" .. string.GetFormattedSeperatorNum(self.param.allianceKill))
            self.alliance_score_slider:SetValue(1)
        else
            self.alliance_score_value_text:SetText(string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(info.allKill))
                    .. "/" .. string.GetFormattedSeperatorNum(self.param.allianceKill))
            self.alliance_score_slider:SetValue((info.allKill / self.param.allianceKill))
            reach = false
        end
        if reach then
            self.title_bg:SetColor(TitleColor.Reach)
            self.text_bg:SetColor(TextColor.Reach)
        else
            self.title_bg:SetColor(TitleColor.No)
            self.text_bg:SetColor(TextColor.No)
        end
    end
end

function UIBlackKnightRankScoreRewardCell:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIBlackKnightRankScoreRewardCell:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIBlackKnightRankScoreRewardCell:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonItem, itemObj)
    item:ReInit(self.list[index])
end

function UIBlackKnightRankScoreRewardCell:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIBlackKnightRankScoreRewardCell:GetDataList()
    self.list = self.param.reward
end

return UIBlackKnightRankScoreRewardCell