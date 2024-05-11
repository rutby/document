--- Created by shimin
--- DateTime: 2023/7/14 14:56
--- 英雄插件详情界面

local UIHeroPluginInfoView = BaseClass("UIHeroPluginInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroPluginQualityCell = require "UI.UIHeroPluginInfo.Component.UIHeroPluginQualityCell"
local UIHeroInfoPlugin = require "UI.UIHero2.UIHeroInfo.Component.UIHeroInfoPlugin"
local UIHeroPluginDesRandomWithoutCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesRandomWithoutCell"
local UIHeroPluginDesConstCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesConstCell"

local panel_btn_path = "Root/BtnBack"
local rank_btn_path = "Root/rank_btn"
local rank_btn_text_path = "Root/rank_btn/rank_btn_text"
local rank_text_path = "Root/rank_btn/rank_text"
local plugin_btn_path = "Root/PageRoot/LayerNormal/Align/UIHeroPluginBtn"
local quality_text_path = "Root/PageRoot/LayerNormal/Align/quality_text"
local const_go_path = "Root/PageRoot/LayerNormal/NodeAttribute/UIHeroPluginDesLayout/const_go"
local random_go_path = "Root/PageRoot/LayerNormal/NodeAttribute/UIHeroPluginDesLayout/random_go"
local quality_title_text_path = "Root/PageRoot/LayerNormal/NodeSkill/SkillTitle"
local quality_layout_path = "Root/PageRoot/LayerNormal/NodeSkill/LayerMulti"
local upgrade_btn_path = "Root/PageRoot/LayerNormal/NodeCost/BtnUpgrade"
local upgrade_btn_text_path = "Root/PageRoot/LayerNormal/NodeCost/BtnUpgrade/TextBtnUpgrade"
local refine_btn_path = "Root/PageRoot/LayerNormal/NodeCost/BtnRefine"
local refine_btn_text_path = "Root/PageRoot/LayerNormal/NodeCost/BtnRefine/BtnRefineText"
local map_btn_path = "Root/map_btn"
local map_btn_text_path = "Root/map_btn/map_btn_text"


function UIHeroPluginInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginInfoView:ComponentDefine()
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.refine_btn = self:AddComponent(UIButton, refine_btn_path)
    self.refine_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRefineBtnClick()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
    self.rank_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRankBtnClick()
    end)
    self.rank_btn_text = self:AddComponent(UIText, rank_btn_text_path)
    self.plugin_btn = self:AddComponent(UIHeroInfoPlugin, plugin_btn_path)
    self.quality_text = self:AddComponent(UIText, quality_text_path)
    self.quality_title_text = self:AddComponent(UIText, quality_title_text_path)
    self.const_go = self:AddComponent(UIBaseContainer, const_go_path)
    self.random_go = self:AddComponent(UIBaseContainer, random_go_path)
    self.quality_layout = self:AddComponent(UIBaseContainer, quality_layout_path)
    self.upgrade_btn_text = self:AddComponent(UIText, upgrade_btn_text_path)
    self.refine_btn_text = self:AddComponent(UIText, refine_btn_text_path)
    self.rank_text = self:AddComponent(UIText, rank_text_path)
    self.map_btn = self:AddComponent(UIButton, map_btn_path)
    self.map_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMapBtnClick()
    end)
    self.map_btn_text = self:AddComponent(UIText, map_btn_text_path)
end

function UIHeroPluginInfoView:ComponentDestroy()
end

function UIHeroPluginInfoView:DataDefine()
    EventManager:GetInstance():Broadcast(EventId.ToggleHeroPreviewScene, false)
    self.uuid = 0
    self.mainDesList = {}
    self.mainDesCells = {}
    self.randomDesList = {}
    self.randomDesCells = {}
    self.qualityList = {}
    self.qualityCells = {}
end

function UIHeroPluginInfoView:DataDestroy()
    EventManager:GetInstance():Broadcast(EventId.ToggleHeroPreviewScene, true)
    self.uuid = 0
    self.mainDesList = {}
    self.mainDesCells = {}
    self.randomDesList = {}
    self.randomDesCells = {}
    self.qualityList = {}
    self.qualityCells = {}
end

function UIHeroPluginInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginInfoView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginInfoView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginInfoView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginInfoView:ReInit()
    self.uuid = self:GetUserData()
    self.upgrade_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
    self.refine_btn_text:SetLocalText(GameDialogDefine.REFINE)
    self.rank_btn_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_RANK)
    self.quality_title_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_QUALITY)
    self.map_btn_text:SetLocalText(GameDialogDefine.BUILD_BAUBLE_PAGE_NAME)
    self:Refresh()
end

