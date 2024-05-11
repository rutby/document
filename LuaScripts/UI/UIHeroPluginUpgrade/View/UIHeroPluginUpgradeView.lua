--- Created by shimin
--- DateTime: 2023/6/5 18:36
--- 英雄插件升级界面

local UIHeroPluginUpgradeView = BaseClass("UIHeroPluginUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroPluginUpgradeTab = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradeTab"
local UIHeroPluginUpgradeUpgrade = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradeUpgrade"
local UIHeroPluginUpgradeRefine = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradeRefine"

local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_path = "UICommonPopUpTitle/panel"
local intro_btn_path = "UICommonPopUpTitle/bg_mid/titleText/Common_btn_info"
local tab_path = "TabContent/tab"
local item_btn_path = "UIMainTopResourceCell"
local item_icon_path = "UIMainTopResourceCell/root/resourceIcon"
local item_num_text_path = "UIMainTopResourceCell/root/resourceNum"
local gold_btn_path = "gold_btn"
local gold_icon_path = "gold_btn/root/gold_icon"
local gold_num_text_path = "gold_btn/root/gold_num_text"
local upgrade_go_path = "ImgBg1"
local refine_go_path = "ImgBg2"
local change_btn_path = "change_btn"

function UIHeroPluginUpgradeView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginUpgradeView:ComponentDefine()
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
    self.info_btn = self:AddComponent(UIButton, intro_btn_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.script = {}
    self.script[HeroPluginTabType.Upgrade] = self:AddComponent(UIHeroPluginUpgradeUpgrade, upgrade_go_path)
    self.script[HeroPluginTabType.Refine] = self:AddComponent(UIHeroPluginUpgradeRefine, refine_go_path)
    self.item_btn = self:AddComponent(UIButton, item_btn_path)
    self.item_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnItemBtnClick()
    end)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.item_num_text = self:AddComponent(UIText, item_num_text_path)
    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoldBtnClick()
    end)
    self.gold_icon = self:AddComponent(UIImage, gold_icon_path)
    self.gold_num_text = self:AddComponent(UIText, gold_num_text_path)
    
    self.tab = {}
    for i = 1, table.count(HeroPluginTabType), 1 do
        local tab = self:AddComponent(UIHeroPluginUpgradeTab, tab_path .. i)
        table.insert(self.tab, tab)
    end
    self.change_btn = self:AddComponent(UIButton, change_btn_path)
    self.change_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnChangeBtnClick()
    end)
end

function UIHeroPluginUpgradeView:ComponentDestroy()
end

function UIHeroPluginUpgradeView:DataDefine()
    self.param = {}
end

function UIHeroPluginUpgradeView:DataDestroy()
    self.param = {}
end

function UIHeroPluginUpgradeView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIHeroPluginUpgradeView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIHeroPluginUpgradeView:ReInit()
    self.param = self:GetUserData()
    for k, v in pairs(self.tab) do
        local param = {}
        param.visible = true
        param.tabType = k
        param.select = self.param.tabType == k
        v:ReInit(param)
    end

    for k, v in pairs(self.script) do
        local param = {}
        param.select = self.param.tabType == k
        param.uuid = self.param.uuid
        v:ReInit(param)
    end
    self:Refresh()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
        if template ~= nil then
            local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            local itemId = template:GetCostItemId(campType)
            if itemId ~= 0 then
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                if goods ~= nil then
                    local iconName = string.format(LoadPath.ItemPath, goods.icon)
                    self.item_icon:LoadSprite(iconName)
                end
            end
        end
    end
    self:RefreshItemCount()
    self:RefreshGoldCount()
end

function UIHeroPluginUpgradeView:Refresh()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        self._title_txt:SetText(Localization:GetString(GameDialogDefine.HERO_PLUGIN_TITLE) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, heroData.plugin.lv))
    end
end

--点击信息界面
function UIHeroPluginUpgradeView:OnInfoBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgradeInfo)
end

function UIHeroPluginUpgradeView:SetSelect(tabType)
    if self.param.tabType ~= tabType then
        self:RefreshCellSelect(self.param.tabType, false)
        self.param.tabType = tabType
        self:RefreshCellSelect(self.param.tabType, true)
        self:Refresh()
    end
end

function UIHeroPluginUpgradeView:RefreshCellSelect(tabType, isSelect)
    if self.tab[tabType] ~= nil then
        self.tab[tabType]:Select(isSelect)
    end
    if self.script[tabType] ~= nil then
        self.script[tabType]:Select(tabType, isSelect)
    end
end

function UIHeroPluginUpgradeView:OnItemBtnClick()
end

function UIHeroPluginUpgradeView:OnGoldBtnClick()
end

function UIHeroPluginUpgradeView:RefreshHeroPluginSignal()
    self:Refresh()
    if self.script[self.param.tabType] ~= nil then
        self.script[self.param.tabType]:RefreshHeroPluginSignal()
    end
end

function UIHeroPluginUpgradeView:RefreshItemCount()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local template = DataCenter.RandomPlugCostTemplateManager:GetTemplate(heroData.plugin.lv)
        if template ~= nil then
            local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            local itemId = template:GetCostItemId(campType)
            if itemId ~= 0 then
                local ownCount = DataCenter.ItemData:GetItemCount(itemId)
                self.item_num_text:SetText(string.GetFormattedSeperatorNum(ownCount))
            end
        end
    end
end

function UIHeroPluginUpgradeView:RefreshGoldCount()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIHeroPluginUpgradeView:RefreshItemsSignal()
    self:RefreshItemCount()
    if self.script[self.param.tabType] ~= nil then
        self.script[self.param.tabType]:RefreshItemCount()
    end
end

function UIHeroPluginUpgradeView:UpdateGoldSignal()
    self:RefreshGoldCount()
    if self.script[self.param.tabType] ~= nil then
        self.script[self.param.tabType]:RefreshGoldCount()
    end
end

--点击替换
function UIHeroPluginUpgradeView:OnChangeBtnClick()
    --出征不打开界面
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
    if heroData ~= nil then
        if heroData.state == ArmyFormationState.March then
            UIUtil.ShowTipsId(GameDialogDefine.HERO_PLUGIN_CHANGE_IN_MARCH_TIPS)
        else
            --检测是否有0级需要升级的
            local list = DataCenter.HeroDataManager:GetAllHeroByCampAndSort(GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp") ,false)
            for k, v in ipairs(list) do
                if v:IsPluginRedDot() then
                    DataCenter.HeroPluginManager:SendUpgradeHeroPlugin(v.uuid)
                end
            end

            local param = {}
            param.uuid = self.param.uuid
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginChange, { anim = false, playEffect = false }, param)
            self.ctrl:CloseSelf()
        end
    end
end

return UIHeroPluginUpgradeView