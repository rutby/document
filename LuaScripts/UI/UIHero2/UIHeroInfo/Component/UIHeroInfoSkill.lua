---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 6/22/21 6:44 PM
---

local UIHeroInfoSkill = BaseClass("UIHeroInfoSkill", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroSkillTipView = require "UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView"
local UIHeroArkTip = require 'UI.UIHero2.UIHeroInfo.Component.UIHeroArkTip'
local UIMedalCell = require "UI.UIHero2.UIHeroMedalExchange.Component.UIMedalCell"

local UIGray = CS.UIGray
local Screen = CS.UnityEngine.Screen

local SkillSlotMax = 6
local Radius = 125


-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self.param = nil

    self:ComponentDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.btnSkills = {}
    
    self.btnArk = self:AddComponent(UIButton, 'NodeArk')
    self.imgArk = self:AddComponent(UIImage, 'NodeArk')
    self.textArk = self:AddComponent(UITextMeshProUGUIEx, 'NodeArk/TextArk')
    self.nodeArkFx = self:AddComponent(UIBaseContainer, 'NodeArk/NodeArkEffect')
    
    self.btnArk:SetOnClick(BindCallback(self, self.OnBtnArkClick))
    
    for k=1, SkillSlotMax do
        local nodeBtn = self:AddComponent(UIButton, "SkillContent/Skill" .. k)
        nodeBtn:SetOnClick(function()  
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self:OnBtnSkillClick(k)
        end)

        local imgIcon = self:AddComponent(UIImage, "SkillContent/Skill" .. k .. "/ImgIcon" .. k)
        local textLevel = self:AddComponent(UITextMeshProUGUIEx, "SkillContent/Skill" .. k .. "/TextLv" .. k)
        local nodeEffect = self:AddComponent(UIBaseContainer, "SkillContent/Skill" .. k .. "/NodeEffect" .. k)
        
        table.insert(self.btnSkills, {btn = nodeBtn, icon = imgIcon, textLv = textLevel, nodeFx = nodeEffect})
    end
    
    self.btnUpgrade = self:AddComponent(UIButton, 'BtnUpgrade')
    self.btnUpgrade:SetOnClick(BindCallback(self, self.OnBtnUpgradeClick))
    
    self.textUpgrade = self:AddComponent(UITextMeshProUGUIEx, 'BtnUpgrade/TextUpgrade')
    self.textUpgrade:SetLocalText(161002) 
    
    self.arkTipPanel = self:AddComponent(UIHeroArkTip, 'ArkTipPanel')
    self.arkTipPanel:SetActive(false)
    
    self.nodeConsume = self:AddComponent(UIBaseContainer, 'Consume')
    --self.imgItemIcon = self:AddComponent(UIImage, 'Consume/ItemBg/Mask/ImgIcon')
    self.medalCellSmall = self:AddComponent(UIMedalCell, 'Consume/UIMedalCellSmall')
    
    self.slider = self:AddComponent(UISlider, 'Consume/Slider')
    self.textSlider = self:AddComponent(UITextMeshProUGUIEx, 'Consume/Slider/TextSlider')
    self.btnAdd = self:AddComponent(UIButton, 'Consume/BtnAdd')
    self.btnAdd:SetOnClick(BindCallback(self, self.OnBtnAddClick))
    
    self.nodeMedalTip = self:AddComponent(UIBaseContainer, 'MedalTip')
    self.textConvert  = self:AddComponent(UITextMeshProUGUIEx, 'MedalTip/Root/TextConvert')
    self.medalCell    = self:AddComponent(UIMedalCell, 'MedalTip/Root/UIMedalCell')
    self.btnMedalTip  = self:AddComponent(UIButton, 'MedalTip/Root/BtnBg')
    
    self.textBottomTip = self:AddComponent(UITextMeshProUGUIEx, 'TextBottomTip')
    
    self.btnMedalTip:SetOnClick(BindCallback(self, self.OnBtnMedalTipClick))
    self.textConvert:SetLocalText(110029) 
    local btnMedalPanel = self:AddComponent(UIButton, 'MedalTip/MedalPanel')
    btnMedalPanel:SetOnClick(BindCallback(self, self.OnMedalPanelClick))

    self.textBottomTip:SetLocalText(161001)
    self.nodeMedalTip:SetActive(false)
end

--控件的销毁
local function ComponentDestroy(self)
    self.btnSkills = nil
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    self.nodeArkFx:SetActive(false)

    for _, v in pairs(self.btnSkills) do
        if v.nodeFx ~= nil then
            v.nodeFx:SetActive(false)
        end
    end
    
    
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
    self:AddUIListener(EventId.HeroMedalExchanged, self.OnMedalExchanged)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
    self:RemoveUIListener(EventId.HeroMedalExchanged, self.OnMedalExchanged)
    base.OnRemoveListener(self)
end

local function InitData(self, param)
    self.fromType = self.view:GetFromType()
    self.param = param

    local heroCfgId
    if self.fromType == self.view.FromType.HeroList then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
        heroCfgId = heroData.heroId
    elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
        heroCfgId = self.param
    end
    self.heroCfgId = heroCfgId
    
    self.btnUpgrade:SetActive(self.fromType == self.view.FromType.HeroList)
    self.nodeConsume:SetActive(self.fromType == self.view.FromType.HeroList)

    self:UpdateView()
end

local function OnBtnSkillClick(self, index)
    local config, heroData
    if self.fromType == self.view.FromType.HeroList then
        heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
        config = heroData.config
    elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
        config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param)
    end
    
    local skillIdList = config['skill']
    if type(skillIdList) ~= 'table' then
        skillIdList = string.split(skillIdList, '|')
    end
    
    local skillId = tonumber(skillIdList[index])
    local level = HeroUtils.SkillLevelLimit     --图鉴默认最大等级
    local unlockQuality = 1
    if heroData ~= nil then
        local skillData = heroData:GetSkillData(skillId)
        if skillData ~= nil then
            level = skillData.level
            unlockQuality = skillData.unlockQuality
        end
    end
    
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    
    local btn = self.btnSkills[index].btn
    local position = btn.transform.position -- + Vector3.New(0, -50, 0) * scaleFactor

    local screenPos = PosConverse.WorldToScreenPos(position)
    local dir = screenPos.y < (Screen.height/2) and UIHeroSkillTipView.Direction.ABOVE or UIHeroSkillTipView.Direction.BELOW
    
    
    local param = UIHeroSkillTipView.Param.New()
    param.content = Localization:GetString("150155")
    param.dir = dir
    param.skillId = skillId
    param.skillLevel = level
    param.skillUnlockQuality = unlockQuality
    param.pivot = 0.8--0.45 + index * 0.1
    param.position = position + Vector3.New(0,  dir == UIHeroSkillTipView.Direction.ABOVE and 55 or -50, 0) * scaleFactor
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, { anim = false }, param)
end

