---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2021/12/30 15:53
---

local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIHeroStationCell = require "UI.UIHeroStation.Component.UIHeroStationCell"
local UIHeroStationSkill = require "UI.UIHeroStation.Component.UIHeroStationSkill"
local UIHeroStationValUp = require "UI.UIHeroStation.Component.UIHeroStationValUp"
local UIHeroStationTip = require "UI.UIHeroStation.Component.UIHeroStationTip"
local UIHeroStation = BaseClass("UIHeroStation", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local this_path = ""
local black_path = "Black"
local title_path = "Title"
local close_path = "Back"
local build_path = "Info/Build"
local info_glow_path = "Info/InfoGlow"
local hero_list_path = "Hero"
local hero_path = "Hero/UIHeroStationCell_%s"
local my_hero_path = "MyHero"
local hero_scroll_path = "MyHero/HeroScroll"
local hero_content_path = "MyHero/HeroScroll/HeroContent"
local recruit_path = "MyHero/Recruit"
local recruit_desc_path = "MyHero/Recruit/RecruitDesc"
local recruit_btn_path = "MyHero/Recruit/RecruitBtn"
local recruit_btn_text_path = "MyHero/Recruit/RecruitBtn/RecruitBtnText"
local skill_list_path = "SkillList"
local skill_path = "SkillList/UIHeroStationSkill_%s"
local skill_val_path = "Info/Black/SkillVal"
local skill_icon_bg_path = "Info/Black/SkillIconBg"
local skill_icon_path = "Info/Black/SkillIconBg/SkillIcon"
local skill_info_path = "Info/Black/SkillInfoBtn"
local skill_glow_path = "Info/Black/SkillGlow"
local skill_desc_path = "Info/SkillDesc"
local skill_desc_top_path = "Info/SkillDesc/SkillDescTop"
local skill_desc_bottom_locked_path = "Info/SkillDesc/SkillDescBottomLocked"
local skill_desc_bottom_unlocked_path = "Info/SkillDesc/SkillDescBottomUnlocked"
local skill_tip_path = "Info/SkillTip"
local task_tip_path = "Info/TaskTips"
local task_tipDesc_path = "Info/TaskTips/TaskTipsBg/TaskTipDesc"
local intro_path = "Info/Intro"
local intro_tip_path = "Info/IntroTip"
local val_up_path = "UIHeroStationValUp"

local FULL_HERO_INDEX = -1
local GREEN = Color.New(0.5333334, 0.8941177, 0.2156863, 1)
local GRAY = Color.New(0.8705882, 0.6941177, 0.5372549, 1)
local TWEEN_NUM_DURATION = 0.425
local TWEEN_NUM_DELAY = 0.2
local TWEEN_NUM_SCALE = 1.2
local HERO_SCROLL_HEIGHT_WHOLE = 614
local HERO_SCROLL_HEIGHT_HALF = 494

local HeroCellAnim =
{
    Select = "V_ui_hero_station_chuxian",
    Delete = "V_ui_hero_station_delete",
    Idle = "V_ui_hero_station_idle",
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ClearHeroScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    
    local stationId, isArrow, highlightLevelUp,heroLvUpArrow,taskInfo = self:GetUserData()
    
    --1: 指向空栏位; 2：指向英雄升级; 3：指向未解锁栏位
    self.isArrow = isArrow
    --是否有指定英雄升级
    self.heroLvUpArrow = heroLvUpArrow
    
    self.highlightLevelUp = highlightLevelUp
    
    --任务目标信息
    self.taskInfo = taskInfo
    
    DataCenter.HeroStationManager:Backup()
    DataCenter.HeroStationManager:ReCalcSkillAddition()
    
    self:SetStationId(stationId)
    self:HideMyHero()
    self:LookAtBuilding()
    
    DataCenter.BuildManager:SetShowCityLabel(false)
end

local function OnDisable(self)
    DataCenter.BuildManager:SetShowCityLabel(true)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    -- Common
    self.panel_btn = self:AddComponent(UIButton, this_path)
    self.black_go = self:AddComponent(UIBaseContainer, black_path)
    self.panel_btn:SetOnClick(function() self:HideMyHero() end)
    self.title_text = self:AddComponent(UIText, title_path)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function() self:OnClose() end)
    
    -- Info
    self.build_image = self:AddComponent(UIImage, build_path)
    self.info_glow_particle = self.transform:Find(info_glow_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    
    -- Hero
    self.hero_list_go = self:AddComponent(UIBaseContainer, hero_list_path)
    self.heroCells = {}
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        self.heroCells[i] = self:AddComponent(UIHeroStationCell, string.format(hero_path, i))
        self.heroCells[i]:SetOnSelectClick(function() self:OnHeroSelectClick(i) end)
        self.heroCells[i]:SetOnDeleteClick(function() self:OnHeroDeleteClick(i) end)
        self.heroCells[i]:SetOnLevelUpClick(function() self:OnHeroLevelUpClick(i) end)
    end
    
    -- My Hero
    self.myHero_go = self:AddComponent(UIBaseContainer, my_hero_path)
    self.heroItems = {}
    self.heroScroll_go = self:AddComponent(UIBaseContainer, hero_scroll_path)
    self.heroContent_sv = self:AddComponent(GridInfinityScrollView, hero_content_path)
    self.heroContent_sv:Init(BindCallback(self, self.OnInitItem), BindCallback(self, self.OnUpdateItem), BindCallback(self, self.OnDestroyItem))
    
    -- Recruit
    self.recruit_go = self:AddComponent(UIBaseContainer, recruit_path)
    self.recruit_desc_text = self:AddComponent(UIText, recruit_desc_path)
    self.recruit_btn = self:AddComponent(UIButton, recruit_btn_path)
    self.recruit_btn:SetOnClick(function()
        self:HideMyHero()
        self:OnClose()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
    end)
    self.recruit_btn_text = self:AddComponent(UIText, recruit_btn_text_path)
    self.recruit_btn_text:SetLocalText(128011)
    
    -- Skill
    self.skill_list_go = self:AddComponent(UIBaseContainer, skill_list_path)
    self.skill_items = {}
    for i = 1, DataCenter.HeroStationManager.SKILL_COUNT do
        self.skill_items[i] = self:AddComponent(UIHeroStationSkill, string.format(skill_path, i))
        self.skill_items[i]:SetOnClick(function() self:OnSkillClick(i) end)
    end
    self.skill_val_text = self:AddComponent(UITweenNumberText, skill_val_path)
    self.skill_icon_bg_go = self:AddComponent(UIBaseContainer, skill_icon_bg_path)
    self.skill_icon_image = self:AddComponent(UIImage, skill_icon_path)
    self.skill_info_btn = self:AddComponent(UIButton, skill_info_path)
    self.skill_glow_particle = self.transform:Find(skill_glow_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    self.skill_info_btn:SetOnClick(function() self.skill_tip:Show() end)
    self.skill_desc_go = self:AddComponent(UIBaseContainer, skill_desc_path)
    self.skill_desc_top_text = self:AddComponent(UIText, skill_desc_top_path)
    self.skill_desc_bottom_locked_text = self:AddComponent(UIText, skill_desc_bottom_locked_path)
    self.skill_desc_bottom_unlocked_text = self:AddComponent(UIText, skill_desc_bottom_unlocked_path)
    self.skill_desc_bottom_unlocked_text:SetLocalText(162117)
    self.skill_tip = self:AddComponent(UIHeroStationTip, skill_tip_path)
    
    -- Intro
    self.intro_btn = self:AddComponent(UIButton, intro_path)
    self.intro_btn:SetOnClick(function() self.intro_tip:Show() end)
    self.intro_tip = self:AddComponent(UIHeroStationTip, intro_tip_path)
    self.intro_tip:SetDesc(Localization:GetString("162008") .. "\n\n" .. Localization:GetString("162009") .. "\n\n" .. Localization:GetString("162010"))
    
    -- Val Up
    self.val_up = self:AddComponent(UIHeroStationValUp, val_up_path)
    
    -- Task Tip
    self.task_tip = self:AddComponent(UIBaseContainer,task_tip_path)
    self.task_tipDesc = self:AddComponent(UIText,task_tipDesc_path)
end

local function ComponentDestroy(self)
    self.panel_btn = nil
    self.black_go = nil
    self.title_text = nil
    self.close_btn = nil
    self.build_image = nil
    self.info_glow_particle = nil
    self.hero_list_go = nil
    self.heroCells = nil
    self.myHero_go = nil
    self.heroItems = nil
    self.heroScroll_go = nil
    self.heroContent_sv = nil
    self.recruit_go = nil
    self.recruit_desc_text = nil
    self.recruit_btn = nil
    self.recruit_btn_text = nil
    self.skill_list_go = nil
    self.skill_items = nil
    self.skill_val_text = nil
    self.skill_icon_bg_go = nil
    self.skill_icon_image = nil
    self.skill_info_btn = nil
    self.skill_glow_particle = nil
    self.skill_desc_go = nil
    self.skill_desc_top_text = nil
    self.skill_desc_bottom_locked_text = nil
    self.skill_desc_bottom_unlocked_text = nil
    self.skill_tip = nil
    self.intro_btn = nil
    self.intro_tip = nil
    self.val_up = nil
    self.task_tip = nil
    self.task_tipDesc = nil
end

local function DataDefine(self)
    self.stationId = nil
    self.buildId = nil
    self.selectHeroIndex = 1
    self.selectSkillIndex = 1
    self.heroUuidList = {}
    self.myHeroUuidList = {}
    self.active = false
    self.engagedCache = false
    self.isArrow = nil
    self.highlightLevelUp = false
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self.showingMyHero = false
end

local function DataDestroy(self)
    self.stationId = nil
    self.buildId = nil
    self.selectHeroIndex = nil
    self.selectSkillIndex = nil
    self.heroUuidList = nil
    self.myHeroUuidList = nil
    self.active = nil
    self.engagedCache = nil
    self.isArrow = nil
    self.highlightLevelUp = nil
    self.timer_action = nil
    self:DelTimer()
    self.heroLvUpArrow = nil
    if self.timerTask ~= nil then
        self.timerTask:Stop()
        self.timerTask = nil
    end
    self.showingMyHero = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroStationSave, self.HeroStationSaveSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroStationSave, self.HeroStationSaveSignal)
end

local function OnClose(self)
    if self.showingMyHero then
        self:HideMyHero()
        return
    end
    
    DataCenter.HeroStationManager:Save()
    self.active = false
    self:SaveValCacheDict()
    
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
    local worldPos = buildData:GetCenterVec()
    GoToUtil.GotoPos(worldPos, CS.SceneManager.World.InitZoom, 0.2)
    
    self.ctrl:CloseSelf()
end

local function OnInitItem(self, go, index)
    local item = self.heroScroll_go:AddComponent(UIHeroCellSmall, go)
    self.heroItems[go] = item
end

local function OnUpdateItem(self, go, index)
    local item = self.heroItems[go]
    go.name = "HeroItem_" .. index + 1
    local heroUuid = self.myHeroUuidList[index + 1]
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    item:SetData(heroUuid, function(_, _) self:OnItemClick(index + 1) end, nil, true)
    item:SetHeroStationSkill(skillIdList[self.selectSkillIndex])
    item:CheckInStation(self.stationId)
end

local function OnDestroyItem(self, go, index)
    
end

local function RefreshHeroItems(self)
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    for _, item in pairs(self.heroItems) do
        item:CheckInStation(self.stationId, skillIdList[self.selectSkillIndex])
    end
    self:RefreshRecruit()
end

local function ReInitHeroScroll(self)
    local count = #self.myHeroUuidList
    if count > 0 then
        self.heroContent_sv:SetItemCount(count)
        self.heroContent_sv:MoveItemByIndex(0, 0)
    end
    self:RefreshRecruit()
end

local function ClearHeroScroll(self)
    self.heroScroll_go:RemoveComponents(UIHeroCellSmall)
    self.heroContent_sv:DestroyChildNode()
end

local function RefreshRecruit(self)
    if not DataCenter.HeroStationManager:HasAvailableHero(self.stationId) and
        DataCenter.HeroStationManager:HasAvailableSlot(self.stationId)
    then
        self.recruit_go:SetActive(true)
        self.heroScroll_go.rectTransform:Set_sizeDelta_y(HERO_SCROLL_HEIGHT_HALF)
    else
        self.recruit_go:SetActive(false)
        self.heroScroll_go.rectTransform:Set_sizeDelta_y(HERO_SCROLL_HEIGHT_WHOLE)
    end
end

local function SetStationId(self, stationId)
    self.active = true
    self.stationId = stationId
    
    local buildId = DataCenter.HeroStationManager:GetBuildIdByStationId(stationId)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
    if buildData ~= nil then
        self.title_text:SetText(Localization:GetString("162121", 
                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + buildData.level,"name"))))
        self.build_image:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(buildId, buildData.level), nil, function()
            self.build_image:SetNativeSize()
        end)
    end
    self.buildId = buildId
    self.skill_tip:Hide()
    self:RefreshHero()
    self:RefreshSkill(true)
    self:HideMyHero()
    self:LoadValCacheDict()
    self:TaskTipRefresh()
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(0.3, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

local function DelTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function RefreshTime(self)
    self:DelTimer()
    local param = {}
    if self.isArrow == 1 then
        --空栏位
        local emptySlot = DataCenter.HeroStationManager:GetEmptySlotList(self.stationId)
        param.position = self.heroCells[emptySlot[1]]:GetValuePos()
    elseif self.isArrow == 2 then
        --升级
        if self.heroLvUpArrow then
            param.position = self.heroCells[self.heroLvUpArrow]:GetLvUpPos()
        else
            local stationData = DataCenter.HeroStationManager:GetStationData(self.stationId)
            local heroUuids = stationData:GetHeroUuids()
            --查找能够升级的英雄
            for i = 1, #heroUuids do
                local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuids[i])
                if heroData.level < heroData:GetFinalLevel() then
                    param.position = self.heroCells[i]:GetLvUpPos()
                    break
                end
            end
        end
    elseif self.isArrow == 3 then
        --未解锁栏位
        local lockedSlot = DataCenter.HeroStationManager:GetLockedSlotList(self.stationId)
        param.position = self.heroCells[lockedSlot[1]]:GetLockPos()
    end
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
    end
    self.isArrow = nil
