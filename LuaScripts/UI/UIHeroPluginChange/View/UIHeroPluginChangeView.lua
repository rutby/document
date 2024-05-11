--- Created by shimin
--- DateTime: 2023/6/6 21:12
--- 英雄插件交换界面

local UIHeroPluginChangeView = BaseClass("UIHeroPluginChangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroPluginChangeSelectHeroCell = require "UI.UIHeroPluginChange.Component.UIHeroPluginChangeSelectHeroCell"
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"
local UIHeroPluginDesRandomWithCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesRandomWithCell"
local UIHeroPluginDesConstCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesConstCell"

local return_path = "UICommonPopUpTitle/panel"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/bg_mid/titleText"
local scroll_view_path = "FormationHeroList/ScrollView"
local hero_num_path ="FormationHeroList/heroNum"
local empty_text_path ="FormationHeroList/TxtEmpty"
local upgrade_btn_path = "ChangeGo/btnTxt_green_big_new"
local upgrade_btn_text_path = "ChangeGo/btnTxt_green_big_new/SubmitBtnText"
local right_btn_path = "ChangeGo/right_bg"
local left_hero_path = "ChangeGo/LeftHero"
local right_hero_path = "ChangeGo/RightHero"
local change_des_text_path = "ChangeGo/Text_uityjc20"
local right_add_go_path = "ChangeGo/addImg"
local effect_go_path = "ChangeGo/EffectGo"
local anim_path = "FormationHeroList"
local hide_btn_path = "FormationHeroList/selectHeroBtn"
local plugin_left_path = "ChangeGo/left_bg/UIHeroPluginBtn"
local plugin_right_path = "ChangeGo/right_bg/UIHeroPluginBtn (1)"
local left_const_go_path = "ChangeGo/left_bg/LeftContent/const_go"
local left_random_go_path = "ChangeGo/left_bg/LeftContent/random_go"
local right_const_go_path = "ChangeGo/right_bg/RightContent/right_const_go"
local right_random_go_path = "ChangeGo/right_bg/RightContent/right_random_go"
local left_quality_text_path = "ChangeGo/left_bg/quality_text"
local right_quality_text_path = "ChangeGo/right_bg/right_quality_text"
local select_hero_tip_text_path = "ChangeGo/addImg/select_hero_tip_text"

local AnimName =
{
    Idle = "idle",
    Show = "show",
    Hide = "hide"
}

function UIHeroPluginChangeView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginChangeView:ComponentDefine()
    self._title_txt = self:AddComponent(UIText, titleTxt_path)
    self._close_btn = self:AddComponent(UIButton, closeBtn_path)
    self._return_btn = self:AddComponent(UIButton, return_path)
    self._close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self._return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.upgrade_btn_text = self:AddComponent(UIText, upgrade_btn_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    
    self.hero_num = self:AddComponent(UIText, hero_num_path)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
    self.left_hero = self:AddComponent(UIHeroCell, left_hero_path)
    self.right_hero = self:AddComponent(UIHeroCell, right_hero_path)
    self.change_des_text = self:AddComponent(UIText, change_des_text_path)
    self.effect_go = self:AddComponent(UIBaseContainer, effect_go_path)
    self.right_add_go = self:AddComponent(UIBaseContainer, right_add_go_path)
    self.anim = self:AddComponent(UIAnimator, anim_path)
    self.hide_btn = self:AddComponent(UIButton, hide_btn_path)
    self.hide_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnHideBtnClick()
    end)
    self.left_plugin_icon = self:AddComponent(UIHeroPluginUpgradePluginIcon, plugin_left_path)
    self.right_plugin_icon = self:AddComponent(UIHeroPluginUpgradePluginIcon, plugin_right_path)
    self.add_btn = self:AddComponent(UIButton, right_btn_path)
    self.add_btn:SetOnClick(function()
        self:OnAddBtnClick()
    end)
    self.left_const_go = self:AddComponent(UIBaseContainer, left_const_go_path)
    self.left_random_go = self:AddComponent(UIBaseContainer, left_random_go_path)
    self.right_const_go = self:AddComponent(UIBaseContainer, right_const_go_path)
    self.right_random_go = self:AddComponent(UIBaseContainer, right_random_go_path)
    self.left_quality_text = self:AddComponent(UIText, left_quality_text_path)
    self.right_quality_text = self:AddComponent(UIText, right_quality_text_path)
    self.select_hero_tip_text = self:AddComponent(UIText, select_hero_tip_text_path)
end

function UIHeroPluginChangeView:ComponentDestroy()
end

function UIHeroPluginChangeView:DataDefine()
    self.param = {}
    self.list = {}--左边英雄列表
    self.heroCells = {}
    self.pointEffectTimer = nil
    self.isShowList = false
    self.leftMainDesList = {}
    self.rightMainDesList = {}
    self.leftRandomDesList = {}
    self.rightRandomDesList = {}
    self.leftMainDesCells = {}
    self.rightMainDesCells = {}
    self.leftRandomDesCells = {}
    self.rightRandomDesCells = {}
end

function UIHeroPluginChangeView:DataDestroy()
    self:ClearEffectTimer()
    self.param = {}
    self.list = {}--左边英雄列表
    self.heroCells = {}
    self.isShowList = false
    self.leftMainDesList = {}
    self.rightMainDesList = {}
    self.leftRandomDesList = {}
    self.rightRandomDesList = {}
    self.leftMainDesCells = {}
    self.rightMainDesCells = {}
    self.leftRandomDesCells = {}
    self.rightRandomDesCells = {}
end

function UIHeroPluginChangeView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginChangeView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginChangeView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginChangeView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginChangeView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginChangeView:ReInit()
    self.param = self:GetUserData()
    self.empty_text:SetLocalText(GameDialogDefine.NO_HERO)
    self._title_txt:SetLocalText(GameDialogDefine.HERO_PLUGIN_CHANGE_TITLE)
    self.change_des_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_CHANGE_DES)
    self.upgrade_btn_text:SetLocalText(GameDialogDefine.CHANGE)
    self:Refresh()
    self:ShowCells()
    self:PlayAnim(AnimName.Idle)
    self.effect_go:SetActive(false)
