---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/25 17:31
---

local UIGarageRefit = BaseClass("UIGarageRefit", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIGarageRefitItem = require "UI.UIGarageRefit.Component.UIGarageRefitItem"
local UIGarageRefitItemTip = require "UI.UIGarageRefit.Component.UIGarageRefitItemTip"
--local UIGarageRefitUpgrade = require "UI.UIGarageRefit.Component.UIGarageRefitUpgrade"
local UIGarageRefitTroopUpgrade = require "UI.UIGarageRefit.Component.UIGarageRefitTroopUpgrade"

local bg_path = "UICommonFullTop/Bg2"
local back_path = "UICommonFullTop/CloseBtn"
--local title_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local hero_path = "UICommonFullTop/Bg2/HeroList/HeroSlot_%s/UIHeroCellSmall_%s"
local hero_lock_path = "UICommonFullTop/Bg2/HeroList/HeroSlot_%s/HeroLock_%s"
local hero_lock_text_path = "UICommonFullTop/Bg2/HeroList/HeroSlot_%s/HeroLock_%s/HeroLockText_%s"
local hero_add_path = "UICommonFullTop/Bg2/HeroList/HeroSlot_%s/HeroEmpty_%s"
local car_path = "UICommonFullTop/Bg2/middle/CarImage"
local car_glow1_path = "UICommonFullTop/Bg2/middle/CarGlow1"
local car_glow2_path = "middle/CarGlow2"
local name_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local info_path = "UICommonFullTop/imgTitle/Info"
local level_path = "UICommonFullTop/Bg2/bottom/Level"
local slider_path = "UICommonFullTop/Bg2/bottom/Slider"
local progress_path = "UICommonFullTop/Bg2/bottom/Slider/Progress"
local crit_path = "UICommonFullTop/Bg2/bottom/Crit"
local max_text_path = "UICommonFullTop/Bg2/bottom/max_text"
local upgrade_btn_path = "UICommonFullTop/Bg2/bottom/UpgradeBtn"
local upgrade_text_path = "UICommonFullTop/Bg2/bottom/UpgradeBtn/layout/UpgradeText"
local upgrade_desc_path = "UICommonFullTop/Bg2/bottom/UpgradeBtn/layout/UpgradeDesc"
local upgrade_cost_path = "UICommonFullTop/Bg2/bottom/UpgradeBtn/layout/UpgradeDesc/UpgradeCost"
local upgrade_res_path = "UICommonFullTop/Bg2/bottom/UpgradeBtn/layout/UpgradeDesc/UpgradeCost/UpgradeRes"
local multi_upgrade_bg_path = "UICommonFullTop/Bg2/bottom/MultiUpgradeBg"
local multi_upgrade_btn_path = "UICommonFullTop/Bg2/bottom/MultiUpgradeBg/MultiUpgradeBtn"
local multi_upgrade_text_path = "UICommonFullTop/Bg2/bottom/MultiUpgradeBg/MultiUpgradeBtn/MultiUpgradeText"
local part_path = "UICommonFullTop/Bg2/middle/UIGarageRefitItem_%s"
local part_tip_path = "UIGarageRefitItemTip"
--local upgrade_panel_path = "UIGarageRefitUpgrade"
local troop_upgrade_panel_path = "UIGarageRefitTroopUpgrade"
local troop_btn_path = "UICommonFullTop/Bg2/bottom/Troop"
local troop_count_path = "UICommonFullTop/Bg2/bottom/Troop/TroopCount"
local goldIcon_path = "UICommonFullTop/gold_btn/goldIcon"
local txtGoldNum_path = "UICommonFullTop/gold_btn/gold_num_text"
local gold_btn_path = "UICommonFullTop/gold_btn"


local HERO_COUNT = 5
local PART_COUNT = 4
local PROGRESS_DURATION = 1
local MULTI_UPGRADE_TIMES = 5

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.bg_btn = self:AddComponent(UIButton, bg_path)
    self.bg_btn:SetOnClick(BindCallback(self, self.CloseTip))
    self.back_btn = self:AddComponent(UIButton, back_path)
    -- self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    -- self.title_text:SetLocalText(140323)
    self.back_btn:SetOnClick(BindCallback(self, self.Close))
    self.heroes = {}
    self.hero_lock_gos = {}
    self.hero_lock_texts = {}
    self.hero_add_btns = {}
    self.hero_add_btns2 = {}
    for i = 1, HERO_COUNT do
        self.heroes[i] = self:AddComponent(UIHeroCellSmall, string.format(hero_path, i, i))
        self.hero_lock_gos[i] = self:AddComponent(UIBaseContainer, string.format(hero_lock_path, i, i))
        self.hero_lock_texts[i] = self:AddComponent(UITextMeshProUGUIEx, string.format(hero_lock_text_path, i, i, i))
        self.hero_add_btns[i] = self:AddComponent(UIButton, string.format(hero_add_path, i, i))
        self.hero_add_btns[i]:SetOnClick(BindCallback(self, self.OnAddClick))
        self.hero_add_btns2[i] = self:AddComponent(UIButton, string.format(hero_path, i, i))
        self.hero_add_btns2[i]:SetOnClick(BindCallback(self, self.OnAddClick))
    end
    self.car_image = self:AddComponent(UIImage, car_path)
    --self.car_glow1_particle = self.transform:Find(car_glow1_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    --self.car_glow2_particle = self.transform:Find(car_glow2_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.progress_text = self:AddComponent(UITweenNumberText_TextMeshPro, progress_path)
    self.crit_text = self:AddComponent(UITextMeshProUGUIEx, crit_path)
    self.max_text = self:AddComponent(UITextMeshProUGUIEx, max_text_path)
    self.max_text:SetLocalText(150072)
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(BindCallback(self, self.OnUpgradeClick))
    self.upgrade_text = self:AddComponent(UITextMeshProUGUIEx, upgrade_text_path)
    self.upgrade_desc_go = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, upgrade_desc_path)
    self.upgrade_cost_text = self:AddComponent(UITextMeshProUGUIEx, upgrade_cost_path)
    self.upgrade_res_image = self:AddComponent(UIImage, upgrade_res_path)
    self.multi_upgrade_bg_go = self:AddComponent(UIBaseContainer, multi_upgrade_bg_path)
    self.multi_upgrade_btn = self:AddComponent(UIButton, multi_upgrade_btn_path)
    self.multi_upgrade_btn:SetOnClick(BindCallback(self, self.OnMultiUpgradeClick))
    self.multi_upgrade_text = self:AddComponent(UITextMeshProUGUIEx, multi_upgrade_text_path)
    self.parts = {}
    for type = 1, PART_COUNT do
        self.parts[type] = self:AddComponent(UIGarageRefitItem, string.format(part_path, type))
        self.parts[type]:SetOnClick(function()
            self:OnPartClick(type)
        end)
    end
    self.part_tip = self:AddComponent(UIGarageRefitItemTip, part_tip_path)
    --self.upgrade_panel = self:AddComponent(UIGarageRefitUpgrade, upgrade_panel_path)
    self.troop_upgrade_panel = self:AddComponent(UIGarageRefitTroopUpgrade, troop_upgrade_panel_path)
    self.troop_btn = self:AddComponent(UIButton, troop_btn_path)
    self.troop_btn:SetOnClick(BindCallback(self, self.OnTroopClick))
    self.troop_count_text = self:AddComponent(UITextMeshProUGUIEx, troop_count_path)
    self:ShowExtraRes(true)
    
    self.goldIcon = self:AddComponent(UIImage, goldIcon_path)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(GearItemId)
    self.goldIcon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
    self.txtGoldNum = self:AddComponent(UITextMeshProUGUIEx, txtGoldNum_path)
    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoodsBtnClick()
    end)
    
end

local function ComponentDestroy(self)
    self:ShowExtraRes(false)
end

local function DataDefine(self)
    self.garage = 0
    self.formation = nil
    self.refitData = nil -- 假的，会被服务器返回值覆盖
    self.restFreeCount = 0 -- 假的，会被服务器返回值覆盖
    self.upgradedOnce = false
    self.oldRefitData = nil
    self.refitCount = 0
    self.modifyTemplate = nil
    self.seq = nil
    self.maxLevel = 0
    self.critSeq = nil
    self.targetLv = false
    self.timer_callback = function() 
        self:TimerCallback()
    end
end

local function DataDestroy(self)
    self:DeleteTimer()
    self.garage = nil
    self.formation = nil
    self.refitData = nil
    self.restFreeCount = nil
    self.upgradedOnce = nil
    self.oldRefitData = nil
    self.refitCount = nil
    self.modifyTemplate = nil
    if self.seq ~= nil then
        self.seq:Kill()
    end
    self.seq = nil
    self.maxLevel = nil
    if self.critSeq then
        self.critSeq:Kill()
    end
    self.critSeq = nil
    self.targetLv = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GarageRefitUpdate, self.Refresh)
    self:AddUIListener(EventId.ResourceUpdated, self.RefreshCost)
    self:AddUIListener(EventId.RefreshItems, self.RefreshCost)
    self:AddUIListener(EventId.ArmyFormationSave, self.RefreshHeroList)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GarageRefitUpdate, self.Refresh)
    self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshCost)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshCost)
    self:RemoveUIListener(EventId.ArmyFormationSave, self.RefreshHeroList)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.garage, self.targetLv = self:GetUserData()
    self.upgradedOnce = false
    
    self:Refresh(nil, true)
    self:AddTimer()
    self:RefreshGold()
