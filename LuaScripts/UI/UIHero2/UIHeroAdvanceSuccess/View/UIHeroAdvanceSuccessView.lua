---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/6/28 下午6:48
---


local UIHeroAdvanceSuccessView = BaseClass("UIHeroAdvanceSuccessView", UIBaseView)
local base = UIBaseView

local Localization = CS.GameEntry.Localization
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIHeroSlot = require("UI.UIHero2.UIHeroAdvanceSuccess.Component.UIHeroSlot")

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self.heroUuid = self:GetUserData()
    self:RefreshAdvance()
    self:ShowEnterAnimation()
end

local function ShowEnterAnimation(self)
    self.animator:SetTrigger('show')
end

local function RefreshSuccess(self, message)
    self.message = message
    HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    self.heroSlots:SetActive(false)
    self.successTopHero1:SetData(self.heroUuid, nil ,nil, true)
    self.successTopHero2:SetData(self.heroUuid, nil ,nil, true)
    self.successTopHero3:SetData(self.heroUuid, nil ,nil, true)
    self.successTopHero1:SetQuality(heroData.quality - 1, not heroData.isMaster)

    self:RefreshAttr(heroData.quality - 1, heroData.quality)
    
    local ret, time = self.animator:GetAnimationReturnTime('V_ui_hero_advance_success_advance_xiaoshi')
    if ret then
        self.animator:SetTrigger('success')
        TimerManager:GetInstance():DelayInvoke(function()
            self.advance:SetActive(false)
            self.success:SetActive(true)
            self.caidai:SetActive(true)
            if heroData.quality % 2 == 0 then
                self.half_effect:SetActive(true)
                self.one_effect:SetActive(false)
                self.half_effect.transform.position = self.successTopHero3:GetLastStarPos()
            else
                self.one_effect.transform.position = self.successTopHero3:GetLastStarPos()
                self.one_effect:SetActive(true)
                self.half_effect:SetActive(false)
            end
        end, time + 0.1)
    else
        if heroData.quality % 2 == 0 then
            self.half_effect:SetActive(true)
            self.one_effect:SetActive(false)
            self.half_effect.transform.position = self.successTopHero3:GetLastStarPos()
        else
            self.one_effect.transform.position = self.successTopHero3:GetLastStarPos()
            self.one_effect:SetActive(true)
            self.half_effect:SetActive(false)
        end
        self.advance:SetActive(false)
        self.success:SetActive(true)
    end
end

local function RefreshAdvance(self)
    self.success:SetActive(false)
    self.advance:SetActive(true)
    self.heroSlots:SetActive(true)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    self.half_effect:SetActive(false)
    self.one_effect:SetActive(false)
    self.advanceTopHero1:SetData(self.heroUuid)
    self.advanceTopHero2:SetData(self.heroUuid)
    self.advanceTopHero2:SetQuality(heroData.quality + 1, not heroData.isMaster)

    self.coreHeroSlot:SetData(self.heroUuid)
    self.coreHeroSlot:SetCampActive(false)
    local consumeDataMap = DeepCopy(HeroAdvanceController:GetInstance():GetCurConsumeMap())
    local requireNum = HeroAdvanceController:GetInstance():GetCurAdvanceRequireNum()
    local consume = heroData:GetAdvanceConsume()
    local sameHeroQuality, sameHeroNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Hero)
    local sameCampQuality, sameCampNum = consume:GetConditionByType(HeroAdvanceConsumeType.ConsumeType_Same_Camp)
    sameHeroNum = sameHeroNum or 0
    sameCampNum = sameCampNum or 0

    for k=1, requireNum do
        local slot = self.consumeObjList[k]
        if k <= sameHeroNum then
            slot:SetData(consumeDataMap[k], HeroAdvanceConsumeType.ConsumeType_Same_Hero, sameHeroQuality)
        else
            slot:SetData(consumeDataMap[k], HeroAdvanceConsumeType.ConsumeType_Same_Camp, sameCampQuality)
        end
        slot:SetActive(true)
    end

    for k=requireNum+1, HeroUtils.ConsumeSlotMax do
        self.consumeObjList[k]:SetActive(false)
    end
    
    self:RefreshAttr(heroData.quality, heroData.quality + 1)
end