function UIHeroPluginInfoView:Refresh()
    self.plugin_btn:ReInit(self.uuid)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil then
        if heroData.plugin ~= nil then
            self.quality_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(heroData.plugin.lv))
        end
        self:ShowMainDesCells()
        self:ShowRandomDesCells()
        self:ShowQualityCells()
    end
    local myRank = DataCenter.HeroPluginRankManager:GetSelfRank()
    if myRank == nil then
        self.rank_text:SetText("100+")
    else
        self.rank_text:SetText(myRank.rank)
    end
end

function UIHeroPluginInfoView:ShowMainDesCells()
    self:InitMainDesList()
    local count = #self.mainDesList
    for k, v in ipairs(self.mainDesList) do
        if self.mainDesCells[k] == nil then
            local param = {}
            self.mainDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginDesConstCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.const_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.const_go:AddComponent(UIHeroPluginDesConstCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.mainDesCells[k].visible = true
            self.mainDesCells[k].data = v
            if self.mainDesCells[k].model ~= nil then
                self.mainDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.mainDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.mainDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginInfoView:InitMainDesList()
    self.mainDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(heroData.plugin.lv)
        if list ~= nil then
            for k, v in ipairs(list) do
                local param = {}
                param.showName = v:GetConstName()
                param.showValue = v:GetConstValue()
                table.insert(self.mainDesList, param)
            end
        end
    end
end

function UIHeroPluginInfoView:ShowRandomDesCells()
    self:InitRandomDesList()
    local count = #self.randomDesList
    for k, v in ipairs(self.randomDesList) do
        if self.randomDesCells[k] == nil then
            local param = {}
            self.randomDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginInfoRandomWithoutCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.random_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.random_go:AddComponent(UIHeroPluginDesRandomWithoutCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.randomDesCells[k].visible = true
            self.randomDesCells[k].data = v
            if self.randomDesCells[k].model ~= nil then
                self.randomDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.randomDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.randomDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginInfoView:InitRandomDesList()
    self.randomDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = heroData.plugin.plugin
        if list ~= nil then
            local count = #list
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                if template ~= nil then
                    local param = {}
                    param.showName = template:GetDesc(v.level)
                    param.showLine = true
                    param.needUnlock = false
                    param.isSpecial = template:IsSpecialShow()
                    param.quality = template.rarity
                    param.isMax = template:IsMax(v.level)
                    table.insert(self.randomDesList, param)
                end
            end
            for i = count + 1, count + 10, 1 do
                local level = DataCenter.HeroPluginManager:GetLevelByNum(i)
                if level <= 0 then
                    break
                else
                    local param = {}
                    param.quality = HeroPluginQualityType.White
                    param.showName = string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(param.quality), Localization:GetString(GameDialogDefine.UN_KNOW_ATTRIBUTE))
                    param.showValue = Localization:GetString(GameDialogDefine.REACH_LEVEL_UNLOCK_WHIT, level)
                    param.showLine = true
                    param.needUnlock = true
                    param.isSpecial = false
                    param.isMax = false
                    table.insert(self.randomDesList, param)
                end
            end
            if self.randomDesList[#self.randomDesList] ~= nil then
                self.randomDesList[#self.randomDesList].showLine = false
            end
        end
    end
end

function UIHeroPluginInfoView:ShowQualityCells()
    self:InitQualityList()
    local count = #self.qualityList
    for k, v in ipairs(self.qualityList) do
        if self.qualityCells[k] == nil then
            local param = {}
            self.qualityCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginQualityCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.quality_layout.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.quality_layout:AddComponent(UIHeroPluginQualityCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.qualityCells[k].visible = true
            self.qualityCells[k].data = v
            if self.qualityCells[k].model ~= nil then
                self.qualityCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.qualityCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.qualityCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginInfoView:InitQualityList()
    self.qualityList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = DataCenter.HeroPluginManager:GetAllUnlockQuality()
        if list ~= nil then
            for k, v in ipairs(list) do
                local param = {}
                param.level = heroData.plugin.lv
                param.qualityParam = v
                param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
                table.insert(self.qualityList, param)
            end
        end
    end
end


function UIHeroPluginInfoView:OnUpgradeBtnClick()
    --去升级
    local param = {}
    param.uuid = self.uuid
    param.tabType = HeroPluginTabType.Upgrade
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgrade, { anim = true, playEffect = false }, param)
end

function UIHeroPluginInfoView:RefreshHeroPluginSignal()
    self:Refresh()
end

function UIHeroPluginInfoView:OnRefineBtnClick()
    --去随机
    local param = {}
    param.uuid = self.uuid
    param.tabType = HeroPluginTabType.Refine
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgrade, { anim = true, playEffect = false }, param)
end

function UIHeroPluginInfoView:OnRankBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList,{ anim = true, hideTop = true, isBlur = true }, RankType.HeroPluginRank)
end

function UIHeroPluginInfoView:OnMapBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgradeInfo)
end

return UIHeroPluginInfoView