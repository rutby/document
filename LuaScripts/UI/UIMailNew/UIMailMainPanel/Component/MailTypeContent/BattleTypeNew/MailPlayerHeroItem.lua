---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/7 16:27
---
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local UIHeroStars = require 'UI.UIHero2.Common.UIHeroStars'
local UIHeroEtoileList = require "UI.UIHero2.Common.UIHeroEtoileList"
local MailPlayerHeroItem = BaseClass("MailPlayerHeroItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_go_path = ""
local img_quality_path = "layout/imgQuality"
local img_camp_path = "layout/imgCamp"
local img_level_bg_path = "layout/LVBg"
local text_level_path = "layout/LVBg/textLevel"
local img_icon_path = "layout/iconMask/imgIcon"
local img_quality_fg_path = "layout/imgQualityfg"
local season_path = "layout/seasonBg"
local season_text_path = "layout/seasonBg/seasonTxt"
local etoile_list_path = "layout/UIHeroEtoileList"

function MailPlayerHeroItem:OnCreate()
    base.OnCreate(self)
    self.img_quality = self:AddComponent(UIImage, img_quality_path)
    self.img_quality_fg = self:AddComponent(UIImage,img_quality_fg_path)
    self.img_icon = self:AddComponent(UIImage, img_icon_path)
    self.img_camp = self:AddComponent(UIImage, img_camp_path)
    self.level_bg = self:AddComponent(UIImage, img_level_bg_path)
    self.text_level = self:AddComponent(UITextMeshProUGUIEx, text_level_path)
    self.btn = self:AddComponent(UIButton,btn_go_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.star = self:AddComponent(UIHeroStars, 'layout/NodeArrow')
    self.season = self:AddComponent(UIBaseContainer, season_path)
    self.seasonTxt = self:AddComponent(UITextMeshProUGUIEx, season_text_path)
    self.etoile_list = self:AddComponent(UIHeroEtoileList, etoile_list_path)
end


function MailPlayerHeroItem:SetData( herodata,parent,isSelf)
    if (herodata == nil) then
        return
    end
    self.parent = parent
    self.isSelf = isSelf
    local heroId = herodata["heroId"]
    self.heroId = heroId
    local heroLv = herodata["heroLevel"]
    self.heroLevel = heroLv
    local heroQuality = herodata["heroQuality"] or 0
    local skillInfos = herodata["skillInfos"] or {}
    local rankLv = herodata["rankLv"] or 0
    local stage = herodata["stage"] or 0
    local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
    local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
    local camp = HeroUtils.GetCamp(herodata)
    local rarity = heroConfig['rarity']
    local isWakeUp = HeroUtils.GetIsWakeUp(rarity,skillInfos,heroId,heroQuality)
    self.img_icon:LoadSprite(HeroUtils.GetHeroIconPath(heroId))
    if camp~=-1 then
        self.img_camp:SetActive(true)
        self.img_camp:LoadSprite(HeroUtils.GetCampIconPath(camp))
    else
        self.img_camp:SetActive(false)
    end
    self:SetSeason(heroConfig.season)
    self.level_bg:SetActive(heroLv ~= nil)
    self.text_level:SetText("Lv." ..tostring(heroLv))
    self.rankId = curMilitaryRankId
    local param = {}
    param.showStarNum = heroQuality
    param.maxStarNum = HeroUtils.GetMaxStarByRarity(rarity)
    local icon = HeroUtils.GetRarityIconPath(rarity, false, isWakeUp)
    self.img_quality:LoadSprite(icon)
    self.img_quality_fg:LoadSprite(icon.."fg")
    self.level_bg:LoadSprite(self:GetLvBgPath(rarity, isWakeUp))
    local lvColor = HeroUtils.GetLvColor(rarity,isWakeUp)
    --self.text_level:SetColor(lvColor)
    self.star:SetData(param)
    self.star:SetActive(true)
    self.etoile_list:SetRankId(curMilitaryRankId)
end

function MailPlayerHeroItem:OnBtnClick()
    local showOther = false
    if self.parent~=nil then
        showOther = self.parent:OnHeroDetailClick(self.isSelf)
    end
    if showOther == false then
        if self.heroId~=nil then
            local heroName = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, "name")
            if heroName~=nil and heroName~="" then
                local rankName = ""
                if self.rankId == nil or self.rankId <=1 then
                    rankName = ""
                else
                    rankName = Localization:GetString(HeroUtils.GetMilitaryRankName(self.rankId))
                end
                local scaleFactor = UIManager:GetInstance():GetScaleFactor()
                local position = self.btn.gameObject.transform.position + Vector3.New(33, -66, 0) * scaleFactor
                local param = UIHeroTipView.Param.New()
                param.content = Localization:GetString(heroName).."\n".."Lv."..self.heroLevel.."  "..rankName
                param.dir = UIHeroTipView.Direction.BELOW
                param.defWidth = 160
                param.pivot = 0.5
                param.position = position
                param.deltaX = 0
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
            end
        end
    end
end

function MailPlayerHeroItem:GetLvBgPath(rarity, isWaken)
    local path = LoadPath.HeroIconsSmallPath

    if isWaken then
        return path.."ui_quality_lvbg_cai"
    end

    local bg = {
        "ui_quality_lvbg_orange",        --1.橙
        "ui_quality_lvbg_purple",        --2.紫
        "ui_quality_lvbg_blue",          --3.蓝
        "ui_quality_lvbg_green",
        --"ui_herolist_lv_cai_bg",           --12.彩
    }

    local iconName = bg[rarity]
    return path..iconName
end

function MailPlayerHeroItem:SetSeason(season)
    self.season:SetActive(season > 0)
    self.seasonTxt:SetText("S"..season)
end

return MailPlayerHeroItem