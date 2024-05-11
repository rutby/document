---
--- 黑骑士排行榜个人排行cell
--- Created by shimin.
--- DateTime: 2023/3/7 14:16
---
local UIDonateSoldierRankPersonalCell = BaseClass("UIDonateSoldierRankPersonalCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local player_name_text_path = "mainContent/nameTxt"
local score_text_path = "mainContent/powerTxt"
local rank_img_path = "mainContent/rankImg"
local rank_text_path = "mainContent/rankNumTxt"
local content_path = "mainContent/Content"
local player_head_btn_path = "mainContent/HeadGo/UIPlayerHead"
local player_head_icon_path = "mainContent/HeadGo/UIPlayerHead/HeadIcon"
local player_head_frame_path = "mainContent/HeadGo/UIPlayerHead/Foreground"

local ResetResItemScale = Vector3.New(0.47,0.47,0.47)

function UIDonateSoldierRankPersonalCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIDonateSoldierRankPersonalCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDonateSoldierRankPersonalCell:OnEnable()
    base.OnEnable(self)
end

function UIDonateSoldierRankPersonalCell:OnDisable()
    base.OnDisable(self)
end

function UIDonateSoldierRankPersonalCell:ComponentDefine()
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.rank_num_text = self:AddComponent(UIText, rank_text_path)
    self.rank_img = self:AddComponent(UIImage, rank_img_path)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
end

function UIDonateSoldierRankPersonalCell:ComponentDestroy()

end

function UIDonateSoldierRankPersonalCell:DataDefine()
    self.cells = {}
    self.param = {}
end

function UIDonateSoldierRankPersonalCell:DataDestroy()
    self:SetAllNeedCellDestroy()
    self.cells = {}
    self.param = {}
end

function UIDonateSoldierRankPersonalCell:OnAddListener()
    base.OnAddListener(self)
end

function UIDonateSoldierRankPersonalCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDonateSoldierRankPersonalCell:ReInit(param)
    self.param = param
    self.player_head_icon:SetData(self.param.uid, self.param.pic, self.param.picVer)
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.param.headSkinId, self.param.headSkinET)
    if headBgImg ~= nil then
        self.player_head_frame:SetActive(true)
        self.player_head_frame:LoadSprite(headBgImg)
    else
        self.player_head_frame:SetActive(false)
    end
    if self.param.abbr ~= nil and self.param.abbr ~= "" then
        self.player_name_text:SetText("[" .. self.param.abbr .. "]" .. self.param.name)
    else
        self.player_name_text:SetText(self.param.name)
    end
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
    -- self:ShowReward()
end

function UIDonateSoldierRankPersonalCell:ShowReward()
    self:SetAllNeedCellDestroy()
    local info = DataCenter.ActBlackKnightManager:GetUserRewardByRank(self.param.rank)
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

function UIDonateSoldierRankPersonalCell:SetAllNeedCellDestroy()
    self.content:RemoveComponents(UICommonItem)
    for k,v in pairs(self.cells) do
        if v ~= nil then
            self:GameObjectDestroy(v)
        end
    end
    self.cells = {}
end

function UIDonateSoldierRankPersonalCell:OnClickPlayerHead()
    if self.param.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, self.param.uid)
    end
end


return UIDonateSoldierRankPersonalCell