end

local function RefreshHero(self)
    local stationData = DataCenter.HeroStationManager:GetStationData(self.stationId)
    local heroUuids = stationData:GetHeroUuids()
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        self:SetHero(i, heroUuids[i])
    end
end

local function RefreshHeroCellEffect(self)
    local showAddGlow = not self.showingMyHero and DataCenter.HeroStationManager:HasAvailableHero()
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        self.heroCells[i]:ShowAddGlow(showAddGlow)
        self.heroCells[i]:ShowLevelUpGlow(self.highlightLevelUp == true)
    end
end

local function RefreshSkill(self, isInit)
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    local skillCount = table.count(skillIdList)
    for i = 1, DataCenter.HeroStationManager.SKILL_COUNT do
        if i <= skillCount then
            self.skill_items[i]:SetUnlocked(true)
            self.skill_items[i]:SetData(skillIdList[i])
        else
            self.skill_items[i]:SetUnlocked(false)
        end
    end
    
    local skillId = skillIdList[self.selectSkillIndex]
    local skillTemplate = DataCenter.HeroStationSkillTemplateManager:GetTemplate(skillId)
    local val, _ = DataCenter.HeroStationManager:GetSkillEffectValue(skillId)
    val = Mathf.Round(val)
    local prefix, suffix = DataCenter.HeroStationManager:GetSkillEffectAffix(skillId)
    local engaged = DataCenter.HeroStationManager:CanEngageSkill(skillId) or val ~= 0

    if not isInit then
        if engaged and not self.engagedCache then
            self.info_glow_particle:Play()
        end
    end
    self.engagedCache = engaged

    if engaged then
        local icon = DataCenter.HeroStationManager:GetSkillIcon(skillId)
        self.skill_icon_image:LoadSprite(icon, nil, function()
            self.skill_icon_image:SetNativeSize()
        end)
        self.skill_icon_bg_go:SetActive(true)
        self.skill_info_btn:SetActive(true)
        self.skill_val_text:SetColor(GREEN)
        self.skill_val_text:SetAffix(prefix, suffix)
        if isInit then
            self.skill_val_text:SetNum(val)
        else
            if val > self.skill_val_text:GetTargetNum() then
                self.skill_glow_particle:Play()
                self.skill_val_text:TweenToNum(val, TWEEN_NUM_DURATION, TWEEN_NUM_DELAY, TWEEN_NUM_SCALE)
            else
                self.skill_val_text:TweenToNum(val, TWEEN_NUM_DURATION)
            end
        end
    else
        self.skill_icon_bg_go:SetActive(false)
        self.skill_info_btn:SetActive(false)
        self.skill_val_text:SetColor(GRAY)
        self.skill_val_text:SetNum(0)
        self.skill_val_text:SetLocalText(120050)
    end

    self.skill_tip:SetDesc(string.join(skillTemplate:GetEffectDescription(), "\n"))
    self.skill_desc_top_text:SetText(string.join(skillTemplate:GetDescription(self.heroUuidList), "\n"))
    self.skill_desc_bottom_locked_text:SetActive(not engaged)
    self.skill_desc_bottom_locked_text:SetText(string.join(skillTemplate:GetUnlockTips(), "\n"))
    self.skill_desc_bottom_unlocked_text:SetActive(engaged)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skill_desc_go.transform)