local function OnBtnUpgradeClick(self)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
    local costItem, costNum = HeroUtils.GetSkillUpgradeItemAndNum(heroData.heroId, heroData.upSkillNum)

    local item = DataCenter.ItemData:GetItemById(costItem)
    local have = item and item.count or 0
    if have < costNum then
        UIUtil.ShowTipsId(120021) 
        return
    end
    
    local state = heroData:GetUpgradeSkillState()
    if state ~= HeroInfo.UpgradeSkillState.CanUpgrade then
        local lang = state == HeroInfo.UpgradeSkillState.NoUnlockSkill and '150196'
                or state == HeroInfo.UpgradeSkillState.AllSKillReachMax and '150198' or '150197'
        
        UIUtil.ShowTipsId(lang) 
        
        return
    end

    local function Confirm()
        SFSNetwork.SendMessage(MsgDefines.HeroSkillUpgrade, self.param)
    end
    
    if HeroUtils.NeedCheckedOptimal then
        local ret, uuid = DataCenter.HeroDataManager:IsTheOptimalHeroInSameId(heroData)
        if not ret then
            UIUtil.ShowMessage(Localization:GetString("120993", heroData:GetName()), 2, GameDialogDefine.CONFIRM, "110036",
                    function()
                        Confirm()
                    end,
                    function()
                        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroInfo)
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, 1, uuid, {uuid})
                    end)
        else
            Confirm()
        end

        HeroUtils.NeedCheckedOptimal = false
    else
        Confirm()
    end