end

local function ShowExtraRes(self, show)
    if show then
        local param = {}
        param.list = {}
        param.uiName = UIWindowNames.UIGarageRefit
        param.itemList = DataCenter.GarageRefitManager.showItemList
        EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
    else
        EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIGarageRefit)
    end
end

local function Refresh(self, message, isInit)
    self:SendGarageRefitMessage()
    local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
    if self.garage == BuildingTypes.FUN_BUILD_TRAINFIELD_4 then
        garageIndex = 4
    end
    self.refitData = DataCenter.GarageRefitManager:GetGarageRefitDataCopy(self.garage)
    if self.refitData == nil then
        Logger.LogError("UIGarageRefitView, Refresh, refitData = null")
        return
    end
    
    self.modifyTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level)
    if self.modifyTemplate == nil then
        Logger.LogError("UIGarageRefitView, Refresh, modifyTemplate = null")
        return
    end
    self.maxLevel = DataCenter.GarageRefitManager:GetMaxLevel()
    self.restFreeCount = DataCenter.GarageRefitManager:GetGarageFreeCount(self.garage)
    
    for type = 1, PART_COUNT do
        local part = self.refitData.parts[type]
        self.parts[type]:SetData(part)
    end
    self.name_text:SetLocalText(140328, garageIndex)
    if garageIndex == 4 then
        self.max_text:SetLocalText(321404)
        self.upgrade_btn:SetActive(false)
        self.max_text:SetActive(true)
    else
        self.max_text:SetLocalText(150072)
        self.upgrade_btn:SetActive(self.refitData.level < self.maxLevel)
        self.max_text:SetActive(self.refitData.level == self.maxLevel)
    end
    
    
    local effect, troopVal = DataCenter.GarageRefitManager:GetAdditionalEffect(self.garage, self.refitData.level)
    if effect ~= nil then
        self.troop_btn:SetActive(true)
        self.troop_count_text:SetText("+" .. troopVal)
    else
        self.troop_btn:SetActive(false)
    end
    
    self:RefreshHeroList()
    self:RefreshExp(isInit)
    self:RefreshCost(isInit)
    
    if isInit then
        self.upgrade_btn:SetInteractable(true)
        self.multi_upgrade_btn:SetInteractable(true)
    end
    
    if message and message.power then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_CombatPowerUp)
        local pic = "Assets/Main/Sprites/UI/UIMain/UIMain_icon_power.png"
        local pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Power)
        UIUtil.DoFly(tonumber(RewardType.POWER), 3, pic, self.car_image.transform.position + Vector3.New(-350, 0, 0), pos)
        --EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
    end
    
    -- 检查升级
    if message and not table.IsNullOrEmpty(message.upgrade) and self.oldRefitData then
        --self.car_glow1_particle:Play()
        --self.car_glow2_particle:Play()
        TimerManager:GetInstance():DelayInvoke(function()
            self:ShowUpgradePanel(self.oldRefitData, message.upgrade)
            self.upgrade_btn:SetInteractable(true)
            self.multi_upgrade_btn:SetInteractable(true)
        end, 0.01)
    end
    self.oldRefitData = self.refitData
    
    -- 暴击种子
    local uid = math.tointeger(LuaEntry.Player.uid)
    local seed = (uid % 122420729 + self.refitData.level * 61 + self.refitData.exp * 83 + self.garage * 151) & 0x7fffffff
    DataCenter.GarageRefitManager.apsRandom:SetSeed(seed)

    if self.targetLv then
        local param = {}
        param.arrowType = ArrowType.Capacity
        param.positionType = PositionType.Screen
        param.position = self.upgrade_btn.transform.position
        DataCenter.ArrowManager:ShowArrow(param)
        self.targetLv = nil
    end