end

local function GetFirstSelectableHeroIndex(self)
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        local unlocked = DataCenter.HeroStationManager:IsStationSlotUnlocked(self.stationId, i)
        if self.heroUuidList[i] == nil and unlocked then
            return i
        end
    end
    return FULL_HERO_INDEX
end

local function SetHero(self, index, heroUuid)
    self.heroUuidList[index] = heroUuid

    local unlocked = DataCenter.HeroStationManager:IsStationSlotUnlocked(self.stationId, index)
    if not unlocked then
        self.heroCells[index]:SetState(UIHeroStationCell.State.Lock)
    elseif heroUuid == nil then
        self.heroCells[index]:SetState(UIHeroStationCell.State.Add)
    else
        self.heroCells[index]:SetState(UIHeroStationCell.State.Hero)
        local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId)
        local skillId = skillIdList[self.selectSkillIndex]
        local _, str = DataCenter.HeroStationManager:GetSkillEffectValue(skillId, heroUuid)
        local data =
        {
            heroUuid = heroUuid,
            valueText = str,
            effectIcon = DataCenter.HeroStationManager:GetSkillIcon(skillId)
        }
        self.heroCells[index]:SetData(data)
    end
    
    self.selectHeroIndex = self:GetFirstSelectableHeroIndex()
    self:RefreshHeroCellEffect()
