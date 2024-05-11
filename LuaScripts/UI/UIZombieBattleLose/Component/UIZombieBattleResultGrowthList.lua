---@class UIZombieBattleResultGrowthList : UIBaseContainer
---@field heroLevelContent UIZombieBattleResultGrowthListItem
---@field recruitHeroContent UIZombieBattleResultGrowthListItem
---@field heroEquipContent UIZombieBattleResultGrowthListItem
---@field heroSkillContent UIZombieBattleResultGrowthListItem
---@field firstPayContent UIZombieBattleResultGrowthListItem
---@field cityUpdateContent UIZombieBattleResultGrowthListItem
---@field tankUpdateContent UIZombieBattleResultGrowthListItem
---@field radarContent UIZombieBattleResultGrowthListItem
local UIZombieBattleResultGrowthList = BaseClass("UIZombieBattleResultGrowthList", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization
---@type UIZombieBattleResultGrowthListItem
local UIGrowthItem = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthListItem")

-- 创建
function UIZombieBattleResultGrowthList:OnCreate(ctrl)
    base.OnCreate(self)
    self:ComponentDefine()
    self.ctrl = ctrl
end

-- 销毁
function UIZombieBattleResultGrowthList:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIZombieBattleResultGrowthList:OnEnable()
    base.OnEnable(self)
    self.active = true
end

-- 隐藏
function UIZombieBattleResultGrowthList:OnDisable()
    base.OnDisable(self)
    self.active = false
end

function UIZombieBattleResultGrowthList:ComponentDefine()
    self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    -- 升级英雄
    self.heroLevelContent = self:AddComponent(UIGrowthItem,"Viewport/Content/HeroLevelContent")
    self.heroLevelContent:RefreshView(Localization:GetString("140062"), "450004", self, self.OnHeroLevelBtnClick)
    -- 招募英雄
    self.recruitHeroContent = self:AddComponent(UIGrowthItem,"Viewport/Content/RecruitHeroContent")
    self.recruitHeroContent:RefreshView(Localization:GetString("450005"), "450004", self, self.OnRecruitHeroBtnClick)
    -- 英雄装备
    self.heroEquipContent = self:AddComponent(UIGrowthItem,"Viewport/Content/HeroEquipContent")
    self.heroEquipContent:RefreshView(Localization:GetString("260000"), "450004", self, self.OnHeroEquipBtnClick)
    -- 英雄技能
    self.heroSkillContent = self:AddComponent(UIGrowthItem,"Viewport/Content/HeroSkillContent")
    self.heroSkillContent:RefreshView(Localization:GetString("450007"), "450004", self, self.OnHeroSkillBtnClick)
    -- 首充送英雄
    self.firstPayContent = self:AddComponent(UIGrowthItem,"Viewport/Content/FirstPayContent")
    self.firstPayContent:RefreshView(Localization:GetString("2000328"), "450004", self, self.OnFirstPayBtnClick)
    -- 升级大本
    self.cityUpdateContent = self:AddComponent(UIGrowthItem,"Viewport/Content/CityUpdate")
    self.cityUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("135104")), "450004", self, self.OnCityBtnClick)
    -- 升级坦克中心
    self.tankUpdateContent = self:AddComponent(UIGrowthItem,"Viewport/Content/TankUpdate")
    self.tankUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("129031")), "450004", self, self.OnTankBtnClick)
    -- 雷达
    self.radarContent = self:AddComponent(UIGrowthItem,"Viewport/Content/RadarUpdate")
    self.radarContent:RefreshView(Localization:GetString("121289"), "450004", self, self.OnRadarBtnClick)
end

function UIZombieBattleResultGrowthList:ComponentDestroy()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end
end

function UIZombieBattleResultGrowthList:FadeIn()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end

    self.canvasGroup.alpha = 0
    self.fadeTween = CS.DG.Tweening.DOTween.To(function()
        return self.canvasGroup.alpha
    end, function(value)
        self.canvasGroup.alpha = value
    end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIZombieBattleResultGrowthList:OnCityBtnClick()
    self.ctrl:CloseSelf()
    local afterSwitchScene = function()
        GoToUtil.GotoCityByBuildId(10100000, WorldTileBtnType.City_Upgrade, nil, true)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnTankBtnClick()
    self.ctrl:CloseSelf()
    local tankData = self.tankData
    local afterSwitchScene = function()
        if tankData == nil then
            -- 若没有坦克中心，打开建造列表，跳转至坦克中心所在分页
            GoToUtil.GotoCityByBuildId(10116000, WorldTileBtnType.City_Upgrade)
        else
            -- 若已有坦克中心，打开坦克中心升级面板
            GoToUtil.GotoCityByBuildId(10116000, WorldTileBtnType.City_Upgrade, nil, true)
        end
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnRadarBtnClick()
    self.ctrl:CloseSelf()
    local afterSwitchScene = function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroLevelBtnClick()
    self.ctrl:CloseSelf()
    local heroUuid = self.heroQualityHigh
    local afterSwitchScene = function()
        local arrowData = {
            arrowType = HeroDetailGuideArrowType.Upgrade,
            heroUid = heroUuid,
        }
        local heroList = HeroUtils.GenerateHeroDataList(0)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel,{anim=false}, heroUuid,heroList,nil,arrowData)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnRecruitHeroBtnClick()
    self.ctrl:CloseSelf()
    local afterSwitchScene = function() 
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, { anim = true })
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroEquipBtnClick()
    self.ctrl:CloseSelf()
    local heroUuid = self.canEquipHero
    local afterSwitchScene = function()
        local arrowData = {
            arrowType = HeroDetailGuideArrowType.Equip,
            heroUid = heroUuid,
        }
        local heroList = HeroUtils.GenerateHeroDataList(0)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel,{anim=false}, heroUuid,heroList,nil,arrowData)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroSkillBtnClick()
    self.ctrl:CloseSelf()
    local heroUuid = self.canSkillUpHero
    local afterSwitchScene = function()
        local arrowData = {
            arrowType = HeroDetailGuideArrowType.Skill,
            heroUid = heroUuid,
            skillSlotIndex = self.canUpgradeSkillSlotIndex,
        }
        local heroList = HeroUtils.GenerateHeroDataList(0)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel,{anim=false}, heroUuid,heroList,nil,arrowData)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:FirstTimeLoseGuide()
    local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(10100000)[1]   -- 要求基地2级
    if not buildingData or buildingData.level < 2 then
        return
    end
    
    if CommonUtil.PlayerPrefsGetInt("STAGE_LOSE_HERO_LV_GUIDE", 0) == 0 then
        CommonUtil.PlayerPrefsSetInt("STAGE_LOSE_HERO_LV_GUIDE", 1)
        local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
        fingerHandle:completed('+', function(handle)
            if handle.isError then return end
            local gameObject = handle.gameObject
            local transform = gameObject.transform
            transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
            transform.position = self.heroLevelContent and self.heroLevelContent.goto_btn and not IsNull(self.heroLevelContent.goto_btn.transform) and self.heroLevelContent.goto_btn.transform.position or Vector3.zero
            TimerManager:GetInstance():DelayInvoke(function()
                fingerHandle:Destroy()
            end, 3)
        end)
    end