end

local function RefreshHeroList(self)
    self.formation = self.ctrl:GetFormation(self.garage)
    if self.formation == nil then
        Logger.LogError("UIGarageRefitView, Refresh, formation = null")
        return
    end
    if self.formation.state == ArmyFormationState.Free then
        DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.formation.uuid)
    end
    local formationForm = DataCenter.ArmyFormationDataManager:GetArmyFormInfoByUuid(self.formation.uuid)
    local heroUuidList = {}
    local showHeroes = false
    local armyInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.formation.uuid)
    if armyInfo ~= nil then
        showHeroes = self.ctrl:ShowFormationHeroes(self.formation)
    end
    
    if showHeroes then
        for heroUuid, i in pairs(formationForm:GetCurHeroes()) do
            heroUuidList[i] = heroUuid
        end
    else
        for i = 1, HERO_COUNT do
            heroUuidList[i] = nil
        end
    end
    
    for i = 1, HERO_COUNT do
        local heroUuid = heroUuidList[i]
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroUuid and heroData then
            self.heroes[i]:SetActive(true)
            self.heroes[i]:SetData(heroUuid)
           -- self.heroes[i]:SetStarActive(false)
            self.hero_lock_gos[i]:SetActive(false)
            self.hero_add_btns[i]:SetActive(false)
        else
            self.heroes[i]:SetActive(false)
            local unlockLevel = DataCenter.GarageRefitManager:GetSlotUnlockLevel(self.garage, i)
            if self.refitData.level >= unlockLevel then
                self.hero_lock_gos[i]:SetActive(false)
                self.hero_add_btns[i]:SetActive(self.formation.state == ArmyFormationState.Free)
            else
                local lockStr = "Lv." .. unlockLevel .. "\n" .. Localization:GetString("130056")
                self.hero_lock_gos[i]:SetActive(true)
                self.hero_lock_texts[i]:SetText(lockStr)
                self.hero_add_btns[i]:SetActive(false)
            end
        end
    end