end

local function PlayHeroAnim(self, index, heroCellAnim)
    self.heroCells[index]:PlayAnim(heroCellAnim)
end

local function OnHeroSelectClick(self, index)
    if self.heroCells[index].state == UIHeroStationCell.State.Lock then
        local unlockLevel = DataCenter.HeroStationManager:GetStationSlotUnlockLevel(self.stationId, index)
        UIUtil.ShowTips(Localization:GetString("162013", unlockLevel))
    else
        self:ShowMyHero()
    end
end

local function OnHeroDeleteClick(self, index)
    DataCenter.HeroStationManager:RemoveStationHero(self.stationId, index)
    self:PlayHeroAnim(index, HeroCellAnim.Delete)
    self:SetHero(index, nil)
    self:RefreshHeroItems()
    self:RefreshSkill(false)
end

local function OnHeroLevelUpClick(self, index)
    local heroUuid = self.heroUuidList[index]
    if heroUuid == nil then
        return
    end
    
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData.level < heroData:GetFinalLevel() then
        if heroData:NeedBeyond() then
            UIUtil.ShowTipsId(129085)
        end
        
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroLvUp, heroUuid, function()
            TimerManager:GetInstance():DelayInvoke(function()
                if self.active then
                    self:RefreshHero()
                    self:RefreshSkill(false)
                end
            end, 0.5)
        end)
    end