end

function UIHeroPluginChangeView:Refresh()
    self:ShowLeftMainDesCells()
    self:ShowLeftRandomDesCells()
    self:ShowRightMainDesCells()
    self:ShowRightRandomDesCells()
end

function UIHeroPluginChangeView:OnUpgradeBtnClick()
    local changeUuid = self:GetChangeUuid()
    if changeUuid ~= 0 then
        DataCenter.HeroPluginManager:SendExchangeHeroPlugin(self.param.uuid, changeUuid)
        self:PlayEffect()
    end
end

function UIHeroPluginChangeView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.empty_text:SetActive(true)
    end
    self.hero_num:SetText(tostring(count))
end

function UIHeroPluginChangeView:ClearScroll()
    self.heroCells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIHeroPluginChangeSelectHeroCell)--清循环列表gameObject
end

function UIHeroPluginChangeView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIHeroPluginChangeSelectHeroCell, itemObj)
    item:ReInit(self.list[index])
    self.heroCells[index] = item
end

function UIHeroPluginChangeView:OnCellMoveOut(itemObj, index)
    self.heroCells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIHeroPluginChangeSelectHeroCell)
end

function UIHeroPluginChangeView:GetDataList()
    self.list = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil then
        local index = 1
        local changeUuid = self:GetChangeUuid()
        local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        local list = DataCenter.HeroDataManager:GetAllHeroByCampAndSort(campType ,true)
        for k, v in ipairs(list) do
            if v.uuid ~= self.param.uuid then
                local param = {}
                param.uuid = v.uuid
                param.isInMarch = v.state == ArmyFormationState.March
                param.select = v.uuid == changeUuid
                param.index = index
                param.camp = v:GetCamp()
                table.insert(self.list, param)
                index = index + 1
            end
        end
    end
end

function UIHeroPluginChangeView:ShowLeftMainDesCells()
    self:InitLeftMainDesList()
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
end

function UIHeroPluginChangeView:InitLeftMainDesList()
    self.leftMainDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(heroData.plugin.lv)
        if list ~= nil then
            for k, v in ipairs(list) do
                local param = {}
                param.showName = v:GetConstName()
                param.showValue = v:GetConstValue()
                table.insert(self.leftMainDesList, param)
            end
        end
    end
end

function UIHeroPluginChangeView:ShowLeftRandomDesCells()
    self:InitLeftRandomDesList()
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
    self.left_hero:SetData(self.param.uuid, nil, nil, true)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil then
        local param = {}
        param.level = heroData.plugin.lv
        param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        param.score = heroData.plugin:GetScore()
        self.left_plugin_icon:ReInit(param)
        self.left_quality_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(heroData.plugin.lv))
    end
end

function UIHeroPluginChangeView:InitLeftRandomDesList()
    self.leftRandomDesList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = heroData.plugin.plugin
        if list ~= nil then
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
                    param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
                    param.quality = template.rarity
                    param.isMax = template:IsMax(v.level)
                    table.insert(self.leftRandomDesList, param)
                end
            end
        end
    end
end