end

local function RefreshExp(self, isInit)
    if isInit then
        if self.refitData.level < self.maxLevel then
            self.progress_text:SetSuffix("%")
            local percent = self.refitData.exp / self.modifyTemplate:getValue("exp")
            self.progress_text:SetNum(math.ceil(percent * 100))
            self.slider:SetValue(percent)
            self.level_text:SetText("Lv." .. self.refitData.level)
        else
            self.progress_text:SetLocalText(150072)
            self.slider:SetValue(1)
            self.level_text:SetText("Lv." .. self.refitData.level)
        end
    else
        self:TweenToProgress()
    end
end

local function RefreshCost(self, isInit)
    if self.refitData.level < self.maxLevel then
        local isFree = true
        local isEnough = true
        if self.restFreeCount <= 0 then
            if self.modifyTemplate:getValue("money") ~=nil and self.modifyTemplate:getValue("money") > 0 then
                self.upgrade_cost_text:SetText(self.modifyTemplate:getValue("money"))
                self.upgrade_res_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Money))
                isFree = false
                isEnough = LuaEntry.Resource:GetCntByResType(ResourceType.Money) >= self.modifyTemplate:getValue("money")
            else
                local itemId, count = DataCenter.GarageRefitManager:GetCostItem(self.garage, self.refitData.level)
                if itemId ~= nil and count > 0 then
                    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                    local itemData = DataCenter.ItemData:GetItemById(itemId)
                    local itemCount = itemData and itemData.count or 0
                    self.upgrade_cost_text:SetText(count)
                    self.upgrade_res_image:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
                    isFree = false
                    isEnough = itemCount >= count
                end
            end
        end

        if isFree then
            self.upgrade_text:SetLocalText(130126)
            self.upgrade_cost_text:SetText(self.restFreeCount .. "/" .. DataCenter.GarageRefitManager:GetFreeCount())
            self.upgrade_res_image:SetActive(false)
            self.upgrade_desc_go:SetPaddingLeft(0)
        else
            self.upgrade_text:SetLocalText(100091)
            self.upgrade_res_image:SetActive(true)
            self.upgrade_desc_go:SetPaddingLeft(44)
        end

        self.upgrade_cost_text:SetColor(isEnough and WhiteColor or ButtonRedTextColor)
        
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgrade_btn.rectTransform)
    end
    self:RefreshMultiUpgrade(isInit)
    self:RefreshGold()