end

local function ShowMyHero(self)
    if self.showingMyHero then
        return
    end
    self.showingMyHero = true
    --self.myHero_go:SetActive(true)
    self.skill_list_go:SetActive(false)
    self:RefreshMyHeroUuidList()
    self:ReInitHeroScroll()
    self:RefreshHeroCellEffect()
    self.hero_list_go.rectTransform:DOAnchorPosX(100, 0.2)
    self.myHero_go.rectTransform:DOAnchorPosX(150, 0.2)
end

local function HideMyHero(self)
    if not self.showingMyHero then
        return
    end
    self.showingMyHero = false
    --self.myHero_go:SetActive(false)
    self.heroContent_sv:MoveItemByIndex(0, 0)
    --self.skill_list_go:SetActive(true)
    self.skill_list_go:SetActive(false)
    self:RefreshHeroCellEffect()
    self.hero_list_go.rectTransform:DOAnchorPosX(0, 0.2)
    self.myHero_go.rectTransform:DOAnchorPosX(-150, 0.2)
end

--有任务目标时
local function TaskTipRefresh(self)
    self.task_tip:SetActive(self.taskInfo)
    if self.taskInfo then
        if tonumber(self.buildId) == BuildingTypes.FUN_BUILD_MAIN or tonumber(self.buildId) == BuildingTypes.FUN_BUILD_RADAR_CENTER then
            self.task_tipDesc:SetLocalText(170480,self.taskInfo.para2)
        else
            self.task_tipDesc:SetLocalText(170481,self.taskInfo.para2)
        end
        self.timerTask = TimerManager:GetInstance():DelayInvoke(function()
            self.task_tip:SetActive(false)
        end, 3)
        self.taskInfo = nil
    end
