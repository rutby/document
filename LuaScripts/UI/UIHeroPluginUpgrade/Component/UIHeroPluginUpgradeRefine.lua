--- Created by shimin
--- DateTime: 2023/7/26 19:16
--- 英雄插件转换Tab界面

local UIHeroPluginUpgradeRefine = BaseClass("UIHeroPluginUpgradeRefine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"
local UIHeroPluginDesRandomWithCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesRandomWithCell"
local UIHeroPluginDesConstCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesConstCell"

local upgrade_btn_path = "layout/Common_btn_green_big"
local upgrade_btn_text_path = "layout/Common_btn_green_big/btnTxt_green_big_new"
local upgrade_cost_item_btn_path = "layout/Common_btn_green_big/CostContent/CostItemCell"
local upgrade_cost_item_text_path = "layout/Common_btn_green_big/CostContent/CostItemCell/ResourceNum"
local upgrade_cost_item_img_path = "layout/Common_btn_green_big/CostContent/CostItemCell/ResourceNum/ResourceIcon"
local upgrade_cost_gold_btn_path = "layout/Common_btn_green_big/CostContent/CostGoldCell"
local upgrade_cost_gold_text_path = "layout/Common_btn_green_big/CostContent/CostGoldCell/CostGoldCellText"
local upgrade_cost_gold_img_path = "layout/Common_btn_green_big/CostContent/CostGoldCell/CostGoldCellText/CostGoldCellIcon"
local save_btn_path = "layout/SaveBtn"
local save_btn_text_path = "layout/SaveBtn/UpgradeBtnText"

local plugin_left_path = "left_bg/UIHeroPluginBtn"
local plugin_right_path = "right_bg/UIHeroPluginBtn (1)"
local left_const_go_path = "left_bg/LeftContent/const_go"
local left_random_go_path = "left_bg/LeftContent/random_go"
local right_const_go_path = "right_bg/RightContent/right_const_go"
local right_random_go_path = "right_bg/RightContent/right_random_go"
local left_quality_text_path = "left_bg/quality_text"
local right_quality_text_path = "right_bg/right_quality_text"

function UIHeroPluginUpgradeRefine:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeRefine:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeRefine:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeRefine:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeRefine:ComponentDefine()
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
    self.plugin_right = self:AddComponent(UIHeroPluginUpgradePluginIcon, plugin_right_path)
    self.save_btn = self:AddComponent(UIButton, save_btn_path)
    self.save_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSaveBtnClick()
    end)
    self.save_btn_text = self:AddComponent(UIText, save_btn_text_path)
    self.left_const_go = self:AddComponent(UIBaseContainer, left_const_go_path)
    self.left_random_go = self:AddComponent(UIBaseContainer, left_random_go_path)
    self.right_const_go = self:AddComponent(UIBaseContainer, right_const_go_path)
    self.right_random_go = self:AddComponent(UIBaseContainer, right_random_go_path)
    self.left_quality_text = self:AddComponent(UIText, left_quality_text_path)
    self.right_quality_text = self:AddComponent(UIText, right_quality_text_path)
end

function UIHeroPluginUpgradeRefine:ComponentDestroy()

end

function UIHeroPluginUpgradeRefine:DataDefine()
    self.param = {}
    self.noClick = false
    self.leftMainDesList = {}
    self.rightMainDesList = {}
    self.leftRandomDesList = {}
    self.rightRandomDesList = {}
    self.leftMainDesCells = {}
    self.rightMainDesCells = {}
    self.leftRandomDesCells = {}
    self.rightRandomDesCells = {}
    self.useRightUpgradeTime = 0
    self.useLeftUpgradeTime = 0
    self.camp = nil
end

function UIHeroPluginUpgradeRefine:DataDestroy()
    self.param = {}
    self.noClick = false
    self.leftMainDesList = {}
    self.rightMainDesList = {}
    self.leftRandomDesList = {}
    self.rightRandomDesList = {}
    self.leftMainDesCells = {}
    self.rightMainDesCells = {}
    self.leftRandomDesCells = {}
    self.rightRandomDesCells = {}
    self.useRightUpgradeTime = 0
    self.useLeftUpgradeTime = 0
    self.camp = nil
