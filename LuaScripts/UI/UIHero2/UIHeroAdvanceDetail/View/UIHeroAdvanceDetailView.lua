---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/6/28 下午6:48
---


local UIHeroAdvanceDetailView = BaseClass("UIHeroAdvanceDetailView", UIBaseView)
local base = UIBaseView

local Localization = CS.GameEntry.Localization
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIHeroSkillTipView = require "UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView"

local SkillSlotMax = 4

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()

    local confirmCallback = self:GetUserData()
    self.isSend = false
    self.callback = confirmCallback
    local coreHeroData = HeroAdvanceController:GetInstance():GetAdvanceHeroData()
    self.coreHeroData = coreHeroData
    local coreHeroId = coreHeroData.heroId
    
    self.topHero1:SetData(coreHeroData.uuid, nil, nil, true)
    self.topHero2:SetData(coreHeroData.uuid, nil, nil, true)
    self.topHero2:SetQuality(coreHeroData.quality + 1, not coreHeroData.isMaster)

    self.nodeAttr1:SetActive(coreHeroData.isMaster)
    local curAttack, curDefence = coreHeroData:GetAttrByQuality(coreHeroData.quality)
    local nextAttack, nextDefence = coreHeroData:GetAttrByQuality(coreHeroData.quality +1)
    local curTroop = HeroUtils.GetArmyLimit(coreHeroData.level, coreHeroData:GetCurMilitaryRankId(), coreHeroData.rarity, coreHeroData.heroId,coreHeroData.quality)
    local nextTroop = HeroUtils.GetArmyLimit(coreHeroData.level, coreHeroData:GetCurMilitaryRankId(), coreHeroData.rarity, coreHeroData.heroId,coreHeroData.quality+1)
    
    --change to power
    local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
    local k5 = LuaEntry.DataConfig:TryGetNum("power_setting", "k5")
    if k5 <=0 then
        k5 = 1
    end
    self.textValueCurMaxLevel:SetText(Mathf.Round(Mathf.Pow((curAttack + curDefence),k5) * k1))
    self.textValueNextMaxLevel:SetText(Mathf.Round(Mathf.Pow((nextAttack + nextDefence),k5) * k1))
    
    self.textValueCurAttack:SetText(Mathf.Round(curAttack))
    self.textValueNextAttack:SetText(Mathf.Round(nextAttack))
    self.textValueCurDefence:SetText(Mathf.Round(curDefence))
    self.textValueNextDefence:SetText(Mathf.Round(nextDefence))
    self.textValueCurTroop:SetText(Mathf.Round(curTroop))
    self.textValueNextTroop:SetText(Mathf.Round(nextTroop))
    if not HeroUtils.IsNewMaxLevel() then
        local curLvMax = HeroUtils.GetMaxLevelByQuality(coreHeroData.heroId, coreHeroData.quality)
        local nextLvMax = HeroUtils.GetMaxLevelByQuality(coreHeroData.heroId, coreHeroData.quality + 1)
        self.textValueCurLvMax:SetText(Mathf.Round(curLvMax))
        self.textValueNextLvMax:SetText(Mathf.Round(nextLvMax))
    else
        self.level:SetActive(false)
    end

    local consumeDataMap = HeroAdvanceController:GetInstance():GetCurConsumeMap()
    local requireNum = HeroAdvanceController:GetInstance():GetCurAdvanceRequireNum()
    for k=1, requireNum do
        local slot = self.consumeObjList[k]
        slot:SetData(consumeDataMap[k])
        slot:SetActive(true)
    end

    for k=requireNum+1, HeroUtils.ConsumeSlotMax do
        self.consumeObjList[k]:SetActive(false)
    end

    if coreHeroData.isMaster then
        local nextUnlockSkills = coreHeroData:GetNextUnlockSkills()
        self.nextUnlockSkills = nextUnlockSkills
        local unlockNums = #nextUnlockSkills
        for k, skillTable in ipairs(self.skillTables) do
            if k > unlockNums then
                skillTable.btn:SetActive(false)
                goto continue
            end

            skillTable.icon:LoadSprite(HeroUtils.GetSkillIcon(nextUnlockSkills[k]))
            skillTable.btn:SetActive(true)

            ::continue::
        end
        self.nodeSKillRoot:SetActive(unlockNums > 0)
    else
        self.nodeSKillRoot:SetActive(false)
    end