function UIHeroPluginChangeView:ShowRightMainDesCells()
    self:InitRightMainDesList()
    local count = #self.rightMainDesList
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
    local cellCount = #self.rightMainDesCells
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

function UIHeroPluginChangeView:InitRightMainDesList()
    self.rightMainDesList = {}
    local changeUuid = self:GetChangeUuid()
    if changeUuid ~= 0 then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(changeUuid)
        if heroData ~= nil and heroData.plugin ~= nil then
            local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(heroData.plugin.lv)
            if list ~= nil then
                for k, v in ipairs(list) do
                    local param = {}
                    param.showName = v:GetConstName()
                    param.showValue = v:GetConstValue()
                    table.insert(self.rightMainDesList, param)
                end
            end
        end
    end
end

function UIHeroPluginChangeView:ShowRightRandomDesCells()
    self:InitRightRandomDesList()
    local count = #self.rightRandomDesList
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
    local cellCount = #self.rightRandomDesCells
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
    
    local changeUuid = self:GetChangeUuid()
    if changeUuid == 0 then
        self.right_add_go:SetActive(true)
        self.right_hero:SetActive(false)
        self.right_plugin_icon:SetActive(false)
        self.right_quality_text:SetActive(false)
        self.upgrade_btn:SetInteractable(false)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
        if heroData ~= nil then
            self.select_hero_tip_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_SELECT_HERO_CHANGE_TIP, 
                    HeroUtils.GetHeroNameByConfigId(heroData.heroId))
        end
    else
        self.upgrade_btn:SetInteractable(true)
        self.right_add_go:SetActive(false)
        self.right_hero:SetActive(true)
        self.right_quality_text:SetActive(true)
        self.right_hero:SetData(changeUuid, nil, nil, true)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(changeUuid)
        if heroData ~= nil then
            self.right_plugin_icon:SetActive(true)
            local param = {}
            param.level = heroData.plugin.lv
            param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            param.score = heroData.plugin:GetScore()
            self.right_plugin_icon:ReInit(param)
            self.right_quality_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(heroData.plugin.lv))
        end
    end
end

function UIHeroPluginChangeView:InitRightRandomDesList()
    self.rightRandomDesList = {}
    local changeUuid = self:GetChangeUuid()
    if changeUuid ~= 0 then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(changeUuid)
        if heroData ~= nil and heroData.plugin ~= nil then
            local list = heroData.plugin.plugin
            if list ~= nil then
                for k, v in ipairs(list) do
                    local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                    if template ~= nil then
                        local param = {}
                        param.select = false
                        param.showName = template:GetDesc(v.level)
                        param.showValue = ""
                        param.infoText = template:GetDescRange()
                        param.heroUuid = changeUuid
                        param.index = k - 1
                        param.useSelect = false
                        param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
                        param.quality = template.rarity
                        param.isMax = template:IsMax(v.level)
                        table.insert(self.rightRandomDesList, param)
                    end
                end
            end
        end
    end
end

function UIHeroPluginChangeView:OnSelectClick(index)
    self:RefreshHeroCellSelect(self.index, false)
    if self.index == index then
        self.index = 0
    else
        self.index = index
    end
    self:RefreshHeroCellSelect(self.index, true)
    self:ShowRightMainDesCells()
    self:ShowRightRandomDesCells()
end

function UIHeroPluginChangeView:RefreshHeroCellSelect(index, isSelect)
    if self.heroCells[index] ~= nil then
        self.heroCells[index]:Select(isSelect)
    end
end

function UIHeroPluginChangeView:GetChangeUuid()
    if self.list[self.index] ~= nil then
        return self.list[self.index].uuid
    end
    return 0
end

function UIHeroPluginChangeView:RefreshHeroPluginSignal()
    self:Refresh()
end

function UIHeroPluginChangeView:PlayAnim(animName)
    self.anim:Play(animName, 0 , 0)
end

function UIHeroPluginChangeView:OnHideBtnClick()
    self.isShowList = false
    self:PlayAnim(AnimName.Hide)
end

function UIHeroPluginChangeView:PlayEffect()
    self.effect_go:SetActive(true)
    self.pointEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.effect_go:SetActive(false)
        self:ClearEffectTimer()
    end, 0.5)
end

function UIHeroPluginChangeView:ClearEffectTimer()
    if self.pointEffectTimer ~= nil then
        self.pointEffectTimer:Stop()
        self.pointEffectTimer = nil
    end
end

function UIHeroPluginChangeView:OnAddBtnClick()
    if not self.isShowList then
        self.isShowList = true
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:PlayAnim(AnimName.Show)
    end
end

return UIHeroPluginChangeView