end

function UIHeroPluginUpgradeRefine:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeRefine:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeRefine:ReInit(param)
    self.param = param
    self.useRightUpgradeTime = 0
    self.useLeftUpgradeTime = 0
    self.save_btn_text:SetLocalText(GameDialogDefine.SAVE)
    self.upgrade_btn_text:SetLocalText(GameDialogDefine.REFINE)
    self:Refresh()
end

function UIHeroPluginUpgradeRefine:Refresh()
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
                self.right_quality_text:SetText(nameStr)

                local rightParam = {}
                rightParam.level = heroData.plugin.lv
                rightParam.camp = self.camp
                local list = heroData.plugin.tmpPlugin
                if list ~= nil and list[1] ~= nil then
                    rightParam.score = heroData.plugin:GetTmpScore()
                end
                self.plugin_right:ReInit(rightParam)

                local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
                if template ~= nil then
                   local campType = self.camp
                    local itemId = template:GetCostItemId(campType)
                    if itemId ~= 0 then
                        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                        if goods ~= nil then
                            local iconName = string.format(LoadPath.ItemPath, goods.icon)
                            self.upgrade_cost_item_img:LoadSprite(iconName)
                        end
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

function UIHeroPluginUpgradeRefine:Select(tabType, select)
    if self.param.select ~= select then
        self.param.select = select
        self:Refresh()
    end
end

function UIHeroPluginUpgradeRefine:SetItemCount(ownCount, needCount)
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

function UIHeroPluginUpgradeRefine:SetGoldCount(ownCount, needCount)
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

function UIHeroPluginUpgradeRefine:RefreshHeroPluginSignal()
    self:Refresh()
end

function UIHeroPluginUpgradeRefine:RefreshItemCount()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
        if template ~= nil then
            local itemId = template:GetCostItemId(self.camp)
            if itemId ~= 0 then
                local ownCount = DataCenter.ItemData:GetItemCount(itemId)
                local needCount = template:GetRefineCostNum(self.camp)
                self:SetItemCount(ownCount, needCount)
            end
        end
    end
end

function UIHeroPluginUpgradeRefine:RefreshGoldCount()
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

function UIHeroPluginUpgradeRefine:OnSaveBtnClick()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil and heroData.plugin.tmpPlugin[1] ~= nil then
        if heroData.plugin:GetTmpScore() < heroData.plugin:GetScore() then
            UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.HERO_PLUGIN_SAVE_SCORE_LOW), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                self.useLeftUpgradeTime = HeroPluginUpgradeShowAnimTime
                DataCenter.HeroPluginManager:SendSaveHeroPlugin(self.param.uuid, SaveHeroPluginType.Save)
            end)
        else
            UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.HERO_PLUGIN_CHECK_SAVE_OR_RESET), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                self.useLeftUpgradeTime = HeroPluginUpgradeShowAnimTime
                DataCenter.HeroPluginManager:SendSaveHeroPlugin(self.param.uuid, SaveHeroPluginType.Save)
            end)
        end
    end
end

function UIHeroPluginUpgradeRefine:OnUpgradeBtnClick()
    if not self.noClick then
        if DataCenter.HeroPluginManager:IsAllLock(self.param.uuid) then
            UIUtil.ShowTipsId(GameDialogDefine.HERO_PLUGIN_ALL_LOCK)
        else
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
            if heroData ~= nil and heroData.plugin ~= nil then
                local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
                if template ~= nil then
                    local itemId = template:GetCostItemId(self.camp)
                    if itemId ~= 0 then
                        local ownCount = DataCenter.ItemData:GetItemCount(itemId)
                        local needCount = template:GetRefineCostNum(self.camp)
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
                                local list = heroData.plugin.tmpPlugin
                                if list ~= nil then
                                    for k, v in ipairs(list) do
                                        local tempTemplate = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                                        if tempTemplate ~= nil and tempTemplate:IsSpecialTag() and (not heroData.plugin:IsLock(k)) then
                                            needCheck = true
                                            break
                                        end
                                    end
                                end
                                if needCheck then
                                    local all = DataCenter.HeroPluginManager:GetLockNum(self.camp)
                                    if num > 0 and num >= all then
                                        UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.HERO_PLUGIN_SPECIAL_TAG_AND_LOCK_MAX), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                                            self.noClick = true
                                            self.useRightUpgradeTime = HeroPluginUpgradeShowAnimTime
                                            DataCenter.HeroPluginManager:SendRefineHeroPlugin(self.param.uuid)
                                        end)
                                    else
                                        UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.HERO_PLUGIN_CHECK_SPECIAL_TAG), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                                            self.noClick = true
                                            self.useRightUpgradeTime = HeroPluginUpgradeShowAnimTime
                                            DataCenter.HeroPluginManager:SendRefineHeroPlugin(self.param.uuid)
                                        end)
                                    end
                                else
                                    self.noClick = true
                                    self.useRightUpgradeTime = HeroPluginUpgradeShowAnimTime
                                    DataCenter.HeroPluginManager:SendRefineHeroPlugin(self.param.uuid)
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

