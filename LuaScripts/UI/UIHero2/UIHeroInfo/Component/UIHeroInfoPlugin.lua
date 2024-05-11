--- Created by shimin
--- DateTime: 2023/6/8 15:44
--- 英雄插件按钮

local UIHeroInfoPlugin = BaseClass("UIHeroInfoPlugin", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local quality_img_path = "QualityBg"
local red_dot_path = "PluginBtnRed"
local camp_img_path = "CampImg"
local level_text_path = "Text_lv"
local gray_go_path = "GrayBg"
local score_bg_path = "scoreBg"
local score_text_path = "scoreBg/score_text"

function UIHeroInfoPlugin:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroInfoPlugin:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroInfoPlugin:OnEnable()
    base.OnEnable(self)
end

function UIHeroInfoPlugin:OnDisable()
    base.OnDisable(self)
end

function UIHeroInfoPlugin:ComponentDefine()
    self.plugin_btn = self:AddComponent(UIButton, this_path)
    self.plugin_btn:SetOnClick(function()
        self:OnPluginBtnClick()
    end)
    self.plugin_btn_red = self:AddComponent(UIBaseContainer, red_dot_path)
    self.camp_img = self:AddComponent(UIImage, camp_img_path)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
    self.gray_go = self:AddComponent(UIBaseContainer, gray_go_path)
    self.score_bg = self:AddComponent(UIBaseContainer, score_bg_path)
    self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
end

function UIHeroInfoPlugin:ComponentDestroy()
end

function UIHeroInfoPlugin:DataDefine()
    self.heroUuid = 0
end

function UIHeroInfoPlugin:DataDestroy()
    self.heroUuid = 0
end

function UIHeroInfoPlugin:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroInfoPlugin:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroInfoPlugin:ReInit(heroUuid)
    self.heroUuid = heroUuid
    self:Refresh()
end

function UIHeroInfoPlugin:Refresh()
    if DataCenter.HeroPluginManager:IsOpen() then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
        if heroData ~= nil then
            local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            if (campType ~= HeroCamp.NEW_HUMAN or DataCenter.HeroPluginManager:IsUnlock(campType, self.heroUuid)) and DataCenter.HeroPluginManager:GetCampIconName(campType) ~= "" then
                self:SetActive(true)
                local level = 1
                if heroData.plugin == nil or heroData.plugin.lv <= 0 then
                    self.level_text:SetActive(false)
                    self.plugin_btn_red:SetActive(false)
                    self.gray_go:SetActive(true)
                    self.score_bg:SetActive(false)
                else
                    level = heroData.plugin.lv
                    self.level_text:SetActive(true)
                    self.level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, level)
                    self.gray_go:SetActive(false)
                    self.score_bg:SetActive(true)
                    self.score_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_SCORE_WITH, string.GetFormattedSeperatorNum(heroData.plugin:GetScore()))
                end
                if heroData:IsPluginRedDot() then
                    self.plugin_btn_red:SetActive(true)
                else
                    self.plugin_btn_red:SetActive(false)
                end
                self.quality_img:LoadSprite(DataCenter.HeroPluginManager:GetQualityIconName(level))
                self.camp_img:LoadSprite(DataCenter.HeroPluginManager:GetCampIconName(campType))
            else
                self:SetActive(false)
            end
        else
            self:SetActive(false)
        end
    else
        self:SetActive(false)
    end
end

function UIHeroInfoPlugin:OnPluginBtnClick()
    --弹出属性展示界面
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData ~= nil then
        local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        if DataCenter.HeroPluginManager:IsUnlock(campType, self.heroUuid) then
            if heroData.plugin == nil or heroData.plugin.lv == 0 then
                --发送0升1
                DataCenter.HeroPluginManager:SendUpgradeHeroPlugin(self.heroUuid)
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUnlock, {anim = true, playEffect = false }, campType)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginInfo, {anim = true, playEffect = false }, self.heroUuid)
            end
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginTip, {anim = true, playEffect = false }, self.heroUuid)
        end
    end
end


return UIHeroInfoPlugin