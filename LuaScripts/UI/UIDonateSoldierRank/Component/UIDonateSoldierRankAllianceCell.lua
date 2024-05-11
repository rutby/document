---
--- 黑骑士排行榜联盟排行cell
--- Created by shimin.
--- DateTime: 2023/3/7 14:16
---
local UIDonateSoldierRankAllianceCell = BaseClass("UIDonateSoldierRankAllianceCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local player_name_text_path = "mainContent/nameTxt"
local score_text_path = "mainContent/powerTxt"
local rank_img_path = "mainContent/rankImg"
local rank_text_path = "mainContent/rankNumTxt"
local content_path = "mainContent/Content"
local alliance_flag_path = "mainContent/AllianceFlag"
local ResetResItemScale = Vector3.New(0.47,0.47,0.47)

function UIDonateSoldierRankAllianceCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIDonateSoldierRankAllianceCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRankAllianceCell:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRankAllianceCell:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRankAllianceCell:ComponentDefine()
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.rank_num_text = self:AddComponent(UIText, rank_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.alliance_flag = self:AddComponent(AllianceFlagItem, alliance_flag_path)
end

function UIDonateSoldierRankAllianceCell:ComponentDestroy()

end

function UIDonateSoldierRankAllianceCell:DataDefine()
    self.cells = {}
    self.param = {}
end

function UIDonateSoldierRankAllianceCell:DataDestroy()
    self:SetAllNeedCellDestroy()
    self.cells = {}
    self.param = {}
end

function UIDonateSoldierRankAllianceCell:OnAddListener()
    base.OnAddListener(self)
end

function UIDonateSoldierRankAllianceCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDonateSoldierRankAllianceCell:ReInit(param)
    self.param = param
    self.player_name_text:SetText("[" .. self.param.abbr .. "]" .. self.param.allianceName)
    self.alliance_flag:SetData(self.param.icon)
    self.score_text:SetText(string.GetFormattedSeperatorNum(self.param.score))
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
    self:ShowReward()
end

function UIDonateSoldierRankAllianceCell:ShowReward()
    self:SetAllNeedCellDestroy()
    local info = DataCenter.ActBlackKnightManager:GetAllianceRewardByRank(self.param.rank)
    if info ~= nil and info.reward ~= nil then
        for k,v in ipairs(info.reward) do
            self.cells[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetResItemScale.x, ResetResItemScale.y, ResetResItemScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.content:AddComponent(UICommonItem, nameStr)
                cell:ReInit(v)
            end)
        end
    end
end

function UIDonateSoldierRankAllianceCell:SetAllNeedCellDestroy()
    self.content:RemoveComponents(UICommonItem)
    for k,v in pairs(self.cells) do
        if v ~= nil then
            self:GameObjectDestroy(v)
        end
    end
    self.cells = {}
end

return UIDonateSoldierRankAllianceCell