end

function UIZombieBattleResultGrowthList:OnFirstPayBtnClick()
    self.ctrl:CloseSelf()
    local afterSwitchScene = function()
        EventManager:GetInstance():Broadcast(EventId.ShowFirstPayUI)
    end
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:RefreshView()
    self.canLevelUpHero = 0
    self.canEquipHero = 0
    self.canSkillUpHero = 0

    -- 任意一个英雄的等级小于 finalLevel 都显示
    local canShowCityUpdate = false
    local heroQuality = 0
    local heroQualityHigh = 0

    if DataCenter.ZombieBattleManager.squad then
        local squadHeroes = DataCenter.ZombieBattleManager.squad.heroes
        for slotIndex,heroData in pairs(squadHeroes) do
            local hero=heroData
            local heroUuid = hero.uuid
            local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)

            canUpgrade = not overFinalLevel and not reachLevelLimit
            if canUpgrade then
                -- 打开当前阵容中，品质最高的英雄详情面板
                self.canLevelUpHero = heroUuid
            end
            if heroQuality < hero.quality then
                heroQualityHigh = heroUuid
                heroQuality = hero.quality
            end
            if (hero.finalLevel == nil and hero.level < 100) or (hero.level < hero.finalLevel) then
                -- 任意一个英雄的等级小于 finalLevel 都显示
                canShowCityUpdate = true
            end

            local equip = DataCenter.EquipDataManager:GetHeroBetterEquip(hero)
            if equip then
                self.canEquipHero = heroUuid
            end

            local skill = hero:GetCanUpgradeSkill()
            if skill then
                self.canSkillUpHero = heroUuid
                self.canUpgradeSkillSlotIndex = skill.slotIndex
            end
        end
    end

    local canRecruit = false
    -- 1. 拥有建筑10120000，等级>=1级
    -- 2. 道具230006 数量>=10
    local buildData = DataCenter.BuildManager.buildIdBuilding[10120000]
    if buildData ~= nil and #buildData >= 1 and buildData[1].level > 0 then
        local count = DataCenter.ItemData:GetItemCount("230006") --抽奖券
        if count ~= nil and count >= 10 then
            canRecruit = true
        end
    end

    self.heroQualityHigh = heroQualityHigh

    self.recruitHeroContent:SetActive(canRecruit)
    self.heroLevelContent:SetActive(self.canLevelUpHero > 0)
    self.heroEquipContent:SetActive(self.canEquipHero > 0)
    self.heroSkillContent:SetActive(false)

    local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
    if isNewFirstPay then
        local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
        local hasFirstPayGift = firstPayPack ~= nil
        self.firstPayContent:SetActive(hasFirstPayGift)
    else
        local firstPayState = DataCenter.FirstPayManager:GetState()
        local hasFirstPayGift = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
        self.firstPayContent:SetActive(hasFirstPayGift)
    end

    local tankData = DataCenter.BuildManager.buildIdBuilding[10116000]
    local cityData = DataCenter.BuildManager.buildIdBuilding[10100000]
    if cityData ~= nil and #cityData == 1 then
        local canShowTank = false
        if tankData ~= nil and #tankData >= 1 then
            -- 坦克中心等级 < 大本等级
            if tankData[1].level < cityData[1].level then
                self.tankData = tankData[1]
                canShowTank = true
            else
                canShowTank = false
            end
        else
            local state = DataCenter.BuildManager:GetBuildState(10116000)
            if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
                canShowTank = true
            else
                canShowTank = false  -- 还不能建造
            end
        end
        self.cityData = cityData[1]
        self.tankUpdateContent:SetActive(canShowTank)
        -- 队伍中所有英雄已满级，且英雄等级<100级
        self.cityUpdateContent:SetActive(canShowCityUpdate)
    else
        self.tankUpdateContent:SetActive(false)
        self.cityUpdateContent:SetActive(false)
    end

    local count = DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum()
    self.radarContent:SetActive(count > 0)
end

return UIZombieBattleResultGrowthList