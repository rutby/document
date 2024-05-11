
local UIHeroSkillAdvanceView = BaseClass("UIHeroSkillAdvanceView", UIBaseView)
local base = UIBaseView
local UIHeroMilitarySkillIcon = require "UI.UIHero2.UIHeroMilitaryRank.Component.UIHeroMilitarySkillIcon"

local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
    local heroUuid, skillId = self:GetUserData()
    self.heroUuid = heroUuid
    self.skillId = skillId
    self:ComponentDefine()
    self:RefreshView()
end

local function OnDestroy(self)
    self.callback = nil
    self.coreHeroData = nil
    
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UIText, "UICommonMidPopUpTitle/bg_mid/titleText")
    self.textTitle:SetLocalText(150134)
    local panelClose = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
    panelClose:SetOnClick(BindCallback(self, self.OnBtnCancelClick))

    local btnClose = self:AddComponent(UIButton, "CloseBtn1")
    btnClose:SetOnClick(BindCallback(self, self.OnBtnCancelClick))
    --self.updateEffect = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/Top/Glow1")
    --self.updateEffect:SetActive(false)
    self.content = self:AddComponent(UIBaseContainer, 'Root/ScrollView/Viewport/Content')

    self.skill1Btn = self:AddComponent(UIHeroMilitarySkillIcon, "Root/ScrollView/Viewport/Content/Top/SkillItem")
    self.nextLevelText = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/Top/nextLevelText")
    self.currentLevelText = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/Top/currentLevelText")
    
    self.btnConfirm = self:AddComponent(UIButton, "Root/BtnConfirm")
    self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnConfirmClick))
    local textConfirm = self:AddComponent(UIText, "Root/BtnConfirm/TextConfirm")
    textConfirm:SetLocalText(100091)

    local exchangeBtn = self:AddComponent(UIButton, "Root/NodeMedal")
    exchangeBtn:SetOnClick(BindCallback(self, self.OnBtnExchangeClick))
    self.exchangeText = self:AddComponent(UIText, "Root/NodeMedal/TextMedalExchange")
    
    self.nodeAttr1 = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1")
    self.nodeAttr2 = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3")
    self.nodeAttr3 = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4")
    self.textTitleMaxLevel      = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextTitleMaxLevel")
    self.textValueCurMaxLevel   = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextValueCurMaxLevel")
    self.textValueNextMaxLevel  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr1/TextValueNextMaxLevel")
    
    self.textTitleAttack     = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextTitleAttack")
    self.textValueCurAttack  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextValueCurAttack")
    self.textValueNextAttack = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr3/TextValueNextAttack")
    
    self.textTitleDefence     = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextTitleDefence")
    self.textValueCurDefence  = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextValueCurDefence")
    self.textValueNextDefence = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/InfoChange/ImgBgAttr4/TextValueNextDefence")
    
    self.medalCostText = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/MedalCost/MedalCostText")
    self.medalNumText = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content/MedalCost/MedalNumText")
    self.medalIcon = self:AddComponent(UIImage, "Root/ScrollView/Viewport/Content/MedalCost/ImgIcon")
    self.medalIcon1 = self:AddComponent(UIImage, "Root/NodeMedal")
    self.slider = self:AddComponent(UISlider, "Root/ScrollView/Viewport/Content/MedalCost/Slider")
    self.medalCostText:SetLocalText(140046)
    self.textTitleMaxLevel:SetLocalText(150135) 
    self.textTitleAttack:SetLocalText(150101) 
    self.textTitleDefence:SetLocalText(150102)
end

local function ComponentDestroy(self)
    self.textTitle = nil
    self.content  = nil
    self.topHero1 = nil
    self.topHero2 = nil

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
end

local function OnBtnConfirmClick(self)
    --self.updateEffect:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.HeroSkillUpgrade, self.heroUuid, self.skillId)
end

local function OnBtnCancelClick(self)
    self.ctrl:CloseSelf()
end