end

local function RefreshMyHeroUuidList(self)
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    local skillId = skillIdList[self.selectSkillIndex]
    local heroDataDict = DataCenter.HeroDataManager:GetMasterHeroList()
    local heroDataList = {}
    for _, heroData in pairs(heroDataDict) do
        table.insert(heroDataList, heroData)
    end
    local campA = nil
    local campB = nil
    table.sort(heroDataList, function(heroDataA, heroDataB)
        local stationStateA = DataCenter.HeroStationManager:GetHeroStationState(self.stationId, heroDataA.uuid)
        local stationStateB = DataCenter.HeroStationManager:GetHeroStationState(self.stationId, heroDataB.uuid)
        if stationStateA ~= stationStateB then
            return stationStateA < stationStateB
        else
            local valA = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(skillId, heroDataA.uuid))
            local valB = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(skillId, heroDataB.uuid))
            if valA ~= valB then
                return valA > valB
            end
        end
        campA = heroDataA:GetCamp()
        campB = heroDataB:GetCamp()
        
        if heroDataA.level ~= heroDataB.level then
            return heroDataA.level > heroDataB.level
        elseif heroDataA.quality ~= heroDataB.quality then
            return heroDataA.quality > heroDataB.quality
        elseif campA ~= campB then
            return campA < campB
        else
            return heroDataA.heroId < heroDataB.heroId
        end
    end)
    
     -- 同类英雄只显示最高的，已驻扎除外
    local tempDict = {}
    self.myHeroUuidList = {}
    for _, heroData in ipairs(heroDataList) do
        if tempDict[heroData.heroId] == nil then
            tempDict[heroData.heroId] = true
            table.insert(self.myHeroUuidList, heroData.uuid)
        else
            local stationState = DataCenter.HeroStationManager:GetHeroStationState(self.stationId, heroData.uuid)
            if stationState == HeroStationState.Current then
                table.insert(self.myHeroUuidList, heroData.uuid)
            end
        end
    end
end