end

local function OnHandleSkillUpgrade(self, message)
    local heroUuid = message['heroUuid']
    local skillId  = message['skillId']
    local skillLv    = message['level']
    
    local btn = self.btnSkillsDict[skillId]
    if btn ~= nil then
        btn.nodeFx:SetActive(false)
        btn.nodeFx:SetActive(true)
    end

    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local arkTotalLv = heroData:GetArkTotalLevel()
    local lastArkId = HeroUtils.GetArkIdAndGrade(heroData.heroId, arkTotalLv - 1)
    local curArkId, curArkGrade = HeroUtils.GetArkIdAndGrade(heroData.heroId, arkTotalLv)
    local needShowArk = lastArkId ~= curArkId

    if needShowArk then
        self.nodeArkFx:SetActive(false)
        self.nodeArkFx:SetActive(true)
    end

    self:UpdateView()
    
    TimerManager:GetInstance():DelayInvoke(function() 
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillUpgradeSuccess, { anim = false }, heroData.heroId, skillId, skillLv, arkTotalLv)
    end, 1.2)
end

local function UpdateView(self)
    local config, heroData
    if self.fromType == self.view.FromType.HeroList then
        heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
        config = heroData.config
    elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
        config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param)
    end
    
    local skillArray = config['skill']
    if type(skillArray) ~= 'table' then
        skillArray = string.split(skillArray, '|')     
    end
    
    local skillCount = #skillArray

    self.btnSkillsDict = {}
    
    local angle = 360 / skillCount 
    local totalLevel = 0
    for k, t in ipairs(self.btnSkills) do
        if k> skillCount then
            t.btn:SetActive(false)
            goto continue
        end

        t.btn:SetActive(true)

        --RotateAround突然首次不生效了 改成手动计算吧
        local rad = angle * (k-1) * math.pi / 180
        local x = Radius * math.sin(rad)
        local y = Radius * math.cos(rad)
        t.btn.rectTransform:Set_localPosition(x, y, 0)

        
        local skillId = tonumber(skillArray[k])
        self.btnSkillsDict[skillId] = t
        t.icon:LoadSprite(HeroUtils.GetSkillIcon(skillId))
        
        local level = HeroUtils.SkillLevelLimit     --图鉴默认最大等级
        if heroData ~= nil then
            local skillData = heroData:GetSkillData(skillId)
            if skillData ~= nil then
                level = skillData.level
            end
        end

        UIGray.SetGray(t.btn.transform, level <= 0, true)
        totalLevel = totalLevel + level
        t.textLv:SetText(level == 0 and '' or level)
        
        ::continue::
    end

    self:UpdateArk(totalLevel)
    self:UpdateConsume()
end

local function UpdateArk(self, totalLevel)
    self.arkTotalLevel = totalLevel
    
    local arkId, arkGrade = HeroUtils.GetArkIdAndGrade(self.heroCfgId, totalLevel)
    self.imgArk:LoadSprite(HeroUtils.GetArkGradeIcon(arkGrade, true))
    self.textArk:SetText(totalLevel)
    UIGray.SetGray(self.btnArk.transform, arkGrade <= 0, true)
end

