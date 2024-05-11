--- Created by shimin
--- DateTime: 2023/7/18 20:30
--- 英雄插件品质升级成功界面

local UIHeroPluginUpgradeQualitySuccessView = BaseClass("UIHeroPluginUpgradeQualitySuccessView", UIBaseView)
local base = UIBaseView

local UIHeroPluginUpgradeQualitySuccessCell = require "UI.UIHeroPluginUpgradeQualitySuccess.Component.UIHeroPluginUpgradeQualitySuccessCell"
local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"

local title_text_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local panel_btn_path = "UICommonRewardPopUp/Panel"
local left_plugin_icon_path = "Root/Content/UIHeroPluginBtn"
local right_plugin_icon_path = "Root/Content/UIHeroPluginBtn (1)"
local left_name_text_path = "Root/Content/left_name_text"
local right_name_text_path = "Root/Content/right_name_text"
local scroll_view_path = "Root/Content/ScrollView"
local des_text_path = "Root/Content/des_text"
local new_text_path = "Root/Content/new_text"

function UIHeroPluginUpgradeQualitySuccessView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginUpgradeQualitySuccessView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.left_plugin_icon = self:AddComponent(UIHeroPluginUpgradePluginIcon, left_plugin_icon_path)
    self.right_plugin_icon = self:AddComponent(UIHeroPluginUpgradePluginIcon, right_plugin_icon_path)
    self.right_name_text = self:AddComponent(UIText, right_name_text_path)
    self.left_name_text = self:AddComponent(UIText, left_name_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.new_text = self:AddComponent(UIText, new_text_path)
end

function UIHeroPluginUpgradeQualitySuccessView:ComponentDestroy()
end

function UIHeroPluginUpgradeQualitySuccessView:DataDefine()
    self.param = {}
    self.cells = {}
    self.list = {}
end

function UIHeroPluginUpgradeQualitySuccessView:DataDestroy()
    self.param = {}
    self.cells = {}
    self.list = {}
end

function UIHeroPluginUpgradeQualitySuccessView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeQualitySuccessView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeQualitySuccessView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeQualitySuccessView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeQualitySuccessView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeQualitySuccessView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.BUILD_BAUBLE_UPGRADE_SUCCESS)
    self.new_text:SetLocalText(GameDialogDefine.NEW_ATTRIBUTE)
    self:Refresh()
end

function UIHeroPluginUpgradeQualitySuccessView:Refresh()
    if self.param.qualityParam ~= nil then
        self.des_text:SetLocalText(self.param.qualityParam.desc,
                DataCenter.HeroPluginManager:GetQualityColorNameByLevel(self.param.qualityParam.level))
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
        if heroData ~= nil then
            local param = {}
            param.level = self.param.level - 1
            param.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            self.left_plugin_icon:ReInit(param)
            self.left_name_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(param.level))

            local rightParam = {}
            rightParam.level = self.param.level
            rightParam.camp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            self.right_plugin_icon:ReInit(rightParam)
            self.right_name_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(rightParam.level))
        end
    end
    self:ShowCells()
end

function UIHeroPluginUpgradeQualitySuccessView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIHeroPluginUpgradeQualitySuccessView:ClearScroll()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIHeroPluginUpgradeQualitySuccessCell)--清循环列表gameObject
end

function UIHeroPluginUpgradeQualitySuccessView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIHeroPluginUpgradeQualitySuccessCell, itemObj)
    item:ReInit(self.list[index])
    self.cells[index] = item
end

function UIHeroPluginUpgradeQualitySuccessView:OnCellMoveOut(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIHeroPluginUpgradeQualitySuccessCell)
end

function UIHeroPluginUpgradeQualitySuccessView:GetDataList()
    self.list = {}
    if self.param.qualityParam ~= nil then
        local list = self.param.qualityParam.list
        if list ~= nil then
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v)
                if template ~= nil then
                    local param = {}
                    param.isSpecial = template:IsSpecialShow()
                    param.quality = template.rarity
                    if template.value_para == HeroPluginShowDesType.Behind then
                        param.showName = template:GetRangeName()
                        param.showValue = template:GetRangeValue()
                    else
                        param.showName = template:GetDescRange()
                    end
                    table.insert(self.list, param)
                end
            end
        end
    end
end


return UIHeroPluginUpgradeQualitySuccessView