local function OnItemClick(self, index)
    local heroUuid = self.myHeroUuidList[index]
    local stationState = DataCenter.HeroStationManager:GetHeroStationState(self.stationId, heroUuid)
    
    -- 点击已驻扎在当前建筑的，从当前建筑移除
    if stationState == HeroStationState.Current then
        local heroIndex = DataCenter.HeroStationManager:GetStationHeroIndex(self.stationId, heroUuid)
        DataCenter.HeroStationManager:RemoveStationHero(self.stationId, heroIndex)
        self:PlayHeroAnim(heroIndex, HeroCellAnim.Delete)
        self:SetHero(heroIndex, nil)
        self:RefreshHeroItems()
        self:RefreshSkill(false)
    
    -- 点击闲置的，驻扎至当前建筑
    elseif stationState == HeroStationState.Idle then
        if self.selectHeroIndex == FULL_HERO_INDEX then
            local level = 0
            local buildId = self.buildId
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil then
                level = buildData.level
            end
            UIUtil.ShowTips(Localization:GetString("162006", 
                    Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name"))))
            return
        end
        DataCenter.HeroStationManager:SetStationHero(self.stationId, self.selectHeroIndex, heroUuid)
        self:PlayHeroAnim(self.selectHeroIndex, HeroCellAnim.Select)
        self:SetHero(self.selectHeroIndex, heroUuid)
        self:RefreshHeroItems()
        self:RefreshSkill(false)
    
    -- 点击已驻扎在其他建筑的，从其他建筑移除，驻扎至当前建筑
    elseif stationState == HeroStationState.Other then
        if self.selectHeroIndex == FULL_HERO_INDEX then
            local level = 0
            local buildId = self.buildId
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
            if buildData ~= nil then
                level = buildData.level
            end
            UIUtil.ShowTips(Localization:GetString("162006",
                    Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name"))))
            return
        end
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        local heroName = HeroUtils.GetHeroNameByConfigId(heroData.heroId)
        local otherStationId = DataCenter.HeroStationManager:GetHeroStationId(heroUuid)
        local otherBuildId = DataCenter.HeroStationManager:GetBuildIdByStationId(otherStationId)
        local level = 0
        local buildId = otherBuildId
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData ~= nil then
            level = buildData.level
        end
        local tip = Localization:GetString("162005", heroName, Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + level,"name")))
        UIUtil.ShowMessage(tip, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            local heroIndex = DataCenter.HeroStationManager:GetStationHeroIndex(otherStationId, heroUuid)
            DataCenter.HeroStationManager:RemoveStationHero(otherStationId, heroIndex)
            DataCenter.HeroStationManager:SetStationHero(self.stationId, self.selectHeroIndex, heroUuid)
            self:PlayHeroAnim(self.selectHeroIndex, HeroCellAnim.Select)
            self:SetHero(self.selectHeroIndex, heroUuid)
            self:RefreshHeroItems()
            self:RefreshSkill(false)
        end)
    
    -- 点击已有同名英雄驻扎的，提示
    elseif stationState == HeroStationState.Namesake then
        UIUtil.ShowTips(Localization:GetString("162004"))
    
    -- 点击不可用的，无
    elseif stationState == HeroStationState.Disabled then
        -- nothing
    end
end

local function OnSkillClick(self, index)
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    local skillCount = table.count(skillIdList)
    if index <= skillCount then
        self.selectSkillIndex = index
        self:RefreshHero()
        self:RefreshSkill(true)
    else
        UIUtil.ShowTips(Localization:GetString("120105"))
    end
end

-- 读取当前每个英雄的效果值
local function LoadValCacheDict(self)
    local valCacheDict = DataCenter.HeroStationManager:GetStationHeroValCacheDict(self.stationId)
    if table.IsNullOrEmpty(valCacheDict) then
        if self.isArrow then
            self:AddTimer()
        end
        return
    end
    
    local stationData = DataCenter.HeroStationManager:GetStationData(self.stationId)
    local heroUuids = stationData:GetHeroUuids()
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    local skillId = skillIdList[1]
    local dataList = {}
    local addition = Mathf.Round(DataCenter.HeroStationManager:GetSkillAddition(skillId))
    local oldTotalVal, newTotalVal = addition, addition
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        local heroUuid = heroUuids[i]
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroUuid ~= nil and valCacheDict[heroUuid] ~= nil then
            local valCache = valCacheDict[heroUuid]
            local oldVal = Mathf.Round(valCache.val)
            local newVal = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(skillId, heroUuid))
            oldTotalVal = oldTotalVal + oldVal
            newTotalVal = newTotalVal + newVal
            if newVal > oldVal then
                -- 效果提升展示
                local data =
                {
                    heroUuid = heroUuid,
                    skillId = skillId,
                    old = valCache,
                    new =
                    {
                        quality = heroData.quality,
                        level = heroData.level,
                        rank = heroData.curMilitaryRankId,
                        val = newVal,
                    }
                }
                table.insert(dataList, data)
            end
        end
    end
    if not table.IsNullOrEmpty(dataList) then
        self.skill_val_text:SetNum(oldTotalVal)
        self.val_up:SetActive(true)
        self.val_up:SetData(dataList)
        self.val_up:SetCallback(function()
            if newTotalVal > oldTotalVal then
                self.skill_glow_particle:Play()
                self.skill_val_text:TweenToNum(newTotalVal, TWEEN_NUM_DURATION, TWEEN_NUM_DELAY, TWEEN_NUM_SCALE)
            else
                self.skill_val_text:TweenToNum(newTotalVal, TWEEN_NUM_DURATION)
            end
            if self.isArrow then
                self:AddTimer()
            end
        end)
        self:SaveValCacheDict()
    else
        if self.isArrow then
            self:AddTimer()
        end
    end
end

-- 保存当前每个英雄的效果值
local function SaveValCacheDict(self)
    local valCacheDict = {}
    local stationData = DataCenter.HeroStationManager:GetStationData(self.stationId)
    local heroUuids = stationData:GetHeroUuids()
    local skillIdList = DataCenter.HeroStationManager:GetSkillIdListByStationId(self.stationId, false)
    for i = 1, DataCenter.HeroStationManager.HERO_COUNT do
        local heroUuid = heroUuids[i]
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroUuid ~= nil then
            valCacheDict[heroUuid] =
            {
                quality = heroData.quality,
                level = heroData.level,
                rank = heroData.curMilitaryRankId,
                val = Mathf.Round(DataCenter.HeroStationManager:GetSkillEffectValue(skillIdList[1], heroUuid)),
            }
        end
    end
    DataCenter.HeroStationManager:SetStationHeroValCacheDict(self.stationId, valCacheDict)
end

local function HeroStationSaveSignal(self, stationId)
    if self.stationId == stationId then
        self:RefreshHero()
        self:RefreshSkill()
    end
end

local function LookAtBuilding(self)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
    local worldPos = buildData:GetCenterVec()
    
    -- 黑幕位置
    local rtf = self.black_go.rectTransform
    local offsetY, scaleX, scaleY, zoom = 0, 1, 1, 23
    if self.buildId == BuildingTypes.FUN_BUILD_MAIN then
        offsetY = 100
        scaleX = 1.75
        scaleY = 1.5
        zoom = 20
    elseif self.buildId == BuildingTypes.FUN_BUILD_BARRACKS then
        offsetY = 100
        scaleX = 1.75
        scaleY = 1.5
        zoom = 20
    elseif self.buildId == BuildingTypes.FUN_BUILD_HERO_MONUMENT then
        offsetY = 100
        scaleX = 1.75
        scaleY = 1.5
        zoom = 20
    end
    rtf.anchoredPosition = Vector2.New(0, offsetY)
    rtf.localScale = Vector2.New(scaleX, scaleY, 1)
    GoToUtil.GotoPos(worldPos, zoom, 0.2)
end

UIHeroStation.OnCreate = OnCreate
UIHeroStation.OnDestroy = OnDestroy
UIHeroStation.OnEnable = OnEnable
UIHeroStation.OnDisable = OnDisable
UIHeroStation.ComponentDefine = ComponentDefine
UIHeroStation.ComponentDestroy = ComponentDestroy
UIHeroStation.DataDefine = DataDefine
UIHeroStation.DataDestroy = DataDestroy
UIHeroStation.OnAddListener = OnAddListener
UIHeroStation.OnRemoveListener = OnRemoveListener

UIHeroStation.OnClose = OnClose
UIHeroStation.OnInitItem = OnInitItem
UIHeroStation.OnUpdateItem = OnUpdateItem
UIHeroStation.OnDestroyItem = OnDestroyItem
UIHeroStation.RefreshHeroItems = RefreshHeroItems
UIHeroStation.ReInitHeroScroll = ReInitHeroScroll
UIHeroStation.ClearHeroScroll = ClearHeroScroll
UIHeroStation.RefreshRecruit = RefreshRecruit

UIHeroStation.SetStationId = SetStationId
UIHeroStation.RefreshHero = RefreshHero
UIHeroStation.RefreshHeroCellEffect = RefreshHeroCellEffect
UIHeroStation.RefreshSkill = RefreshSkill
UIHeroStation.GetFirstSelectableHeroIndex = GetFirstSelectableHeroIndex
UIHeroStation.SetHero = SetHero
UIHeroStation.PlayHeroAnim = PlayHeroAnim
UIHeroStation.OnHeroSelectClick = OnHeroSelectClick
UIHeroStation.OnHeroDeleteClick = OnHeroDeleteClick
UIHeroStation.OnHeroLevelUpClick = OnHeroLevelUpClick
UIHeroStation.ShowMyHero = ShowMyHero
UIHeroStation.HideMyHero = HideMyHero
UIHeroStation.RefreshMyHeroUuidList = RefreshMyHeroUuidList
UIHeroStation.OnItemClick = OnItemClick
UIHeroStation.OnSkillClick = OnSkillClick
UIHeroStation.HeroStationSaveSignal = HeroStationSaveSignal
UIHeroStation.LoadValCacheDict = LoadValCacheDict
UIHeroStation.SaveValCacheDict = SaveValCacheDict
UIHeroStation.AddTimer = AddTimer
UIHeroStation.DelTimer = DelTimer
UIHeroStation.RefreshTime = RefreshTime
UIHeroStation.TaskTipRefresh = TaskTipRefresh
UIHeroStation.LookAtBuilding = LookAtBuilding

return UIHeroStation