local function UpdateConsume(self)
    if self.fromType ~= self.view.FromType.HeroList then
        return
    end
    
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
    local costItemId, costItemNum = HeroUtils.GetSkillUpgradeItemAndNum(heroData.heroId, heroData.upSkillNum)

    local item = DataCenter.ItemData:GetItemById(costItemId)
    local have = item and item.count or 0

    --self.imgItemIcon:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItemId).icon))
    --self.imgItemIcon:LoadSprite(HeroUtils.GetHeroIconPath(heroData.heroId))
    self.medalCellSmall:SetData(costItemId, have)
    
    self.slider:SetValue(Mathf.Clamp01(have / costItemNum))
    self.textSlider:SetText(have .. '/' .. costItemNum)
    
    self.costItemId = costItemId
    self.costItemNum = costItemNum


    local template = DataCenter.ItemTemplateManager:GetItemTemplate(costItemId)
    local para1 = template and template.para1 or nil
    if para1 ~= nil and para1 ~= '' then

        local commonMedalData = DataCenter.ItemData:GetItemById(para1)
        local commonCount = commonMedalData and commonMedalData.count or 0
        self.medalCell:SetData(para1, commonCount)
    end
end

local function OnBtnArkClick(self)
    self.arkTipPanel:SetData(self.heroCfgId, self.arkTotalLevel)
    self.arkTipPanel:SetActive(true)
end

---点击添加道具
local function OnBtnAddClick(self)
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.costItemId)
    local para1 = template and template.para1 or nil
    if para1 == nil or para1 == '' then
        Logger.Log('#zlh# there are no items that can be exchanged!')
        return
    end

    --local template2 = DataCenter.ItemTemplateManager:GetItemTemplate(para1)
    --self.imgMedalIcon:LoadSprite(string.format(LoadPath.ItemPath, template2.icon))
    --local exchangeItemData = DataCenter.ItemData:GetItemById(para1)
    --local have = exchangeItemData and exchangeItemData.count or 0
    --self.textMedalNum:SetText(have)
    self.nodeMedalTip:SetActive(not self.nodeMedalTip.activeSelf)
end

local function OnMedalPanelClick(self)
    self.nodeMedalTip:SetActive(false)
end

local function OnBtnMedalTipClick(self)
    self.nodeMedalTip:SetActive(false)

    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.costItemId)
    local para1 = template and template.para1 or nil
    if para1 == nil or para1 == '' then
        Logger.Log('#zlh# there are no items that can be exchanged!')
        return
    end

    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMedalExchange, para1, self.costItemId, heroData.heroId, self.costItemNum)
end

local function OnMedalExchanged(self)
    self:UpdateConsume()
end

UIHeroInfoSkill.OnCreate = OnCreate
UIHeroInfoSkill.OnDestroy = OnDestroy
UIHeroInfoSkill.OnEnable = OnEnable
UIHeroInfoSkill.OnDisable = OnDisable
UIHeroInfoSkill.ComponentDefine = ComponentDefine
UIHeroInfoSkill.ComponentDestroy = ComponentDestroy
UIHeroInfoSkill.OnAddListener = OnAddListener
UIHeroInfoSkill.OnRemoveListener = OnRemoveListener

UIHeroInfoSkill.InitData = InitData
UIHeroInfoSkill.OnBtnSkillClick = OnBtnSkillClick
UIHeroInfoSkill.OnBtnUpgradeClick = OnBtnUpgradeClick
UIHeroInfoSkill.OnHandleSkillUpgrade = OnHandleSkillUpgrade
UIHeroInfoSkill.UpdateView = UpdateView
UIHeroInfoSkill.UpdateArk = UpdateArk
UIHeroInfoSkill.UpdateConsume = UpdateConsume
UIHeroInfoSkill.OnBtnArkClick = OnBtnArkClick
UIHeroInfoSkill.OnBtnAddClick = OnBtnAddClick
UIHeroInfoSkill.OnMedalPanelClick = OnMedalPanelClick
UIHeroInfoSkill.OnBtnMedalTipClick = OnBtnMedalTipClick
UIHeroInfoSkill.OnMedalExchanged = OnMedalExchanged


return UIHeroInfoSkill