--- Created by shimin
--- DateTime: 2023/7/26 19:16
--- 英雄插件升级Tab界面

local UIHeroPluginUpgradeUpgrade = BaseClass("UIHeroPluginUpgradeUpgrade", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"
local UIHeroPluginDesRandomWithCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesRandomWithCell"
local UIHeroPluginDesConstCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesConstCell"

local upgrade_btn_path = "Top/Common_btn_green_big"
local upgrade_btn_text_path = "Top/Common_btn_green_big/btnTxt_green_big_new"
local goto_text_path = "Top/Common_btn_green_big/btnTxt_yellow_big_new"
local upgrade_cost_item_btn_path = "Top/Common_btn_green_big/CostContent/CostItemCell"
local upgrade_cost_item_text_path = "Top/Common_btn_green_big/CostContent/CostItemCell/ResourceNum"
local upgrade_cost_item_img_path = "Top/Common_btn_green_big/CostContent/CostItemCell/ResourceNum/ResourceIcon"
local upgrade_cost_gold_btn_path = "Top/Common_btn_green_big/CostContent/CostGoldCell"
local upgrade_cost_gold_text_path = "Top/Common_btn_green_big/CostContent/CostGoldCell/CostGoldCellText"
local upgrade_cost_gold_img_path = "Top/Common_btn_green_big/CostContent/CostGoldCell/CostGoldCellText/CostGoldCellIcon"
local plugin_left_path = "Top/UIHeroPluginBtn"
local left_effect_go_path = "Top/EffectGo"
local left_quality_text_path = "Top/quality_text"
local left_const_go_path = "LeftContent/const_go"
local left_random_go_path = "LeftContent/random_go"
local cost_go_path = "Top/Common_btn_green_big/CostContent"

local EffectTime = 1.5

function UIHeroPluginUpgradeUpgrade:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeUpgrade:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeUpgrade:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeUpgrade:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeUpgrade:ComponentDefine()
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.upgrade_btn_text = self:AddComponent(UIText, upgrade_btn_text_path)
    self.upgrade_cost_item_btn = self:AddComponent(UIBaseContainer, upgrade_cost_item_btn_path)
    self.upgrade_cost_item_text = self:AddComponent(UIText, upgrade_cost_item_text_path)
    self.upgrade_cost_item_img = self:AddComponent(UIImage, upgrade_cost_item_img_path)
    self.upgrade_cost_gold_btn = self:AddComponent(UIBaseContainer, upgrade_cost_gold_btn_path)
    self.upgrade_cost_gold_text = self:AddComponent(UIText, upgrade_cost_gold_text_path)
    self.upgrade_cost_gold_img = self:AddComponent(UIImage, upgrade_cost_gold_img_path)
    self.plugin_left = self:AddComponent(UIHeroPluginUpgradePluginIcon, plugin_left_path)
    self.left_effect_go = self:AddComponent(UIBaseContainer, left_effect_go_path)
    self.left_const_go = self:AddComponent(UIBaseContainer, left_const_go_path)
    self.left_random_go = self:AddComponent(UIBaseContainer, left_random_go_path)
    self.left_quality_text = self:AddComponent(UIText, left_quality_text_path)
    self.goto_text = self:AddComponent(UIText, goto_text_path)
    self.cost_go = self:AddComponent(UIBaseContainer, cost_go_path)
end

function UIHeroPluginUpgradeUpgrade:ComponentDestroy()

end

function UIHeroPluginUpgradeUpgrade:DataDefine()
    self.param = {}
    self.pointEffectTimer = nil
    self.noClick = false
    self.leftMainDesList = {}
    self.leftRandomDesList = {}
    self.leftMainDesCells = {}
    self.leftRandomDesCells = {}
    self.useUpgradeTime = 0
end

function UIHeroPluginUpgradeUpgrade:DataDestroy()
    self:ClearEffectTimer()
    self.param = {}
    self.noClick = false
    self.leftMainDesList = {}
    self.leftRandomDesList = {}
    self.leftMainDesCells = {}
    self.leftRandomDesCells = {}
    self.useUpgradeTime = 0
end

function UIHeroPluginUpgradeUpgrade:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeUpgrade:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeUpgrade:ReInit(param)
    self.param = param
    self.useUpgradeTime = 0
    self.upgrade_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
    self.goto_text:SetLocalText(GameDialogDefine.UPGRADE)
    self.left_effect_go:SetActive(false)
    self:Refresh()
end


function UIHeroPluginUpgradeUpgrade:Refresh()
    if self.param.select then
        self:SetActive(true)
        self.noClick = false
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
        if heroData ~= nil then
            self.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            if heroData.plugin ~= nil then
                local param = {}
                param.level = heroData.plugin.lv
                param.camp = self.camp
                param.score = heroData.plugin:GetScore()
                self.plugin_left:ReInit(param)
                local nameStr = DataCenter.HeroPluginManager:GetQualityNameByLevel(heroData.plugin.lv)
                self.left_quality_text:SetText(nameStr)

                local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
                if template ~= nil then
                    local itemId = template:GetCostItemId(self.camp)
                    if itemId ~= 0 then
                        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                        if goods ~= nil then
                            local iconName = string.format(LoadPath.ItemPath, goods.icon)
                            self.upgrade_cost_item_img:LoadSprite(iconName)
                        end
                    end
                end
                if heroData.plugin.lv >= DataCenter.HeroPluginManager:GetMaxLevel() then
                    self.upgrade_btn:SetActive(false)
                else
                    self.upgrade_btn:SetActive(true)
                    if heroData.plugin.lv >= DataCenter.HeroPluginManager:GetCurMaxLevel(self.camp) then
                        self.goto_text:SetActive(true)
                        self.upgrade_btn_text:SetActive(false)
                        self.cost_go:SetActive(false)
                    else
                        self.goto_text:SetActive(false)
                        self.upgrade_btn_text:SetActive(true)
                        self.cost_go:SetActive(true)
                    end
                end
                
                self:RefreshItemCount()
                self:RefreshGoldCount()
            end
        end
        self:ShowMainDesCells()
        self:ShowRandomDesCells()
    else
        self:SetActive(false)
    end
end


function UIHeroPluginUpgradeUpgrade:Select(tabType, select)
    if self.param.select ~= select then
        self.param.select = select
        self:Refresh()
    end
end

function UIHeroPluginUpgradeUpgrade:SetItemCount(ownCount, needCount)
    if needCount > 0 then
        self.upgrade_cost_item_btn:SetActive(true)
        self.upgrade_cost_item_text:SetText(string.GetFormattedSeperatorNum(needCount))
        if needCount > ownCount then
            --红色
            self.upgrade_cost_item_text:SetColor(RedColor)
        else
            --白色
            self.upgrade_cost_item_text:SetColor(WhiteColor)
        end
    else
        self.upgrade_cost_item_btn:SetActive(false)
    end
end

function UIHeroPluginUpgradeUpgrade:SetGoldCount(ownCount, needCount)
    if needCount > 0 then
        self.upgrade_cost_gold_btn:SetActive(true)
        self.upgrade_cost_gold_text:SetText(string.GetFormattedSeperatorNum(needCount))
        if needCount > ownCount then
            --红色
            self.upgrade_cost_gold_text:SetColor(RedColor)
        else
            --白色
            self.upgrade_cost_gold_text:SetColor(WhiteColor)
        end
    else
        self.upgrade_cost_gold_btn:SetActive(false)
    end
end

function UIHeroPluginUpgradeUpgrade:RefreshHeroPluginSignal()
    self:Refresh()
end

function UIHeroPluginUpgradeUpgrade:RefreshItemCount()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
        if template ~= nil then
            local itemId = template:GetCostItemId(self.camp)
            if itemId ~= 0 then
                local ownCount = DataCenter.ItemData:GetItemCount(itemId)
                local needCount = template:GetUpgradeCostNum(self.camp)
                self:SetItemCount(ownCount, needCount)
            end
        end
    end
end

function UIHeroPluginUpgradeUpgrade:RefreshGoldCount()
    local needGoldCount = 0
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local num = heroData:GetLockPluginNum()
        if num > 0 then
            needGoldCount = DataCenter.HeroPluginManager:GetLockCostNum(num)
        end
    end
    self:SetGoldCount(LuaEntry.Player.gold, needGoldCount)
end

function UIHeroPluginUpgradeUpgrade:ShowMainDesCells()
    self:InitMainDesList()
    local count = #self.leftMainDesList
    for k, v in ipairs(self.leftMainDesList) do
        if self.leftMainDesCells[k] == nil then
            local param = {}
            self.leftMainDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginUpgradeConstCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.left_const_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.left_const_go:AddComponent(UIHeroPluginDesConstCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.leftMainDesCells[k].visible = true
            self.leftMainDesCells[k].data = v
            if self.leftMainDesCells[k].model ~= nil then
                self.leftMainDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.leftMainDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.leftMainDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginUpgradeUpgrade:InitMainDesList()
    self.leftMainDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(heroData.plugin.lv)
        if list ~= nil then
            for k, v in ipairs(list) do
                local param = {}
                param.showName = v:GetConstName()
                param.showValue = v:GetConstValue()
                if self.useUpgradeTime > 0 then
                    param.delayTime = self.useUpgradeTime
                    self.useUpgradeTime = self.useUpgradeTime + HeroPluginUpgradeShowAnimTime
                end
                table.insert(self.leftMainDesList, param)
            end
        end
    end
end

function UIHeroPluginUpgradeUpgrade:ShowRandomDesCells()
    self:InitRandomDesList()
    local count = #self.leftRandomDesList
    for k, v in ipairs(self.leftRandomDesList) do
        if self.leftRandomDesCells[k] == nil then
            local param = {}
            self.leftRandomDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginUpgradeRandomWithCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.left_random_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.left_random_go:AddComponent(UIHeroPluginDesRandomWithCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.leftRandomDesCells[k].visible = true
            self.leftRandomDesCells[k].data = v
            if self.leftRandomDesCells[k].model ~= nil then
                self.leftRandomDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.leftRandomDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.leftRandomDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginUpgradeUpgrade:InitRandomDesList()
    self.leftRandomDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local lockTemplateList = {}
        local list = heroData.plugin.plugin
        if list ~= nil then
            local count = #list
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                if template ~= nil then
                    local param = {}
                    param.showName = template:GetDesc(v.level)
                    param.isMax = template:IsMax(v.level)
                    if heroData.plugin:IsLock(k) then
                        param.select = true
                        table.insert(lockTemplateList, v)
                    else
                        param.select = false
                        if self.useUpgradeTime > 0 then
                            param.delayTime = self.useUpgradeTime
                            self.useUpgradeTime = self.useUpgradeTime + HeroPluginUpgradeShowAnimTime
                            param.effectName = DataCenter.HeroPluginManager:GetUpgradeEffectName(template.rarity)
                            if param.isMax then
                                param.maxTime = self.useUpgradeTime
                                self.useUpgradeTime = self.useUpgradeTime + HeroPluginUpgradeShowMaxAnimTime
                            end
                        end
                    end
                    param.infoText = template:GetDescRange()
                    param.heroUuid = self.param.uuid
                    param.index = k - 1
                    param.useSelect = true
                    param.quality = template.rarity
                    param.camp = self.camp
                 
                    param.isSpecial = template:IsSpecialShow()
                    table.insert(self.leftRandomDesList, param)
                end
            end
            for i = count + 1, count + 10 ,1 do
                local level = DataCenter.HeroPluginManager:GetLevelByNum(i)
                if level <= 0 then
                    break
                else
                    local param = {}
                    param.select = false
                    param.useSelect = false
                    param.quality = HeroPluginQualityType.White
                    param.showName = string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(param.quality), Localization:GetString(GameDialogDefine.UN_KNOW_ATTRIBUTE)) 
                    param.showValue = Localization:GetString(GameDialogDefine.REACH_LEVEL_UNLOCK_WHIT, level)
                    param.heroUuid = self.param.uuid
                    param.index = i
                    param.camp = self.camp
                    param.needUnlock = true
                    param.isMax = false
                    table.insert(self.leftRandomDesList, param)
                end
            end
        end
    end
    self.useUpgradeTime = 0
end

function UIHeroPluginUpgradeUpgrade:PlayLeftEffect()
    self.left_effect_go:SetActive(true)
    self.pointEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.left_effect_go:SetActive(false)
        self:ClearEffectTimer()
    end, EffectTime)
end

function UIHeroPluginUpgradeUpgrade:ClearEffectTimer()
    if self.pointEffectTimer ~= nil then
        self.pointEffectTimer:Stop()
        self.pointEffectTimer = nil
    end
end

function UIHeroPluginUpgradeUpgrade:RefreshItemsSignal()
    self:RefreshItemCount()
end

function UIHeroPluginUpgradeUpgrade:UpdateGoldSignal()
    self:RefreshGoldCount()
end


function UIHeroPluginUpgradeUpgrade:OnUpgradeBtnClick()
    if not self.noClick then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
        if heroData ~= nil and heroData.plugin ~= nil then
            if heroData.plugin.lv >= DataCenter.HeroPluginManager:GetCurMaxLevel(self.camp) then
                --跳转解锁最大等级科技
                local scienceId = DataCenter.HeroPluginManager:GetUnlockMaxLevelScienceId(self.camp, heroData.plugin.lv)
                if scienceId ~= 0 then
                    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.UNLOCK_MAX_LEVEL_NEED_GOTO_SCIENCE), 2, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
                        GoToUtil.GotoScience(scienceId)
                    end)
                end
            else
                local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
                if template ~= nil then
                    local itemId = template:GetCostItemId(self.camp)
                    if itemId ~= 0 then
                        local ownCount = DataCenter.ItemData:GetItemCount(itemId)
                        local needCount = template:GetUpgradeCostNum(self.camp)
                        if needCount > ownCount then
                            local lackTab = {}
                            local param = {}
                            param.type = ResLackType.Item
                            param.id = itemId
                            param.targetNum = needCount
                            table.insert(lackTab,param)
                            GoToResLack.GoToItemResLackList(lackTab)
                        else
                            local needGoldCount = 0
                            local num = heroData:GetLockPluginNum()
                            if num > 0 then
                                needGoldCount = DataCenter.HeroPluginManager:GetLockCostNum(num)
                            end
                            if LuaEntry.Player.gold >= needGoldCount then
                                --检测是否有稀有属性
                                local needCheck = false
                                local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.HeroPluginUpgradeSpecialTag)
                                if needShow then
                                    local list = heroData.plugin.plugin
                                    if list ~= nil then
                                        for k, v in ipairs(list) do
                                            local tempTemplate = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                                            if tempTemplate ~= nil and tempTemplate:IsSpecialTag() then
                                                needCheck = true
                                                break
                                            end
                                        end
                                    end
                                end
                                if needCheck then
                                    UIUtil.ShowSecondMessage(Localization:GetString(GameDialogDefine.PROMPT_TITLE), 
                                            Localization:GetString(GameDialogDefine.HERO_PLUGIN_UPGRADE_SPECIAL_TIP), 2, GameDialogDefine.CONFIRM, 
                                            GameDialogDefine.CANCEL, function()
                                                self.noClick = true
                                                self.useUpgradeTime = HeroPluginUpgradeShowAnimTime
                                                DataCenter.HeroPluginManager:SendUpgradeHeroPlugin(self.param.uuid)
                                                self:PlayLeftEffect()
                                    end, function(needSellConfirm)
                                        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.HeroPluginUpgradeSpecialTag, not needSellConfirm)
                                    end, nil,function()
                                    end,nil,Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
                                else
                                    self.noClick = true
                                    self.useUpgradeTime = HeroPluginUpgradeShowAnimTime
                                    DataCenter.HeroPluginManager:SendUpgradeHeroPlugin(self.param.uuid)
                                    self:PlayLeftEffect()
                                end
                            else
                                GoToUtil.GotoPayTips()
                            end
                        end
                    end
                end
            end
        end
    end
end


return UIHeroPluginUpgradeUpgrade