end

local function RefreshGold(self)
    local itemCount = DataCenter.ItemData:GetItemCount(GearItemId)
    self.txtGoldNum:SetText(string.GetFormattedSeperatorNum(itemCount))
end

local function RefreshMultiUpgrade(self, isInit)
    local showMulti = false
    local k = isInit and LuaEntry.DataConfig:TryGetNum("car_modify", "k7") or 1
    if self.modifyTemplate:getValue("money") ~=nil and self.modifyTemplate:getValue("money") > 0 then
        local playerMoney = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
        showMulti = playerMoney > self.modifyTemplate:getValue("money") * k * MULTI_UPGRADE_TIMES
    else
        local itemId, count = DataCenter.GarageRefitManager:GetCostItem(self.garage, self.refitData.level)
        if itemId ~= nil and count > 0 then
            local itemData = DataCenter.ItemData:GetItemById(itemId)
            local itemCount = itemData and itemData.count or 0
            showMulti = itemCount > count * k * MULTI_UPGRADE_TIMES
        end
    end
    self.multi_upgrade_bg_go:SetActive(showMulti and self.upgradedOnce)
    self.multi_upgrade_text:SetText("x" .. MULTI_UPGRADE_TIMES)
end

local function TweenToProgress(self)
    local curLevel = tonumber(string.sub(self.level_text:GetText(), 4)) or self.refitData.level
    local template = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, curLevel)
    if template == nil then
        return
    end
    local curExp = self.progress_text:GetCurNum() or (self.refitData.exp / template:getValue("exp"))
    self.progress_text:SetSuffix("%")
    
    if self.seq ~= nil then
        self.seq:Kill()
    end
    
    if curLevel < self.refitData.level then
        local duration = PROGRESS_DURATION / (self.refitData.level - curLevel + 1) * (100 - curExp) / 100
        self.progress_text:TweenToNum(100, duration)
        self.seq = DOTween.Sequence()
        :Append(self.slider.unity_uislider:DOValue(1, duration))
        :AppendCallback(function()
            -- 进入下一级
            if curLevel + 1 < self.maxLevel then
                self.progress_text:SetNum(0)
                self.slider:SetValue(0)
                self.level_text:SetText("Lv." .. (curLevel + 1))
                self:TweenToProgress()
            else
                self.progress_text:SetLocalText(150072)
                self.slider:SetValue(1)
                self.level_text:SetText("Lv." .. self.maxLevel)
            end
        end)
    elseif curLevel == self.refitData.level then
        local percent = self.refitData.exp / template:getValue("exp")
        local intPercent = math.ceil(percent * 100)
        local duration = PROGRESS_DURATION * (intPercent - curExp) / 100
        self.progress_text:TweenToNum(intPercent, duration)
        self.seq = DOTween.Sequence()
        :Append(self.slider.unity_uislider:DOValue(percent, duration))
    else
        local percent = self.refitData.exp / template:getValue("exp")
        self.progress_text:SetNum(math.ceil(percent * 100))
        self.slider:SetValue(percent)
        self.level_text:SetText("Lv." .. self.refitData.level)
    end
end

local function Close(self)
    self:SendGarageRefitMessage()
    self:CloseTip()
    self.ctrl:CloseSelf()
end