local function RefreshView(self)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData ~= nil then
        local costMedalId = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, 'skill_levelup_item')
        local costMedalNum = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, 'skill_levelup_num')
        local currentNum = DataCenter.ItemData:GetItemCount(costMedalId)
        
        local skillData = heroData:GetSkillData(self.skillId)
        if skillData.level > table.count(costMedalNum) then
            self.ctrl:CloseSelf()
            return
        end
        local needNum = costMedalNum[skillData.level]
        self.medalNumText:SetText(currentNum.."/"..needNum)
        local value = currentNum / needNum
        value = math.min(1, math.max(0, value))
        self.slider:SetValue(value)
        local canUpgrade = currentNum >= needNum
        CS.UIGray.SetGray(self.btnConfirm.transform, not canUpgrade, canUpgrade)

        local template = DataCenter.ItemTemplateManager:GetItemTemplate(costMedalId)
        self.medalIcon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))

        if template.para1 ~= nil and template.para1 ~= '' then
            local have1 = DataCenter.ItemData:GetItemCount(template.para1)
            self.exchangeText:SetText(string.GetFormattedSeperatorNum(have1))
            local template1 = DataCenter.ItemTemplateManager:GetItemTemplate(template.para1)
            self.medalIcon1:LoadSprite(string.format(LoadPath.ItemPath, template1.icon))
        end
        
        local currentSkillLv = heroData:GetSkillLevel(self.skillId)
        local nextSkillLv = currentSkillLv + 1
        self.skill1Btn:SetData(self.skillId, currentSkillLv, false, 0.5, false, true)
        self.nextLevelText:SetText(nextSkillLv)
        self.currentLevelText:SetText(currentSkillLv)

        local powerStr = GetTableData(TableName.SkillTab, self.skillId, 'power')
        local powerVec = string.split(powerStr, "|")
        local effectStr = GetTableData(TableName.SkillTab, self.skillId, 'effect_num_des')
        local effectNumStr = GetTableData(TableName.SkillTab, self.skillId, 'effect_des')
        
        local setEffect = function(effectNameText, text1, text2, effectId, effect1, effect2)
            if effectNameText ~= nil and effectId ~= nil then
                local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
                effectNameText:SetLocalText(nameStr)
            end
            text1:SetText(effect1)
            text2:SetText(effect2)
        end
        
        local effectVec = string.split(effectStr, "|")
        local effectValueVec = string.split(effectNumStr, "|")
        
        local currentEffectValue = string.split(effectValueVec[currentSkillLv], ";")
        local nextEffectValue = string.split(effectValueVec[nextSkillLv], ";")
        setEffect(nil, self.textValueCurMaxLevel, self.textValueNextMaxLevel, nil, powerVec[currentSkillLv], powerVec[nextSkillLv])
        self.nodeAttr2:SetActive(false)
        self.nodeAttr3:SetActive(false)

        if table.count(effectVec) == table.count(currentEffectValue) and table.count(effectVec) == table.count(nextEffectValue) then
            local total = table.count(effectVec)
            if total >= 1 then
                self.nodeAttr2:SetActive(true)
                setEffect(self.textTitleAttack, self.textValueCurAttack, self.textValueNextAttack, effectVec[1], currentEffectValue[1], nextEffectValue[1])
            end
            if total >= 2 then
                self.nodeAttr3:SetActive(true)
                setEffect(self.textTitleDefence, self.textValueCurDefence, self.textValueNextDefence, effectVec[2], currentEffectValue[2], nextEffectValue[2])
            end
        end
    end
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

local function OnBtnExchangeClick(self)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)

    local costMedalId = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, 'skill_levelup_item')
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(costMedalId)
    local para1 = template and template.para1

    local costMedalNum = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, 'skill_levelup_num')
    local skillData = heroData:GetSkillData(self.skillId)
    local needNum = costMedalNum[skillData.level]

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMedalExchange, para1, costMedalId, heroData.heroId, needNum)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroMedalExchanged, self.OnMedalChange)
    self:AddUIListener(EventId.HeroStationUpdate, self.OnMedalChange)
    self:AddUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroMedalExchanged, self.OnMedalChange)
    self:RemoveUIListener(EventId.HeroStationUpdate, self.OnMedalChange)
    self:RemoveUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
    base.OnRemoveListener(self)
end

local function OnMedalChange(self)
    self:RefreshView()
end

local function OnHandleSkillUpgrade(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillAdvanceSuccess, self.heroUuid, self.skillId)
end

UIHeroSkillAdvanceView.OnAddListener = OnAddListener
UIHeroSkillAdvanceView.OnRemoveListener = OnRemoveListener
UIHeroSkillAdvanceView.OnCreate= OnCreate
UIHeroSkillAdvanceView.OnDestroy = OnDestroy
UIHeroSkillAdvanceView.OnEnable = OnEnable
UIHeroSkillAdvanceView.OnDisable = OnDisable
UIHeroSkillAdvanceView.ComponentDefine = ComponentDefine
UIHeroSkillAdvanceView.ComponentDestroy = ComponentDestroy
UIHeroSkillAdvanceView.OnHandleSkillUpgrade = OnHandleSkillUpgrade
UIHeroSkillAdvanceView.OnBtnSkillClick = OnBtnSkillClick
UIHeroSkillAdvanceView.OnBtnConfirmClick = OnBtnConfirmClick
UIHeroSkillAdvanceView.OnBtnCancelClick = OnBtnCancelClick
UIHeroSkillAdvanceView.OnBtnExchangeClick = OnBtnExchangeClick
UIHeroSkillAdvanceView.RefreshView = RefreshView
UIHeroSkillAdvanceView.OnMedalChange = OnMedalChange
return UIHeroSkillAdvanceView