local function RefreshAttr(self, fromQuality, toQuality)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local curAttack, curDefence = heroData:GetAttrByQuality(fromQuality)
    local nextAttack, nextDefence = heroData:GetAttrByQuality(toQuality)
    local curTroop = HeroUtils.GetArmyLimit(heroData.level, heroData:GetCurMilitaryRankId(), heroData.rarity, heroData.heroId, fromQuality)
    local nextTroop = HeroUtils.GetArmyLimit(heroData.level, heroData:GetCurMilitaryRankId(), heroData.rarity, heroData.heroId, toQuality)

    self.textValueCurAttack:SetText(Mathf.Round(curAttack))
    self.textValueNextAttack:SetText(Mathf.Round(nextAttack))
    self.textValueCurDefence:SetText(Mathf.Round(curDefence))
    self.textValueNextDefence:SetText(Mathf.Round(nextDefence))
    self.textValueCurTroop:SetText(Mathf.Round(curTroop))
    self.textValueNextTroop:SetText(Mathf.Round(nextTroop))
    if not HeroUtils.IsNewMaxLevel() then
        local curLvMax = HeroUtils.GetMaxLevelByQuality(heroData.heroId, fromQuality)
        local nextLvMax = HeroUtils.GetMaxLevelByQuality(heroData.heroId, toQuality)
        self.textValueCurLevel:SetText(Mathf.Round(curLvMax))
        self.textValueNextLevel:SetText(Mathf.Round(nextLvMax))
    else
        self.level:SetActive(false)
    end

    local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
    local k5 = LuaEntry.DataConfig:TryGetNum("power_setting", "k5")
    if k5 <=0 then
        k5 = 1
    end
    self.textValueCurMaxPower:SetText(Mathf.Round(Mathf.Pow((curAttack + curDefence),k5) * k1))
    self.textValueNextMaxPower:SetText(Mathf.Round(Mathf.Pow((nextAttack + nextDefence),k5) * k1))
    --self.nodeAttr0:SetActive(heroData.isMaster)
    --self.nodeAttr1:SetActive(Mathf.Round(curLvMax) ~= Mathf.Round(nextLvMax))
end

local function OnDestroy(self)
    --recover pos
    self.nodeAttr2:SetPosition(self.attrPos2)
    self.nodeAttr3:SetPosition(self.attrPos3)
    
    self:ComponentDestroy()
    base.OnDestroy(self)

    self.callback = nil
end