local function Upgrade(self, times)
    local succ = true
    
    local useFreeCount = math.min(self.restFreeCount, times)
    local costTimes = times - useFreeCount
    
    if self.modifyTemplate:getValue("money")~=nil and self.modifyTemplate:getValue("money") > 0 then
        local playerMoney = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
        local costMoney = self.modifyTemplate:getValue("money") * costTimes
        if playerMoney >= costMoney then
            LuaEntry.Resource:UpdateResource({ ["money"] = playerMoney - costMoney })
            succ = true
        else
            UIUtil.ShowTipsId(120450)
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Res
            param.id = ResourceType.Money
            param.targetNum = costMoney
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab)
            succ = false
        end
    else
        local itemId, count = DataCenter.GarageRefitManager:GetCostItem(self.garage, self.refitData.level)
        if itemId ~= nil and count > 0 then
            local costCount = count * costTimes
            local itemData = DataCenter.ItemData:GetItemById(itemId)
            local itemCount = itemData and itemData.count or 0
            if itemCount >= costCount then
                if itemData and costCount > 0 then
                    itemData.count = itemData.count - costCount
                end
                self:ShowExtraRes(true)
                succ = true
            else
                UIUtil.ShowTipsId(120021)
                local lackTab = {}
                local param = {}
                param.type = ResLackType.Item
                param.id = itemId
                param.targetNum = costCount
                table.insert(lackTab, param)
                GoToResLack.GoToItemResLackList(lackTab)
                succ = false
            end
        end
    end
    
    if succ then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Garage_Upgrade)
        local factor = 1
        for i = 1, times do
            factor = DataCenter.GarageRefitManager:GetExpCritFactor()
            self.refitData.exp = self.refitData.exp + self.modifyTemplate:getValue("add_exp") * factor
        end
        self.refitCount = self.refitCount + times
        self.restFreeCount = self.restFreeCount - useFreeCount
        self.upgradedOnce = true
        self:RefreshExp(false)
        self:RefreshCost(false)
        if self.refitData.exp >= self.modifyTemplate:getValue("exp") then
            self.upgrade_btn:SetInteractable(false)
            self.multi_upgrade_btn:SetInteractable(false)
            self:SendGarageRefitMessage()
        end
        if factor > 1 then
            self.crit_text:SetLocalText(140332, factor)
            self.crit_text:SetColor(Color.New(1, 1, 1, 0))
            self.critSeq = DOTween.Sequence()
            :Append(self.crit_text.unity_text:DOFade(1, 0.1))
            :AppendInterval(1)
            :Append(self.crit_text.unity_text:DOFade(0, 0.3))
        end
    else
        self:SendGarageRefitMessage()
    end
    self:CloseTip()
end

local function OnUpgradeClick(self)
    self:Upgrade(1)
end

local function OnMultiUpgradeClick(self)
    self:Upgrade(MULTI_UPGRADE_TIMES)
end

local function OnPartClick(self, type)
    local part = self.refitData.parts[type]
    if part then
        if self.part_tip.active then
            self.part_tip:OnClose()
        end
        self.part_tip:SetActive(true)
        self.part_tip:SetData(part, self.parts[part.type].gameObject)
    end
end

local function OnAddClick(self)
    if self.formation.state == ArmyFormationState.Free then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, self.formation.uuid, -1, -1, 0, -1, 1, 0, nil, 1)
        --self.ctrl:CloseSelf()
    end
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("170001"), Localization:GetString("302027"), Localization:GetString("140334"))
    self:CloseTip()
end

local function OnTroopClick(self)
    self:CloseTip()
    local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
    local effect, val = DataCenter.GarageRefitManager:GetAdditionalEffect(self.garage, self.refitData.level)
    local effectDesc = GetTableData(TableName.EffectNumDesc, effect, 'des')
    local param = {}
    param.type = "desc"
    --param.title = Localization:GetString("140328", garageIndex)
    param.desc = Localization:GetString(effectDesc) .. " +" .. val .. "\n" .. Localization:GetString("140406")
    param.alignObject = self.troop_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function CloseTip(self)
    self.part_tip:OnClose()
end