end

local function OnDestroy(self)
    self.callback = nil
    self.coreHeroData = nil
    self.isSend = nil
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg_mid/titleText")
    
    local btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/bg_mid/CloseBtn")
    btnClose:SetOnClick(BindCallback(self, self.OnBtnCancelClick))

    self.content = self:AddComponent(UIBaseContainer, 'Root/ScrollView/Viewport/Content')
    
    self.topHero1 = self:AddComponent(UIHeroCell, "Root/ScrollView/Viewport/Content/Top/TopHero1")
    self.topHero2 = self:AddComponent(UIHeroCell, "Root/ScrollView/Viewport/Content/Top/TopHero2")
    
    self.consumeObjList = {}
    for i = 1, HeroUtils.ConsumeSlotMax do
        local hero = self:AddComponent(UIHeroCell, "Root/ScrollView/Viewport/Content/InfoChange/NodeConsume/CostItemList/ConsumeHero" .. i)
        self.consumeObjList[i] = hero
    end
    
    local btnConfirm = self:AddComponent(UIButton, "Root/BtnConfirm")
    btnConfirm:SetOnClick(BindCallback(self, self.OnBtnConfirmClick))

    local btnCancel = self:AddComponent(UIButton, "Root/BtnCancel")
    btnCancel:SetOnClick(BindCallback(self, self.OnBtnCancelClick))
    
    local textConfirm = self:AddComponent(UIText, "Root/BtnConfirm/TextConfirm")
    local textCancel = self:AddComponent(UIText, "Root/BtnCancel/TextCancel")
    
    textConfirm:SetLocalText(GameDialogDefine.CONFIRM) 
    textCancel:SetLocalText(GameDialogDefine.CANCEL) 
    
    self.textTitle:SetLocalText(150134) 

    self.nodeAttr1 = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1")
    self.textTitleMaxLevel      = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextTitleMaxLevel")
    self.textValueCurMaxLevel   = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextValueCurMaxLevel")
    self.textValueNextMaxLevel  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextValueNextMaxLevel")
    
    self.textTitleLife      = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr2/TextTitleLife")
    self.textValueCurLife   = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr2/TextValueCurLife")
    self.textValueNextLife  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr2/TextValueNextLife")

    self.level = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr0")
    self.textTitleLvMax      = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr0/TextTitleLvMax")
    self.textValueCurLvMax   = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr0/TextValueCurLvMax")
    self.textValueNextLvMax  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr0/TextValueNextLvMax")

    self.textTitleAttack     = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextTitleAttack")
    self.textValueCurAttack  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextValueCurAttack")
    self.textValueNextAttack = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextValueNextAttack")
    
    self.textTitleDefence     = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextTitleDefence")
    self.textValueCurDefence  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextValueCurDefence")
    self.textValueNextDefence = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextValueNextDefence")

    self.textTitleTroop    = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr5/TextTitleTroop")
    self.textValueCurTroop  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr5/TextValueCurTroop")
    self.textValueNextTroop= self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr5/TextValueNextTroop")

    self.textTitleCost = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/NodeConsume/TextCostTitle")
    self.textTitleSkill = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/NodeSkill/TextTitleSkill")

    self.nodeSKillRoot = self:AddComponent(UIBaseContainer, 'Root/ScrollView/Viewport/Content/NodeSkill')
    
    self.skillTables = {}
    for k=1, SkillSlotMax do
        local btnSkill = self:AddComponent(UIButton, 'Root/ScrollView/Viewport/Content/NodeSkill/SkillList/Skill' .. k)
        btnSkill:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self:OnBtnSkillClick(k)
        end)

        local imgIcon = self:AddComponent(UIImage, btnSkill.transform:Find('ImgIcon' .. k))
        table.insert(self.skillTables, {btn = btnSkill, icon = imgIcon})
    end
    
    self.textTitleSkill:SetLocalText(100213)
    self.textTitleMaxLevel:SetLocalText(100644) 
    self.textTitleLife:SetLocalText(150103) 
    self.textTitleAttack:SetLocalText(150101)
    self.textTitleLvMax:SetLocalText(129112)
    self.textTitleDefence:SetLocalText(150102)
    self.textTitleTroop:SetLocalText(100508)
    self.textTitleCost:SetLocalText(150136) 