function UIHeroPluginUpgradeRefine:ShowMainDesCells()
    self:InitMainDesList()
    local count = #self.leftMainDesList
    for k, v in ipairs(self.leftMainDesList) do
        if self.leftMainDesCells[k] == nil then
            local param = {}
            self.leftMainDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginDesConstCell, function(request)
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
    --右侧
    count = #self.rightMainDesList
    for k, v in ipairs(self.rightMainDesList) do
        if self.rightMainDesCells[k] == nil then
            local param = {}
            self.rightMainDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginDesConstCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.right_const_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.right_const_go:AddComponent(UIHeroPluginDesConstCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.rightMainDesCells[k].visible = true
            self.rightMainDesCells[k].data = v
            if self.rightMainDesCells[k].model ~= nil then
                self.rightMainDesCells[k].model:Refresh()
            end
        end
    end
    cellCount = #self.rightMainDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.rightMainDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginUpgradeRefine:InitMainDesList()
    self.leftMainDesList = {}
    self.rightMainDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(heroData.plugin.lv)
        if list ~= nil then
            for k, v in ipairs(list) do
                local param = {}
                param.showName = v:GetConstName()
                param.showValue = v:GetConstValue()
                table.insert(self.leftMainDesList, param)
                table.insert(self.rightMainDesList, param)
            end
        end
    end
end

function UIHeroPluginUpgradeRefine:ShowRandomDesCells()
    self:InitRandomDesList()
    local count = #self.leftRandomDesList
    for k, v in ipairs(self.leftRandomDesList) do
        if self.leftRandomDesCells[k] == nil then
            local param = {}
            self.leftRandomDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginDesRandomWithCell, function(request)
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

    count = #self.rightRandomDesList
    for k, v in ipairs(self.rightRandomDesList) do
        if self.rightRandomDesCells[k] == nil then
            local param = {}
            self.rightRandomDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginDesRandomWithCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.right_random_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.right_random_go:AddComponent(UIHeroPluginDesRandomWithCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.rightRandomDesCells[k].visible = true
            self.rightRandomDesCells[k].data = v
            if self.rightRandomDesCells[k].model ~= nil then
                self.rightRandomDesCells[k].model:Refresh()
            end
        end
    end
    cellCount = #self.rightRandomDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.rightRandomDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end

    self.save_btn:SetActive(true)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil and heroData.plugin.tmpPlugin ~= nil and heroData.plugin.tmpPlugin[1] ~= nil then
        self.save_btn:SetInteractable(true)
    else
        self.save_btn:SetInteractable(false)
    end
end

function UIHeroPluginUpgradeRefine:InitRandomDesList()
    self.leftRandomDesList = {}
    self.rightRandomDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local lockTemplateList = {}
        local rightShowUnlock = {}
        local list = heroData.plugin.plugin
        if list ~= nil then
            local lv = heroData.plugin.lv
            local count = #list
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                if template ~= nil then
                    local param = {}
                    param.showName = template:GetDesc(v.level)
                    param.isMax = template:IsMax(v.level)
                    if heroData.plugin:IsLock(k) then
                        param.select = true
                        lockTemplateList[k] = v
                    else
                        param.select = false
                        if self.useLeftUpgradeTime > 0 then
                            param.delayTime = self.useLeftUpgradeTime
                            self.useLeftUpgradeTime = self.useLeftUpgradeTime + HeroPluginUpgradeShowAnimTime
                            param.effectName = DataCenter.HeroPluginManager:GetRefineEffectName(template.rarity)
                            if param.isMax then
                                param.maxTime = self.useLeftUpgradeTime
                                self.useLeftUpgradeTime = self.useLeftUpgradeTime + HeroPluginUpgradeShowMaxAnimTime
                            end
                        end
                    end
                    param.infoText = template:GetDescRange()
                    param.heroUuid = self.param.uuid
                    param.index = k - 1
                    param.useSelect = true
                    param.camp = self.camp
                    param.quality = template.rarity
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
                    --右边判断实际是否解锁
                    if lv < level then
                        table.insert(rightShowUnlock, param)
                    end
                end
            end
        end
        list = heroData.plugin.tmpPlugin
        if list ~= nil and list[1] ~= nil then
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                if template ~= nil then
                    local param = {}
                    param.select = false
                    param.showName = template:GetDesc(v.level)
                    param.showValue = ""
                    param.infoText = template:GetDescRange()
                    param.heroUuid = self.param.uuid
                    param.index = k - 1
                    param.useSelect = false
                    param.camp = self.camp
                    param.quality = template.rarity
                    param.isMax = template:IsMax(v.level)
                    param.isSpecial = template:IsSpecialShow()
                    if lockTemplateList[k] == nil then
                        --使用自己插件判断锁还是没锁
                        if self.useRightUpgradeTime > 0 then
                            param.delayTime = self.useRightUpgradeTime
                            self.useRightUpgradeTime = self.useRightUpgradeTime + HeroPluginUpgradeShowAnimTime
                            param.effectName = DataCenter.HeroPluginManager:GetRefineEffectName(template.rarity)
                            if param.isMax then
                                param.maxTime = self.useRightUpgradeTime
                                self.useRightUpgradeTime = self.useRightUpgradeTime + HeroPluginUpgradeShowMaxAnimTime
                            end
                        end
                    end
                    table.insert(self.rightRandomDesList, param)
                end
            end
        else
            local count = DataCenter.HeroPluginManager:GetMaxNum(heroData.plugin.lv)
            for i = 1, count, 1 do
                if lockTemplateList[i] ~= nil then
                    local template = DataCenter.RandomPlugTemplateManager:GetTemplate(lockTemplateList[i].id)
                    if template ~= nil then
                        local param = {}
                        param.select = false
                        param.showName = template:GetDesc(lockTemplateList[i].level)
                        param.showValue = ""
                        param.heroUuid = self.param.uuid
                        param.index = i - 1
                        param.useSelect = false
                        param.camp = self.camp
                        param.quality = template.rarity
                        param.isMax = template:IsMax(lockTemplateList[i].level)
                        param.isSpecial = template:IsSpecialShow()
                        table.insert(self.rightRandomDesList, param)
                    end
                else
                    local param = {}
                    param.select = false
                    param.quality = HeroPluginQualityType.White
                    param.showName = string.format(TextColorStr, DataCenter.HeroPluginManager:GetTextColorByQuality(param.quality), Localization:GetString(GameDialogDefine.UN_KNOW_ATTRIBUTE))
                    param.showValue = ""
                    param.heroUuid = self.param.uuid
                    param.index = i - 1
                    param.useSelect = false
                    param.camp = self.camp
                    param.isMax = false
                    table.insert(self.rightRandomDesList, param)
                end
            end
        end
        
        for k, v in ipairs(rightShowUnlock) do
            table.insert(self.rightRandomDesList, v)
        end
    end
    self.useLeftUpgradeTime = 0
    self.useRightUpgradeTime = 0
end

function UIHeroPluginUpgradeRefine:RefreshItemsSignal()
    self:RefreshItemCount()
end

function UIHeroPluginUpgradeRefine:UpdateGoldSignal()
    self:RefreshGoldCount()
end

return UIHeroPluginUpgradeRefine