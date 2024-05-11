
local UIHeroMilitaryRankIntroView = BaseClass("UIHeroMilitaryRankIntroView", UIBaseView)
local base = UIBaseView

local UIHeroMilitaryRankIcon = require "UI.UIHero2.UIHeroInfo.Component.UIHeroMilitaryRankIcon"
local UIHeroMilitarySkillIcon = require "UI.UIHero2.UIHeroMilitaryRank.Component.UIHeroMilitarySkillIcon"
local UIHeroMilitaryRankIntroCell = require "UI.UIHero2.UIHeroMilitaryRankIntro.Component.UIHeroMilitaryRankIntroCell"

local Localization = CS.GameEntry.Localization

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local close_panel_path = "UICommonPopUpTitle/panel"
local MilitaryName_path = "Root/MilitaryName"
local military_icon_path = "Root/MilitaryIcon"

local skill_prefix_path = "Root/LayerMulti/HeroSkillIcon"
local condition_text_path = "Root/ConditionText"

local scroll_view_path = "Root/ScrollView"

local skill_component_prefix = "skill"
local Max_Skill_Num = 5

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshView()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title = self:AddComponent(UIText, title_path)
    self.title:SetLocalText(129117)
    self.MilitaryName = self:AddComponent(UIText, MilitaryName_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_panel = self:AddComponent(UIButton, close_panel_path)
    self.militaryIcon = self:AddComponent(UIHeroMilitaryRankIcon, military_icon_path)
    self.condition_text = self:AddComponent(UIText, condition_text_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.btnSkills = {}
    for k = 1, HeroUtils.SKILL_CNT_MAX do
        local nodeBtn = self:AddComponent(UIButton, "Root/SkillContent/Skill" .. k)
        nodeBtn:SetOnClick(function()
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self:OnBtnSkillClick(k)
        end)

        local imgIcon = self:AddComponent(UIImage, "Root/SkillContent/Skill" .. k .. "/ImgIcon" .. k)
        local textLevel = self:AddComponent(UIText, "Root/SkillContent/Skill" .. k .. "/TextLv" .. k)
        local imgLvBg = self:AddComponent(UIText, "Root/SkillContent/Skill" .. k .. "/ImgLvBg" .. k)
        local imgLock = self:AddComponent(UIImage, "Root/SkillContent/Skill" .. k .. "/ImgLock" .. k)
        local nodeEffect = self:AddComponent(UIBaseContainer, "Root/SkillContent/Skill" .. k .. "/NodeEffect" .. k)
        table.insert(self.btnSkills, {btn = nodeBtn, icon = imgIcon, lvBg = imgLvBg, lock = imgLock, textLv = textLevel, nodeFx = nodeEffect})
    end
    self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnRankItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnRankItemMoveOut(itemObj, index)
    end)
    self.rankList = {}
    self.itemList = {}
end

local function OnRankItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(UIHeroMilitaryRankIntroCell, itemObj)
    cellItem:SetData(self.rankList[index])
end
local function OnRankItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, UIHeroMilitaryRankIntroCell)
end
local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(UIHeroMilitaryRankIntroCell)
end