local function ComponentDefine(self)
    local btnClose = self:AddComponent(UIButton, "Panel")
    btnClose:SetOnClick(BindCallback(self, self.OnCancelCore))
    
    --success 
    self.success = self:AddComponent(UIBaseContainer, "Root/success")
    self.successTopHero1 = self:AddComponent(UIHeroCell, "Root/success/SuccessTopHero1")
    self.successTopHero2 = self:AddComponent(UIHeroCell, "Root/success/SuccessTopHero2")
    self.successTopHero3 = self:AddComponent(UIHeroCell, "Root/success/SuccessTopHero3")

    self.textTitleSuccess = self:AddComponent(UIText, "Root/success/TextTitleSuccess")
    self.clickAnyWhere = self:AddComponent(UIText, "Root/success/ClickAnyWhere")
    self.textTitleSuccess:SetLocalText(129219)
    self.clickAnyWhere:SetLocalText(129074)
    self.half_effect = self:AddComponent(UIBaseContainer, "Root/success/VFX_ui_shengxing_half")
    self.one_effect = self:AddComponent(UIBaseContainer, "Root/success/VFX_ui_shengxing_one")
    self.half_effect:SetActive(false)
    self.one_effect:SetActive(false)
    self.caidai = self:AddComponent(UIBaseContainer, "VFX_ui_heroadvancesuccess_caidai")
    self.caidai:SetActive(false)
    --advance
    self.advance = self:AddComponent(UIBaseContainer, "Root/advance")
    self.advanceTopHero1 = self:AddComponent(UIHeroCell, "Root/advance/AdvanceTopHero1")
    self.advanceTopHero2 = self:AddComponent(UIHeroCell, "Root/advance/AdvanceTopHero2")
    self.advanceTitle = self:AddComponent(UIText, "Root/advance/AdvanceTitle")
    self.advanceTitle:SetLocalText(150134)
    self.advanceBtn = self:AddComponent(UIButton, "Root/advance/BtnAdvance")
    self.advanceBtnText = self:AddComponent(UIText, "Root/advance/BtnAdvance/BtnAdvanceText")
    self.advanceBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        --self:RefreshSuccess()
        self:OnAdvanceClick()
    end)
    self.advanceBtnText:SetLocalText(150115)
    --attr
    self.nodeAttr1 = self:AddComponent(UIBaseContainer, 'Root/layout/ImgBgAttr1')
    self.nodeAttr2 = self:AddComponent(UIBaseContainer, 'Root/layout/ImgBgAttr2')
    self.nodeAttr3 = self:AddComponent(UIBaseContainer, 'Root/layout/ImgBgAttr3')
    
    self.attrPos1 = self.nodeAttr1:GetPosition()
    self.attrPos2 = self.nodeAttr2:GetPosition()
    self.attrPos3 = self.nodeAttr3:GetPosition()

    self.nodeAttr0 = self:AddComponent(UIBaseContainer, "Root/layout/ImgBgAttr0")
    self.textValueCurMaxPower  = self:AddComponent(UIText, "Root/layout/ImgBgAttr0/aim0/TextValueCurMaxPower")
    self.textValueNextMaxPower = self:AddComponent(UIText, "Root/layout/ImgBgAttr0/aim0/TextValueNextMaxPower")
    self.TextTitlePower = self:AddComponent(UIText, "Root/layout/ImgBgAttr0/aim0/TextTitlePower")
    self.TextTitlePower:SetLocalText(100644)
    self.level = self:AddComponent(UIBaseContainer, "Root/layout/ImgBgAttr1/aim1")
    self.textTitleMaxLevel    = self:AddComponent(UIText, "Root/layout/ImgBgAttr1/aim1/TextTitleMaxLevel")
    self.textTitleMaxLevel:SetLocalText(129112)
    self.textValueCurLevel  = self:AddComponent(UIText, "Root/layout/ImgBgAttr1/aim1/TextValueCurMaxLevel")
    self.textValueNextLevel = self:AddComponent(UIText, "Root/layout/ImgBgAttr1/aim1/TextValueNextMaxLevel")

    self.textTitleAttack     = self:AddComponent(UIText, "Root/layout/ImgBgAttr2/aim2/TextTitleAttack")
    self.textValueCurAttack  = self:AddComponent(UIText, "Root/layout/ImgBgAttr2/aim2/TextValueCurAttack")
    self.textValueNextAttack = self:AddComponent(UIText, "Root/layout/ImgBgAttr2/aim2/TextValueNextAttack")

    self.textTitleDefence      = self:AddComponent(UIText, "Root/layout/ImgBgAttr3/aim3/TextTitleDefence")
    self.textValueCurDefence   = self:AddComponent(UIText, "Root/layout/ImgBgAttr3/aim3/TextValueCurDefence")
    self.textValueNextDefence  = self:AddComponent(UIText, "Root/layout/ImgBgAttr3/aim3/TextValueNextDefence")
    
    self.textTitleTroop      = self:AddComponent(UIText, "Root/layout/ImgBgAttr4/aim4/TextTitleTroop")
    self.textValueCurTroop   = self:AddComponent(UIText, "Root/layout/ImgBgAttr4/aim4/TextValueCurTroop")
    self.textValueNextTroop  = self:AddComponent(UIText, "Root/layout/ImgBgAttr4/aim4/TextValueNextTroop")
    
    self.nodeSkill = self:AddComponent(UIBaseContainer, 'Root/NodeSkill')
    self.imgSkillIcon = self:AddComponent(UIImage, "Root/NodeSkill/SkillBg/IconSkill")
    self.textTitleSkill = self:AddComponent(UIText, "Root/NodeSkill/TextTitleSkill")
    self.textValueSkill = self:AddComponent(UIText, "Root/NodeSkill/TextValueSkill")
    self.textTitleSkill:SetLocalText(161009)
    self.nodeSkill:SetActive(false)

    self.textTitleAttack:SetLocalText(150101) 
    self.textTitleDefence:SetLocalText(150102)
    self.textTitleTroop:SetLocalText(100508)

    self.animator = self:AddComponent(UIAnimator, '')

    self.heroSlots = self:AddComponent(UIBaseContainer, "ObjHero")
    self.coreHeroSlot = self:AddComponent(UIHeroCell, "ObjHero/HeroAdvanceContent/UIAdvanceCore/UIHeroCellSmall")
    local btnCoreHero = self:AddComponent(UIButton, "ObjHero/HeroAdvanceContent/UIAdvanceCore/CoreClose")
    btnCoreHero:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnCancelCore()
    end)

    self.consumeObjList = {}
    for i = 1, HeroUtils.ConsumeSlotMax do
        local slot = self:AddComponent(UIHeroSlot, "ObjHero/HeroAdvanceContent/ConsumeSlot" .. i)
        slot:SetParent(self)
        self.consumeObjList[i] = slot
    end
end

local function OnCancelCore(self)
    HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
    self:PlayCloseAni()
end

local function OnToggleDogFood(self, uuid)
    HeroAdvanceController:GetInstance():OnToggleDogFood(uuid)
    self:PlayCloseAni()
end

local function ComponentDestroy(self)
    self.textTitle = nil
    self.textTitleAttack     = nil
    self.textValueCurAttack  = nil
    self.textValueNextAttack = nil
    self.textTitleDefence     = nil
    self.textValueCurDefence  = nil
    self.textValueNextDefence = nil
end

local function OnEnable(self)
    base.OnEnable(self)

    local message = self.message
    if message ~= nil then
        local retItems = message["retItem"] or {}
        if message["money"] ~= nil then
            table.insert(retItems, {["id"]= ResourceType.Money, ["add"] =message["money"]})
        end

        if next(retItems) ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetSuccess, nil, retItems, true)
        end
    end
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroAdvanceSuccess, self.RefreshSuccess)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.RefreshSuccess)
end