end

local function ComponentDestroy(self)
    self.textTitle = nil
    self.content  = nil
    self.topHero1 = nil
    self.topHero2 = nil
    self.consumeObjList = nil

    self.textTitleMaxLevel = nil
    self.textValueCurMaxLevel = nil
    self.textValueNextMaxLevel  = nil
    self.textTitleLife      = nil
    self.textValueCurLife   = nil
    self.textValueNextLife  = nil
    self.textTitleAttack     = nil
    self.textValueCurAttack  = nil
    self.textValueNextAttack = nil
    self.textTitleDefence     = nil
    self.textValueCurDefence  = nil
    self.textValueNextDefence = nil
    
    self.skillTables = nil
end

local function OnBtnConfirmClick(self)
    if self.isSend == true then
        return
    end
    --如果狗粮等级不为1或有升级过技能则进行二次确认
    local consumeDataMap = HeroAdvanceController:GetInstance():GetCurConsumeMap()
    local needConfirm = false
    for _, uuid in pairs(consumeDataMap) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
        if heroData ~= nil and heroData:HasCultivated() then
            needConfirm = true
            break
        end
    end

    local function confirm()
        if self.callback then
            self.callback()
        end
        self.isSend = true
        self.ctrl:CloseSelf()
    end

    if needConfirm then
        --策划要求确认按钮在右边
        UIUtil.ShowMessage(Localization:GetString("161024"), 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, function()
            confirm()
        end)
    else
        confirm()
    end
end

local function OnBtnCancelClick(self)
    self.ctrl:CloseSelf()
end

local function OnEnable(self)
    base.OnEnable(self)
    self.content.transform.localPosition = Vector3.zero
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnBtnSkillClick(self, index)
    local skillId = self.nextUnlockSkills[index]   --skillIdList[index]
    
    local btn = self.skillTables[index].btn
    --local skillId = self.skillTables[index].skillId
    local position = btn.transform.position + Vector3.New(0, 50, 0)

    local param = UIHeroSkillTipView.Param.New()
    param.content = Localization:GetString("150155")
    param.dir = UIHeroSkillTipView.Direction.ABOVE
    param.skillId = skillId
    param.skillLevel = 1
    param.pivot = 0.5
    param.position = position

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, { anim = false }, param)
end


UIHeroAdvanceDetailView.OnCreate= OnCreate
UIHeroAdvanceDetailView.OnDestroy = OnDestroy
UIHeroAdvanceDetailView.OnEnable = OnEnable
UIHeroAdvanceDetailView.OnDisable = OnDisable
UIHeroAdvanceDetailView.ComponentDefine = ComponentDefine
UIHeroAdvanceDetailView.ComponentDestroy = ComponentDestroy

UIHeroAdvanceDetailView.OnBtnSkillClick = OnBtnSkillClick
UIHeroAdvanceDetailView.OnBtnConfirmClick = OnBtnConfirmClick
UIHeroAdvanceDetailView.OnBtnCancelClick = OnBtnCancelClick


return UIHeroAdvanceDetailView
