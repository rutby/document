---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/12/30 16:38
---
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local SeasonRewardStampItem = BaseClass("SeasonRewardStampItem", UIBaseContainer)
local base = UIBaseContainer

local TextColor =
{
    competition_icon_dominate1 = Color.New(1, 0.9254903, 0.7058824, 1),
    competition_icon_explore1 = Color.New(0.4588236, 0.8980393, 0.9686275, 1),
    competition_icon_conquer1 = Color.New(0.937255, 0.5058824, 0.7058824, 1),
}

local this_path = ""
local stamp_text_path = "stamp_text"
local stamp_item_des_path = "Text_stamp"

-- 创建
function SeasonRewardStampItem:OnCreate()
    base.OnCreate(self)
    self.stampImg = self:AddComponent(UIImage, this_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
    self.stamp_item_des = self:AddComponent(UIText, stamp_item_des_path)
    self.stamp_text = self:AddComponent(UIText, stamp_text_path)
end

-- 销毁
function SeasonRewardStampItem:OnDestroy()
    base.OnDestroy(self)
end

-- 显示
function SeasonRewardStampItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function SeasonRewardStampItem:OnDisable()
    base.OnDisable(self)
end
function SeasonRewardStampItem:InitData(itemId, pic, des, icon_value)
    self.itemId = itemId
    self.stamp_item_des:SetText(des)
    self.stampImg:LoadSprite(string.format(LoadPath.UISeasonRobots, pic))
    if icon_value ==nil or icon_value == "" then
        self.stamp_text:SetActive(false)
    else
        self.stamp_text:SetActive(true)
        self.stamp_text:SetText(icon_value)
        local color = TextColor[pic]
        if color ~= nil then
            self.stamp_text:SetColor(color)
        end
    end
end

function SeasonRewardStampItem:OnClick()
    if self.itemId~=nil then
        if self.view.noShowViewList~=nil and self.view.noShowViewList[tonumber(self.itemId)]~=nil then
            local desc = DataCenter.RewardManager:GetDescByType(RewardType.GOODS, self.itemId)
            local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.itemId)
            local scaleFactor = UIManager:GetInstance():GetScaleFactor()
            local position = self.stampImg.gameObject.transform.position + Vector3.New(0, -50, 0) * scaleFactor
            local param = UIHeroTipView.Param.New()
            param.title = name
            param.content = desc
            param.dir = UIHeroTipView.Direction.BELOW
            param.defWidth = 250
            param.pivot = 0.5
            param.position = position
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)

        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonRecruitItemIntro, tostring(self.itemId)) 
        end
        
    end
end

return SeasonRewardStampItem