local function SendGarageRefitMessage(self)
    if self.refitCount == 0 then
        return
    end
    
    local param =
    {
        uuid = self.refitData.uuid,
        count = self.refitCount,
    }
    SFSNetwork.SendMessage(MsgDefines.GarageRefit, param)
    self.refitCount = 0
end

local function ShowUpgradePanel(self, refitData, typeList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGarageRefitUpgradeTip, NormalPanelAnim, {refitData = refitData, typeList = typeList})
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoticeEquipTips, { anim = true, playEffect = false })
    
    local leftTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level - 1)
    local rightTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level)
    local showTroopUpgrade = false
    if leftTemplate == nil and rightTemplate ~= nil then
        showTroopUpgrade = true
    elseif leftTemplate ~= nil and rightTemplate ~= nil then
        local leftEffect, leftVal = DataCenter.GarageRefitManager:GetAdditionalEffect(self.garage, self.refitData.level - 1)
        local rightEffect, rightVal = DataCenter.GarageRefitManager:GetAdditionalEffect(self.garage, self.refitData.level)
        if leftEffect ~= rightEffect or leftVal ~= rightVal then
            showTroopUpgrade = true
        end
    end

    if showTroopUpgrade then
        local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
        self.troop_upgrade_panel:SetData(leftTemplate, rightTemplate, garageIndex)
        -- new
        TimerManager:GetInstance():DelayInvoke(function()
            self.troop_upgrade_panel:SetActive(true)
        end, 0.5)
    else
    end
end

local function OnKeyEscape(self)
    self:Close()
end

function UIGarageRefit:OnGoodsBtnClick()
    if self.refitData.level < self.maxLevel then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.id = GearItemId
        local itemId, count = DataCenter.GarageRefitManager:GetCostItem(self.garage, self.refitData.level)
        param.targetNum = count
        table.insert(lackTab,param)
        GoToResLack.GoToItemResLackList(lackTab)
    end
end

function UIGarageRefit:AddTimer()
    self:DeleteTimer()
    local restTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if restTime > 0 then
        self.timer = TimerManager:GetInstance():GetTimer(restTime, self.timer_callback, self, true, false, false)
        self.timer:Start()
    end
end

function UIGarageRefit:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIGarageRefit:TimerCallback()
    self:DeleteTimer()
    self:Refresh(nil, true)
end

UIGarageRefit.OnCreate = OnCreate
UIGarageRefit.OnDestroy = OnDestroy
UIGarageRefit.OnEnable = OnEnable
UIGarageRefit.OnDisable = OnDisable
UIGarageRefit.ComponentDefine = ComponentDefine
UIGarageRefit.ComponentDestroy = ComponentDestroy
UIGarageRefit.DataDefine = DataDefine
UIGarageRefit.DataDestroy = DataDestroy
UIGarageRefit.OnAddListener = OnAddListener
UIGarageRefit.OnRemoveListener = OnRemoveListener

UIGarageRefit.ReInit = ReInit
UIGarageRefit.ShowExtraRes = ShowExtraRes
UIGarageRefit.Refresh = Refresh
UIGarageRefit.RefreshHeroList = RefreshHeroList
UIGarageRefit.RefreshExp = RefreshExp
UIGarageRefit.RefreshCost = RefreshCost
UIGarageRefit.RefreshMultiUpgrade = RefreshMultiUpgrade
UIGarageRefit.TweenToProgress = TweenToProgress
UIGarageRefit.Close = Close
UIGarageRefit.Upgrade = Upgrade
UIGarageRefit.OnUpgradeClick = OnUpgradeClick
UIGarageRefit.OnMultiUpgradeClick = OnMultiUpgradeClick
UIGarageRefit.OnPartClick = OnPartClick
UIGarageRefit.OnAddClick = OnAddClick
UIGarageRefit.OnInfoClick = OnInfoClick
UIGarageRefit.OnTroopClick = OnTroopClick
UIGarageRefit.CloseTip = CloseTip
UIGarageRefit.SendGarageRefitMessage = SendGarageRefitMessage
UIGarageRefit.ShowUpgradePanel = ShowUpgradePanel
UIGarageRefit.RefreshGold = RefreshGold
UIGarageRefit.OnKeyEscape = OnKeyEscape

return UIGarageRefit