local function PlayCloseAni(self)
    local ret, time = self.animator:GetAnimationReturnTime('V_ui_hero_advance_success_hide')
    if ret then
        self.animator:SetTrigger('close')
        TimerManager:GetInstance():DelayInvoke(function()
            self.ctrl:CloseSelf()
        end, time)
    else
        self.ctrl:CloseSelf()
    end
end



local function OnAdvanceClick(self)
    if not HeroAdvanceController:GetInstance():IsConsumeFull() then
        return
    end

    local function Confirm()
        local coreHeroUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
        local consumeMap = HeroAdvanceController:GetInstance():GetCurConsumeMap()
        --SFSNetwork.SendMessage(MsgDefines.HeroAdvance, coreHeroUuid, table.values(consumeMap))
        self.ctrl:DoWhenAdvance(coreHeroUuid, table.values(consumeMap))
    end

    local function OptimalCheck()
        local coreHeroUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
        local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(coreHeroUuid)
        local rarity = coreHeroData.rarity
        local nextQuality = coreHeroData.quality + 1

        if rarity ~=  HeroUtils.RarityType.S and rarity ~= HeroUtils.RarityType.A then
            Confirm()
            return
        end

        local ret, uuid = DataCenter.HeroDataManager:IsTheOptimalHeroInSameId(coreHeroData)
        if ret then
            Confirm()
            return
        end

        local optimalHeroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)

        --当玩家拥有[橙]品质以上的【S】将时，狗粮不能再进阶到【橙】品质以上
        local express1 = rarity == HeroUtils.RarityType.S and optimalHeroData.quality > 6 and nextQuality > 6
        --当玩家拥有红+品质以上的A将时，狗粮不能再进阶到红+品质以上
        local express2 = rarity == HeroUtils.RarityType.A and optimalHeroData.quality > 9 and nextQuality > 9

        --当玩家拥有红+品质以上的a将时，狗粮不能再进阶到红+品质以上
        if express1 or express2 then
            local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(optimalHeroData.rarity), optimalHeroData:GetName())
            UIUtil.ShowMessage(Localization:GetString("129127", heroName), 1, GameDialogDefine.CONFIRM)
            return
        end

        --当玩家此heroId的最佳英雄是紫+品质以上的s或a将时，相同英雄进阶到紫+品质以上时进行提示
        if optimalHeroData.quality > 5 and nextQuality > 5 then
            local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(optimalHeroData.rarity), optimalHeroData:GetName())
            UIUtil.ShowMessage(Localization:GetString("129126", heroName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, Confirm)
            return
        end

        Confirm()
    end

    --狗粮稀有度检查
    local function CheckRarityOfConsume()
        --检查是否有s或a级其他英雄被消耗
        local ret, str = HeroAdvanceController:GetInstance():HasRaritySOrAHeroInConsume()
        if ret then
            --UIUtil.ShowMessage(Localization:GetString('129128', str), 2, '', '', OptimalCheck)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceRarityConfirm, OptimalCheck)
        else
            OptimalCheck()
        end
    end

    --检查是否有驻扎英雄被消耗
    local ret, _, buildNames = HeroAdvanceController:GetInstance():HasStationedHeroInConsume()
    if ret then
        local buildName = buildNames[1]
        UIUtil.ShowMessage(Localization:GetString("162011", buildName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, CheckRarityOfConsume)
    else
        CheckRarityOfConsume()
    end
end

UIHeroAdvanceSuccessView.OnCreate= OnCreate
UIHeroAdvanceSuccessView.OnDestroy = OnDestroy
UIHeroAdvanceSuccessView.OnEnable = OnEnable
UIHeroAdvanceSuccessView.OnDisable = OnDisable
UIHeroAdvanceSuccessView.ComponentDefine = ComponentDefine
UIHeroAdvanceSuccessView.ComponentDestroy = ComponentDestroy
UIHeroAdvanceSuccessView.PlayCloseAni = PlayCloseAni
UIHeroAdvanceSuccessView.OnAdvanceClick = OnAdvanceClick
UIHeroAdvanceSuccessView.RefreshSuccess = RefreshSuccess
UIHeroAdvanceSuccessView.RefreshAdvance = RefreshAdvance
UIHeroAdvanceSuccessView.RefreshAttr = RefreshAttr
UIHeroAdvanceSuccessView.OnAddListener = OnAddListener
UIHeroAdvanceSuccessView.OnRemoveListener = OnRemoveListener
UIHeroAdvanceSuccessView.ShowEnterAnimation = ShowEnterAnimation
UIHeroAdvanceSuccessView.OnCancelCore = OnCancelCore
UIHeroAdvanceSuccessView.OnToggleDogFood = OnToggleDogFood

return UIHeroAdvanceSuccessView