local function ComponentDestroy(self)
    self:ClearScroll()
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshView(self)
    local heroUid = self:GetUserData()
    self.data = self.ctrl:GetShowData(heroUid)
    self.rankList = self.data.rankList
    self.militaryIcon:SetData(self.data.currentMilitaryRankId)
    if self.data.currentMilitaryRankLv > 0 then
        self.MilitaryName:SetLocalText(HeroUtils.GetMilitaryRankName(self.data.currentMilitaryRankId))
    else
        self.MilitaryName:SetText("")
    end
    if #self.rankList >0 then
        self.ScrollView:SetTotalCount(#self.rankList)
        self.ScrollView:RefillCells()
    end
    self:RefreshSkill()
end

local function GetSkillPath(self, index)
    return skill_prefix_path..index
end

local function GetSkillComponentName(self, index)
    return skill_component_prefix..index
end

local function RefreshSkill(self)
    local index = 1
    local skillCount = table.count(self.data.skillList)
    while index <= Max_Skill_Num do
        local component = self.btnSkills[index]
        component.btn:SetActive(index <= skillCount)
        index = index + 1
    end
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.data.heroUid)

    index = 1
    table.walk(self.data.skillList, function (_, skillId)
        local skillData = heroData:GetSkillData(skillId)
        local t = self.btnSkills[index]
        t.icon:LoadSprite(HeroUtils.GetSkillIcon(skillId))

        local level = HeroUtils.SkillLevelLimit     --图鉴默认最大等级
        local unlock = true
        if skillData ~= nil then
            level = skillData:GetLevel()
            unlock = skillData:IsUnlock()
        end

        t.lvBg:SetActive(unlock)--(level > 0)
        t.lock:SetActive(unlock)--(not unlock)
        CS.UIGray.SetGray(t.btn.transform, not unlock, true)
        t.textLv:SetText(level)
        t.textLv:SetActive(unlock)
        index = index + 1
    end)
    if self.data.currentMilitaryRankId < self.data.maxMilitaryRankId then
        local nextName = HeroUtils.GetMilitaryRankName(self.data.currentMilitaryRankId + 1)
        self.condition_text:SetLocalText(129217, self.data.currentMilitaryRankLv + 1, Localization:GetString(nextName))
    else
        self.condition_text:SetText("")
    end
end

local function OnBtnSkillClick(self, index)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.data.heroUid)
    local config = heroData.config

    local skillIdList = config['skill']
    if type(skillIdList) ~= 'table' then
        skillIdList = string.split(skillIdList, '|')
    end

    local skillId = tonumber(skillIdList[index])
    local level = HeroUtils.SkillLevelLimit     --图鉴默认最大等级
    local unlock = true
    local unlockQuality = 1
    if heroData ~= nil then
        local skillData = heroData:GetSkillData(skillId)
        if skillData ~= nil then
            level = skillData:GetLevel()
            unlock = skillData:IsUnlock()
            unlockQuality = skillData.unlockQuality
        end
    else
        local type2 = tonumber(GetTableData(TableName.SkillTab, skillId, 'type2'))
        if type2 == 11 then
            level = 1 --觉醒技能始终显示1级
        end
    end

    local scaleFactor = UIManager:GetInstance():GetScaleFactor()

    local btn = self.btnSkills[index].btn
    local position = btn.transform.position

    local UIHeroSkillTipView = require "UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView"
    local dir = UIHeroSkillTipView.Direction.BELOW


    local param = UIHeroSkillTipView.Param.New()
    param.content = Localization:GetString("150155")
    param.dir = dir
    param.skillId = skillId
    param.isUnlock = unlock
    param.skillLevel = level
    param.skillIndex = index
    param.skillUnlockQuality = unlockQuality
    param.heroRarity = self.rarity
    param.heroUuid = self.data.heroUid
    param.pivot = 0.75 + index * 0.03
    param.position = position + Vector3.New(0,  -55, 0) * scaleFactor

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, { anim = false }, param)
end


UIHeroMilitaryRankIntroView.OnCreate= OnCreate
UIHeroMilitaryRankIntroView.OnDestroy = OnDestroy
UIHeroMilitaryRankIntroView.OnEnable = OnEnable
UIHeroMilitaryRankIntroView.OnDisable = OnDisable
UIHeroMilitaryRankIntroView.ComponentDefine = ComponentDefine
UIHeroMilitaryRankIntroView.ComponentDestroy = ComponentDestroy
UIHeroMilitaryRankIntroView.DataDefine = DataDefine
UIHeroMilitaryRankIntroView.DataDestroy = DataDestroy
UIHeroMilitaryRankIntroView.RefreshView = RefreshView
UIHeroMilitaryRankIntroView.GetSkillPath = GetSkillPath
UIHeroMilitaryRankIntroView.GetSkillComponentName = GetSkillComponentName
UIHeroMilitaryRankIntroView.ClearScroll = ClearScroll
UIHeroMilitaryRankIntroView.OnBtnSkillClick = OnBtnSkillClick
UIHeroMilitaryRankIntroView.RefreshSkill = RefreshSkill
UIHeroMilitaryRankIntroView.OnRankItemMoveIn = OnRankItemMoveIn
UIHeroMilitaryRankIntroView.OnRankItemMoveOut = OnRankItemMoveOut

return UIHeroMilitaryRankIntroView
